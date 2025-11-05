import 'package:flutter/material.dart';

class InfoBar extends StatelessWidget {
  const InfoBar({
    super.key,
    required this.message,
    required this.onPressed,
    this.isError = false,
  });

  final String message;
  final Function onPressed;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isError
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isError
                    ? Theme.of(context).colorScheme.onErrorContainer
                    : Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            ElevatedButton(
              onPressed: () => onPressed(),
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(
                  isError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: Text("Dismiss"),
            ),
          ],
        ),
      ),
    );
  }
}
