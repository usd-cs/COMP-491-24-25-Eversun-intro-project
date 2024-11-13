import 'package:flutter/material.dart';
import 'state_machine.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'dart:math';

class MiddleSection extends StatelessWidget {
  final DisplayStates currentDisplayState;
  final Function(UserType) triggerUserChange;
  final Function(DisplayStates) triggerDisplayChange;
  const MiddleSection({super.key, required this.currentDisplayState, required this.triggerUserChange, required this.triggerDisplayChange});

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (currentDisplayState == DisplayStates.login) {
      content = LoginContent(triggerUserChange: triggerUserChange, triggerDisplayChange: triggerDisplayChange);
    } else if (currentDisplayState == DisplayStates.forum) {
      content = ForumContent();
    } else if (currentDisplayState == DisplayStates.comment) {
      content = const CommentContent();
    } else if (currentDisplayState == DisplayStates.account) {
      content = AccountContent(triggerUserChange: triggerUserChange, triggerDisplayChange: triggerDisplayChange);
    } else {
      content = const Text('Unknown State'); // Default for any undefined states
    }

    return Expanded(
      flex: 70,
      child: Container(
        color: Colors.grey[200],
        child: Center(child: content),
      ),
    );
  }
}



class LoginContent extends StatelessWidget {
  final Function(UserType) triggerUserChange;
  final Function(DisplayStates) triggerDisplayChange;
  const LoginContent({super.key, required this.triggerUserChange, required this.triggerDisplayChange});
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add some padding around the content
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Username TextField
          const TextField(
            style: TextStyle(color: Colors.white,),
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Color.fromARGB(255, 255, 166, 42),
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16), // Add space between the fields

          // Password TextField
          const TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor:  Color.fromARGB(255, 255, 166, 42),
              border: InputBorder.none,
            ),
            obscureText: true, // Hide the text for the password field
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 16), // Add space between the fields

          const SizedBox(
            height: 80,
          ),

          // Login Button
          ElevatedButton(
            onPressed: () {
              // Implement login functionality here
              triggerUserChange(UserType.loggedIn);
              triggerDisplayChange(DisplayStates.forum);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 166, 42), // Transparent background
              shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)),),
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
            ),
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}


class ForumContent extends StatefulWidget {
  const ForumContent({super.key});

  @override
  _ForumContentState createState() => _ForumContentState();
}

class _ForumContentState extends State<ForumContent> {
  late String username;
  late String postContent;
  late DateTime postDate;

  @override
  void initState() {
    super.initState();
    generateRandomPost();
  }

  void generateRandomPost() {
    final List<String> usernames = ["Alice", "Bob", "Charlie", "Diana"];
    final List<String> contents = [
      "Really enjoyed this!",
      "Thanks for sharing.",
      "Interesting perspective.",
      "Could you elaborate on this point?"
    ];

    setState(() {
      username = usernames[Random().nextInt(usernames.length)];
      postContent = contents[Random().nextInt(contents.length)];
      postDate = DateTime.now().subtract(Duration(days: Random().nextInt(10)));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sample post data
    final String username = "SampleUser";
    final String postContent = "Here is an example of what a post will look like.";
    final DateTime postDate = DateTime.now();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 166, 42),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('MM/dd/yyyy').format(postDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    postContent,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const CommentContent(),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                ),
                child: const Text(
                  'View Comments',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 166, 42),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Comment {
  final String username;
  final String content;
  final DateTime date;

  Comment({required this.username, required this.content, required this.date});
}

// Temporary list of comments for placeholder
List<Comment> tempComments = [
  Comment(username: "Alice", content: "Really enjoyed this!", date: DateTime.now().subtract(const Duration(days: 1))),
  Comment(username: "Bob", content: "Interesting perspective.", date: DateTime.now().subtract(const Duration(days: 2))),
  Comment(username: "Charlie", content: "Could you elaborate on this point?", date: DateTime.now().subtract(const Duration(days: 3))),
];

class CommentContent extends StatelessWidget {
  const CommentContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Comments'),
      content: SingleChildScrollView(
        child: ListBody(
          children: tempComments.map((comment) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(comment.username),
                subtitle: Text(comment.content),
                trailing: Text(DateFormat('MM/dd/yyyy').format(comment.date)),
              ),
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class AccountContent extends StatelessWidget {
  final Function(UserType) triggerUserChange;
  final Function(DisplayStates) triggerDisplayChange;

  const AccountContent({super.key, required this.triggerUserChange, required this.triggerDisplayChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Placeholder for user account image
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/DefaultUser.png'), // Ensure this image exists
          ),
          const SizedBox(height: 16),

          // Username
          const Text(
            'Username: JohnDoe',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 8),

          // Account Created Date
          const Text(
            'Account Created: Jan 1, 2020',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 8),

          // Account Info
          const Text(
            'Account Info: This is a sample account.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 16),

          // Logout Button
          Align(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
              onPressed: () {
                triggerUserChange(UserType.loggedOut);
                triggerDisplayChange(DisplayStates.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}