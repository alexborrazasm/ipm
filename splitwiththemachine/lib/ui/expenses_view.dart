import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'expenses_viewmodel.dart';


class FriendsScreen extends StatefulWidget {
  const FriendsScreen({
    super.key,
    required this.title,
    required this.viewModel,
  });

  final String title;
  final ExpenseViewModel viewModel;

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.loadExpenses,
          widget.viewModel.loadFriends
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              if (widget.viewModel.loadExpenses.running ||
                  widget.viewModel.loadFriends.running)
                Center(child: CircularProgressIndicator()),

              widget.viewModel.friends.isEmpty
                  ? Center(child: Text("No friends"))
                  : CustomScrollView(
                      slivers: [
                        if (widget.viewModel.loadFriends.error ||
                            widget.viewModel.loadExpenses.error)
                          SliverToBoxAdapter(
                            child: InfoBar(
                              message: widget.viewModel.errorMessage!,
                              onPressed: widget.viewModel.loadFriends.clearResult,
                              isError: true,
                            ),
                          ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return FriendRow(
                              friend: widget.viewModel.friends[index],
                            );
                          }, childCount: widget.viewModel.friends.length),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 200)),
                      ],
                    ),
            ],
          );
        },
      ),

    );
  }
}

class FriendRow extends StatelessWidget {
  const FriendRow({super.key, required this.friend});

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        key: ValueKey("friend-${friend.id}"),
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(child: Text(friend.name.substring(0, 1))),
          ),
          Expanded(
            child: InkWell(
              child: Text(friend.name),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoBar extends StatelessWidget {
  const InfoBar({
    super.key,
    required this.message,
    required this.onPressed,
    this.isError = false,
  });

  final String message;
  final Function onPressed;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isError
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isError
                    ? Theme.of(context).colorScheme.onErrorContainer
                    : Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            ElevatedButton(
              onPressed: () => onPressed(),
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(
                  isError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: Text("Dismiss"),
            ),
          ],
        ),
      ),
    );
  }
}
