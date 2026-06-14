class Friend {

  constructor(id, name, credit_balance, debit_balance){
    this.id = id;
    this.name = name;
    this.credit_balance = credit_balance;
    this.debit_balance = debit_balance;
  }

  toString() {
    return [this.id, this.name, this.credit_balance, this.debit_balance].join(" | ");
  }

}

class Expense {

  constructor(id, description, date, amount, numFriends, creditBalance, friends) {
    this.id = id;
    this.description = description;
    this.date = date;
    this.amount = amount;
    this.numFriends = numFriends;
    this.creditBalance = creditBalance;
    this.friends = friends; // Array of Friend objects
 } 

  toString() {
    return [this.id, this.description, this.date, this.amount, this.numFriends, 
      this.creditBalance, 
      this.friends.map(friend => friend.toString()).join(" || ")].join(" | ");
  }

}

export {Expense, Friend};