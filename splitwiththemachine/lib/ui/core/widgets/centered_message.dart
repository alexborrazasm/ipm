import 'package:flutter/material.dart';

/// A reusable widget that centers a text message.
class CenteredMessage extends StatelessWidget {
  const CenteredMessage({
    super.key,
    required this.message,
  });

  /// The text message to display
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}