import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import 'package:splitwiththemachine/ui/core/widgets/centered_message.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_floating_button.dart';
import 'package:splitwiththemachine/ui/core/widgets/scrollable_sliver_list.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:splitwiththemachine/ui/features/expenses/view/edit_expense_view.dart';

// -----------------------------
//  SHARED COMPONENTS
// -----------------------------
class ExpenseDetailsSection extends StatelessWidget {
  const ExpenseDetailsSection({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
            value: '${expense.amount.toStringAsFixed(2)} €',
          ),
          const SizedBox(height: 12),
          _DetailRow(
            icon: FontAwesomeIcons.moneyBillTransfer,
            label: 'Balance',
            value: '${expense.creditBalance?.toStringAsFixed(2)} €',
          ),
          const SizedBox(height: 12),
          _DetailRow(
            icon: FontAwesomeIcons.calendar,
            label: 'Date',
            value: expense.getDateString(),
          ),
        ],
      ),
    );
  }
}

class ExpenseFriendsSection extends StatelessWidget {
  const ExpenseFriendsSection({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return expense.friends.isEmpty ?
    const Padding(
      padding: EdgeInsets.all(32.0),
      child: CenteredMessage(message: "No friends added"),
    ) : ScrollableSliverList(
        itemCount: expense.friends.length,
        itemBuilder: (context, index) {
          final friend = expense.friends[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(friend.name),
              subtitle: Text(
                  "Credit: ${friend.creditBalance?.toStringAsFixed(2)} € "
                  "| Debit: ${friend.debitBalance?.toStringAsFixed(2)} €"),
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          );
        }
    );
  }
}

// -----------------------------
//  MOBILE VERSION
// -----------------------------
class ExpenseDetailScreen extends StatefulWidget {
  const ExpenseDetailScreen({
    super.key,
    required this.expense,
    required this.viewModel,
  });

  final Expense expense;
  final ExpenseViewModel viewModel;

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  int _selectedIndex = 0; // Navigation bar index
  late Expense expense;

  @override
  void initState() {
    super.initState();
    expense = widget.expense; // Creamos una referencia local que podemos reemplazar
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Scaffold(
        body: ExpenseDetailsSection(expense: expense),
        floatingActionButton: _EditExpenseButton(
          onPressed: () async {
            final updated = await Navigator.push<Expense>(
              context,
              MaterialPageRoute(
                builder: (_) => ExpenseEditScreen(
                  expense: expense,
                  viewModel: widget.viewModel,
                ),
              ),
            );

            if (updated != null) {
              setState(() {
                expense = updated;
              });
            }
          },
        ),
      ),
      Scaffold(
        body: ExpenseFriendsSection(expense: expense),
        floatingActionButton: _AddFriendButton(
          onPressed: () => print('Add friend TODO'),
        ),
      ),
    ];

    return Scaffold(
      appBar: GenericAppBar(title: expense.description),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.circleInfo),
            label: 'Details',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.userGroup),
            label: 'Friends',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// -----------------------------
//  TABLET / BIG SCREEN VERSION
// -----------------------------
class ExpenseDetailBigScreen extends StatefulWidget {
  const ExpenseDetailBigScreen({
    super.key,
    required this.expense,
    required this.viewModel,
  });

  final Expense expense;
  final ExpenseViewModel viewModel;

  @override
  State<ExpenseDetailBigScreen> createState() => _ExpenseDetailBigScreenState();
}

class _ExpenseDetailBigScreenState extends State<ExpenseDetailBigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(title: widget.expense.description),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.circleInfo, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            ExpenseDetailsSection(expense: widget.expense),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.userGroup, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Friends',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            Expanded(child: ExpenseFriendsSection(expense: widget.expense)),
          ],
        ),
      ),
      floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EditExpenseButton(onPressed: () => print('Edit TODO')),
            const SizedBox(height: 16),
            _AddFriendButton(onPressed: () => print('Add friend TODO')),
          ]
        )
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
  final VoidCallback onPressed;

  const _EditExpenseButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericFloatingButton(
      tooltip: "Edit expense",
      icon: Icons.edit,
      onPressed: onPressed,
    );
  }
}

class _AddFriendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddFriendButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericFloatingButton(
      tooltip: "Add friend",
      icon: Icons.person_add,
      onPressed: onPressed,
    );
  }
}