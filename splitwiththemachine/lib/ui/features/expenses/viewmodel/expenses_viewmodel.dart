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

  List<Expense> expenses = [];
  List<Friend> friends = [];
  String? errorMessage;

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

  // TODO implements all necessary methods

}
