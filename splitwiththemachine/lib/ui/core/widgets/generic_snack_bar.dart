import 'package:flutter/material.dart';


// Generic SnackBar to show info messages
class GenericSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Check if dark or light mode
    final brightness = Theme.of(context).brightness;
    final bool isDarkMode = brightness == Brightness.dark;

    // Define colors
    final Color backgroundColor = isDarkMode
        ? Colors.grey[800]!
        : Colors.grey[700]!;

    final Color textColor = isDarkMode
        ? Colors.white
        : Colors.white;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            message,
            style: TextStyle(color: textColor)
        ),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
