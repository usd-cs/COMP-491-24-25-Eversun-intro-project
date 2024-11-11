from flask import Flask
import psycopg2
import random
import time

def get_db_connection():
    connection = psycopg2.connect(host='localhost', 
                                  database=' database_name', 
                                  user=os.environ['DB_USERNAME'], 
                                  password=os.environ['DB_PASSWORD'])
    return connection


from flask import request
app = Flask(__name__)

#@app.route('/')
#TO_DO: Need to check authentication
@app.route('/', methods=['GET','POST'])
def index():
    if request.method == "GET":
        print('Received GET message\n')
        post_id = request.form.get('postid')
        return view_single_post(post_id)
    elif request.method == "POST":
        #return 'Received POST message\n'
        command = request.form.get(command)
        if command == "post":
            my_post = request.form.get('mypost')
            user_id = request.form.get('userid')
            timestamp = time.time()
            post_id = random.randomint(0,1000000) #generating a random number is temp, replace with unique post id, 
                                                    #requires persisting latest post id and incrementing
            print(my_post, user_id, timestamp, post_id)
            #print(request.form.get('mypost'),request.form.get('userid'))
            
            return insert_single_post(my_post, user_id, timestamp, post_id)
        elif request.method == "comment":
            my_comment = request.form.get('mycomment')
            user_id = request.form.get('userid')
            post_id = request.form.get('postid')
            timestamp = time.time()
            comment_id = random.randomint(0,1000000) #generating a random number is temp, replace with unique post id, 
                                                    #requires persisting latest post id and incrementing
            print(my_comment, user_id, timestamp, post_id, comment_id)
            #print(request.form.get('mypost'),request.form.get('userid'))
            
            return insert_single_comment(my_comment, user_id, timestamp, post_id, comment_id)
            
        elif request.method == "delete_post":
            user_id = request.form.get('userid')
            post_id = request.form.get('postid')
            print(user_id, post_id)
            #print(request.form.get('mypost'),request.form.get('userid'))
            
            return delete_single_post(user_id,post_id)
            
        elif request.method == "delete_comment":
            user_id = request.form.get('userid')
            comment_id = request.form.get('commentid')
            print(user_id, comment_id)
            #print(request.form.get('mypost'),request.form.get('userid'))
            
            return delete_single_comment(user_id,comment_id)
    else:
        return 'Unidentifiable message\n'
    
def delete_single_comment(user_id, comment_id):
    connection = get_db_connection()
    cur = connection.cursor()
    cur = connection.cursor()
    cur.execute('DELETE FROM comments WHERE id = ?'
                (comment_id,))
    print("Deleted single post from database")
    return True
    
def delete_single_post(user_id, post_id):
    connection = get_db_connection()
    cur = connection.cursor()
    cur = connection.cursor()
    cur.execute('DELETE FROM posts WHERE id = ?'
                (post_id,))
    print("Deleted single post from database")
    return True
    

    
def insert_single_comment(my_comment, user_id, timestamp, post_id, comment_id):
    connection = get_db_connection()
    cur = connection.cursor()
    cur = connection.cursor()
    cur.execute('INSERT INTO comments (id,contents,user_id, post_id, created_at)'
                        'VALUES(%d,%s,%d,%d,%f)',
                        comment_id, my_comment, user_id, post_id, timestamp)
    print("Inserted single post into database")
    return True

def insert_single_post(my_post, user_id, timestamp, post_id):
    connection = get_db_connection()
    cur = connection.cursor()
    cur = connection.cursor()
    cur.execute('INSERT INTO posts (id,contents,user_id,created_at)'
                        'VALUES(%d,%s,%d,%f)',
                        post_id, my_post, user_id, timestamp)
    print("Inserted single post into database")
    return True
    

def view_posts():
    connection = get_db_connection()
    cur = connection.cursor()
    posts = cur.execute('SELECT * FROM posts').fetchall()
    cur.close()
    connection.close()
    return posts
    #return render_template('index.html', posts=posts)

#might need to modify index.html

def view_single_post(post_id):
    connection = get_db_connection()
    cur = connection.cursor()
    post = cur.execute('SELECT * FROM posts WHERE id = ?',
                        (post_id,)).fetchone()
    cur.close()
    connection.close()
    if post is None:
        abort(404)
    return post



#How to test:
#curl -F command="post" mypost="today was a great day" -F userid="17"  http://127.0.0.1:4999


    
