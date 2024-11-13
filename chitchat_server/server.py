from flask import Flask, abort
from datetime import datetime
import json

import sqlalchemy
from sqlalchemy import orm

from models import db
from models import User
from models import Post
from models import Comment

from flask import request
app = Flask(__name__)

# TODO: Pull this info from environment variables
app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://postgres:changeme@db"
db.init_app(app)
with app.app_context():
    db.reflect()

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
    user_id = request.form.get('userid')
    timestamp = datetime.now()
    print(my_post, user_id, timestamp)
    #print(request.form.get('mypost'),request.form.get('userid'))
            
    return insert_single_post(my_post, user_id, timestamp)



@app.route('/v1/post/<int: post_id>/comment/create', methods=['POST'])
def createcomment(post_id): 
    my_comment = request.form.get('content')
    user_id = request.form.get('userid')
    timestamp = datetime.now()
    #comment_id = random.randomint(0,1000000) #generating a random number is temp, replace with unique post id, 
                                                    #requires persisting latest post id and incrementing
    print(my_comment, user_id, timestamp, post_id)
    #print(request.form.get('mypost'),request.form.get('userid'))
            
    return insert_single_comment(my_comment, user_id, timestamp, post_id)

@app.route('/v1/post/<int: post_id>/comment/<int: comment_id>', methods=['GET'])
def getcomment(post_id, comment_id):
    print(post_id, comment_id)
    return get_single_comment(post_id, comment_id)

@app.route('/v1/post/delete/<int:id>',methods=['DELETE'])
def deletepost(id):  
    print(user_id, id)
    #print(request.form.get('mypost'),request.form.get('userid'))
            
    return delete_single_post(user_id,id)
            

@app.route('/v1/post/<int: post_id>/comment/delete/<int:id>',methods=['DELETE'])
def deletecomment(post_id, id):
    _ = post_id
    user_id = request.form.get('')
    print(user_id, id)
    #print(request.form.get('mypost'),request.form.get('userid'))
            
    return delete_single_comment(id)


def get_single_comment(post_id, comment_id):
    _ = post_id
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

def delete_single_post(_, post_id):
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
    return json.dumps({'success':True, 'comment_id':post.id}), 200, {'ContentType':'application/json'}
    

def view_posts():
    posts = db.session.execute(db.select(Post).order_by(Post.created_at)).mappings().all()
    json_string = json.dumps(posts, indent=4)
    return json_string
    #return render_template('index.html', posts=posts)



def view_single_post(post_id):
    json_string = json.dumps(post, indent=4)
    #if post is None:
        #abort(404)
    return json_string



#How to test:
#curl -F command="post" mypost="today was a great day" -F userid="17"  http://127.0.0.1:4999

#Steps to do:
#1) Unit tests
#2) Authentication



    
