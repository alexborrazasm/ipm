import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:splitwiththemachine/data/repositories.dart';
import 'package:splitwiththemachine/utils/result.dart';
import 'package:splitwiththemachine/utils/command.dart';

class ExpenseViewModel extends ChangeNotifier {

  ExpenseViewModel({
    required FriendRepository friendRepository,
    required ExpenseRepository expenseRepository,
  })  : _friendRepository = friendRepository,
        _expenseRepository = expenseRepository {
    loadFriends = Command0(_loadFriends);
    loadExpenses = Command0(_loadExpenses);
    addExpense = Command1(_addExpense);
    editExpense = Command1(_editExpense);
    deleteExpense = Command1(_deleteExpense);
    addFriendToExpense = Command1(_addFriendToExpense);
    deleteFriendFromExpense = Command1(_deleteFriendFromExpense);
    addCreditToFriend = Command1(_addCreditToFriend);

    if (friends.isEmpty) {
      loadFriends.execute();
    }

    if (expenses.isEmpty) {
      loadExpenses.execute();
    }
  }

  final ExpenseRepository _expenseRepository;
  final FriendRepository _friendRepository;
  late final Command0 loadFriends;
  late final Command0 loadExpenses;
  late final Command1<void,Expense> addExpense;
  late final Command1<void,Expense> editExpense;
  late final Command1<void,Expense> deleteExpense;
  late final Command1<void,FriendExpenseArgs> addFriendToExpense;
  late final Command1<void,FriendExpenseArgs> deleteFriendFromExpense;
  late final Command1<void,CreditArgs> addCreditToFriend;

  List<Expense> expenses = [];
  List<Friend> friends = [];
  String? errorMessage;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<Result<void>> _loadFriends() async {
    final result = await _friendRepository.fetchFriends();
    switch (result) {
      case Ok<List<Friend>>():
        friends = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error<List<Friend>>():
        errorMessage = "Cannot retrieve the list of friends";
        notifyListeners();
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadExpenses() async {
    final result = await _expenseRepository.fetchExpenses();
    switch (result) {
      case Ok<List<Expense>>():
        expenses = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error<List<Expense>>():
        errorMessage = "Cannot retrieve the list of expenses";
        notifyListeners();
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _addExpense(Expense expense) async {
    final result = await _expenseRepository.addExpense(expense);

    switch (result) {
      case Ok<Expense>():
        expenses.add(result.value);
      case Error<Expense>():
        errorMessage = "Cannot add expense ${expense.description}";
    }
    notifyListeners();
    return result;
  }

  Future<Result<void>> _editExpense(Expense expense) async {
    final result = await _expenseRepository.editExpense(expense);

    switch (result) {
      case Ok<Expense>():
        final index =  expenses.indexWhere((e) => e.id == expense.id);
        if (index == -1) {
          return Result.error(Exception("Expense to edit not found: ${expense.id}"));
        }
        expenses[index] = result.value;
      case Error<Expense>():
        errorMessage = "Cannot edit expense ${expense.description}";
    }
    notifyListeners();
    return result;
  }

  Future<Result<void>> _deleteExpense(Expense expense) async {
    final result = await _expenseRepository.deleteExpense(expense.id!);

    switch (result) {
      case Ok<void>():
        expenses.remove(expense);
      case Error<void>():
        errorMessage = "Cannot remove expense ${expense.description}";
    }
    notifyListeners();
    return result;
  }

  Future<Result<void>> _addFriendToExpense(FriendExpenseArgs args) async { // TODO
    final result = await _expenseRepository.addFriendToExpense(
      args.expense.id!, args.friend.id!
    );

    switch (result) {
      case Ok<List<Friend>>():
        final index = expenses.indexWhere((e) => e.id == args.expense.id);
        if (index != -1) {
          final old = expenses[index];
          // Update friends list
          final updated = old.copyWith(
            numFriends: result.value.length,
            friends: result.value,
          );
          expenses[index] = updated;
        }
      case Error<List<Friend>>():
        errorMessage = "Cannot add ${args.friend.name} to "
                       "${args.expense.description}";
    }
    notifyListeners();
    return result;
  }

  Future<Result<void>> _deleteFriendFromExpense(FriendExpenseArgs args) async { // TODO
    final result = await _expenseRepository.deleteFriendFromExpense(
        args.expense.id!, args.friend.id!
    );

    switch (result) {
      case Ok<List<Friend>>():
        final index = expenses.indexWhere((e) => e.id == args.expense.id);
        if (index != -1) {
          final old = expenses[index];
          // Update friends list
          final updated = old.copyWith(
            numFriends: result.value.length,
            friends: result.value,
          );
          expenses[index] = updated;
        }
      case Error<List<Friend>>():
        errorMessage = "Cannot add ${args.friend.name} to "
            "${args.expense.description}";
    }
    notifyListeners();
    return result;
  }

  Future<Result<void>> _addCreditToFriend(CreditArgs args) async { // TODO
    final result = await _expenseRepository.addCreditToFriend(
        args.expense.id!, args.friend.id!, args.amount
    );

    switch (result) {
      case Ok<List<Friend>>():
        final index = expenses.indexWhere((e) => e.id == args.expense.id);
        if (index != -1) {
          final old = expenses[index];
          // Update friends list
          final updated = old.copyWith(
            numFriends: result.value.length,
            friends: result.value,
            creditBalance: (old.creditBalance ?? 0) + args.amount,
          );
          expenses[index] = updated;
        }
      case Error<List<Friend>>():
        errorMessage = "Cannot add ${args.friend.name} to "
            "${args.expense.description}";
    }
    notifyListeners();
    return result;
  }

}

// Args for adding/removing a friends from an expense using Command1
class FriendExpenseArgs {
  final Expense expense;
  final Friend friend;

  const FriendExpenseArgs({
    required this.expense,
    required this.friend,
  });
}

// Args for adding credit to a friend in an expense using Command1
class CreditArgs {
  final Expense expense;
  final Friend friend;
  final double amount;

  const CreditArgs({
    required this.expense,
    required this.friend,
    required this.amount
  });
}

