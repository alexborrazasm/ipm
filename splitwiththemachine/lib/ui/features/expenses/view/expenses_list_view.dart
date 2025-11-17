import 'package:flutter/material.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_floating_button.dart';
import 'package:splitwiththemachine/ui/core/widgets/scrollable_sliver_list.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_snack_bar.dart';
import '../widgets/generic_search.dart';
import 'expense_detail_view.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({
    super.key,
    required this.title,
    required this.viewModel,
    required this.mobile
  });

  final String title;
  final ExpenseViewModel viewModel;

  final bool mobile;

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
              if (value == 'help_feedback') {
                Navigator.pushNamed(context, '/help_feedback');
              }
            },
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem(
                value: 'help_feedback',
                child: Text('Help and feedback'),
              ),
            ],
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.loadExpenses,
          widget.viewModel.loadFriends,
          widget.viewModel.addExpense,
          widget.viewModel.deleteExpense,
          widget.viewModel.editExpense,
          widget.viewModel.addFriendToExpense,
          widget.viewModel.deleteFriendFromExpense,
          widget.viewModel.addCreditToFriend,
        ]),
        builder: (context, child) {
          final filteredExpenses = widget.viewModel.filteredExpenses;
          final isLoading = widget.viewModel.loadExpenses.running ||
              widget.viewModel.loadFriends.running;

          if (widget.viewModel.loadExpenses.error ||
              widget.viewModel.loadFriends.error
          ) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ErrorSnackBar.show(
                context,
                widget.viewModel.errorMessage!,
                actionLabel: "Retry",
                onAction: () {
                  if (widget.viewModel.loadExpenses.error) {
                    widget.viewModel.loadExpenses.clearResult();
                    widget.viewModel.loadExpenses.execute();
                  }
                  if (widget.viewModel.loadFriends.error) {
                    widget.viewModel.loadFriends.clearResult();
                    widget.viewModel.loadFriends.execute();
                  }
                  ErrorSnackBar.hide();
                },
              );
            });
          }

          if (widget.viewModel.addExpense.error ||
              widget.viewModel.deleteExpense.error ||
              widget.viewModel.editExpense.error ||
              widget.viewModel.addFriendToExpense.error ||
              widget.viewModel.deleteFriendFromExpense.error ||
              widget.viewModel.addCreditToFriend.error
          ) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ErrorSnackBar.show(
                context,
                widget.viewModel.errorMessage!,
                actionLabel: "Dismiss",
                onAction: () {
                  widget.viewModel.addExpense.error
                      ? widget.viewModel.addExpense.clearResult()
                      : widget.viewModel.deleteExpense.error
                      ? widget.viewModel.deleteExpense.clearResult()
                      : widget.viewModel.editExpense.error
                      ? widget.viewModel.editExpense.clearResult()
                      : widget.viewModel.addFriendToExpense.error
                      ? widget.viewModel.addFriendToExpense.clearResult()
                      : widget.viewModel.deleteFriendFromExpense.error
                      ? widget.viewModel.deleteFriendFromExpense.clearResult()
                      : widget.viewModel.addCreditToFriend.error
                      ? widget.viewModel.addCreditToFriend.clearResult()
                      : null;
                  ErrorSnackBar.hide();
                },
              );
            });
          }

          if (widget.viewModel.addExpense.completed ||
              widget.viewModel.deleteExpense.completed ||
              widget.viewModel.editExpense.completed ||
              widget.viewModel.addFriendToExpense.completed ||
              widget.viewModel.deleteFriendFromExpense.completed ||
              widget.viewModel.addCreditToFriend.completed
          ) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              GenericSnackBar.show(
                context,
                widget.viewModel.infoMessage!,
              );
              widget.viewModel.addExpense.completed
              ? widget.viewModel.addExpense.clearResult()
              : widget.viewModel.deleteExpense.completed
              ? widget.viewModel.deleteExpense.clearResult()
              : widget.viewModel.editExpense.completed
              ? widget.viewModel.editExpense.clearResult()
              : widget.viewModel.addFriendToExpense.completed
              ? widget.viewModel.addFriendToExpense.clearResult()
              : widget.viewModel.deleteFriendFromExpense.completed
              ? widget.viewModel.deleteFriendFromExpense.clearResult()
              : widget.viewModel.addCreditToFriend.completed
              ? widget.viewModel.addCreditToFriend.clearResult()
              : null;
            });
          }

          return ScrollableSliverList(
            emptyListMsg: widget.viewModel.searchQueryExpenses != ""
                ? "No expenses found"
                : "No expenses",
            header: GenericSearch(
              viewModel: widget.viewModel,
              getSearchQuery: (vm) => vm.searchQueryExpenses,
              onSearchChanged: (vm, value) => vm.searchExpenses(value),
              hintText: 'Search expenses',
            ),
            itemCount: filteredExpenses.length,
            itemBuilder: (context, index) {
              final expense = filteredExpenses[index];
              return ExpenseRow(
                expense: expense,
                viewModel: widget.viewModel,
                isSelected: !widget.mobile &&
                    expense == widget.viewModel.selectedExpense,
                onTap: () {
                  widget.viewModel.selectExpense(expense);
                  if (widget.mobile) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExpenseDetailScreen(
                            viewModel: widget.viewModel,
                        ),
                      ),
                    );
                  }
                  widget.viewModel.searchExpenses("");
                },
              );
            },
            loading: isLoading,
            loadBuilder: (context) {
              return expenseRowLoadingBuilder(context);
            }
          );
        },
      ),
      floatingActionButton: GenericFloatingButton(
        tooltip: "Add an expense",
        onPressed: () {
          Navigator.pushNamed(context, '/add_expense');
          widget.viewModel.setSelectedDate(DateTime.now());
        },
        icon: Icons.add,
        viewModel: widget.viewModel,
        commands: [widget.viewModel.addExpense],
        heroTag: widget.mobile ? "animated-1" : null,
      ),
    );
  }
}

class ExpenseRow extends StatelessWidget {
  const ExpenseRow({
    super.key,
    required this.expense,
    required this.viewModel,
    this.isSelected = false,
    required this.onTap,
  });

  final Expense expense;
  final ExpenseViewModel viewModel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDeleting = viewModel.deleteExpense.running;
    final bool isMarked;
    if (viewModel.deletingExpense != null) {
      isMarked = viewModel.deletingExpense!.id == expense.id;
    } else {
      isMarked = false;
    }
    final isDisabled = isDeleting && isMarked;

    return Dismissible(
      key: ValueKey("expense-${expense.id}"),
      direction: isDeleting ? DismissDirection.none : DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, size: 28),
      ),
      confirmDismiss: (direction) async {
        if (isDeleting) return false; // extra safety
        final _ = await showDialog<bool>(
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
                onPressed: () {
                  Navigator.pop(context, true);
                  viewModel.deleteExpense.execute(expense);
                  viewModel.markDeletingExpense(expense);
                  viewModel.selectExpense(null);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        );
        return false;
      },
      child: Tooltip (
        message: 'Click to view expense\nSlide left to remove',
        triggerMode: TooltipTriggerMode.longPress,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isSelected ? Theme.of(context).colorScheme.
            surfaceContainerHighest : null,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: isDisabled ? null : onTap,
            child: ListTile(
              leading: FaIcon(
                FontAwesomeIcons.creditCard,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(expense.description),
              subtitle: Text(
                  'Balance: \$ ${expense.creditBalance?.toStringAsFixed(2)}'
              ),
              trailing: isDisabled
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : null,
            ),
          ),
        ),
      )
    );
  }
}

Widget expenseRowLoadingBuilder(BuildContext context, {double? height}) {
  final rowHeight = height ?? 80.0; // approximate ListTile height

  return SizedBox(
    height: rowHeight,
    child: Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation(
            Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    ),
  );
}
