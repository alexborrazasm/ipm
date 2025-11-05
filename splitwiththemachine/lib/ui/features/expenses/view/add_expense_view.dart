import 'package:flutter/material.dart';
import '../viewmodel/expenses_viewmodel.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({
    super.key,
    required this.title,
    required this.viewModel
  });

  final String title;
  final ExpenseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        centerTitle: true
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) {
                // TODO: update ViewModel if needed
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // TODO: parse and update ViewModel
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: call viewModel.addExpense(...)
                Navigator.pop(context); // go back to list
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
