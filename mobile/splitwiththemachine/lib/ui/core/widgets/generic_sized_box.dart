import 'package:flutter/material.dart';

class GenericSizedBox extends StatelessWidget {
  const GenericSizedBox({
    super.key,
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 700,
        child: child,
      ),
    );
  }
}