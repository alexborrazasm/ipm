import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:splitwiththemachine/data/models.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_floating_button.dart';
import '../widgets/expense_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenseEditScreen extends StatefulWidget {
  final Expense expense;
  final ExpenseViewModel viewModel;

  const ExpenseEditScreen({
    super.key,
    required this.expense,
    required this.viewModel,
  });

  @override
  State<ExpenseEditScreen> createState() => _ExpenseEditScreenState();
}

class _ExpenseEditScreenState extends State<ExpenseEditScreen> {
  late DateTime selectedDate;
  late TextEditingController descriptionController;
  late TextEditingController amountController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.expense.date;
    descriptionController = TextEditingController(text: widget.expense.description);
    amountController = TextEditingController(text: widget.expense.amount.toStringAsFixed(2));
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

  void _saveExpense() {
    final description = descriptionController.text;
    final amount = double.tryParse(amountController.text) ?? 0.0;

    if (description.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly.')),
      );
      return;
    }

    final updatedExpense = Expense(
      id: widget.expense.id,
      description: description,
      amount: amount,
      date: selectedDate,
      friends: widget.expense.friends,
      creditBalance: widget.expense.creditBalance,
    );

    //TODO The ViewModel logic still needs to be implemented for this to work.


    Navigator.pop(context, updatedExpense);
  }

  Widget _buildDetailRow({required IconData icon, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(title: 'Edit Expense'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow(
              icon: FontAwesomeIcons.fileLines,
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ),
            _buildDetailRow(
              icon: FontAwesomeIcons.moneyBill,
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
            ),
            _buildDetailRow(
              icon: FontAwesomeIcons.calendar,
              child: TextField(
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
          ],
        ),
      ),
      floatingActionButton: GenericFloatingButton(
        tooltip: 'Save',
        icon: Icons.save,
        onPressed: _saveExpense,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.circleInfo, color: Colors.grey),
            label: 'Details',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.userGroup, color: Colors.grey),
            label: 'Friends',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (_) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You must exit edit mode to switch tabs'),
              duration: Duration(seconds: 1),
            ),
          );
        },

      ),
    );
  }

}
