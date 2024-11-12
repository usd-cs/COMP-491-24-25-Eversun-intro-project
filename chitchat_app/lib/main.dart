import 'package:flutter/material.dart';
import 'dart:math';

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
      home: const MainPage(), // Main page of the app.
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
  int _selectedIndex = 1; // Tracks the selected navigation index.

  // List of pages for navigation.
  static const List<Widget> _pages = <Widget>[
    AccountPage(),
    HomePage(),
  ];

  /// Handles bottom navigation taps and updates selected index.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Displays a dialog to create a new post with a title and content.
  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController contentController = TextEditingController();
        return AlertDialog(
          title: Text('Create Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text field for post title
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Post Title'),
              ),
              SizedBox(height: 8),
              // Text field for post content
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Post Content'),
                maxLines: 5,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes dialog.
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Checks if fields are non-empty before adding post
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  AccountPage.recentPosts.add({
                    'title': titleController.text,
                    'content': contentController.text,
                    'comments': _generateRandomComments(),
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
        'date': _randomDate(),
      };
    });
  }

  /// Generates a random date within the past 30 days.
  String _randomDate() {
    final now = DateTime.now();
    final randomDays = Random().nextInt(30);
    final randomDate = now.subtract(Duration(days: randomDays));
    return "${randomDate.month}/${randomDate.day}/${randomDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Chit Chat',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: _pages[_selectedIndex], // Displays the current page.
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
        currentIndex: _selectedIndex, // Highlights selected tab.
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

/// Account page that displays user information and recent posts.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static List<Map<String, dynamic>> recentPosts = []; // Stores recent posts.

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        // Displays a default profile picture.
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/default_profile.png'),
        ),
        SizedBox(height: 16),
        Text(
          'Username: user123',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Account Created: 01/01/2023',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 16),
        Text(
          'Recent Posts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // Displays each recent post as a PostCard widget.
        ...recentPosts.map((post) => PostCard(
              title: post['title']!,
              content: post['content']!,
              username: 'user123',
              comments: post['comments'],
            )),
      ],
    );
  }
}

/// Home page displaying recent posts and randomly generated posts.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          title: post['title'],
          content: post['content'],
          username: post['username'],
          comments: post['comments'],
        );
      },
    );
  }

  /// Generates a list of random posts for the homepage.
  List<Map<String, dynamic>> _generateRandomPosts() {
    final random = Random();
    final List<String> usernames = [
      "randomUser1",
      "FirewallFox",
      "GlitchGuru",
      "TerminalTitan",
    ];
    final List<String> randomTitles = [
      "Random Thoughts",
      "Flutter Tips",
      "Tech News",
      "Daily Update",
      "Coding Fun",
    ];
    final List<String> randomContents = [
      "Just sharing some thoughts...",
      "Here are some tips for Flutter.",
      "Latest news in tech today.",
      "Here's what happened today.",
      "Coding is fun when you know how!",
    ];

    // Limit each user to a maximum of 2 posts
    Map<String, int> userPostCount = {};
    return List.generate(5, (index) {
      String username;
      do {
        username = usernames[random.nextInt(usernames.length)];
      } while (userPostCount[username] != null && userPostCount[username]! >= 2);

      userPostCount[username] = (userPostCount[username] ?? 0) + 1;

      return {
        'title': randomTitles[random.nextInt(randomTitles.length)],
        'content': randomContents[random.nextInt(randomContents.length)],
        'username': username,
        'comments': _generateRandomComments(),
      };
    });
  }

  List<Map<String, String>> _generateRandomComments() {
    final random = Random();
    final List<String> usernames = [
      "NullNinja",
      "flutterFan",
      "devGuru",
      "StackSlinger",
      "JavaJunkie",
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
        'date': _randomDate(),
      };
    });
  }

  /// Generates a random date within the past 30 days.
  String _randomDate() {
    final now = DateTime.now();
    final randomDays = Random().nextInt(30);
    final randomDate = now.subtract(Duration(days: randomDays));
    return "${randomDate.month}/${randomDate.day}/${randomDate.year}";
  }
}

/// Card widget for displaying individual posts with title, content, and comments.
class PostCard extends StatelessWidget {
  final String? title;
  final String? content;
  final String? username;
  final List<Map<String, String>>? comments;
  final Random random = Random();

  PostCard({this.title, this.content, this.username, this.comments});

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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _randomDate(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title ?? "Untitled",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(content ?? "No content"),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _showCommentsDialog(context);
                },
                child: Text('View Comments'),
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
          title: Text('Comments'),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            comment['date']!,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(comment['content']!),
                      Divider(),
                    ],
                  )),
              // Input field for adding a new comment.
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Add a comment'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes dialog.
              },
            ),
            TextButton(
              child: Text('Submit'),
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
