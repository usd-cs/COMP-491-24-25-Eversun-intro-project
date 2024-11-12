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
      flex: 13, // 13% of screen height
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
    return Row(
      children: [
        if (userType == UserType.loggedOut) ...[
          BottomButton( //Login - LoggedOut User
            relativePath: 'assets/images/UserLoggedIn.png',
            action: () => triggerDisplayChange(DisplayStates.login),
          ),
        ] else if (userType == UserType.loggedIn) ...[
          BottomButton( //Logout - loggedIn User
            relativePath: 'assets/images/UserLoggedIn.png',
            action: () => triggerDisplayChange(DisplayStates.login),
          ),
          BottomButton( //Post - loggedIn User
            relativePath: 'assets/images/Post.png',
            action: () {
              print("post button pressed");
            },
          ),
        ] else ...[
          BottomButton( //Logout - admin User
            relativePath: 'assets/images/UserLoggedIn.png',
            action:  () => triggerDisplayChange(DisplayStates.login),
          ),
          BottomButton( //Remove - admin User
            relativePath: 'assets/images/Remove.png',
            action: () {
              print("remove button pressed");
            },
          ),
        ],
        // Static buttons for all user types
        BottomButton( //Home
          relativePath: 'assets/images/Home.png',
          action: () => triggerDisplayChange(DisplayStates.forum),
        ),
        BottomButton( //Back
          relativePath: 'assets/images/BackArrow.png',
          action: () {
            print("back button pressed");
          },
        ),
        BottomButton( //Forward
          relativePath: 'assets/images/ForwardArrow.png',
          action: () {
            print("forward button pressed");
          },
        ),
      ],
    );
  }
}
//a generic button template used by all buttons
class BottomButton extends StatelessWidget {
  final String relativePath;
  final Function action;

  const BottomButton({
    super.key,
    required this.relativePath,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => action(),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparent background
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero,),
          
          side: const BorderSide(
            color: Colors.white, // Outline color set to white
            width: 1, // Set outline width
          ),
        ),
        child: Center(
          child: Image.asset(
              relativePath,
              height: 30,
              width: 30,
            ),
        ),
      ),
    );
  }
}
