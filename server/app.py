from flask import Flask

from models import db, User, Post, Comment

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://postgres:changeme@db"
db.init_app(app)

with app.app_context():
    db.create_all()

@app.route("/")
def index():
    return "Hallo :3. Visit <a href=/users>users page to test</a><br>"


@app.route("/users")
def user_list():
    users = db.session.execute(db.select(User).order_by(User.name)).scalars()
    return str(users)

@app.route("/create_test")
def create_test():
    user = User(
        name="RegUser",
        password="pass+salt",
        email="big@test.lan",
        admin=False
    )
    db.session.add(user)
    db.session.commit()
    return "Test ran; Check Db"
