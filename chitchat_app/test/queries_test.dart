import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:chitchat_app/query_attempts.dart'; // Import the functions

void main() {
  // Test retrieveUsername function
  group('retrieveUsername', () {
    test('returns the username when the http call completes with a 200 response', () async {
      final client = MockClient((request) async {
        return http.Response('{"name": "John Doe"}', 200);  // Simulate success
      });

      final username = await retrieveUsername(1, client: client);

      expect(username, 'John Doe');
    });

    test('returns "user X" when the http call completes with a non-200 response', () async {
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);  // Simulate failure
      });

      final username = await retrieveUsername(1, client: client);

      expect(username, 'user X');
    });
  });

  // Test usernameAndContentDataAllPosts function
  group('usernameAndContentDataAllPosts', () {
    test('returns error data when the http call fails', () async {
      final client = MockClient((request) async {
        return http.Response('Failed to fetch posts', 500);  // Simulate server error
      });

      final posts = await usernameAndContentDataAllPosts(client: client);

      expect(posts, [["UserUnknown", "failed to get posts"]]);
    });
  });

  // Test usernameAndContentDataAllComments function
  group('usernameAndContentDataAllComments', () {

    test('returns error data when the http call fails', () async {
      final client = MockClient((request) async {
        return http.Response('Failed to fetch comments', 500);  // Simulate server error
      });

      final comments = await usernameAndContentDataAllComments(1, client: client);

      expect(comments, [["UserUnknown", "failed to get posts"]]);
    });
  });

  // Test addPostToDatabase function
  group('addPostToDatabase', () {
    test('returns true when the http call completes with a 200 response', () async {
      final client = MockClient((request) async {
        return http.Response('{"status": "success"}', 200);  // Simulate success
      });

      final result = await addPostToDatabase("Test Post", 1, client: client);

      expect(result, true);
    });

    test('returns false when the http call completes with a non-200 response', () async {
      final client = MockClient((request) async {
        return http.Response('Error', 400);  // Simulate failure
      });

      final result = await addPostToDatabase("Test Post", 1, client: client);

      expect(result, false);
    });
  });

  // Test addCommentToDatabase function
  group('addCommentToDatabase', () {
    test('returns true when the http call completes with a 200 response', () async {
      final client = MockClient((request) async {
        return http.Response('{"status": "success"}', 200);  // Simulate success
      });

      final result = await addCommentToDatabase("Test Comment", 1, 1, client: client);

      expect(result, true);
    });

    test('returns false when the http call completes with a non-200 response', () async {
      final client = MockClient((request) async {
        return http.Response('Error', 400);  // Simulate failure
      });

      final result = await addCommentToDatabase("Test Comment", 1, 1, client: client);

      expect(result, false);
    });
  });

  // Test deletePost function
  group('deletePost', () {
    test('returns true when the http call completes with a 200 response', () async {
      final client = MockClient((request) async {
        return http.Response('{"status": "deleted"}', 200);  // Simulate success
      });

      final result = await deletePost(1, client: client);

      expect(result, true);
    });

    test('returns false when the http call completes with a non-200 response', () async {
      final client = MockClient((request) async {
        return http.Response('Error', 500);  // Simulate failure
      });

      final result = await deletePost(1, client: client);

      expect(result, false);
    });
  });

  // Test deleteComment function
  group('deleteComment', () {
    test('returns true when the http call completes with a 200 response', () async {
      final client = MockClient((request) async {
        return http.Response('{"status": "deleted"}', 200);  // Simulate success
      });

      final result = await deleteComment(1, 1, client: client);

      expect(result, true);
    });

    test('returns false when the http call completes with a non-200 response', () async {
      final client = MockClient((request) async {
        return http.Response('Error', 500);  // Simulate failure
      });

      final result = await deleteComment(1, 1, client: client);

      expect(result, false);
    });
  });
}
