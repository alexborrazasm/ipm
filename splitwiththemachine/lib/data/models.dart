class Expense {

  Expense({this.id, required this.description, required this.date, required
  this.amount, this.numFriends, this.creditBalance});
  final int? id;
  final String description;
  final String date;
  final double amount;
  final int? numFriends;
  final double? creditBalance;
  List<Friend> friends = [];

  Expense.fromJson(Map json)
    : id = json["id"],
      description = json["description"],
      date = json["date"],
      amount = json["amount"],
      numFriends = json["num_friends"],
      creditBalance = json["credit_balance"],
      friends = [];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
      "date": date,
      "amount": amount,
      "num_friends": numFriends,
      "credit_balance": creditBalance,
    };
  }

  @override
  String toString() {
    return "$id | $description | $date | $amount | $numFriends | $creditBalance"
        "\n Friends: $friends";
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