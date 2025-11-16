import 'package:flutter/material.dart';
import 'package:splitwiththemachine/data/models.dart';
import 'package:splitwiththemachine/data/repositories.dart';
import 'package:splitwiththemachine/ui/core/utils/search_utils.dart';
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
  String? infoMessage;
  String? errorMessage;

  // --- Search states
  String _searchQueryExpenses = "";
  String get searchQueryExpenses => _searchQueryExpenses;

  String _searchQueryFriends = "";
  String get searchQueryFriends => _searchQueryFriends;

  // --- Selected states
  Expense? _selectedExpense;

  Expense? get selectedExpense => _selectedExpense;

  // --- Expense deleting now
  Expense? _deletingExpense;

  Expense? get deletingExpense => _deletingExpense;

  // --- Friend and expenses
  Friend? _deletingFriend;
  Expense? _deletingFriendExpense;

  Friend? get deletingFriend => _deletingFriend;
  Expense? get deletingFriendExpense => _deletingFriendExpense;

  Friend? _addingCreditFriend;
  Expense? _addingCreditExpense;

  Friend? get addingCreditFriend => _addingCreditFriend;
  Expense? get addingCreditExpense => _addingCreditExpense;

  // --- Selected date for Add/Edit screens ---
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  // --- Setters ---
  void selectExpense(Expense? expense) {
    _selectedExpense = expense;
    notifyListeners();
  }

  void markDeletingExpense(Expense? expense) {
    _deletingExpense = expense;
    notifyListeners();
  }

  void markDeletingFriendExpense(Friend? friend, Expense? expense) {
    _deletingFriend = friend;
    _deletingFriendExpense = expense;
    notifyListeners();
  }

  void markAddingFriendExpense(Friend? friend, Expense? expense) {
    _addingCreditFriend = friend;
    _addingCreditExpense = expense;
    notifyListeners();
  }


  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void searchExpenses(String query) {
    _searchQueryExpenses = query;
    notifyListeners();
  }

  void searchFriends(String query) {
    _searchQueryFriends = query;
    notifyListeners();
  }

  // --- Filtering logic ---
  List<Expense> get filteredExpenses {
    return expenses
        .where((expense) => SearchUtils.match(
        expense.description, _searchQueryExpenses))
        .toList();
  }

  List<Friend> get filteredFriendsInExpense {
    final expense = _selectedExpense;
    if (expense == null) return [];

    return friends
        .where((f) => !expense.friends.any((e) => e.id == f.id))
        .where((f) => SearchUtils.match(f.name, _searchQueryFriends))
        .toList();
  }

  // --- Repository calls ---
  Future<Result<void>> _loadFriends() async {
    final result = await _friendRepository.fetchFriends();
    switch (result) {
      case Ok<List<Friend>>():
        friends = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error<List<Friend>>(error: var e):
        errorMessage = _mapServerError(e,
          msg: "Cannot retrieve the list of friends",
        );
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
      case Error<List<Expense>>(error: var e):
        errorMessage = _mapServerError(e,
          msg: "Cannot retrieve the list of expenses",
        );
        notifyListeners();
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _addExpense(Expense expense) async {
    final result = await _expenseRepository.addExpense(expense);

    switch (result) {
      case Ok<Expense>():
        infoMessage = "Expense '${expense.description}' added";
        expenses.add(result.value);
        notifyListeners();
        return Result.ok(null);
      case Error<Expense>(error: var e):
        errorMessage = _mapServerError(e,
          msg: "Expense '${expense.description}' is already added"
        );
        notifyListeners();
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _editExpense(Expense expense) async {
    final result = await _expenseRepository.editExpense(expense);
    switch (result) {
      case Ok<Expense>():
        infoMessage = "Expense '${expense.description}' edited";
        final index =  expenses.indexWhere((e) => e.id == expense.id);
        if (index == -1) {
          return Result.error(Exception("Expense to edit not found: '${expense.id}'"));
        }
        expenses[index] = result.value;
        if (_selectedExpense!.id == result.value.id) {
          selectExpense(result.value); // Tigger ui update
        }
        notifyListeners();
        return Result.ok(null);
      case Error<Expense>(error: var e):
        errorMessage = _mapServerError(e,
          msg: "Cannot edit expense '${expense.description}'",
        );
        notifyListeners();
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _deleteExpense(Expense expense) async {
    final result = await _expenseRepository.deleteExpense(expense.id!);
    switch (result) {
      case Ok<void>():
        infoMessage = "Expense '${expense.description}' deleted";
        expenses.remove(expense);
        notifyListeners();
        return Result.ok(null);
      case Error<void>(error: var e):
        errorMessage = _mapServerError(e,
            msg: "Cannot remove expense '${expense.description}'",
        );
        notifyListeners();
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _addFriendToExpense(FriendExpenseArgs args) async {
    final result = await _expenseRepository.addFriendToExpense(
        args.expense.id!, args.friend.id!
    );
    switch (result) {
      case Ok<List<Friend>>():
        infoMessage = "'${args.friend.name}' added to '${args.expense.description}'";
        final index = expenses.indexWhere((e) => e.id == args.expense.id);
        if (index != -1) {
          final old = expenses[index];
          // Update friends list
          final updated = old.copyWith(
            numFriends: result.value.length,
            friends: result.value,
          );
          expenses[index] = updated;
          if (_selectedExpense!.id == updated.id) {
            selectExpense(updated); // Tigger ui update
          }
          notifyListeners();
        }
        return Result.ok(null);
      case Error<List<Friend>>(error: var e):
         errorMessage = _mapServerError(e,
           msg: "Cannot add '${args.friend.name}' to ${args.expense.description}"
         );
        notifyListeners();
        return Result.error(result.error);

    }
  }

  Future<Result<void>> _deleteFriendFromExpense(FriendExpenseArgs args) async { // TODO
    final result = await _expenseRepository.deleteFriendFromExpense(
        args.expense.id!, args.friend.id!
    );

    switch (result) {
      case Ok<List<Friend>>():
        infoMessage = "'${args.friend.name}' deleted from '${args.expense.description}'";
        final index = expenses.indexWhere((e) => e.id == args.expense.id);
        if (index != -1) {
          final old = expenses[index];
          // Update friends list
          final updated = old.copyWith(
            numFriends: result.value.length,
            friends: result.value,
          );
          expenses[index] = updated;
          if (_selectedExpense!.id == updated.id) {
            selectExpense(updated); // Tigger ui update
          }
          markDeletingFriendExpense(null, null);
          notifyListeners();
        }
        return Result.ok(null);
      case Error<List<Friend>>(error: var e):
        errorMessage = _mapServerError(e,
          msg: "Cannot delete '${args.friend.name}' from "
            "${args.expense.description}",
        );
        markDeletingFriendExpense(null, null);
        notifyListeners();
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _addCreditToFriend(CreditArgs args) async {
    final result = await _expenseRepository.addCreditToFriend(
        args.expense.id!, args.friend.id!, args.amount
    );

    switch (result) {
      case Ok<List<Friend>>():
        infoMessage = "Added \$ ${args.amount} credit to '${args.friend.name}'"
            " in '${args.expense.description}'";
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
          if (_selectedExpense!.id == updated.id) {
            selectExpense(updated); // Tigger ui update
          }
          markAddingFriendExpense(null, null);
          notifyListeners();
        }
        return Result.ok(null);
      case Error<List<Friend>>(error: var e):
        errorMessage = _mapServerError(e,
          msg: "Cannot add ${args.friend.name} to '${args.expense.description}'"
        );
        markAddingFriendExpense(null, null);
        notifyListeners();
        return Result.error(result.error);
    }
  }

}

/// Maps a caught exception into a user-friendly message.
/// Useful for centralizing error handling logic.
///
/// [exception] - The thrown exception.
/// [msg] - Message for validation errors (ex: "Cannot add friend").
///
/// Returns a human readable string message.
String _mapServerError(Exception exception, {required String msg}) {
  // Check if the exception is a known server exception.
  if (exception is ServerException) {
    switch (exception.type) {
      case ServerErrorType.noConnection:
        return "No internet connection";

      case ServerErrorType.validation:
        return msg;

      default:
        return "Unexpected server error";
    }
  }

  // Fallback if exception type is unknown.
  return "Unexpected error";
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

// --- Args for adding credit to a friend in an expense using Command1
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

