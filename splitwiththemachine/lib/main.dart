import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/services.dart';
import 'data/repositories.dart';
import 'ui/expenses_view.dart';
import 'ui/expenses_viewmodel.dart';

void main() {
  final apiService = SplitWithMeAPIService(); // Only one instance

  final providers = [
    Provider(
      create: (context) => FriendRepository(service: apiService),
    ),
    Provider(
      create: (context) => ExpenseRepository(service: apiService),
    ),
  ];

  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
}
