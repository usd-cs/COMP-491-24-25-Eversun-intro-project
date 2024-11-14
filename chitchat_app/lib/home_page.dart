import 'package:flutter/material.dart';
import 'post_card.dart';
import 'services/post_service.dart';
import 'services/user_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required List posts});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadPosts(); // Reload posts when widget updates
  }

  Future<void> _loadPosts() async {
    setState(() => isLoading = true);
    try {
      final loadedPosts = await PostService.getAllPosts();
      setState(() {
        posts = loadedPosts;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() => isLoading = false);
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
            content: post.content,
            username: post.username,
            postId: post.postId,
            comments: post.comments.map((comment) => {
              'username': comment.username,
              'content': comment.content,
            }).toList(),
            onDelete: UserService.isAdmin ? () => _handleDelete(post) : null,
            onAddComment: UserService.isLoggedIn ? () => _handleAddComment(post) : null,
          );
        },
      ),
    );
  }

  Future<void> _handleAddComment(Post post) async {
    String commentContent = ""; // Get this from a dialog
    await PostService.addComment(commentContent, post.postId);
    _loadPosts();
  }

  Future<void> _handleDelete(Post post) async {
    final success = await PostService.deletePost(post.postId);
    if (success) {
      _loadPosts();
    }
  }

  Future<void> _handleDeleteComment(Post post, int commentId) async {
    final success = await PostService.deleteComment(post.postId, commentId);
    if (success) {
      _loadPosts(); // Refresh the posts
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete comment')),
      );
    }
  }
}