import 'package:flutter/material.dart';

// Top Section
class TopSection extends StatelessWidget {
  const TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 17, // 17% of screen height
      child: TopSectionContent(),
    );
  }
}
//Contents of the top section color and title
class TopSectionContent extends StatelessWidget {
  const TopSectionContent({super.key});

  @override
  Widget build(BuildContext context) {
  return Container(
      color: const Color.fromARGB(255, 255, 166, 42),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double fontSize = constraints.maxHeight * 0.4; // Adjust font size based on container height
            return Text(
              "ChitChat",
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize, // Dynamically adjusted font size
              ),
            );
          },
        ),
      ),
    );
  }
}