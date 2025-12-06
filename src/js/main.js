import * as model from "./model.js";
import * as ui from "./dom.js";
import * as cache from "./cache.js";

ui.init();
ui.setReloadCallback(load);
load();

async function load(event) {
  console.log("on load expenses");
  try {
    ui.clearError();
    ui.toggleLoadingExpenses();
    ui.clearExpenses();
    cache.clearCache();
    let friends = await model.retrieveFriends();
    friends.map((friend) => cache.setFriend(friend));
    let expenses = await model.retrieveExpenses();
    expenses.map((expense) => ui.addExpenseItem(expense));
    expenses.map((expense) => cache.setExpense(expense));
    ui.toggleLoadingExpenses();
  } catch(error) {
    ui.toggleLoadingExpenses();
    ui.showError("Connection error. Please, try again later.");
    console.error(error);
  }
}
