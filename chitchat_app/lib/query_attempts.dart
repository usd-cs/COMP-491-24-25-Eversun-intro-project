import 'package:http/http.dart' as http;
import 'paths.dart';
import 'dart:convert';

String usersCookie = "";
int globalUserId = -1;

void main(List<String> arguments) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview

  await loginAttempt("test@localhost.lan", "password");
  await addPostToDatabase("This is a example post", 1);
}
//Done!!!
Future<String> retrieveUsername(int userId) async {
  var url = getUsername(userId);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    return jsonMap['name'];
  } else {
    return 'user X';
  }
}

//Done!!!
Future<List<List<String>>> usernameAndContentDataAllPosts() async {
  List<List<String>> returnedThing = [];
  Map<String, String> idToUsername = {};

  var url = getAllPosts();
  var response = await http.get(url);

  if (response.statusCode == 200) {
    String stringJsonResponse = response.body;
    stringJsonResponse = stringJsonResponse.substring(2, stringJsonResponse.length-2);
    List<String> listJson = stringJsonResponse.split('\', \'');
    
    List<Map<String, dynamic>> posts = [];
  
    for (var jsonStr in listJson) {
    // Decode each JSON string into a Map and add to the list
      posts.add(jsonDecode(jsonStr));
    }
    
    int numIterations = 0;
    for (var post in posts) {
      returnedThing.add([]);
      String username = "";
      String userId = post['user_id'].toString();
      String content = post['contents'].toString();
      String postId = post['id'].toString();

      //looks through local list of list to see if we already have to see if we have the username
      if (idToUsername.containsKey(userId)) {
        username = idToUsername[userId]!;
      } else { //wamp wamp :(
        username = await retrieveUsername(int.parse(userId));
        idToUsername[userId] = username;
      }

      returnedThing[numIterations].add(username); 
      returnedThing[numIterations].add(content);
      returnedThing[numIterations].add(postId);
      numIterations++;
    }
    return returnedThing;
  } else {
    return ([["UserUnknown","failed to get posts"]]);
  }
}

//Done!!!
Future<List<List<String>>> usernameAndContentDataAllComments(int postId) async {
  List<List<String>> returnedThing = [];
  Map<String, String> idToUsername = {};

  var url = getAllComments(postId);
  var response = await http.get(url);

  if (response.statusCode == 200) {
    String stringJsonResponse = response.body;
    stringJsonResponse = stringJsonResponse.substring(2, stringJsonResponse.length-2);
    List<String> listJson = stringJsonResponse.split('\', \'');
    
    List<Map<String, dynamic>> posts = [];
  
    for (var jsonStr in listJson) {
    // Decode each JSON string into a Map and add to the list
      posts.add(jsonDecode(jsonStr));
    }
    
    int numIterations = 0;
    for (var post in posts) {
      returnedThing.add([]);
      String username = "";
      String userId = post['user_id'].toString();
      String content = post['contents'].toString();
      String postId = post['id'].toString();

      //looks through local list of list to see if we already have to see if we have the username
      if (idToUsername.containsKey(userId)) {
        username = idToUsername[userId]!;
      } else { //wamp wamp :(
        username = await retrieveUsername(int.parse(userId));
        idToUsername[userId] = username;
      }

      returnedThing[numIterations].add(username); 
      returnedThing[numIterations].add(content);
      returnedThing[numIterations].add(postId);
      numIterations++;
    }
 
    return returnedThing;
  } else {
    return ([["UserUnknown","failed to get posts"]]);
  }
}

//Done!!!
Future<bool> addPostToDatabase(String postContent, int userid) async {
  var uri = createPost();
  String id = "$userid";
  final cookie = <String, String>{};
  cookie['cookie'] = usersCookie;
  final map = <String, dynamic>{};
  map['content'] = postContent;
  map['userid'] = id;
  

  http.Response response = await http.post(
    uri,
    headers: cookie,
    body: map,
  );

  if (response.statusCode == 200) {
    print("added post");
    return true;
  } else {
    print('fail');
    return false;
  }
}

//Done!!!
Future<bool> addCommentToDatabase(String postContent, int userid, int postId) async {
  var uri = createComment(postId);
  String id = "$userid";
  final cookie = <String, String>{};
  cookie['cookie'] = usersCookie;
  final map = <String, dynamic>{};
  map['content'] = postContent;
  map['userid'] = id;

  http.Response response = await http.post(
    uri,
    headers: cookie,
    body: map,
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

//Done!!!
Future<bool> deletePost(int postId) async {
  var uri = removePost(postId);
  final map = <String, String>{};
  map['cookie'] = usersCookie;
  http.Response response = await http.delete(
    uri,
    headers: map,
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

//Done!!!
Future<bool> deleteComment(int postId, int commentId) async {
  var uri = removeComment(postId, commentId);
  final map = <String, String>{};
  map['cookie'] = usersCookie;
  http.Response response = await http.delete(
    uri,
    headers: map,
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

//DONE!!!
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
    print("fail");
    return [false, false];
  }
}
