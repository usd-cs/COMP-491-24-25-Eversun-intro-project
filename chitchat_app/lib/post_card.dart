import 'package:flutter/material.dart';
import 'dart:math';
import 'account_page.dart';
import 'global_variables.dart';

/// Card widget for displaying individual posts with title, content, and comments.
class PostCard extends StatelessWidget {
  final String? title;
  final String? content;
  final String? username;
  final List<Map<String, String>>? comments;
  final Random random = Random();

  PostCard({super.key, this.title, this.content, this.username, this.comments});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  username ?? "Anonymous",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _randomDate(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title ?? "Untitled",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(content ?? "No content"),
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
                    // Delete post logic
                    AccountPage.recentPosts.removeWhere((post) => post['title'] == title);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post deleted')),
                    );
                  },
                  child: const Text('Delete Post', style: TextStyle(color: Colors.red)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Generates a random date within the past 30 days.
  String _randomDate() {
    final now = DateTime.now();
    final randomDays = random.nextInt(30);
    final randomDate = now.subtract(Duration(days: randomDays));
    return "${randomDate.month}/${randomDate.day}/${randomDate.year}";
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
              // List of existing comments.
              ...?comments?.map((comment) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            comment['username']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            comment['date']!,
                            style: const TextStyle(color: Colors.grey),
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
                              // Delete comment logic
                              comments?.remove(comment);
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
              // Input field for adding a new comment.
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
                Navigator.of(context).pop(); // Closes dialog.
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  comments?.add({
                    'username': 'user123',
                    'content': commentController.text,
                    'date': _randomDate(),
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}