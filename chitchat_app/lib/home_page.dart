import 'package:flutter/material.dart';
import 'post_card.dart';
import 'services/post_service.dart';
import 'services/user_service.dart';
import 'query_attempts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required List posts});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  bool isLoading = true;
  Map<int, List<Map<String,String>>> comments = {};

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => isLoading = true);
    Map<int, List<Map<String,String>>> commentMap = {};
    try {
      final loadedPosts = await PostService.getAllPosts();
      for (int i = 0; i < loadedPosts.length; i++) {
        commentMap[int.parse(loadedPosts[i].postId)] = await _loadCommentsForPost(int.parse(loadedPosts[i].postId));
      }
      setState(() {
        comments = commentMap;
        posts = loadedPosts;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<List<Map<String, String>>> _loadCommentsForPost(int postID) async {
    // This just needs to pull the comments as needed for the postID. Currently broken
    try {
      final loadedComments = await PostService.getAllComments(postID);
      List<Map<String, String>> commentList = loadedComments.map((comment) => {
        'username': comment.username,
        'content': comment.content,
        'comment_id': comment.commentId,
    }).toList();
      return commentList;
    } catch (e) {
      return <Map<String, String>>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          final post = posts[index];
          return PostCard(
            postId: int.parse(post.postId),
            content: post.content,
            username: post.username,
            comments: comments[int.parse(post.postId)],
            onDelete: UserService.isAdmin ? () => _handleDelete(post) : null,
            onAddComment: UserService.isLoggedIn ? () => _handleAddComment(post) : null,
          );
        },
      ),
    );
  }

  Future<void> _handleAddComment(Post post) async {
    String commentContent = ""; // Get this from a dialog
    await PostService.addComment(commentContent, int.parse(post.postId));
    _loadPosts(); // Refresh the posts
  }

  Future<void> _handleDelete(Post post) async {
    await deletePost(int.parse(post.postId));
    _loadPosts(); // Refresh the posts
    
  }
}