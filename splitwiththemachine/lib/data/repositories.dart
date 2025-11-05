import 'package:splitwiththemachine/utils/result.dart';
import 'services.dart';
import 'models.dart';

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
      final newExpense = await _service.addExpense(expense);
      return Result.ok(newExpense);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Edit an existing expense
  Future<Result<Expense>> editExpense(Expense expense) async {
    try {
      final editedExpense = await _service.editExpense(expense);
      return Result.ok(editedExpense);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Remove an expense by ID
  Future<Result<void>> deleteExpense(int id) async {
    try {
      await _service.deleteExpense(id);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Add friends to an expense (multiple IDs possible)
  Future<Result<void>> addFriendToExpense(int expenseId, int friendId) async {
    try {
      await _service.addFriendToExpense(expenseId, friendId);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Delete friends from an expense
  Future<Result<void>> deleteFriendFromExpense(int expenseId, int friendId) async {
    try {
      await _service.deleteFriendFromExpense(expenseId, friendId);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Add credit to a friend in an expense
  Future<Result<void>> addCreditToFriend(int expenseId, int friendId,
      double amount) async {
    try {
      await _service.addCreditToFriend(expenseId, friendId, amount);
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
