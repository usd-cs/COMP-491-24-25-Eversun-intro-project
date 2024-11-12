from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import ForeignKey
from sqlalchemy.orm import DeclarativeBase
from datetime import datetime

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

class Post(db.Model):
    __tablename__ = "posts"
    id: Mapped[int] = mapped_column(primary_key=True)
    contents: Mapped[str]
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    created_at: Mapped[datetime]

class Comment(db.Model):
    __tablename__ = "comments"
    id: Mapped[int] = mapped_column(primary_key=True)
    contents: Mapped[str]
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    post_id: Mapped[int] = mapped_column(ForeignKey("posts.id"))
    created_at: Mapped[datetime]

