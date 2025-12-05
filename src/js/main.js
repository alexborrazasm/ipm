import * as model from "./model.js";
import * as ui from "./dom.js";
import * as cache from "./expensesCache.js";

ui.init();
ui.setReloadCallback(loadExpenses);
loadExpenses();

async function loadExpenses(event) {
  console.log("on load expenses");
  try {
    ui.toggleLoadingExpenses()
    ui.clearExpenses();
    cache.clearCache();
    let expenses = await model.retrieveExpenses();
    expenses.map((expense) => ui.addExpenseItem(expense));
    expenses.forEach(exp => cache.setExpense(exp));
    ui.toggleLoadingExpenses()
  } catch(error) {
    ui.toggleLoadingExpenses();
    //ui.showMessage("Connection error. Please, try again later.");
    console.error(error);
  }
}
