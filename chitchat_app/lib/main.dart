import 'package:flutter/material.dart';
import 'basic_screen_a_top_logo.dart';
import 'basic_screen_b_middle_content.dart';
import 'basic_screen_c_bottom_bar.dart';
import 'state_machine.dart';
import 'create_post_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DisplayStates currentDisplayState = DisplayStates.login;
  UserType currentUserType = UserType.loggedOut;
  bool _showFAB = false; // Initially, do not show the FAB

  void triggerDisplayChange(DisplayStates newState) {
    setState(() {
      currentDisplayState = newState;
      // Update FAB visibility based on state and user type
      _showFAB = (currentUserType == UserType.loggedIn && newState == DisplayStates.forum);
    });
  }

  void triggerUserChange(UserType newUserType) {
    setState(() {
      currentUserType = newUserType;
      // Update FAB visibility based on user type and display state
      _showFAB = (newUserType == UserType.loggedIn && currentDisplayState == DisplayStates.forum);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopSection(),
          MiddleSection(
            currentDisplayState: currentDisplayState,
            triggerUserChange: triggerUserChange,
            triggerDisplayChange: triggerDisplayChange,
          ),
          if (currentUserType == UserType.loggedIn)
            BottomContent(
              userType: currentUserType,
              triggerDisplayChange: triggerDisplayChange,
            ),
        ],
      ),
      floatingActionButton: _showFAB ? Padding(
        padding: const EdgeInsets.only(bottom: 50.0), // Move FAB up to avoid overlapping
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePostPage()),
            );
          },
          tooltip: 'Create Post',
          child: const Icon(Icons.add),
        ),
      ) : null,
    );
  }
}