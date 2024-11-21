import 'package:http/http.dart' as http;
import 'paths.dart';
import 'dart:convert';

String usersCookie = "";
int globalUserId = -1;

void main(List<String> arguments) async {
  // Example usage:
  await retrieveUsername(1);
  await addPostToDatabase("This is an example post", 1);
  await usernameAndContentDataAllPosts();
}

// retrieveUsername function
Future<String> retrieveUsername(int userId, {http.Client? client}) async {
  client ??= http.Client(); // Use the provided client or create a new one
  var url = getUsername(userId);
  var response = await client.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    return jsonMap['name'];
  } else {
    return 'user X';
  }
}

// usernameAndContentDataAllPosts function
Future<List<List<String>>> usernameAndContentDataAllPosts({http.Client? client}) async {
  List<List<String>> returnedThing = [];
  Map<String, String> idToUsername = {};

  client ??= http.Client(); // Use the provided client or create a new one
  var url = getAllPosts();
  var response = await client.get(url);

  if (response.statusCode == 200) {
    String stringJsonResponse = response.body;
    stringJsonResponse = stringJsonResponse.substring(2, stringJsonResponse.length - 2);
    List<String> listJson = stringJsonResponse.split('\', \'');

    List<Map<String, dynamic>> posts = [];
    for (var jsonStr in listJson) {
      posts.add(jsonDecode(jsonStr));
    }

    int numIterations = 0;
    for (var post in posts) {
      returnedThing.add([]);
      String username = "";
      String userId = post['user_id'].toString();
      String content = post['contents'].toString();
      String postId = post['id'].toString();

      if (idToUsername.containsKey(userId)) {
        username = idToUsername[userId]!;
      } else {
        username = await retrieveUsername(int.parse(userId), client: client);
        idToUsername[userId] = username;
      }

      returnedThing[numIterations].add(username);
      returnedThing[numIterations].add(content);
      returnedThing[numIterations].add(postId);
      numIterations++;
    }
    return returnedThing;
  } else {
    return [["UserUnknown", "failed to get posts"]];
  }
}

// usernameAndContentDataAllComments function
Future<List<List<String>>> usernameAndContentDataAllComments(int postId, {http.Client? client}) async {
  List<List<String>> returnedThing = [];
  Map<String, String> idToUsername = {};

  client ??= http.Client(); // Use the provided client or create a new one
  var url = getAllComments(postId);
  var response = await client.get(url);

  if (response.statusCode == 200) {
    String stringJsonResponse = response.body;
    stringJsonResponse = stringJsonResponse.substring(2, stringJsonResponse.length - 2);
    List<String> listJson = stringJsonResponse.split('\', \'');

    List<Map<String, dynamic>> posts = [];
    for (var jsonStr in listJson) {
      posts.add(jsonDecode(jsonStr));
    }

    int numIterations = 0;
    for (var post in posts) {
      returnedThing.add([]);
      String username = "";
      String userId = post['user_id'].toString();
      String content = post['contents'].toString();
      String postId = post['id'].toString();

      if (idToUsername.containsKey(userId)) {
        username = idToUsername[userId]!;
      } else {
        username = await retrieveUsername(int.parse(userId), client: client);
        idToUsername[userId] = username;
      }

      returnedThing[numIterations].add(username);
      returnedThing[numIterations].add(content);
      returnedThing[numIterations].add(postId);
      numIterations++;
    }
    return returnedThing;
  } else {
    return [["UserUnknown", "failed to get posts"]];
  }
}

// addPostToDatabase function
Future<bool> addPostToDatabase(String postContent, int userId, {http.Client? client}) async {
  client ??= http.Client(); // Use the provided client or create a new one
  var uri = createPost();
  final cookie = <String, String>{};
  cookie['cookie'] = usersCookie;
  final map = <String, dynamic>{};
  map['content'] = postContent;
  map['userid'] = "$userId";

  http.Response response = await client.post(
    uri,
    headers: cookie,
    body: map,
  );

  return response.statusCode == 200;
}

// addCommentToDatabase function
Future<bool> addCommentToDatabase(String postContent, int userId, int postId, {http.Client? client}) async {
  client ??= http.Client(); // Use the provided client or create a new one
  var uri = createComment(postId);
  final cookie = <String, String>{};
  cookie['cookie'] = usersCookie;
  final map = <String, dynamic>{};
  map['content'] = postContent;
  map['userid'] = "$userId";

  http.Response response = await client.post(
    uri,
    headers: cookie,
    body: map,
  );

  return response.statusCode == 200;
}

// deletePost function
Future<bool> deletePost(int postId, {http.Client? client}) async {
  client ??= http.Client(); // Use the provided client or create a new one
  var uri = removePost(postId);
  final map = <String, String>{};
  map['cookie'] = usersCookie;
  http.Response response = await client.delete(
    uri,
    headers: map,
  );

  return response.statusCode == 200;
}

// deleteComment function
Future<bool> deleteComment(int postId, int commentId, {http.Client? client}) async {
  client ??= http.Client(); // Use the provided client or create a new one
  var uri = removeComment(postId, commentId);
  final map = <String, String>{};
  map['cookie'] = usersCookie;
  http.Response response = await client.delete(
    uri,
    headers: map,
  );

  return response.statusCode == 200;
}

// loginAttempt function
Future<List<bool>> loginAttempt(String username, String password) async {
  var uri = login();
  final map = <String, dynamic>{};
  map['email'] = username;
  map['password'] = password;
  http.Response response = await http.post(
    uri,
    body: map,
  );

  if (response.statusCode == 200) {
    usersCookie = response.headers['set-cookie'].toString().split(';')[0];
    String token = usersCookie.toString().split("session=")[1].split(';')[0].split('.')[0];
    Codec<String, String> stringToBase64 = utf8.fuse(base64Url);
    String data = stringToBase64.decode(token+("="*(token.length%4)));
    Map<String, dynamic> jsonMap = jsonDecode(data);
    
    jsonMap['user_id:'] = globalUserId;
    return [true, jsonMap['is_admin']];
  } else {
    return [false, false];
  }
}
