import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:splitwiththemachine/ui/core/widgets/centered_message.dart';
import 'package:splitwiththemachine/ui/core/widgets/scrollable_sliver_list.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import '../viewmodel/expenses_viewmodel.dart';

class AddFriendToExpenseScreen extends StatelessWidget {
  const AddFriendToExpenseScreen({
    super.key,
    required this.viewModel,
    required this.expense,
  });

  final ExpenseViewModel viewModel;
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(
        title: 'Add Friend',
      ),
      body: viewModel.friends.isEmpty ?
      const Padding(
        padding: EdgeInsets.all(32.0),
        child: CenteredMessage(message: "No friends"),
      ) : ScrollableSliverList(
          itemCount: viewModel.friends.length,
          itemBuilder: (context, index) {
            final friend = viewModel.friends[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.pop(context);
                  FriendExpenseArgs args = FriendExpenseArgs(
                    expense: expense,
                    friend: friend,
                  );
                  viewModel.addFriendToExpense.execute(args);
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
      )
    );
  }
}