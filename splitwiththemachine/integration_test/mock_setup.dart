import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'app_test.mocks.dart';
import 'package:splitwiththemachine/data/models.dart';

MockSplitWithMeService buildMockService() {
  final mockService = MockSplitWithMeService();

  // Configure mock behavior
  when(mockService.fetchExpenses()).thenAnswer((_) async => [
    Expense(
      id: 1,
      description: "Groceries",
      date: DateTime(2025, 01, 02),
      amount: 32.45,
      creditBalance: 0,
    ),
    Expense(
      id: 2,
      description: "Coffee",
      date: DateTime(2025, 01, 04),
      amount: 3.10,
      creditBalance: 0,
    ),
    Expense(
      id: 3,
      description: "Bus Ticket",
      date: DateTime(2025, 01, 06),
      amount: 1.50,
      creditBalance: 0,
    ),
    Expense(
      id: 4,
      description: "Dinner",
      date: DateTime(2025, 01, 08),
      amount: 18.99,
      creditBalance: 0,
    ),
    Expense(
      id: 5,
      description: "Books",
      date: DateTime(2024, 03, 02),
      amount: 120.6,
      creditBalance: 3.3,
      friends: [
        Friend(
          id: 1,
          name: "Nerea",
          creditBalance: 0,
          debitBalance: 40.2,
        ),
        Friend(
          id: 4,
          name: "Alex",
          creditBalance: 1.3,
          debitBalance: 40.2,
        ),
        Friend(
          id: 3,
          name: "Dani",
          creditBalance: 2,
          debitBalance: 40.2,
        ),
      ],
    ),
    Expense(
      id: 6,
      description: "Gym Membership",
      date: DateTime(2025, 01, 12),
      amount: 29.99,
      creditBalance: 0,
    ),
  ]);

  when(mockService.fetchFriends()).thenAnswer((_) async => [
    Friend(id: 1, name: "Nerea"),
    Friend(id: 2, name: "Pepe"),
    Friend(id: 3, name: "Dani"),
    Friend(id: 4, name: "Alex"),
    Friend(id: 5, name: "Marcos"),
    Friend(id: 6, name: "Manolo"),
  ]);

  when(mockService.addFriendToExpense(2, 5)).thenAnswer((_) async => [
    Friend(id: 5, name: "Marcos", debitBalance: 1.55, creditBalance: 0),
  ]);

  when(mockService.addExpense(any)).thenAnswer((_) async =>
    Expense(
      id: 7,
      description: "New TV",
      date: DateTime(2025, 01, 06),
      amount: 1500.99,
      creditBalance: 0,
    ),
  );

  when(mockService.addExpense(
    argThat(
      predicate<Expense>((e) =>
      e.description == 'Gym Membership' &&
      e.date.year == 2025 &&
      e.date.month == 1 &&
      e.date.day == 12,
      ),
    ),
  )).thenAnswer((_) async {
    throw ServerException(
      message: "Expense 'Gym Membership' is already added",
      type: ServerErrorType.validation,
    );
  });

  return mockService;
}
