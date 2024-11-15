// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:chitchat_app/query_attempts.dart';
import 'package:chitchat_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'home_page.dart';
import 'global_variables.dart';
import 'account_page.dart';

/// Main entry point of the application.
void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Builds the application structure, setting theme and the main page.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chit Chat', // Sets the app title.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange), // Sets color theme.
        useMaterial3: true,
      ),
      home: MainPage(), // Main page of the app, now not a constant.
    );
  }
}

/// MainPage serves as the primary interface with navigation between Account and Home pages.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1; // Tracks the selected navigation index
  late List<Widget> _pages; // Declare _pages here without initializing

  @override
  void initState() {
    super.initState();
    // Initialize _pages here where instance variables are accessible
    _pages = [
      AccountPage(username: currentUsername),
      HomePage(posts: AccountPage.recentPosts),
    ];
  }

  /// Handles bottom navigation taps and updates selected index.
  void _onItemTapped(int index) {
    if (index == 0 && !isLoggedIn) { // Account page index is 0
      _showLoginDialog();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  /// Displays a dialog to create a new post with a title and content.
  void _showCreatePostDialog() {
    if (!isLoggedIn) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController contentController = TextEditingController();
        return AlertDialog(
          title: const Text('Create Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Post Content'),
                maxLines: 5,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (contentController.text.isNotEmpty) {
                  addPostToDatabase(contentController.text, globalUserId);
                  setState(() {
                    AccountPage.recentPosts.insert(0, {
                      'content': contentController.text,
                      'username': currentUsername,
                      'comments': <Map<String, String>>[]
                    });
                    _pages[1] = HomePage(posts: AccountPage.recentPosts); // Re-instantiate HomePage
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

  /// Generates a list of random comments for a post.
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

    return List.generate(2, (index) {
      return {
        'username': usernames.removeAt(random.nextInt(usernames.length)),
        'content': randomComments[random.nextInt(randomComments.length)],
        'date': randomDate(),
      };
    });
  }

  void refreshCurrentPage() {
    setState(() {
      // This will trigger the build method to run again, refreshing the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      AccountPage(username: currentUsername),
      HomePage(posts: AccountPage.recentPosts),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Chit Chat')),
        backgroundColor: Colors.orange,
        leading: isLoggedIn ? IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _logout,
        ) : null,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: _showCreatePostDialog,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController usernameController = TextEditingController();
        TextEditingController passwordController = TextEditingController();
        return AlertDialog(
          title: const Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Login'),
              onPressed: () async {
                String username = usernameController.text;
                String password = passwordController.text;
                List<bool> loginfeedback = await loginAttempt(username, password);
                if (loginfeedback[0]) {
                  setState(() {
                    isLoggedIn = true;
                    isAdmin = loginfeedback[1];
                    UserService.isAdmin = loginfeedback[1];
                    currentUsername = username;
                  });
                  Navigator.of(context).pop();
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid credentials')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    setState(() {
      isLoggedIn = false;
      isAdmin = false;
      
      // Navigate to the home page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),  // Navigate to MainPage
        (Route<dynamic> route) => false,
      );
    });
  }


}