import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../view/expense_detail_view.dart';

class ExpenseRow extends StatelessWidget {
  const ExpenseRow({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainer, // Card background
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExpenseDetailScreen(expense: expense),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              key: ValueKey("expense-${expense.id}"),
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
                  child: Text(
                    expense.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
