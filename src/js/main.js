import * as model from "./model.js";
import * as ui from "./dom.js";
import * as cache from "./cache.js";

ui.init();
ui.setReloadCallback(reload);
load();

async function load() {
  console.log("on load expenses");
  try {
    ui.clearError();
    ui.toggleLoadingExpenses();
    cache.clearCache();
    let friends = await model.retrieveFriends();
    friends.forEach((friend) => cache.setFriend(friend));
    let expenses = await model.retrieveExpenses();
    expenses.forEach((expense) => ui.addExpenseItem(expense, onShowExpense));
    expenses.forEach((expense) => cache.setExpense(expense));
    ui.toggleLoadingExpenses();
  } catch(error) {
    ui.toggleLoadingExpenses();
    ui.showError("Connection error. Please, try again later.");
    console.error(error);
  }
}

async function reload() {
  ui.clearExpenses();
  ui.clearExpenseSelection();
  await load();
}

async function onShowExpense(expense) {
  console.log("on show expense");
  ui.buildExpenseDetails(expense, onEditExpense);
  ui.buildFriendsExpense(
    expense,
    onAddFriendExpense, 
    onRemoveFriendExpense, 
    onAddCreditToExpense
  );
}

async function onEditExpense(expense) {
  console.log("on edit expense");
  ui.buildEditExpense(expense, onConfirmEditExpense, onCancelEditExpense);
}

async function onConfirmEditExpense(expense, description, date, amount) {
  console.log("on confirm edit expense");
  // TODO
}

async function onCancelEditExpense(expense) {
  console.log("on cancel edit expense");
  ui.buildExpenseDetails(expense, onEditExpense);
}

async function onAddFriendExpense(expense) {
  console.log("on add friends expense");
  ui.buildAddFriendExpense(
    expense, 
    cache.getAllFriends(), 
    onConfirmAddFriendExpense,
    onCancelAddFriendExpense
  );
}

async function onConfirmAddFriendExpense(friend, expense) {
  console.log("on confirm add friends expense");
  try {
    //ui.toggleLoadingAddExpenses(); TODO
    await model.addFriendToExpense(expense.id, friend.id);
    
    expense.friends = await model.retrieveFriendsOnExpense(expense.id);

    cache.setExpense(expense);
    //ui.toggleLoadingAddFriends();
  } catch(error) {
    //ui.toggleLoadingAddExpenses();
    ui.showError("Connection error. Please, try again later.");
    console.error(error);
  }
  
  ui.buildFriendsExpense(
    expense,
    onAddFriendExpense, 
    onRemoveFriendExpense, 
    onAddCreditToExpense
  );
}

async function onCancelAddFriendExpense(expense) {
  console.log("on cancel add friends expense");

  ui.buildFriendsExpense(
    expense,
    onAddFriendExpense, 
    onRemoveFriendExpense, 
    onAddCreditToExpense
  );
}

async function onRemoveFriendExpense(friend, expense) {
  ui.showRemoveFriend(friend, onConfirmRemoveFriendExpense);
}

async function onConfirmRemoveFriendExpense(friend, expense) {
  console.log("on confirm remove friends expense");
  // TODO
}

async function onAddCreditToExpense(friend, expense) {
  ui.showAddCreditFriend(onConfirmAddCreditFriendExpense);
}

async function onConfirmAddCreditFriendExpense(friend, expense, amount) {
  console.log("on confirm add credit to friend expense");
  // TODO
}