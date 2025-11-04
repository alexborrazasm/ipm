import 'package:splitwiththemachine/utils/result.dart';
import 'services.dart';
import 'models.dart';

// Args for adding/removing a friends from an expense
class FriendExpenseArgs {
  final int expenseId;
  final int friendIds;
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
    try {
      final expenses = await _service.fetchExpenses();
      return Result.ok(expenses);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Add a new expense
  Future<Result<Expense>> addExpense(Expense expense) async {
    try {
      final expense = await _service.addExpense(expense);
      return Result.ok(expense);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Edit an existing expense
  Future<Result<Expense>> editExpense(Expense expense) async {
    try{
      final expense = await _service.editExpense(expense);
      return Result.ok(expense);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Remove an expense by ID
  Future<Result<void>> removeExpense(int id) async {
    try {
      await _service.deleteExpense(id);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Add friends to an expense (multiple IDs possible)
  Future<Result<void>> addFriendToExpense(FriendExpenseArgs args) async {
    try {
      await _service.addFriendToExpense(args.expenseId, args.friendId);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Delete friends from an expense
  Future<Result<void>> deleteFriendFromExpense(FriendExpenseArgs args) async {
    try {
      await _service.deleteFriendFromExpense(args.expenseId, args.friendId);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Add credit to a friend in an expense
  Future<Result<void>> addCreditToFriend(CreditArgs args) async {
    try {
      await _service.addCreditToFriend(args.expenseId, args.friendId, args.amount);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Add credit to a friend in an expense
  Future<Result<void>> addCreditToFriend(CreditArgs args) async {
    try {
      await _service.addCreditToFriend(args.expenseId, args.friendId, args.amount);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
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
