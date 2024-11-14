from flask import Flask
import os
import psycopg2
import time
import json
import init.sql

from models import User
from models import Post
from models import Comment

def get_db_connection():
    connection = psycopg2.connect(host='localhost', 
                                database=' database_name', 
                                user=os.environ['DB_USERNAME'], 
                                password=os.environ['DB_PASSWORD'])
    return connection


from flask import request
app = Flask(__name__)

#add in some of john's code here - it is related to connection to the database, for importing classes
app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://user:password@hostname"
db.init_app(app)
with app.app_context():
    db.reflect()

#@app.route('/')
#TO_DO: Need to check authentication
@app.route('/getonepost', methods=['GET'])
def getonepost():
    print('Received GET message\n')
    post_id = request.form.get('postid')
    return view_single_post(post_id)

@app.route('/getallposts', methods=['GET'])
def getallposts():
    return view_posts()
    

@app.route('/createpost', methods=['POST'])
def createpost():
    command = request.form.get(command)
    my_post = request.form.get('mypost')
    user_id = request.form.get('userid')
    timestamp = time.time()
    #post_id = random.randomint(0,1000000) #generating a random number is temp, replace with unique post id, 
                                                    #requires persisting latest post id and incrementing
    print(my_post, user_id, timestamp)
    #print(request.form.get('mypost'),request.form.get('userid'))
            
    return insert_single_post(my_post, user_id, timestamp)



@app.route('/createcomment', methods=['POST'])
def createcomment(): 
    my_comment = request.form.get('mycomment')
    user_id = request.form.get('userid')
    post_id = request.form.get('postid')
    timestamp = time.time()
    #comment_id = random.randomint(0,1000000) #generating a random number is temp, replace with unique post id, 
                                                    #requires persisting latest post id and incrementing
    print(my_comment, user_id, timestamp, post_id)
    #print(request.form.get('mypost'),request.form.get('userid'))
            
    return insert_single_comment(my_comment, user_id, timestamp, post_id)


@app.route('/deletepost',methods=['POST'])
def deletepost():  
    user_id = request.form.get('userid')
    post_id = request.form.get('postid')
    print(user_id, post_id)
    #print(request.form.get('mypost'),request.form.get('userid'))
            
    return delete_single_post(user_id,post_id)
            

@app.route('/deletecomment',methods=['POST'])
def deletecomment():

    user_id = request.form.get('userid')
    comment_id = request.form.get('commentid')
    print(user_id, comment_id)
    #print(request.form.get('mypost'),request.form.get('userid'))
            
    return delete_single_comment(user_id,comment_id)

    
def delete_single_comment(user_id, comment_id):
    connection = get_db_connection()
    cur = connection.cursor()
    cur = connection.cursor()
    cur.execute('DELETE FROM comments WHERE id = ?'
                (comment_id,))
    print("Deleted single post from database")
    return "Deleted single post from database"
    
def delete_single_post(user_id, post_id):
    connection = get_db_connection()
    cur = connection.cursor()
    cur = connection.cursor()
    cur.execute('DELETE FROM posts WHERE id = ?'
                (post_id,))
    print("Deleted single post from database")
    return "Deleted single post from database"
    

    
def insert_single_comment(my_comment, user_id, timestamp, post_id):
    connection = get_db_connection()
    cur = connection.cursor()
    comment_id = cur.execute('SELECT nextval(init.sql.comment_id_seq)').fetchone()
    cur.execute('INSERT INTO comments (id,contents,user_id, post_id, created_at)'
                        'VALUES(%d,%s,%d,%d,%f)',
                        comment_id, my_comment, user_id, post_id, timestamp)
    cur.close()
    connection.close()
    print("Inserted single post into database")
    return "Inserted single post into database"

def insert_single_post(my_post, user_id, timestamp):
    connection = get_db_connection()
    cur = connection.cursor()
    post_id = cur.execute('SELECT nextval(init.sql.post_id_seq)').fetchone()
    cur.execute('INSERT INTO posts (id,contents,user_id,created_at)'
                        'VALUES(%d,%s,%d,%f)',
                        post_id, my_post, user_id, timestamp)
    cur.close()
    connection.close()
    print("Inserted single post into database")
    return "Inserted single post into database"
    

def view_posts():
    connection = get_db_connection()
    cur = connection.cursor()
    posts = cur.execute('SELECT * FROM posts').fetchall()
    cur.close()
    connection.close()
    json_string = json.dumps(posts, indent=4)
    return json_string
    #return render_template('index.html', posts=posts)



def view_single_post(post_id):
    connection = get_db_connection()
    cur = connection.cursor()
    post = cur.execute('SELECT * FROM posts WHERE id = ?',
                        (post_id,)).fetchone()
    cur.close()
    connection.close()
    json_string = json.dumps(post, indent=4)
    #if post is None:
        #abort(404)
    return json_string



#How to test:
#curl -F command="post" mypost="today was a great day" -F userid="17"  http://127.0.0.1:4999

#Steps to do:
#1) Unit tests
#2) Authentication



    
