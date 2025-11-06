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
  DateTime selectedDate = DateTime.now();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  late final TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(
      text: DateFormat('EEEE, MMMM d').format(selectedDate),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select expense date',
      cancelText: 'Cancel',
      confirmText: 'OK',
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('EEEE, MMMM d').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

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
                labelText: 'Date',
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
