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

  static Future<List<Post>> getAllComments(int postId) async {    
    List<List<String>> rawComment = await usernameAndContentDataAllComments(postId);
    List<Post> comments = [];
    
    for (var commentData in rawComment) {
      comments.add(Post(
        username: commentData[0],
        content: commentData[1],
        postId: commentData[2],
      ));
    }
    
    return comments;
  }

  static Future<void> createPost(String content) async {  
    await addPostToDatabase(content, UserService.currentUserId!);
  }

  static Future<void> addComment(String content, int postId) async {
    await addCommentToDatabase(content, UserService.currentUserId!, postId);
  }

  static Future<void> removePost(int postId) async {
    await removePost(postId);
  }

  static Future<void> removeComment(int commentId) async {
    await removeComment(commentId);
  }
} 