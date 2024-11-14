import 'package:flutter/material.dart';
import 'dart:math';
import 'post_card.dart';
import 'account_page.dart';

/// Home page displaying recent posts and randomly generated posts.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required List posts});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> randomPosts = _generateRandomPosts();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: AccountPage.recentPosts.length + randomPosts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = index < AccountPage.recentPosts.length
            ? AccountPage.recentPosts[index]
            : randomPosts[index - AccountPage.recentPosts.length];
        return PostCard(
          content: post['content'],
          username: post['username'],
          comments: post['comments'],
          onDelete: isLoggedIn ? () => setState(() {}) : null,
          onAddComment: isLoggedIn ? () => _handleAddComment(post) : null,
        );
      },
    );
  }

  void _handleAddComment(Map<String, dynamic> post) {
    // Logic to handle adding a comment
    // This is just a placeholder function
  }

  void showLoginAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You must be logged in to post and comment.')),
    );
  }

  /// Generates a list of random posts for the homepage.
  List<Map<String, dynamic>> _generateRandomPosts() {
    final random = Random();
    final List<String> usernames = [
      "randomUser1",
      "randomUser2",
      "randomUser3",
      "randomUser4",
      "randomUser5",
    ];
    final List<String> randomContents = [
      "Just sharing some thoughts...",
      "Here are some tips for Flutter.",
      "Latest news in tech today.",
      "Here's what happened today.",
      "Coding is fun when you know how!",
    ];

    Map<String, int> userPostCount = {};
    return List.generate(5, (index) {
      String username;
      do {
        username = usernames[random.nextInt(usernames.length)];
      } while (userPostCount[username] != null && userPostCount[username]! >= 2);

      userPostCount[username] = (userPostCount[username] ?? 0) + 1;

      return {
        'content': randomContents[random.nextInt(randomContents.length)],
        'username': username,
        'comments': _generateRandomComments(),
      };
    });
  }

  List<Map<String, String>> _generateRandomComments() {
    final random = Random();
    final List<String> usernames = [
      "user123",
      "flutterFan",
      "devGuru",
      "codeMaster",
      "techSavvy",
    ];
    final List<String> randomComments = [
      "I totally agree!",
      "That's interesting.",
      "Thanks for sharing!",
      "I have a different opinion.",
      "Great post!",
    ];

    // Ensure unique usernames for comments
    List<String> availableUsernames = List.from(usernames);
    return List.generate(2, (index) {
      String username = availableUsernames.removeAt(random.nextInt(availableUsernames.length));
      return {
        'username': username,
        'content': randomComments[random.nextInt(randomComments.length)],
      };
    });
  }
  
}