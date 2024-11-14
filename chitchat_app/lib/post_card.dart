import 'package:flutter/material.dart';
import 'dart:math';
import 'account_page.dart';
import 'global_variables.dart';

/// Card widget for displaying individual posts with title, content, and comments.
class PostCard extends StatefulWidget {
  final String? content;
  final String? username;
  final List<Map<String, String>>? comments;
  final VoidCallback? onDelete;
  final VoidCallback? onAddComment;

  PostCard({super.key, this.content, this.username, this.comments, this.onDelete, this.onAddComment});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.username ?? "Anonymous", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.content ?? ""),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _showCommentsDialog(context);
                },
                child: const Text('View Comments'),
              ),
            ),
            if (isAdmin)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      AccountPage.recentPosts.removeWhere((post) => 
                          post['username'] == widget.username && 
                          post['content'] == widget.content);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post deleted')),
                    );
                    widget.onDelete;
                  },
                  child: const Text('Delete Post', style: TextStyle(color: Colors.red)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Displays dialog with comments for the post and allows adding a new comment.
  void _showCommentsDialog(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Comments'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...?widget.comments?.map((comment) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comment['username']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(comment['content']!),
                  if (isAdmin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            widget.comments?.remove(comment);
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Comment deleted')),
                          );
                        },
                        child: const Text('Delete Comment', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  const Divider(),
                ],
              )),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(labelText: 'Add a comment'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: isLoggedIn ? () {
                if (commentController.text.isNotEmpty) {
                  setState(() {
                    widget.comments?.add({
                      'username': currentUsername,
                      'content': commentController.text,
                      'date': randomDate(),
                    });
                  });
                  Navigator.of(context).pop();
                }
              } : null,
            ),
          ],
        );
      },
    );
  }
}