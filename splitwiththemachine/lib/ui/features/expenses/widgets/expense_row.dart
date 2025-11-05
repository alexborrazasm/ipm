import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenseRow extends StatelessWidget {
  const ExpenseRow({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          key: ValueKey("expense-${expense.id}"),
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FaIcon(
                FontAwesomeIcons.creditCard,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {}, // puedes añadir acción si quieres
                child: Text(
                  expense.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
