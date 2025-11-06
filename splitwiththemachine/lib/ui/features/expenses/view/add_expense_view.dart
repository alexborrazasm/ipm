import 'package:flutter/material.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:flutter/services.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({
    super.key,
    required this.title,
    required this.viewModel,
  });

  final String title;
  final ExpenseViewModel viewModel;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();

  DateTime? selectedDate;

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  String _getLocalizedDateFormat(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final pattern = DateFormat.yMd(locale).pattern ?? 'yyyy-MM-dd';

    return pattern
        .replaceAll('y', 'YYYY')
        .replaceAll('M', 'MM')
        .replaceAll('d', 'DD');
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime today = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? today,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select expense date',
      cancelText: 'Cancel',
      confirmText: 'OK',
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final locale = Localizations.localeOf(context).toString();
        dateController.text = DateFormat.yMd(locale).format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizedPattern = _getLocalizedDateFormat(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
              readOnly: true,
              decoration: InputDecoration(
                labelText: '$localizedPattern',
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () => _pickDate(context),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final description = descriptionController.text;
                final amount = double.tryParse(amountController.text) ?? 0.0;
                final date = selectedDate;

                if (description.isEmpty || amount <= 0 || date == null) {
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

                  await widget.viewModel.addExpense.execute(expense);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
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
