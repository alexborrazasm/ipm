import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Expense {

  Expense({
    this.id,
    required this.description,
    required this.date,
    required this.amount,
    this.numFriends,
    this.creditBalance,
    this.friends = const [],
  });

  final int? id;
  final String description;
  final DateTime date;
  final double amount;
  final int? numFriends;
  final double? creditBalance;
  final List<Friend> friends;

  Expense.fromJson(Map json)
    : id = json["id"],
      description = json["description"],
      date = DateTime.parse(json["date"]),
      amount = json["amount"],
      numFriends = json["num_friends"],
      creditBalance = json["credit_balance"],
      friends = [];

  String getDateString() {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  String getFormatDate() {
    final formatted = DateFormat('EEEE, MMMM d, y').format(date);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  @override
  String toString() {
    return "$id | $description | $date | $amount | $numFriends | $creditBalance"
        "\n Friends: $friends";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Expense &&
        other.id == id &&
        other.description == description &&
        other.date == date &&
        other.amount == amount &&
        other.numFriends == numFriends &&
        other.creditBalance == creditBalance &&
        listEquals(other.friends, friends);
  }

  @override
  int get hashCode {
    return id.hashCode ^
    description.hashCode ^
    date.hashCode ^
    amount.hashCode ^
    numFriends.hashCode ^
    creditBalance.hashCode ^
    friends.hashCode;
  }

  Expense copyWith({
    int? id,
    String? description,
    DateTime? date,
    double? amount,
    int? numFriends,
    double? creditBalance,
    List<Friend>? friends,
  }) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      numFriends: numFriends ?? this.numFriends,
      creditBalance: creditBalance ?? this.creditBalance,
      friends: friends ?? this.friends,
    );
  }

}

class Friend {

  Friend({this.id, required this.name, this.creditBalance, this.debitBalance});
  final int? id;
  final String name;
  final double? creditBalance;
  final double? debitBalance;

  Friend.fromJson(Map json)
    : id = json["id"],
      name = json["name"],
      creditBalance = json["credit_balance"],
      debitBalance = json["debit_balance"];

  @override
  String toString() {
    return "$id | $name | $creditBalance | $debitBalance";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Friend &&
        other.id == id &&
        other.name == name &&
        other.creditBalance == creditBalance &&
        other.debitBalance == debitBalance;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    creditBalance.hashCode ^
    debitBalance.hashCode;
  }
}

enum ServerErrorType {
  noConnection,
  timeout,
  unauthorized,
  notFound,
  validation,
  unknown,
}

class ServerException implements Exception {
  final String message;
  final ServerErrorType type;

  ServerException({
    required this.message,
    this.type = ServerErrorType.unknown,
  });

  @override
  String toString() => "[ServerException][$type] $message";
}
