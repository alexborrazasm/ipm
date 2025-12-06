import * as model from "./model.js";
import * as ui from "./dom.js";
import * as cache from "./cache.js";

ui.init();
ui.setReloadCallback(load);
load();

async function load() {
  console.log("on load expenses");
  try {
    ui.clearError();
    ui.toggleLoadingExpenses();
    ui.clearExpenses();
    cache.clearCache();
    let friends = await model.retrieveFriends();
    friends.map((friend) => cache.setFriend(friend));
    let expenses = await model.retrieveExpenses();
    expenses.map((expense) => ui.addExpenseItem(expense, onShowExpense));
    expenses.map((expense) => cache.setExpense(expense));
    ui.toggleLoadingExpenses();
  } catch(error) {
    ui.toggleLoadingExpenses();
    ui.showError("Connection error. Please, try again later.");
    console.error(error);
  }
}

async function onShowExpense(expense) {
  console.log("on show expense");
  ui.buildExpenseDetails(expense, onEditExpense);
}

async function onEditExpense(expense) {
  console.log("on edit expense");
  console.log(expense);
  // TODO
}

async function onConfirmEditExpense(expense, newExpense) {
  console.log("on confirm edit expense");
  // TODO
}

async function onAddFriendExpense(friend, expense) {
  console.log("on add friends expense");
  // TODO
}

async function onRemoveFriendExpense(friend, expense) {
  console.log("on remove friends expense");
  // TODO
}

async function onConfirmRemoveFriendExpense(friend, expense) {
  console.log("on confirm remove friends expense");
  // TODO
}

async function onAddCreditToExpense(friend, expense) {
  console.log("on add credit to expense");
  // TODO
}

async function onConfirmAddCreditFriendExpense(friend, expense, amount) {
  console.log("on confirm add credit to friend expense");
  // TODO
}