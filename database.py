from config import db

class Student(db.Model):
    __tablename__ = 'Student'
    studentID = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    email = db.Column(db.String(100), unique=True)
    password = db.Column(db.String(100))

class Quiz(db.Model):
    __tablename__ = 'Quiz'
    quizID = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100))
    description = db.Column(db.Text)

class Question(db.Model):
    __tablename__ = 'Question'
    questionID = db.Column(db.Integer, primary_key=True)
    quizID = db.Column(db.Integer, db.ForeignKey('Quiz.quizID'))
    text = db.Column(db.Text)
    quiz = db.relationship('Quiz', backref=db.backref('questions', lazy=True))

class Answer(db.Model):
    __tablename__ = 'Answer'
    answerID = db.Column(db.Integer, primary_key=True)
    questionID = db.Column(db.Integer, db.ForeignKey('Question.questionID'))
    text = db.Column(db.String(255))
    is_correct = db.Column(db.Boolean)
    question = db.relationship('Question', backref=db.backref('answers', lazy=True))

class Scoreboard(db.Model):
    __tablename__ = 'Scoreboard'
    scoreID = db.Column(db.Integer, primary_key=True)
    studentID = db.Column(db.Integer, db.ForeignKey('Student.studentID'))
    quizID = db.Column(db.Integer, db.ForeignKey('Quiz.quizID'))
    score = db.Column(db.Integer)
    taken_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    student = db.relationship('Student', backref=db.backref('scores', lazy=True))
    quiz = db.relationship('Quiz', backref=db.backref('scores', lazy=True))
