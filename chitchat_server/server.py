from flask import Flask, abort, session
from datetime import datetime
import json
import secrets

import sqlalchemy
from sqlalchemy import orm

from models import db
from models import User
from models import Post
from models import Comment

from flask import request
app = Flask(__name__)
app.secret_key = b"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

# TODO: Pull this info from environment variables
app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://postgres:changeme@localhost"
db.init_app(app)
with app.app_context():
    db.reflect()

@app.route("/")
def sanity_check():
    return "This works"

@app.route('/v1/user/login', methods=['POST'])
def login():
    email = request.form.get("email")
    password = request.form.get("password")
    return validate_user(email, password)

#@app.route('/')
#TODO: Need to check authentication
@app.route('/v1/post/<int:id>', methods=['GET'])
def getonepost(id):
    print('Received GET message\n')
    return view_single_post(id)

@app.route('/v1/posts', methods=['GET'])
def getallposts():
    return view_posts()
    

@app.route('/v1/post/create', methods=['POST'])
def createpost():
    my_post = request.form.get('content')
    timestamp = datetime.now()
    #print(request.form.get('mypost'),request.form.get('userid'))
    
    user_id = session.get('user_id')
    if user_id is None:
        abort(403)

    print(my_post, user_id, timestamp)
    
    return insert_single_post(my_post, user_id, timestamp)

@app.route('/v1/post/<int:post_id>/comment/create', methods=['POST'])
def createcomment(post_id): 
    my_comment = request.form.get('content')
    timestamp = datetime.now()
    #comment_id = random.randomint(0,1000000) #generating a random number is temp, replace with unique post id, 
                                                    #requires persisting latest post id and incrementing
    user_id = session.get('user_id')
    if user_id is None:
        abort(403)

    print(my_comment, user_id, timestamp, post_id)
    #print(request.form.get('mypost'),request.form.get('userid'))
            
    return insert_single_comment(my_comment, user_id, timestamp, post_id)

@app.route('/v1/post/<int:post_id>/comment/<int:comment_id>', methods=['GET'])
def getcomment(post_id, comment_id):
    print(post_id, comment_id)
    return get_single_comment(comment_id)

@app.route('/v1/post/delete/<int:id>',methods=['DELETE'])
def deletepost(id):  
    admin = session.get('is_admin')
    if admin is None or admin == False:
        abort(403)
    return delete_single_post(id)
            

@app.route('/v1/post/<int:post_id>/comment/delete/<int:id>',methods=['DELETE'])
def deletecomment(post_id, id):
    _ = post_id
    admin = session.get('is_admin')
    if admin is None or admin == False:
        abort(403)
    #print(request.form.get('mypost'),request.form.get('userid'))
            
    return delete_single_comment(id)

def validate_user(email, password_plaintext):
    user = db.session.execute(db.select(User).where(User.email == email)).scalar_one()
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
    except:
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

    print("Inserted single comment into database")
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
    print("Inserted single post into database")
    return json.dumps({'success':True, 'post_id':post.id}), 200, {'ContentType':'application/json'}
    

def view_posts():
    posts = db.session.execute(db.select(Post).order_by(Post.created_at)).scalars()
    
    post_list = []
    for post in posts:
        print(type(post))
        post_list.append(post.to_json())
    return str(post_list), 200, {'ContentType':'text/plain'}
    #return render_template('index.html', posts=posts)



def view_single_post(post_id):
    try:
        comment = db.session.execute(db.select(Post).where(Post.id == post_id)).scalar_one()
        return comment.to_json()
    except sqlalchemy.exc.NoResultFound:
        abort(404)



#How to test:
#curl -F command="post" mypost="today was a great day" -F userid="17"  http://127.0.0.1:4999

#Steps to do:
#1) Unit tests
#2) Authentication


if __name__ == "__main__":
    app.run()
    
