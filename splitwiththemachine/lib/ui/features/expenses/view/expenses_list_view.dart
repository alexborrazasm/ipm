import 'package:flutter/material.dart';
import '../viewmodel/expenses_viewmodel.dart';
import '../widgets/expense_row.dart';
import 'package:splitwiththemachine/ui/core/widgets/info_bar.dart';

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
