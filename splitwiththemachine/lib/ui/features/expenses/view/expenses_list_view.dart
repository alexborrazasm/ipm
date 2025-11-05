import 'package:flutter/material.dart';
import 'package:splitwiththemachine/ui/core/widgets/info_bar.dart';
import '../viewmodel/expenses_viewmodel.dart';
import '../widgets/expense_row.dart';

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
        centerTitle: true
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
                Center(child: CircularProgressIndicator()),

              widget.viewModel.expenses.isEmpty
                  ? Center(child: Text("No expenses"))
                  : CustomScrollView(
                      slivers: [
                        if (widget.viewModel.loadExpenses.error)
                          SliverToBoxAdapter(
                            child: InfoBar(
                              message: widget.viewModel.errorMessage!,
                              onPressed: widget.viewModel.loadExpenses.clearResult,
                              isError: true,
                            ),
                          ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return ExpenseRow(
                              expense: widget.viewModel.expenses[index],
                            );
                          }, childCount: widget.viewModel.expenses.length),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 200)),
                      ],
                    ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add an expense',
        child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/help_feedback');
          },
      )
    );
  }
}
