import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'paths.dart';
import 'dart:convert';

void main(List<String> arguments) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview


  // Await the http get response, then decode the json-formatted response.
  //await addCommentToDatabase("love it", 1, 1);
  List<bool> returned = await loginAttempt("kobe@sat", "saltydog");
  print("HHHHHHH");
  print(returned);
  //print(await getComment(1, 1));
}

//TODO: Possible waiting on paths
Future<List<List<String>>> usernameAndContentDataAllPosts() async {
  List<List<String>> returnedThing = [[]];
   Map<String, String> idToUsername = {};

  var url = getAllPosts();
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var stringJsonResponse = response.body;
    List posts = jsonDecode(stringJsonResponse);
    int numIterations = 0;

    for (var post in posts) {
      String username = "";
      String userId = post['user_id'].toString();
      String content = post['contents'].toString();
      String postId = post['id'].toString();

      //looks through local list of list to see if we already have to see if we have the username
      if (idToUsername.containsKey(userId)) {
        username = idToUsername[userId]!;
      } else { //wamp wamp :(
        url = getUsername(userId as int);
        var usernameResponse = await http.get(url);
        if (usernameResponse.statusCode == 200) {
          username = usernameResponse.body; //got it add it to user
          idToUsername[userId] = username;  //add it to the map
        } else {
          username = "userX";
        }
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
Future<void> addPostToDatabase(String postContent, int userid) async {
  var uri = createPost();
  String id = "$userid";
  final map = <String, dynamic>{};
  map['content'] = postContent;
  map['userid'] = id;

  http.Response response = await http.post(
    uri,
    body: map,
  );

  if (response.statusCode == 200) {
    print('Post added successfully: ${response.body}');
  } else {
    print('Failed to add post. Status: ${response.statusCode}');
  }
}

//Done!!!
Future<void> addCommentToDatabase(String postContent, int userid, int postId) async {
  var uri = createComment(postId);
  String id = "$userid";
  final map = <String, dynamic>{};
  map['content'] = postContent;
  map['userid'] = id;

  http.Response response = await http.post(
    uri,
    body: map,
  );

  if (response.statusCode == 200) {
    print('Post added successfully: ${response.body}');
  } else {
    print('Failed to add post. Status: ${response.statusCode}');
  }
}


Future<String> getComment(int postId, int commentId) async {
  var url = getComment(postId, commentId);
  var response = await http.get(url as Uri);
  if (response.statusCode == 200) {
    var jsonResponse = response.body;
    return jsonResponse;
  } else {
    return ('failed to get posts');
  }
}

Future<void> deletePost(int postId) async {
  //TODO: add cookie
  var url = removePost(postId);
  var response = await http.get(url as Uri);
  if (response.statusCode == 200) {
    var jsonResponse = response.body;
  } else {
    print('failed to get posts');
  }
}

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
    print(response.body);
    //TODO: figure out how to verify admin
    return [true, false];
  } else {
    print(response.body);
    return [false, false];
  }
}
