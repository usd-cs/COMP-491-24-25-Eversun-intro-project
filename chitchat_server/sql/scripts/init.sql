-- SQL dump generated using DBML (dbml.dbdiagram.io)
-- Database: PostgreSQL
-- Generated at: 2024-11-07T05:16:34.495Z

CREATE TABLE IF NOT EXISTS users (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
  email varchar UNIQUE NOT NULL,
  name varchar NOT NULL,
  admin bool NOT NULL,
  password varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS comments (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
  contents text NOT NULL,
  user_id integer NOT NULL,
  post_id integer NOT NULL,
  created_at timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS posts (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
  contents text NOT NULL,
  user_id integer NOT NULL,
  created_at timestamp NOT NULL
);

ALTER TABLE comments ADD FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE comments ADD FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE;

ALTER TABLE posts ADD FOREIGN KEY (user_id) REFERENCES users (id);

-- DEBUG Only use this password in local environments
INSERT INTO users (email, name, admin, password) VALUES ('test@localhost.lan', 'admin', true, 'bb69221a93dbd1de78c9d1354d1f004160c5ddd3ff3f78bec380e729b5a4964fdbfa69badf3d5d9d');
