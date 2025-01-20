import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget {
  final double scrollOffset;

  const CustomAppBar({Key? key, this.scrollOffset = 0.0,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 24.0,
      ),
      color: Colors.deepPurple.withOpacity((scrollOffset / 350).clamp(0, 1).toDouble()),
      child: SafeArea(
        child: Row(
          children: [
            // Logo button
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer(); // Open the navigation drawer
              },
              child: Image.asset(
                'assets/images/logo.png',
                height: 40.0, // Set logo size
              ),
            ),
            const SizedBox(width: 12.0),
            // Add additional widgets here if needed
          ],
        ),
      ),
    );
  }
}
