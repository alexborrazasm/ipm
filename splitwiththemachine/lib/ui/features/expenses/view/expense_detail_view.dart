import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import 'package:splitwiththemachine/ui/core/widgets/centered_message.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_floating_button.dart';
import '../../../core/themes/app_theme.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:splitwiththemachine/ui/features/expenses/view/edit_expense_view.dart';
import 'package:splitwiththemachine/ui/features/expenses/view/add_friend_to_expense_view.dart';
import 'package:flutter/services.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_snack_bar.dart';

// -----------------------------
//  SHARED COMPONENTS
// -----------------------------
class ExpenseDetailsSection extends StatelessWidget {
  const ExpenseDetailsSection({
    super.key,
    required this.expense,
    required this.viewModel,
  });

  final Expense expense;
  final ExpenseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(
                icon: FontAwesomeIcons.fileLines,
                label: 'Description',
                value: expense.description,
              ),
              const SizedBox(height: 12),
              _DetailRow(
                icon: FontAwesomeIcons.moneyBill,
                label: 'Amount',
                value: '\$ ${expense.amount.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 12),
              _DetailRow(
                icon: FontAwesomeIcons.scaleBalanced,
                label: 'Balance',
                value: '\$ ${expense.creditBalance?.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 12),
              _DetailRow(
                icon: FontAwesomeIcons.calendar,
                label: 'Date',
                value: expense.getDateString(),
              ),
            ],
          ),
        )
    );
  }
}

class ExpenseFriendsSection extends StatefulWidget {
  const ExpenseFriendsSection({
    super.key,
    required this.viewModel,
  });

  final ExpenseViewModel viewModel;

  @override
  State<ExpenseFriendsSection> createState() => _ExpenseFriendsSectionState();
}

class _ExpenseFriendsSectionState extends State<ExpenseFriendsSection> {
  Expense get expense => widget.viewModel.selectedExpense!;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final friends = expense.friends;

        if (friends.isEmpty) {
          return const CenteredMessage(message: "No friends added");
        }

        return Column(
          children: friends.map((friend) {
            return Dismissible(
              key: ValueKey("friend-${friend.id}"),
              direction: DismissDirection.horizontal,
              background: _buildAddBackground(context),
              secondaryBackground: _buildRemoveBackground(context),
              confirmDismiss: (direction) =>
                  _handleDismiss(context, direction, friend),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(friend.name),
                  subtitle: Text(
                    "Credit: \$ ${friend.creditBalance?.toStringAsFixed(2) ?? '-'}\n"
                    "Debit: \$ ${friend.debitBalance?.toStringAsFixed(2) ?? '-'} ",
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Helper widgets and methods for clarity
  Widget _buildAddBackground(BuildContext context) => Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Theme.of(context).extension<CustomColors>()!.addCredit,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(Icons.add, size: 28),
  );

  Widget _buildRemoveBackground(BuildContext context) => Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.error,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(Icons.delete, size: 28),
  );

  Future<bool> _handleDismiss(
      BuildContext context, DismissDirection direction, Friend friend
      ) async {
    if (direction == DismissDirection.startToEnd) {
      return _addCredit(context, friend);
    } else if (direction == DismissDirection.endToStart) {
      return _removeFriend(context, friend);
    }
    return false;
  }

  Future<bool> _addCredit(BuildContext context, Friend friend) async {
    final controller = TextEditingController();
    final amount = await showDialog<double>(
      context: context,
      builder: (_) => _AmountDialog(controller: controller),
    );

    if (amount != null) {
      final args = CreditArgs(
        expense: expense,
        friend: friend,
        amount: double.parse(amount.toStringAsFixed(2)),
      );

      widget.viewModel.addCreditToFriend.execute(args);
      GenericSnackBar.show(context,
          'Added \$ ${args.amount.toStringAsFixed(2)} to ${friend.name}'
      );
    }
    return false;
  }

  Future<bool> _removeFriend(BuildContext context, Friend friend) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _RemoveFriendDialog(friendName: friend.name),
    );

    if (confirmed ?? false) {
      final args = FriendExpenseArgs(expense: expense, friend: friend);
      widget.viewModel.deleteFriendFromExpense.execute(args);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'The friend "${friend.name}" was removed from the expense'
          )
      ));
    }
    return false;
  }
}

// -----------------------------
//  SCREEN
// -----------------------------
class ExpenseDetailScreen extends StatefulWidget {
  const ExpenseDetailScreen({
    super.key,
    required this.viewModel,
  });

  final ExpenseViewModel viewModel;

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final expense = widget.viewModel.selectedExpense!;
        final hasFriends = expense.friends.isNotEmpty;

        return Scaffold(
          appBar: GenericAppBar(title: expense.description),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.circleInfo, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Details',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ExpenseDetailsSection(
                        expense: expense,
                        viewModel: widget.viewModel),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.userGroup, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Friends',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (hasFriends) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ExpenseFriendsSection(viewModel: widget.viewModel),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 200),
                    ),
                  ] else
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ExpenseFriendsSection(viewModel: widget.viewModel),
                      ),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _EditExpenseButton(viewModel: widget.viewModel),
              const SizedBox(height: 16),
              _AddFriendButton(viewModel: widget.viewModel),
            ],
          ),
        );
      },
    );
  }
}

// -----------------------------
//  AUX CLASSES
// -----------------------------
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

@override
Widget build(BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FaIcon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    ],
  );
}
}

// Private reusable buttons for this screen
class _EditExpenseButton extends StatelessWidget {
  final ExpenseViewModel viewModel;

  const _EditExpenseButton({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericFloatingButton(
      tooltip: "Edit expense",
      icon: Icons.edit,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditExpenseScreen(
              viewModel: viewModel,
            ),
          ),
        );
      },
    );
  }
}

class _AddFriendButton extends StatelessWidget {
  final ExpenseViewModel viewModel;

  const _AddFriendButton({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericFloatingButton(
      tooltip: "Add friend",
      icon: Icons.person_add,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddFriendToExpenseScreen(
              viewModel: viewModel,
            ),
          ),
        ).then((_) {
          viewModel.searchFriends(""); // Clean search
        });
      },
    );
  }
}

class _AmountDialog extends StatelessWidget {
  final TextEditingController controller;

  const _AmountDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Credit'),
      content: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
            decimal: true, signed: true
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'^-?\d*\.?\d{0,2}$')
          ),
        ],
        decoration: const InputDecoration(
          labelText: 'Enter amount',
          hintText: 'example 10.50',
          suffixText: '\$',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final value = double.tryParse(controller.text);
            Navigator.pop(context, value);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _RemoveFriendDialog extends StatelessWidget {
  final String friendName;

  const _RemoveFriendDialog({required this.friendName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete friend'),
      content: Text('Are you sure you want to delete $friendName from this expense?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
      ],
    );
  }
}
