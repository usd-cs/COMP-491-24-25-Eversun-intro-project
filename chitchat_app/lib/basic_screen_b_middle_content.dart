import 'package:flutter/material.dart';
import 'state_machine.dart';

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
      content = const ForumContent();
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
          // UsernamEmail TextField
          const TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Color.fromARGB(255, 255, 166, 42),
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white,),
          ),
          const SizedBox(height: 16),

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

class ForumContent extends StatelessWidget {
  const ForumContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 166, 42),
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space the elements apart
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0), // Padding around the text
              child: Text(
                'this is an example of what a post will look like if it were to be here',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2.0), // Padding around the button
              child: ElevatedButton(
                onPressed: () {
                  // Add your action here
                  print("Comments button pressed");
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2), // Padding inside the button
                ),
                child: const Text(
                  'Comments',
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

class CommentContent extends StatelessWidget {
  const CommentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 166, 42),
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space the elements apart
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0), // Padding around the text
              child: Text(
                'this is an example of what a post will look like if it were to be here',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2.0), // Padding around the button
              child: ElevatedButton(
                onPressed: () {
                  // Add your action here
                  print("Comments button pressed");
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2), // Padding inside the button
                ),
                child: const Text(
                  'Comments',
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
            backgroundImage: AssetImage('assets/images/placeholder_user.png'), // Ensure this image exists
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