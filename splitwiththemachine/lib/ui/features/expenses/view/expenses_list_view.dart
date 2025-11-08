import 'package:flutter/material.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import 'package:splitwiththemachine/ui/core/widgets/centered_message.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_floating_button.dart';
import 'package:splitwiththemachine/ui/core/widgets/scrollable_sliver_list.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:splitwiththemachine/ui/core/widgets/info_bar.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({
    super.key,
    required this.title,
    required this.viewModel,
    this.onExpenseSelected,
  });

  final String title;
  final ExpenseViewModel viewModel;

  // Optional callback for when an expense is tapped (for tablet layout)
  final void Function(Expense expense)? onExpenseSelected;

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(
        title: widget.title,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'help_feedback':
                  Navigator.pushNamed(context, '/help_feedback');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'help_feedback',
                child: Text('Help and feedback'),
              )
            ],
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.loadExpenses,
        ]),
        builder: (context, child) {
          final filteredExpenses = widget.viewModel.expenses
              .where((expense) =>
          expense.description.toLowerCase().contains(
              widget.viewModel.searchQuery.toLowerCase())).toList();
          return Stack(
            children: [
              if (widget.viewModel.loadExpenses.running)
                const Center(child: CircularProgressIndicator()),

              if (!widget.viewModel.loadExpenses.running)
                widget.viewModel.expenses.isEmpty
                    ? const CenteredMessage(message: "No expenses")
                    : ScrollableSliverList(
                  header: TextField(
                    onChanged: (value) => widget.viewModel.search(value),
                    decoration: InputDecoration(
                      hintText: 'Search expenses',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = widget.viewModel.expenses[index];
                    return ExpenseRow(
                      expense: filteredExpenses[index],
                      viewModel: widget.viewModel,
                      onTap: () {
                        if (widget.onExpenseSelected != null) {
                          widget.onExpenseSelected!(expense);
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/expense_detail',
                            arguments: expense,
                          );
                        }
                      },
                    );
                  },
                ),

              if (widget.viewModel.loadExpenses.error)
                Align(
                  alignment: Alignment.topCenter,
                  child: InfoBar(
                    message: widget.viewModel.errorMessage!,
                    onPressed: () {
                      widget.viewModel.loadExpenses.clearResult();
                      widget.viewModel.loadExpenses.execute();
                    },
                    isError: true,
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: GenericFloatingButton(
          tooltip: "Add an expense",
          onPressed: () {
            Navigator.pushNamed(context, '/add_expense');
          },
          icon: Icons.add
      )
    );
  }
}

class ExpenseRow extends StatelessWidget {
  const ExpenseRow({
    super.key,
    required this.expense,
    required this.viewModel,
    required this.onTap,
  });

  final Expense expense;
  final ExpenseViewModel viewModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey("expense-${expense.id}"),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 28),
        ),
        confirmDismiss: (direction) async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete expense'),
              content: const Text('Are you sure you want to delete this expense?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
          return confirmed ?? false;
        },
        onDismissed: (direction) async {
          await viewModel.deleteExpense.execute(expense);
          viewModel.selectExpense(null);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Expense "${expense.description}" deleted')),
          );
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: ListTile(
              leading: FaIcon(
                FontAwesomeIcons.creditCard,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(expense.description),
              subtitle: Text('Balance: ${expense.creditBalance} €'),
            ),
          ),
        ),
      );
  }
}
