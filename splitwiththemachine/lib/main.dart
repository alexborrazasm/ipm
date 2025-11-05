import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/services.dart';
import 'data/repositories.dart';
import 'ui/expenses_view.dart';
import 'ui/expenses_viewmodel.dart';

void main() {
  runApp(MyApp(
      expenseRepository: ExpenseRepository(service: SplitWithMeAPIService()),
      friendRepository: FriendRepository(service: SplitWithMeAPIService())
        )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.expenseRepository,
    required this.friendRepository});

  final FriendRepository friendRepository;
  final ExpenseRepository expenseRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => expenseRepository),
        Provider(create: (context) => friendRepository),
      ],
      builder: (context, widget) {
        return MaterialApp(
          title: 'SplitWithFriends',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          ),
          home: FriendsScreen(
            title: 'Friend list',
            viewModel: ExpenseViewModel(
                expenseRepository: context.read(),
                friendRepository: context.read()
            ),
          ),
        );
      }
    );
  }
}
