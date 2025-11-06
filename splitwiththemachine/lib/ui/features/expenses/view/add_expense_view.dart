import 'package:flutter/material.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:flutter/services.dart';
import 'package:splitwiththemachine/data/models.dart';


class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({
    super.key,
    required this.title,
    required this.viewModel,
  });

  final String title;
  final ExpenseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date (YYYY--MM-DD)',
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                final String description = descriptionController.text;
                final double amount = double.tryParse(amountController.text) ?? 0.0;
                final DateTime date = DateTime.parse(dateController.text);

                if (description.isEmpty || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields correctly.'),
                    ),
                  );
                  return;
                }

                try {
                  final expense = Expense(
                    description: description,
                    amount: amount,
                    date: date,
                  );

                  await viewModel.addExpense.execute(expense);

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid date format. Use YYYY-MM-DD.'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),

          ],
        ),
      ),
    );
  }
}
