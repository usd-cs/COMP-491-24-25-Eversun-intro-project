import '../query_attempts.dart';
import 'user_service.dart';

/// Represents a post in the application
/// Contains information about the post's content, author, and associated comments
class Post {
  final String username;    // Username of the post author
  final String content;     // Content/body of the post
  final String postId;      // Unique identifier for the post
  final List<Comment> comments;  // List of comments on this post

  Post({
    required this.username,
    required this.content,
    required this.postId,
    this.comments = const [],  // Default to empty list if no comments provided
  });
}

/// Represents a comment on a post
/// Contains information about the comment's content and author
class Comment {
  final String username;    // Username of the comment author
  final String content;     // Content of the comment
  final String commentId;   // Unique identifier for the comment
  Comment({required this.username, required this.content, required this.commentId});
}

/// Service class handling all post-related operations
/// Provides methods for creating, retrieving, and managing posts and comments
class PostService {

  // Define function types
  static Future<List<Post>> Function() getAllPosts = _defaultGetAllPosts;
  static Future<List<Comment>> Function(int) getAllComments = _defaultGetAllComments;

  // Default implementations
  static Future<List<Post>> _defaultGetAllPosts() async {
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

  static Future<List<Comment>> _defaultGetAllComments(int postId) async {
    List<List<String>> rawComment = await usernameAndContentDataAllComments(postId);
    List<Comment> comments = [];
    
    for (var commentData in rawComment) {
      comments.add(Comment(
        username: commentData[0],    
        content: commentData[1],     
        commentId: commentData[2],   
      ));
    }
    
    return comments;
  }

  /// Creates a new post in the database
  /// @param content - The content of the post to create
  static Future<void> createPost(String content) async {  
    await addPostToDatabase(content, UserService.currentUserId!);
  }

  /// Adds a new comment to a post
  /// @param content - The content of the comment
  /// @param postId - The ID of the post to comment on
  static Future<void> addComment(String content, int postId) async {
    await addCommentToDatabase(content, UserService.currentUserId!, postId);
  }

  /// Removes a post from the database
  /// @param postId - The ID of the post to remove
  static Future<void> removePost(int postId) async {
    await removePost(postId);
  }

  /// Removes a comment from the database
  /// @param commentId - The ID of the comment to remove
  static Future<void> removeComment(int commentId) async {
    await removeComment(commentId);
  }
} 