import 'package:flutter/material.dart';

class ContentHeader extends StatelessWidget {
  final String imagePath; // Image path from assets folder

  const ContentHeader({
    Key? key,
    required this.imagePath, // Make it required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 500.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath), // Use the asset image
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 500.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15, // 35% from the bottom
          left: MediaQuery.of(context).size.width * 0.05, // 5% from the left
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
            children: [
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hi,\n ',
                      style: TextStyle(
                        fontSize: 48.0, // Larger font for "Hi"
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'where are we going today?',
                      style: TextStyle(
                        fontSize: 25.0, // Smaller font for the rest
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}