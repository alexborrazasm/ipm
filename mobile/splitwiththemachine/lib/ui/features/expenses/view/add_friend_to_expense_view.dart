import 'package:flutter/material.dart';
import 'package:splitwiththemachine/ui/core/widgets/centered_message.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_sized_box.dart';
import 'package:splitwiththemachine/ui/core/widgets/scrollable_sliver_list.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import '../viewmodel/expenses_viewmodel.dart';
import '../widgets/generic_search.dart';

class AddFriendToExpenseScreen extends StatefulWidget {
  const AddFriendToExpenseScreen({
    super.key,
    required this.viewModel,
  });

  final ExpenseViewModel viewModel;

  @override
  State<AddFriendToExpenseScreen> createState() => _AddFriendToExpenseScreenState();
}

class _AddFriendToExpenseScreenState extends State<AddFriendToExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(title: 'Add Friend'),
      body: GenericSizedBox(
        child: widget.viewModel.friends.isEmpty
            ? CenteredMessage(message: "No friends")
            : ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) {
            final availableFriends = widget.viewModel.filteredFriendsInExpense;
            return ScrollableSliverList(
              emptyListMsg: widget.viewModel.searchQueryFriends != ""
                  ? "No friends found"
                  : "All friends added",
              header: GenericSearch(
                viewModel: widget.viewModel,
                getSearchQuery: (vm) => vm.searchQueryFriends,
                onSearchChanged: (vm, value) => vm.searchFriends(value),
                hintText: 'Search friends',
              ),
              itemCount: availableFriends.length,
              itemBuilder: (context, index) {
                final friend = availableFriends[index];
                return Card(
                  key: ValueKey("friend-${friend.id}"),
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final args = FriendExpenseArgs(
                        expense: widget.viewModel.selectedExpense!,
                        friend: friend,
                      );
                      widget.viewModel.addFriendToExpense.execute(args);
                      Navigator.pop(context);
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
      ),
    );
  }
}
