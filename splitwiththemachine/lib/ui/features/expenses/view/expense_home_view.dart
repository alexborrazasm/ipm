import 'package:flutter/material.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'expense_detail_view.dart';
import 'expenses_list_view.dart';
import 'expense_empty_view.dart';

/// Main screen for displaying expenses, adapts layout for tablet and mobile.
class ExpenseHomeScreen extends StatefulWidget {
  const ExpenseHomeScreen({
    super.key,
    required this.title,
    required this.viewModel});

  final String title;
  final ExpenseViewModel viewModel;

  @override
  State<ExpenseHomeScreen> createState() => _ExpenseHomeScreenState();
}

class _ExpenseHomeScreenState extends State<ExpenseHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                final viewModel = widget.viewModel;

                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ExpenseListScreen(
                        title: widget.title,
                        viewModel: viewModel,
                        onExpenseSelected: viewModel.selectExpense,
                      ),
                    ),

                    Expanded(
                      flex: 3,
                      child: viewModel.selectedExpense != null
                          ? ExpenseDetailBigScreen(
                        expense: viewModel.selectedExpense!,
                        viewModel: viewModel,
                      )
                          : const ExpenseEmptyView(title: "Expense details"),
                    ),
                  ],
                );
              },
            );
          }

          return ExpenseListScreen(
            title: widget.title,
            viewModel: widget.viewModel,
            onExpenseSelected: (expense) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpenseDetailScreen(
                    expense: expense,
                    viewModel: widget.viewModel,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
