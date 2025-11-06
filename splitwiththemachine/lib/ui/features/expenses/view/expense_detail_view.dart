import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ExpenseViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(expense.description),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${expense.description}'),
            const SizedBox(height: 8),
            Text('Amount: ${expense.amount.toStringAsFixed(2)} €'),
            const SizedBox(height: 8),
            Text('Date: ${expense.date}'),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.circleInfo),
            label: 'Details',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.userGroup),
            label: 'Friends',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          // TODO
          // Manage logic for navigation destinations
        },
      ),
    );
  }
}


