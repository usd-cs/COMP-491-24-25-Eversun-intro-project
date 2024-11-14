import '../query_attempts.dart';
import 'user_service.dart';

class Post {
  final String username;
  final String content;
  final String postId;
  final List<Comment> comments;

  Post({
    required this.username,
    required this.content,
    required this.postId,
    this.comments = const [],
  });
}

class Comment {
  final String username;
  final String content;

  Comment({required this.username, required this.content});
}

class PostService {
  static const bool useMockData = true;

  static Future<List<Post>> getAllPosts() async {
    if (useMockData) {
      return _getMockPosts();
    }
    
    List<List<String>> rawPosts = await usernameAndContentDataAllPosts();
    List<Post> posts = [];
    
    for (var postData in rawPosts) {
      posts.add(Post(
        username: postData[0],
        content: postData[1],
        postId: postData[2],
      ));
    }
    
    return posts;
  }

  static Future<List<Post>> _getMockPosts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      Post(
        username: "JohnDoe",
        content: "Just finished my first Flutter app! 🚀",
        postId: "1",
        comments: [
          Comment(
            username: "AliceSmith",
            content: "That's awesome! What did you build?"
          ),
          Comment(
            username: "BobJohnson",
            content: "Great work! 👏"
          ),
        ]
      ),
      Post(
        username: "AliceSmith",
        content: "Anyone interested in a Flutter study group? 📚",
        postId: "2",
        comments: [
          Comment(
            username: "ModeratorSam",
            content: "Great initiative! Count me in!"
          ),
        ]
      ),
      Post(
        username: "ModeratorSam",
        content: "Welcome to our growing community! Feel free to ask questions and share your knowledge. 🌟",
        postId: "3",
        comments: []
      ),
    ];
  }

  static Future<void> createPost(String content) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      print('Mock: Created post with content: $content');
      return;
    }
    
    if (UserService.currentUserId != null) {
      await addPostToDatabase(content, UserService.currentUserId!);
    }
  }

  static Future<void> addComment(String content, int postId) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      print('Mock: Added comment to post $postId: $content');
      return;
    }
    
    if (UserService.currentUserId != null) {
      await addCommentToDatabase(content, UserService.currentUserId!, postId);
    }
  }
} 