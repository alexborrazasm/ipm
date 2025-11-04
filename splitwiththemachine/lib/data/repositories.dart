import 'package:splitwiththemachine/utils/result.dart';
import 'services.dart';
import 'models.dart';

// Args for adding/removing a friends from an expense
class FriendExpenseArgs {
  final int expenseId;
  final List<int> friendIds;

  const FriendExpenseArgs({
    required this.expenseId,
    required this.friendIds,
  });
}

// Args for adding credit to a friend in an expense
class CreditArgs {
  final int expenseId;
  final int friendId;
  final double amount;

  const CreditArgs({
    required this.expenseId,
    required this.friendId,
    required this.amount
  });
}

class ExpenseRepository {
  ExpenseRepository({required SplitWithMeService service}) : _service = service;
  late final SplitWithMeService _service;

  // Fetch all expenses
  Future<Result<List<Expense>>> fetchExpenses() async {
    // TODO: implement this
    throw UnimplementedError();
  }

  // Add a new expense
  Future<Result<Expense>> addExpense(Expense expense) async {
    // TODO: implement this
    throw UnimplementedError();
  }

  // Edit an existing expense
  Future<Result<Expense>> editExpense(Expense expense) async {
    // TODO: implement this
    throw UnimplementedError();
  }

  // Remove an expense by ID
  Future<Result<void>> removeExpense(int id) async {
    // TODO: implement this
    throw UnimplementedError();
  }

  // Add friends to an expense (multiple IDs possible)
  Future<Result<void>> addFriendToExpense(FriendExpenseArgs args) async {
    // TODO: implement this
    throw UnimplementedError();
  }

  // Delete friends from an expense
  Future<Result<void>> deleteFriendFromExpense(FriendExpenseArgs args) async {
    // TODO: implement this
    throw UnimplementedError();
  }

  // Add credit to a friend in an expense
  Future<Result<void>> addCreditToFriend(CreditArgs args) async {
    // TODO: implement this
    throw UnimplementedError();
  }

}

class FriendRepository {
  FriendRepository({required SplitWithMeService service}) : _service = service;
  late final SplitWithMeService _service;

  Future<Result<List<Friend>>> fetchFriends() async {
    try {
      final friends = await _service.fetchFriends();
      return Result.ok(friends);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

}
