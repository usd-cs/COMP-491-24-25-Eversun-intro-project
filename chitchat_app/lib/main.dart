import 'package:flutter/material.dart';
import 'basic_screen_layout.dart';
import 'basic_screen_a_top_logo.dart';
import 'basic_screen_b_middle_content.dart';
import 'basic_screen_c_bottom_bar.dart';
import 'state_machine.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  void triggerDisplayChange(DisplayStates newState) {
    setState(() {
      currentDisplayState = newState;
    });
  }

  void triggerUserChange(UserType newUserType) {
    setState(() {
      currentUserType = newUserType;
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
    );
  }
}