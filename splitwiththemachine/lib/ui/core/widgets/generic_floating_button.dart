import 'package:flutter/material.dart';

/// Generic Floating Action Button for reuse
class GenericFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String tooltip;

  const GenericFloatingButton({
    super.key,
    required this.onPressed,
    this.tooltip = '',
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: tooltip,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
