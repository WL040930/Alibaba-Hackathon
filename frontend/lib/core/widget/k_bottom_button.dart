import 'package:flutter/material.dart';

class KBottomButton extends StatelessWidget {
  final VoidCallback onTap; 
  final String text; 
  const KBottomButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: Colors.blueAccent, // Custom background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            elevation: 5, // Shadow elevation
            shadowColor: Colors.black54, // Shadow color
          ),
          child: const Text(
            "Save",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text color
            ),
          ),
        ),
      ),
    );
  }
}
