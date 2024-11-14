import '../query_attempts.dart';
import 'user_service.dart';

class Post {
  final String username;
  final String content;
  final int postId;
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
  static List<Post> _mockPosts = [];
  static int _lastPostId = 0;

  static int _getNextPostId() {
    if (_mockPosts.isEmpty) return 1;
    return _mockPosts.map((p) => p.postId).reduce((max, id) => id > max ? id : max) + 1;
  }

  static Future<List<Post>> getAllPosts() async {
    if (useMockData) {
      if (_mockPosts.isEmpty) {
        _mockPosts = await _getInitialMockPosts();
      }
      return _mockPosts;
    }
    
    List<List<String>> rawPosts = await usernameAndContentDataAllPosts();
    List<Post> posts = [];
    
    for (var postData in rawPosts) {
      posts.add(Post(
        username: postData[0],
        content: postData[1],
        postId: int.parse(postData[2]),
      ));
    }
    
    return posts;
  }

  static Future<List<Post>> _getInitialMockPosts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      Post(
        username: "JohnDoe",
        content: "Just finished my first Flutter app! 🚀",
        postId: 1,
        comments: [
          Comment(username: "AliceSmith", content: "That's awesome! What did you build?"),
          Comment(username: "BobJohnson", content: "Great work! 👏"),
        ]
      ),
      Post(
        username: "AliceSmith",
        content: "Anyone interested in a Flutter study group? 📚",
        postId: 2,
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
        postId: 3,
        comments: []
      ),
    ];
  }

  static Future<void> createPost(String content) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newPostId = _getNextPostId();
      final newPost = Post(
        username: UserService.currentUsername ?? "Anonymous",
        content: content,
        postId: newPostId,
        comments: [],
      );

      _mockPosts.insert(0, newPost);
      print('Mock: Created post with content: $content and ID: $newPostId');
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

  static Future<bool> deletePost(int postId) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      try {
        _mockPosts.removeWhere((post) => post.postId == postId);
        print('Mock: Deleted post $postId');
        return true;
      } catch (e) {
        print('Error deleting mock post: $e');
        return false;
      }
    }
    
    try {
      final success = await deletePost(postId);
      if (success) {
        _mockPosts.removeWhere((post) => post.postId == postId);
        print('Database: Deleted post $postId');
      }
      return success;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  static Future<bool> deleteComment(int postId, int commentId) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      try {
        final post = _mockPosts.firstWhere((post) => post.postId == postId);
        if (post.comments.isNotEmpty) {
          post.comments.removeAt(commentId);
          print('Mock: Deleted comment from post $postId');
          return true;
        }
        return false;
      } catch (e) {
        print('Error deleting mock comment: $e');
        return false;
      }
    }
    
    try {
      final success = await deleteComment(postId, commentId);
      if (success) {
        final post = _mockPosts.firstWhere((post) => post.postId == postId);
        if (post.comments.length > commentId) {
          post.comments.removeAt(commentId);
          print('Database: Deleted comment from post $postId');
        }
      }
      return success;
    } catch (e) {
      print('Error deleting comment: $e');
      return false;
    }
  }
} 