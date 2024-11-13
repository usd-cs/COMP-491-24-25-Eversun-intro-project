-- SQL dump generated using DBML (dbml.dbdiagram.io)
-- Database: PostgreSQL
-- Generated at: 2024-11-07T05:16:34.495Z

CREATE TABLE IF NOT EXISTS users (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
  email varchar,
  name varchar,
  admin bool,
  password varchar(80)
);

CREATE TABLE IF NOT EXISTS comments (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
  contents text,
  user_id integer,
  post_id integer,
  created_at timestamp
);

CREATE TABLE IF NOT EXISTS posts (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
  contents text,
  user_id integer,
  created_at timestamp
);

ALTER TABLE comments ADD FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE comments ADD FOREIGN KEY (post_id) REFERENCES posts (id);

ALTER TABLE posts ADD FOREIGN KEY (user_id) REFERENCES users (id);


CREATE SEQUENCE post_id_seq
    [INCREMENT BY 2]
    [START WITH 101]
    [MINVALUE 101]
    [MAXVALUE 1000001]
    [NO CYCLE]
    [OWNED BY { posts.id }]

CREATE SEQUENCE comment_id_seq
    [INCREMENT BY 2]
    [START WITH 100]
    [MINVALUE 100]
    [MAXVALUE 1000000]
    [NO CYCLE]
    [OWNED BY { comments.id }]