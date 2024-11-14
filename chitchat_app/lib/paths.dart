String base = "http://127.0.0.1:8080";

Uri getAllPosts() {
  String temp = "$base/v1/posts";
  return Uri.parse(temp);
}

Uri createPost() {
  String temp = "$base/v1/post/create";
  return Uri.parse(temp);
}

Uri createComment(int postid) {
  String temp =  "$base/v1/post/$postid/comment/create";
  return Uri.parse(temp);
}

Uri getAllComments(int postid) {
  String temp = "$base/v1/post/$postid/comments";
  return Uri.parse(temp);
}


Uri getUsername(int userid) {
  String temp = "$base/v1/user/$userid";
  return Uri.parse(temp);
}

Uri removePost(int postid) {
  String temp = "$base/v1/post/delete/$postid";
  return Uri.parse(temp);
}

Uri removeComment(int postid, int commentid) {
  String temp = "$base/v1/post/$postid/comment/delete/$commentid";
  return Uri.parse(temp);
}


Uri login() {
  String temp = "$base/v1/user/login";
  return Uri.parse(temp);
}