import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';

abstract class SplitWithMeService {
  Future<List<Expense>> fetchExpenses();
  Future<List<Friend>> fetchFriends();
  Future<Expense> addExpense(Expense expense);
  Future<Expense> editExpense(Expense expense);
  Future<void> deleteExpense(int id);
  Future<List<Friend>> addFriendToExpense(int expenseId, int friendId);
  Future<List<Friend>> deleteFriendFromExpense(int expenseId, int friendId);
  Future<List<Friend>> addCreditToFriend(int expenseId, int friendId, double amount);
}

class SplitWithMeAPIService implements SplitWithMeService {
  final serverURL = Platform.isAndroid ? "10.0.2.2" : "127.0.0.1";
  final serverPort = "8000";
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Uri _buildUri(String path, [Map<String, dynamic>? query]) =>
      Uri.http('$serverURL:$serverPort', path, query);

  @override
  Future<List<Expense>> fetchExpenses() async {
    var uri = _buildUri("expenses");
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        final expenses = List<Expense>.from(
          data.map((item) => Expense.fromJson(item)),
        );

        // For each expense get friends
        final expensesWithFriends = await Future.wait(
          expenses.map((expense) async {
            final friends = await _fetchFriendsByExpense(expense.id!);
            return expense.copyWith(friends: friends);
          }),
        );

        return expensesWithFriends;
      } else {
        throw ServerException("Invalid data");
      }
    } on http.ClientException {
      throw ServerException("Service is not available. Try again later.");
    }
  }

  @override
  Future<List<Friend>> fetchFriends() async {
    var uri = _buildUri("friends");
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return List<Friend>.from(data.map((item) => Friend.fromJson(item)));
      } else {
        throw ServerException("Invalid data");
      }
    } on http.ClientException {
      throw ServerException("Service is not available. Try again later.");
    }
  }

  Future<List<Friend>> _fetchFriendsByExpense(int expenseId) async {
    var uri = _buildUri("expenses/$expenseId/friends");
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return List<Friend>.from(data.map((item) => Friend.fromJson(item)));
      } else {
        throw ServerException("Invalid data");
      }
    } on http.ClientException {
      throw ServerException("Service is not available. Try again later.");
    }
  }

  @override
  Future<Expense> addExpense(Expense expense) async {
    var uri = _buildUri("expenses/");
    final Map<String, dynamic> payload = {
      "description": expense.description,
      "amount": expense.amount,
      "date": expense.getDateString(),
    };
    try {
      var response = await http.post(
        uri,
        headers: _headers,
        body: json.encode(payload),
      );
      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        return Expense.fromJson(data);
      } else {
        throw ServerException("Invalid data");
      }
    } on http.ClientException {
      throw ServerException("Service is not available. Try again later.");
    }
  }

  @override
  Future<Expense> editExpense(Expense expense) async {
    var uri = _buildUri("expenses/${expense.id}");
    final Map<String, dynamic> payload = {
      "description": expense.description,
      "amount": expense.amount,
      "date": expense.getDateString(),
    };
    try {
      var response = await http.put(
            uri,
            headers: _headers,
            body: json.encode(payload),
      );
      if (response.statusCode == 204) {
        // Backend returns no content, so reuse the local expense
        // Fetch updated friends (e.g., balances might change)
        final friends = await _fetchFriendsByExpense(expense.id!);

        // Combine updated friends with the current expense data
        final expenseWithFriends = expense.copyWith(friends: friends);

        return expenseWithFriends;
      } else {
        throw ServerException("Invalid data");
      }
    } on http.ClientException {
      throw ServerException("Service is not available. Try again later.");
    }
  }

  @override
  Future<void> deleteExpense(int id) async {
    var uri = _buildUri("expenses/$id");
    try {
      var response = await http.delete(uri);
      if (response.statusCode != 204) {
        throw ServerException("Invalid data");
      }
    } on http.ClientException {
      throw ServerException("Service is not available. Try again later.");
    }
  }

  @override
  Future<List<Friend>> addFriendToExpense(int expenseId, int friendId) async {
    var uri = _buildUri(
        "expenses/$expenseId/friends/",
        {'friendId': friendId.toString()}
    );
    try {
      var response = await http.post(uri);
      if (response.statusCode == 201) {
        return _fetchFriendsByExpense(expenseId);
      } else {
        throw ServerException("Invalid data");
      }
    } on http.ClientException {
      throw ServerException("Service is not available. Try again later.");
    }
  }

  @override
  Future<List<Friend>> deleteFriendFromExpense(int expenseId, int friendId)
      async {
    var uri = _buildUri("expenses/$expenseId/friends/$friendId");
    try {
      var response = await http.delete(uri);
      if (response.statusCode == 204) {
        return _fetchFriendsByExpense(expenseId);
      } else {
        throw ServerException("Invalid data");
      }
    } on http.ClientException {
      throw ServerException("Service is not available. Try again later.");
    }
  }

  @override
  Future<List<Friend>> addCreditToFriend(int expenseId, int friendId,
      double amount) async {
    var uri = _buildUri("expenses/$expenseId/friends/$friendId/",
        {'amount': amount.toString()}
    );
    try {
      var response = await http.put(uri);
      if (response.statusCode == 204) {
        return _fetchFriendsByExpense(expenseId);
      } else {
        throw ServerException("Invalid data");
      }
    } on http.ClientException {
      throw ServerException("Service is not available. Try again later.");
    }
  }

}