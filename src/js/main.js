import * as model from "./model.js";
import * as ui from "./dom.js";

ui.init();
ui.setReloadCallback(loadExpenses);
loadExpenses();

async function loadExpenses(event) {
  console.log("on load expenses");
  try {
    //ui.toggleLoadingList()
    //ui.clearExpenses();
    let expenses = await model.retrieveExpenses();
    //expenses.map((expense) => ui.addExpenseItem(expense));
    //ui.toggleLoadingList()
  } catch(error) {
    //ui.toggleLoadingList();
    //ui.showMessage("Connection error. Please, try again later.");
    console.error(error);
  }
}
