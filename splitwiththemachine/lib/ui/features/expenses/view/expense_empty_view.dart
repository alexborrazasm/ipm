import 'package:flutter/material.dart';
import 'package:splitwiththemachine/ui/core/widgets/centered_message.dart';

class ExpenseEmptyView extends StatelessWidget {
  const ExpenseEmptyView({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          centerTitle: true,
        ),
        body: const Center(
            child: CenteredMessage(message: "Pick an expense")
        )
    );
  }
}
