import 'package:flutter/material.dart';
import 'state_machine.dart';

// BottomSection is the bottom part of the screen, typically containing navigation or action buttons.
class BottomSection extends StatelessWidget {
  final UserType userType;
  final Function(DisplayStates) triggerDisplayChange;

  const BottomSection({super.key, required this.userType, required this.triggerDisplayChange});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1, // 13% of screen height
      child: Container(
        color: const Color.fromARGB(255, 255, 166, 42),
        child: BottomContent(userType: userType, triggerDisplayChange: triggerDisplayChange), 
      ),
    );
  }
}

// BottomContent provides the actual content of the BottomSection, such as navigation icons.
class BottomContent extends StatelessWidget {
  final UserType userType;
  final Function(DisplayStates) triggerDisplayChange;

  const BottomContent({super.key, required this.userType, required this.triggerDisplayChange});

  @override
  Widget build(BuildContext context) {
    final double iconSize = MediaQuery.of(context).size.width * 0.1; 

    return Container(
      color: Colors.white, // Background color for the navigation bar
      padding: const EdgeInsets.symmetric(vertical: 2.0), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, 
        children: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.amber[800]),
            onPressed: () => triggerDisplayChange(DisplayStates.account),
            iconSize: iconSize,
          ),
          IconButton(
            icon: Icon(Icons.home, color: Colors.amber[800]),
            onPressed: () => triggerDisplayChange(DisplayStates.forum),
            iconSize: iconSize,
          ),
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.amber[800]),
            onPressed: () {
              print("Swipe left button pressed");
            },
            iconSize: iconSize,
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.amber[800]),
            onPressed: () {
              print("Swipe right button pressed");
            },
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }
}

// BottomButton is a reusable widget for buttons in the BottomContent, providing a consistent style.
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
    // Use MediaQuery to get screen size and adjust sizes dynamically
    double iconSize = MediaQuery.of(context).size.width * 0.08; // 8% of screen width
    double fontSize = MediaQuery.of(context).size.width * 0.035; // 3.5% of screen width

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Image.asset(relativePath, color: const Color.fromARGB(255, 255, 166, 42)), // Orange icon color
          iconSize: iconSize, // Dynamically adjusted icon size
          onPressed: action,
        ),
        Text(
          label,
          style: TextStyle(color: const Color.fromARGB(255, 255, 166, 42), fontSize: fontSize), // Dynamically adjusted font size
        ),
      ],
    );
  }
}
