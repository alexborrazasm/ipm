import 'package:flutter/material.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:splitwiththemachine/ui/core/widgets/info_bar.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'expense_detail_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({
    super.key,
    required this.title,
    required this.viewModel,
  });

  final String title;
  final ExpenseViewModel viewModel;

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
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
          return Stack(
            children: [
              if (widget.viewModel.loadExpenses.running)
                const Center(child: CircularProgressIndicator()),

              if (!widget.viewModel.loadExpenses.running)
                widget.viewModel.expenses.isEmpty
                    ? const Center(child: Text("No expenses"))
                    : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 12,
                        right: 12,
                        bottom: 8,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return ExpenseRow(
                              expense: widget.viewModel.expenses[index],
                            );
                          },
                          childCount: widget.viewModel.expenses.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 200),
                    ),
                  ],
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
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add an expense',
        child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/add_expense');
          },
      )
    );
  }
}

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
