import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:splitwiththemachine/ui/core/widgets/centered_message.dart';
import 'package:splitwiththemachine/ui/core/widgets/scrollable_sliver_list.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import '../viewmodel/expenses_viewmodel.dart';
import '../widgets/generic_search.dart';

class AddFriendToExpenseScreen extends StatefulWidget {
  const AddFriendToExpenseScreen({
    super.key,
    required this.viewModel,
    required this.expense,
  });

  final ExpenseViewModel viewModel;
  final Expense expense;

  @override
  State<AddFriendToExpenseScreen> createState() => _AddFriendToExpenseScreenState();
}

class _AddFriendToExpenseScreenState extends State<AddFriendToExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(title: 'Add Friend'),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          final availableFriends = widget.viewModel.friends
              .where((f) => !widget.expense.friends.any((e) => e.id == f.id))
              .where((f) => GenericSearch.matchSearch(f.name, widget.viewModel.searchQuery))
              .toList();

          return availableFriends.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(32.0),
            child: CenteredMessage(message: "No friends"),
          )
              : ScrollableSliverList(
            header: GenericSearch(
              viewModel: widget.viewModel,
              getSearchQuery: (vm) => vm.searchQuery,
              onSearchChanged: (vm, value) => vm.search(value),
              hintText: 'Search friends',
            ),
            itemCount: availableFriends.length,
            itemBuilder: (context, index) {
              final friend = availableFriends[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.pop(context);
                    final args = FriendExpenseArgs(
                      expense: widget.expense,
                      friend: friend,
                    );
                    widget.viewModel.addFriendToExpense.execute(args);
                  },
                  child: ListTile(
                    title: Text(friend.name),
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
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
