import 'package:flutter/material.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_sized_box.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_snack_bar.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:flutter/services.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:intl/intl.dart';
import '../widgets/expense_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  Future<void> _openCalendar() async {
    final picked = await Navigator.push<DateTime>(
      context,
      MaterialPageRoute(
        builder: (_) => ExpenseCalendar(initialDate: selectedDate),
      ),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('EEEE, MMMM d').format(picked);
      });
    }
  }

  Widget _buildIconField({required IconData icon, required TextField field}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: field),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(title: widget.title),
      body: GenericSizedBox(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildIconField(
                  icon: FontAwesomeIcons.fileLines,
                  field: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ),
                _buildIconField(
                  icon: FontAwesomeIcons.moneyBill,
                  field: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                ),
                _buildIconField(
                  icon: FontAwesomeIcons.calendar,
                  field: TextField(
                    controller: dateController,
                    readOnly: true,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    onTap: _openCalendar,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary
                  ),
                  onPressed: () async {
                    final description = descriptionController.text;
                    final amount = double.tryParse(amountController.text) ?? 0.0;

                    if (description.isEmpty || amount <= 0) {
                      GenericSnackBar.show(context, 'Please fill in all fields correctly.');
                      return;
                    }

                    try {
                      final expense = Expense(
                        description: description,
                        amount: amount,
                        date: selectedDate,
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
      )
    );
  }
}
