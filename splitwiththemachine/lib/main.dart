import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/services.dart';
import 'data/repositories.dart';
import 'ui/core/themes/app_theme.dart';
import 'ui/features/expenses/view/expense_home_view.dart';
import 'ui/features/expenses/view/add_expense_view.dart';
import 'ui/features/help_feedback/view/help_feedback_view.dart';
import 'ui/features/expenses/viewmodel/expenses_viewmodel.dart';

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
          ChangeNotifierProvider(
            create: (context) => ExpenseViewModel(
              expenseRepository: context.read(),
              friendRepository: context.read(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SplitWithTheMachine',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          initialRoute: '/expenses',
          routes: {
            '/expenses': (context) => ExpenseHomeScreen(
              title: 'Expenses',
              viewModel: context.read<ExpenseViewModel>(),
            ),
            '/add_expense': (context) => AddExpenseScreen(
              title: 'New expense',
              viewModel: context.read<ExpenseViewModel>(),
            ),
            '/help_feedback': (context) => HelpAndFeedbackScreen(
              title: 'Help and feedback',
            ),
          },
        ),
    );
  }
}
