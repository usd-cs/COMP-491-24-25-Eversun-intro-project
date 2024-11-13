import 'package:flutter/material.dart';
import 'state_machine.dart';

// Bottom Section of the Screen
class BottomSection extends StatelessWidget {
  final UserType userType;
  final Function(DisplayStates) triggerDisplayChange;

  const BottomSection({super.key, required this.userType, required this.triggerDisplayChange});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5, // 13% of screen height
      child: Container(
        color: const Color.fromARGB(255, 255, 166, 42),
        child: BottomContent(userType: userType, triggerDisplayChange: triggerDisplayChange), 
      ),
    );
  }
}
//creates all the buttons in the row (changes for the state the user is in)
class BottomContent extends StatelessWidget {
  final UserType userType;
  final Function(DisplayStates) triggerDisplayChange;

  const BottomContent({super.key, required this.userType, required this.triggerDisplayChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Background color for the navigation bar
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Padding for the bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Evenly space the buttons
        children: [
          BottomButton(
            relativePath: 'assets/images/UserLoggedIn.png',
            action: () => triggerDisplayChange(DisplayStates.account),
            label: 'Account',
          ),
          BottomButton(
            relativePath: 'assets/images/Home.png',
            action: () => triggerDisplayChange(DisplayStates.forum),
            label: 'Home',
          ),
          BottomButton(
            relativePath: 'assets/images/BackArrow.png',
            action: () {
              print("swipe left button pressed");
            },
            label: 'Swipe Left',
          ),
          BottomButton(
            relativePath: 'assets/images/ForwardArrow.png',
            action: () {
              print("swipe right button pressed");
            },
            label: 'Swipe Right',
          ),
        ],
      ),
    );
  }
}
//a generic button template used by all buttons
class BottomButton extends StatelessWidget {
  final String relativePath;
  final VoidCallback action;
  final String label;

  const BottomButton({
    super.key,
    required this.relativePath,
    required this.action,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Image.asset(relativePath, color: const Color.fromARGB(255, 255, 166, 42)), // Orange icon color
          iconSize: 5.0, // Smaller icon size
          onPressed: action,
        ),
        Text(
          label,
          style: const TextStyle(color: Color.fromARGB(255, 255, 166, 42), fontSize: 10.0), // Orange label styling
        ),
      ],
    );
  }
}
