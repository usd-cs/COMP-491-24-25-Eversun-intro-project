import 'package:chitchat_app/query_attempts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:math';
import 'account_page.dart';
import 'global_variables.dart';

/// Card widget for displaying individual posts with title, content, and comments.
class PostCard extends StatefulWidget {
  final String? username;
  final String? content;
  final List<Map<String, String>>? comments;
  final int postId;
  final VoidCallback? onDelete;
  final VoidCallback? onAddComment;

  PostCard({super.key,required this.postId, this.content, this.username, this.comments, this.onDelete, this.onAddComment});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Random random = Random();
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.username ?? "Anonymous", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.content ?? ""),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showCommentsDialog(context);
                    },
                    child: const Text('View Comments'),
                  ),
                  if (isAdmin) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        AccountPage.recentPosts.removeWhere((post) => 
                            post['content'] == widget.content && 
                            post['username'] == widget.username);
                        
                        setState(() {
                          _isVisible = false;
                        });
                        
                        widget.onDelete?.call();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post deleted')),
                        );
                      },
                      child: const Text('Delete Post', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ],
              ),
            ],
          ),
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
                            
                            if (AccountPage.recentPosts.any((post) => 
                                post['content'] == widget.content && 
                                post['username'] == widget.username)) {
                              final post = AccountPage.recentPosts.firstWhere((post) => 
                                  post['content'] == widget.content && 
                                  post['username'] == widget.username);
                              post['comments'] = widget.comments;
                            }
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
                  addCommentToDatabase(commentController.text, globalUserId, widget.postId);
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