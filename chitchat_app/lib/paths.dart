String base = "http://localhost:8080";

Uri getAllPosts() {
  String temp = "$base/v1/posts";
  return Uri.parse(temp);
}

Uri createPost() {
  String temp = "$base/v1/post/create";
  return Uri.parse(temp);
}

Uri createComment(int postId) {
  String temp =  "$base/v1/post/$postId/comment/create";
  return Uri.parse(temp);
}

Uri getComment(int postId, int commentId) {
  String temp = "$base/v1/post/$postId/comment/$commentId";
  return Uri.parse(temp);
}

Uri getUsername(int userid) {
  String temp = "$base/v1/user/$userid";
  return Uri.parse(temp);
}

Uri removePost(int postid) {
  String temp = "$base/v1/post/delete/$postid>";
  return Uri.parse(temp);
}

Uri login() {
  String temp = "$base/v1/user/login'>";
  return Uri.parse(temp);
}