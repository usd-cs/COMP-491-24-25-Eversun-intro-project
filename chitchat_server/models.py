from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import ForeignKey
from sqlalchemy.orm import DeclarativeBase
from datetime import datetime
import json
import secrets
import hashlib

class Base(DeclarativeBase):
    pass

db = SQLAlchemy(model_class=Base)

from sqlalchemy.orm import Mapped, mapped_column


# These classes need to match the database tables specified in sql/scripts/init.sql in order
# to work properly.

# Additionally in the main Flask app, the following code needs to be run in order for the database to connect
# correctly.
# 
# ```python3
# app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://user:password@hostname"
# db.init_app(app)
# with app.app_context():
#     db.reflect()
# ```
#
# After these steps are followed the database can be interacted with via the below model classes and the 
# db.session methods. See https://flask-sqlalchemy.readthedocs.io/en/stable/quickstart/ for examples.


class User(db.Model):
    __tablename__ = "users"
    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(unique=True)
    name: Mapped[str]
    admin: Mapped[bool]
    password: Mapped[str]

    def __init__(self, email, name, admin, password_plaintext):
        self.email = email
        self.name = name
        self.admin = admin
        salt = secrets.token_hex(16)
        salted_pass = salt[:8] + password_plaintext + salt[8:]
        self.password = salt+hashlib.sha256(salted_pass.encode('ascii')).hexdigest()

    def check_password(self, plaintext_password):
        salt, hash = self.password[:16], self.password[16:]
        salted_pass = salt[:8] + plaintext_password + salt[8:]
        check_hash = hashlib.sha256(salted_pass.encode('ascii')).hexdigest()
        return check_hash == hash

class Post(db.Model):
    __tablename__ = "posts"
    id: Mapped[int] = mapped_column(primary_key=True)
    contents: Mapped[str]
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    created_at: Mapped[datetime]

    def to_json(self):
        column_map = {
                "id": self.id,
                "contents": self.contents,
                "user_id": self.user_id,
                "created_at": self.created_at
        }
        return json.dumps(column_map)


class Comment(db.Model):
    __tablename__ = "comments"
    id: Mapped[int] = mapped_column(primary_key=True)
    contents: Mapped[str]
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    post_id: Mapped[int] = mapped_column(ForeignKey("posts.id"))
    created_at: Mapped[datetime]
    
    def to_json(self):
        column_map = {
                "id": self.id,
                "contents": self.contents,
                "user_id": self.user_id,
                "post_id": self.post_id,
                "created_at": self.created_at
        }
        return json.dumps(column_map)

