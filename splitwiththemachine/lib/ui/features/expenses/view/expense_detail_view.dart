import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import '../viewmodel/expenses_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenseDetailScreen extends StatefulWidget {
  const ExpenseDetailScreen({
    super.key,
    required this.expense,
    required this.viewModel
  });

  final Expense expense;
  final ExpenseViewModel viewModel;

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ExpenseViewModel>(); // TODO
    final expense = widget.expense;

    // Two possible screens for navigation
    final pages = [
      _buildDetails(expense),
      _buildFriends(expense),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(expense.description),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
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

  // ---- UI sections ----
  Widget _buildDetails(Expense expense) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description: ${expense.description}'),
          const SizedBox(height: 8),
          Text('Amount: ${expense.amount.toStringAsFixed(2)} €'),
          const SizedBox(height: 8),
          Text('Date: ${expense.getDateString()}'),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildFriends(Expense expense) {
    if (expense.friends.isEmpty) {
      return const Center(
        child: Text('No friends added'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: expense.friends.length,
      itemBuilder: (context, index) {
        final friend = expense.friends[index];
        return Card(
          child: ListTile(
            title: Text(friend.name),
            subtitle: Text('Credit: ${friend.creditBalance} €'),
            leading: const Icon(Icons.person),
          ),
        );
      },
    );
  }
}
