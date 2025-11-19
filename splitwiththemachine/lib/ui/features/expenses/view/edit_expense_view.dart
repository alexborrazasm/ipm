import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_sized_box.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_snack_bar.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import '../widgets/expense_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/reusable_form_body.dart';

class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({
    super.key,
    required this.viewModel,
  });
  final ExpenseViewModel viewModel;
  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController descriptionController;
  late TextEditingController amountController;
  late TextEditingController dateController;
  late Expense expense;

  @override
  void initState() {
    super.initState();
    expense = widget.viewModel.selectedExpense!;

    descriptionController = TextEditingController(
        text: expense.description
    );
    amountController = TextEditingController(
        text: expense.amount.toStringAsFixed(2)
    );
    dateController = TextEditingController(
      text: DateFormat('EEEE, MMMM d, y').format(widget.viewModel.selectedDate),
    );

    // Subscribe to ViewModel changes
    widget.viewModel.addListener(_updateFromViewModel);
  }

  void _updateFromViewModel() {
    // Update date text whenever selectedDate changes in VM
    dateController.text =
        DateFormat('EEEE, MMMM d, y').format(widget.viewModel.selectedDate);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    dateController.dispose();
    widget.viewModel.removeListener(_updateFromViewModel);
    super.dispose();
  }

  Future<void> _openCalendar() async {
    final picked = await Navigator.push<DateTime>(
      context,
      MaterialPageRoute(
        builder: (_) => ExpenseCalendar(initialDate: widget.viewModel.selectedDate),
      ),
    );

    if (picked != null) {
      // Notify the ViewModel instead of calling setState
      widget.viewModel.setSelectedDate(picked);
    }
  }

  void _saveExpense() {
    final description = descriptionController.text;
    final amount = double.tryParse(amountController.text) ?? 0.0;

    if (description.isEmpty || amount <= 0) {
      GenericSnackBar.show(context, 'Please fill in all fields correctly.');
      return;
    }

    final updatedExpense = Expense(
      id: expense.id,
      description: description,
      amount: amount,
      date: widget.viewModel.selectedDate,
      friends: expense.friends,
      creditBalance: expense.creditBalance,
    );

    if (updatedExpense.description != expense.description ||
        updatedExpense.amount != expense.amount ||
        updatedExpense.date != expense.date) {
      widget.viewModel.editExpense.execute(updatedExpense);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(title: 'Edit Expense'),
      body: ReusableFormBody(
        descriptionController: descriptionController,
        amountController: amountController,
        dateController: dateController,
        onDateTap: _openCalendar,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Save',
        heroTag: "animated-1",
        onPressed: _saveExpense,
        child: Icon(Icons.save),
      ),
    );
  }
}