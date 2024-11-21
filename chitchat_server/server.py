from flask import Flask, abort, session
from datetime import datetime
import json
import os

import sqlalchemy
from sqlalchemy import orm

from models import db
from models import User
from models import Post
from models import Comment

from flask import request
app = Flask(__name__)

# TODO: Pull from environment variable
app.secret_key = b"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

if os.getenv("TESTING", "false") == "false":
# TODO: Pull this info from environment variables
    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://postgres:changeme@db"
    db.init_app(app)
    with app.app_context():
        db.reflect()
else:
    app.config["TESTING"] = True
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite://" # Use in-memory db for TESTING
    db.init_app(app)
    with app.app_context():
        db.create_all()

# TODO: Remove print statements or replace with logs statements

@app.route("/")
def sanity_check():
    return "This works"

@app.route('/v1/user/login', methods=['POST'])
def login():
    email = request.form.get("email")
    password = request.form.get("password")
    return validate_user(email, password)

@app.route('/v1/user/logout', methods=["GET"])
def logout():
    
    email = session.get("email")
    print(session)
    if email is None:
        abort(404)

    session.pop("email", None)
    session.pop("is_admin", None)
    session.pop("user_id", None)

    return str(json.dumps({"status":"success"})), 200, {'ContentType':'application/json'}

#@app.route('/')
#TODO: Need to check authentication
@app.route('/v1/post/<int:id>', methods=['GET'])
def get_one_post(id):
    return view_single_post(id)

@app.route('/v1/posts', methods=['GET'])
def get_all_posts():
    return view_posts()

@app.route('/v1/user/<int:id>', methods=['GET'])
def get_user(id):
    return view_user(id)
    

@app.route('/v1/post/create', methods=['POST'])
def create_post():
    my_post = request.form.get('content')
    timestamp = datetime.now()
    
    user_id = session.get('user_id')
    if user_id is None:
        abort(403)
    
    return insert_single_post(my_post, user_id, timestamp)

@app.route('/v1/post/<int:post_id>/comment/create', methods=['POST'])
def create_comment(post_id): 
    my_comment = request.form.get('content')
    timestamp = datetime.now()

    user_id = session.get('user_id')
    if user_id is None:
        abort(403)
            
    return insert_single_comment(my_comment, user_id, timestamp, post_id)

@app.route('/v1/post/<int:post_id>/comment/<int:comment_id>', methods=['GET'])
def get_comment(comment_id):
    return get_single_comment(comment_id)

@app.route('/v1/post/<int:post_id>/comments', methods=['GET'])
def get_comments_for_post(post_id):
    return get_all_comments(post_id)

@app.route('/v1/post/delete/<int:id>',methods=['DELETE'])
def delete_post(id):  
    admin = session.get('is_admin')
    if admin is None or admin == False:
        abort(403)
    return delete_single_post(id)
            

@app.route('/v1/post/<int:post_id>/comment/delete/<int:id>',methods=['DELETE'])
def delete_comment(post_id, id):
    _ = post_id
    admin = session.get('is_admin')
    if admin is None or admin == False:
        abort(403)
            
    return delete_single_comment(id)

def validate_user(email, password_plaintext):
    try:
        user = db.session.execute(db.select(User).where(User.email == email)).scalar_one()
    except sqlalchemy.orm.exc.NoResultFound:
        abort(403) # Technically a 404, but return 403 so users cannot scrape if an email has an account

    if user.check_password(password_plaintext):
        session['email'] = user.email
        session['is_admin'] = user.admin
        session['user_id'] = user.id
        return json.dumps({'success':True}), 200, {'ContentType':'application/json'}
    else:
        abort(403)

def get_single_comment(comment_id):
    try:
        comment = db.session.execute(db.select(Comment).where(Comment.id == comment_id)).scalar_one()
        return comment.to_json()
    except sqlalchemy.orm.exc.NoResultFound:
        abort(404)

def delete_single_comment(comment_id):
    try:
        comment = db.session.get_one(Comment, comment_id)
        db.session.delete(comment)
        db.session.commit()
        return json.dumps({'success':True}), 200, {'ContentType':'application/json'}
    except sqlalchemy.orm.exc.NoResultFound:
        abort(404)

def delete_single_post(post_id):
    try:
        post = db.session.get_one(Post, post_id)
        db.session.delete(post)
        db.session.commit()
        return json.dumps({'success':True}), 200, {'ContentType':'application/json'}
    except sqlalchemy.orm.exc.NoResultFound:
        abort(404)
    

    
def insert_single_comment(my_comment, user_id, timestamp, post_id):
    comment = Comment(
        contents=my_comment,
        user_id=user_id,
        post_id=post_id,
        created_at=timestamp,
    )
    db.session.add(comment)
    db.session.commit()
    
    db.session.refresh(comment)

    return json.dumps({'success':True, 'comment_id':comment.id}), 200, {'ContentType':'application/json'}

def insert_single_post(my_post, user_id, timestamp):
    post = Post(
        contents=my_post,
        user_id=user_id,
        created_at=timestamp
    )
    db.session.add(post)
    db.session.commit()
    db.session.refresh(post)

    return json.dumps({'success':True, 'post_id':post.id}), 200, {'ContentType':'application/json'}

def get_all_comments(post_id):
    comments = db.session.execute(db.select(Comment).where(Comment.post_id == post_id)).scalars()
    
    comment_list = []
    for comment in comments:
        comment_list.append(comment.to_json())
    return str(comment_list), 200, {'ContentType':'text/plain'}
    
    

def view_posts():
    posts = db.session.execute(db.select(Post).order_by(Post.created_at)).scalars()
    
    post_list = []
    for post in posts:
        post_list.append(post.to_json())
    return str(post_list), 200, {'ContentType':'text/plain'}

def view_user(user_id):
    try:
        user = db.session.execute(db.select(User).where(User.id == user_id)).scalar_one()
        return user.to_json()
    except sqlalchemy.exc.NoResultFound:
        abort(404)


def view_single_post(post_id):
    try:
        comment = db.session.execute(db.select(Post).where(Post.id == post_id)).scalar_one()
        return comment.to_json()
    except sqlalchemy.exc.NoResultFound:
        abort(404)
        


if __name__ == "__main__":
    app.run()
    
