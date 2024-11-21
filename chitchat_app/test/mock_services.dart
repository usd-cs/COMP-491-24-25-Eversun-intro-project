import 'package:chitchat_app/services/post_service.dart';
import 'package:chitchat_app/services/user_service.dart';

class MockQueryService {
  // Mock user service state
  static bool isLoggedIn = false;
  static String currentUsername = '';
  static bool isAdmin = false;

  static List<List<String>> mockPosts = [
    ['testUser1', 'Test post content 1', '1'],
    ['testUser2', 'Test post content 2', '2'],
  ];

  static List<List<String>> mockComments = [
    ['commenter1', 'Test comment 1', '1'],
    ['commenter2', 'Test comment 2', '2'],
  ];

  static Future<List<Post>> getMockPosts() async {
    return mockPosts.map((postData) => Post(
      username: postData[0],
      content: postData[1],
      postId: postData[2],
    )).toList();
  }

  static Future<bool> getMockLogin(String email, String password) async {
    if (email == 'test@test.com' && password == 'test123') {
      UserService.isLoggedIn = true;
      UserService.currentUsername = 'testUser';
      UserService.isAdmin = false;
      return true;
    } else if (email == 'admin@test.com' && password == 'test123') {
      UserService.isLoggedIn = true;
      UserService.currentUsername = 'adminUser';
      UserService.isAdmin = true;
      return true;
    }
    UserService.isLoggedIn = false;
    UserService.currentUsername = '';
    UserService.isAdmin = false;
    return false;
  }

  static Future<List<Comment>> getMockComments(int postId) async {
    return mockComments.map((commentData) => Comment(
      username: commentData[0],
      content: commentData[1],
      commentId: commentData[2],
    )).toList();
  }

  static Future<bool> mockAddPost(String content) async {
    mockPosts.add(['testUser', content, '${mockPosts.length + 1}']);
    return true;
  }

  static Future<bool> mockDeletePost(String postId) async {
    mockPosts.removeWhere((post) => post[2] == postId);
    return true;
  }

  static Future<bool> mockAddComment(String content, int userId, int postId) async {
    return true;
  }

  static Future<String> mockGetUsername(int userId) async {
    return 'testUser$userId';
  }

  static Future<bool> mockLogin(String email, String password) async {
    // Simple mock validation - in real tests you might want to make this more sophisticated
    if (email == 'test@test.com' && password == 'test123') {
      isLoggedIn = true;
      currentUsername = 'testUser';
      isAdmin = email == 'admin@test.com';
      return true;
    }
    return false;
  }
} 