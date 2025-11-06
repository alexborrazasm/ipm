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

  @override
  String toString() {
    return "$id | $description | $date | $amount | $numFriends | $creditBalance"
        "\n Friends: $friends";
  }

  Expense copyWith({
    int? id,
    String? description,
    DateTime? date,
    double? amount,
    List<Friend>? friends,
  }) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      friends: friends ?? this.friends
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

}

class ServerException implements Exception {
  String errorMessage;
  ServerException(this.errorMessage);
}