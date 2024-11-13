import 'package:flutter/material.dart';
import 'state_machine.dart';
import 'basic_screen_a_top_logo.dart';
import 'basic_screen_b_middle_content.dart';
import 'basic_screen_c_bottom_bar.dart';

// Full screen pulls all the elements together
class ScreenLayout extends StatefulWidget {
  const ScreenLayout({super.key});

  @override
  _ScreenLayoutState createState() => _ScreenLayoutState();
}

class _ScreenLayoutState extends State<ScreenLayout> {
  DisplayStates currentDisplayState = DisplayStates.forum;
  UserType currentUserState = UserType.loggedOut;

  // Function to handle state change
  void _triggerDisplayChange(DisplayStates newState) {
    setState(() {
      currentDisplayState = newState;
    });
  }

  void _triggerUserChange(UserType newState) {
    setState(() {
      currentUserState = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const TopSection(),
            // Pass the current state and change function to MiddleSection
            MiddleSection(currentDisplayState: currentDisplayState, triggerUserChange: _triggerUserChange, triggerDisplayChange: _triggerDisplayChange),
            // Pass the change function to BottomSection
            BottomSection(userType: currentUserState, triggerDisplayChange: _triggerDisplayChange),
          ],
        ),
      ),
    );
  }
}
