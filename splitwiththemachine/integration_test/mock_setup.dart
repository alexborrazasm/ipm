import 'package:mockito/mockito.dart';
import 'app_test.mocks.dart';
import 'package:splitwiththemachine/data/models.dart';

MockSplitWithMeService buildMockService() {
  final mockService = MockSplitWithMeService();

  // Configure mock behavior
  when(mockService.fetchExpenses()).thenAnswer((_) async => [
    Expense(
      description: "Groceries",
      date: DateTime(2025, 01, 02),
      amount: 32.45,
    ),
    Expense(
      description: "Coffee",
      date: DateTime(2025, 01, 04),
      amount: 3.10,
    ),
    Expense(
      description: "Bus Ticket",
      date: DateTime(2025, 01, 06),
      amount: 1.50,
    ),
    Expense(
      description: "Dinner",
      date: DateTime(2025, 01, 08),
      amount: 18.99,
    ),
    Expense(
      description: "Books",
      date: DateTime(2025, 01, 10),
      amount: 54.20,
    ),
    Expense(
      description: "Gym Membership",
      date: DateTime(2025, 01, 12),
      amount: 29.99,
    ),
  ]);

  when(mockService.fetchFriends()).thenAnswer((_) async => [
    Friend(id: 1, name: "Mock 1", creditBalance: 0, debitBalance: 0),
  ]);


  return mockService;
}
