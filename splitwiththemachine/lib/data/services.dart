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

  Uri _buildUri(String path, [Map<String, dynamic>? query]) =>
      Uri.http('$serverURL:$serverPort', path, query);

  @override
  Future<List<Expense>> fetchExpenses() async {
    // TODO: implement this
    throw UnimplementedError();
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

  @override
  Future<Expense> addExpense(Expense expense) async {
    // TODO: implement this
    throw UnimplementedError();
  }

  @override
  Future<Expense> editExpense(Expense expense) async {
    // TODO: implement this
    throw UnimplementedError();
  }

  @override
  Future<void> deleteExpense(int id) async {
    // TODO: implement this
    throw UnimplementedError();
  }

  @override
  Future<List<Friend>> addFriendToExpense(int expenseId, int friendId) async {
    // TODO: implement this
    throw UnimplementedError();
  }

  @override
  Future<List<Friend>> deleteFriendFromExpense(int expenseId, int friendId) async {
    // TODO: implement this
    throw UnimplementedError();
  }

  @override
  Future<List<Friend>> addCreditToFriend(int expenseId, int friendId,
      double amount) async {
    // TODO: implement this
    throw UnimplementedError();
  }

}