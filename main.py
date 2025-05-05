from flask import render_template, request, redirect, session,flash
from database import Quiz, Student, Question, Answer, Scoreboard
from config import app, db

@app.route('/')
def index():
    if 'user_id' not in session:
        return redirect('/login')
    quizzes = Quiz.query.all()
    return render_template('index.html', quizzes=quizzes)


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        password = request.form['password']
        user = Student(name=name, email=email, password=password)
        db.session.add(user)
        db.session.commit()
        return redirect('/login')
    return render_template('register.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user = Student.query.filter_by(email=email, password=password).first()
        if user:
            session['user_id'] = user.studentID
            return redirect('/')
    return render_template('login.html')


@app.route('/quiz/<int:quiz_id>', methods=['GET', 'POST'])
def quiz(quiz_id):
    if request.method == 'POST':
        # Get all submitted answers
        submitted_answers = request.form
        questions = Question.query.filter_by(quizID=quiz_id).all()

        score = 0
        for q in questions:
            selected = submitted_answers.get(f'q{q.questionID}')
            if selected:
                ans = Answer.query.get(int(selected))
                if ans.is_correct:
                    score += 1

        # Save the score
        new_score = Scoreboard(studentID=session['user_id'], quizID=quiz_id, score=score)
        db.session.add(new_score)
        db.session.commit()

        # Prepare leaderboard data
        leaderboard_data = db.session.query(
            Student.name,
            Scoreboard.score
        ).join(Student, Student.studentID == Scoreboard.studentID)\
         .filter(Scoreboard.quizID == quiz_id)\
         .order_by(Scoreboard.score.desc()).all()

        return render_template('result.html', score=score, leaderboard=leaderboard_data)

    else:
        questions = Question.query.filter_by(quizID=quiz_id).all()
        for q in questions:
            q.answers = Answer.query.filter_by(questionID=q.questionID).all()
        return render_template('quiz.html', questions=questions, quiz_id=quiz_id)




@app.route('/logout')
def logout():
    session.clear()
    return redirect('/login')

with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True)
