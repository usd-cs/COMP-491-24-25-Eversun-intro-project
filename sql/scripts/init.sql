-- SQL dump generated using DBML (dbml.dbdiagram.io)
-- Database: PostgreSQL
-- Generated at: 2024-11-07T05:16:34.495Z

CREATE TABLE IF NOT EXISTS "User" (
  "id" integer PRIMARY KEY,
  "email" varchar,
  "name" varchar,
  "admin" bool
);

CREATE TABLE IF NOT EXISTS "Comment" (
  "id" integer PRIMARY KEY,
  "contents" text,
  "user_id" integer,
  "post_id" integer,
  "created_at" timestamp
);

CREATE TABLE IF NOT EXISTS "Post" (
  "id" integer PRIMARY KEY,
  "contents" text,
  "user_id" integer,
  "created_at" timestamp
);

ALTER TABLE "Comment" ADD FOREIGN KEY ("user_id") REFERENCES "User" ("id");

ALTER TABLE "Comment" ADD FOREIGN KEY ("post_id") REFERENCES "Post" ("id");

ALTER TABLE "Post" ADD FOREIGN KEY ("user_id") REFERENCES "User" ("id");
