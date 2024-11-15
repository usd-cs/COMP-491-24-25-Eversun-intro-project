import 'package:flutter/material.dart';
import 'post_card.dart';

/// Account page that displays user information and recent posts.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key, required this.username});

  final String username;

  static List<Map<String, dynamic>> recentPosts = []; // Stores recent posts.

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        // Displays a default profile picture.
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/default_profile.png'),
        ),
        const SizedBox(height: 16),
        Text(
          'Username: $username',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Account Created: 01/01/2023',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        const Text(
          'Recent Posts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // Displays each recent post as a PostCard widget.
        ...recentPosts.map((post) => PostCard(
              content: post['content']!,
              username: 'user123',
              comments: post['comments'],
            )),
      ],
    );
  }
}