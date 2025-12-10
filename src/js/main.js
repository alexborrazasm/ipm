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
  if (expense.description !== description
      || expense.date !== date
      || expense.amount !== amount) {
    try {
      console.log("updating expense...");
      ui.toggleLoadingEditDetails();
      await model.editExpense(expense.id, description, date, amount);

      expense.description = description;
      expense.date = date;
      expense.amount = amount;

      cache.setExpense(expense);
      ui.buildExpenseDetails(expense, onEditExpense);
      ui.toggleLoadingEditDetails();

      ui.clearExpenses();
      load();
    }
    catch(error) {
      ui.showError("Connection error. Please, try again later.");
      console.error(error);
    }
  }
  else {
    console.log("no changes detected");
    ui.buildExpenseDetails(expense, onEditExpense);
  }
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
  ui.buildFriendsExpense(
    expense,
    onAddFriendExpense, 
    onRemoveFriendExpense, 
    onAddCreditToExpense
  );

  console.log("on confirm add friends expense try lock");
  const release = await cache.lockExpense(expense.id);

  try {
    console.log("on confirm add friends expense");
    ui.spinSpinnerFriends();
    await model.addFriendToExpense(expense.id, friend.id);
    
    expense.friends = await model.retrieveFriendsOnExpense(expense.id);
    cache.setExpense(expense);
    ui.stopSpinSpinnerFriends();
    ui.buildFriendsExpense(
      expense,
      onAddFriendExpense, 
      onRemoveFriendExpense, 
      onAddCreditToExpense
    );
  } catch(error) {
    ui.stopSpinSpinnerFriends();
    ui.showError("Connection error. Please, try again later.");
    console.error(error);
  } finally {
    release();
  }
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
  console.log("on remove credit to expense");
  ui.showRemoveFriend(friend, expense, onConfirmRemoveFriendExpense);
}

async function onConfirmRemoveFriendExpense(friend, expense) {
  console.log("on confirm remove friends expense try lock");

  const release = await cache.lockExpense(expense.id);

  try {
    console.log("on confirm remove friends expense");
    ui.spinSpinnerFriends();
    await model.removeFriendFromExpense(friend.id, expense.id);
    
    expense.friends = await model.retrieveFriendsOnExpense(expense.id);

    cache.setExpense(expense);
    ui.stopSpinSpinnerFriends();
    ui.buildFriendsExpense(
      expense,
      onAddFriendExpense, 
      onRemoveFriendExpense, 
      onAddCreditToExpense
    );
  } catch(error) {
    ui.stopSpinSpinnerFriends();
    ui.showError("Connection error. Please, try again later.");
    console.error(error);
  } finally {
    release();
  }
}

async function onAddCreditToExpense(friend, expense) {
  console.log("on add credit to expense");
  ui.showAddCreditFriend(friend, expense, onConfirmAddCreditFriendExpense);
}

async function onConfirmAddCreditFriendExpense(friend, expense, amount) {
  console.log("on confirm add credit to friend expense try lock");
  
  const release = await cache.lockExpense(expense.id);

  try {
    console.log("on confirm add credit to friend expense");
    ui.spinSpinnerFriends();
    await model.addCreditToFriend(friend.id, expense.id, amount);
    
    expense.friends = await model.retrieveFriendsOnExpense(expense.id);

    cache.setExpense(expense);
    ui.stopSpinSpinnerFriends();
    ui.buildFriendsExpense(
      expense,
      onAddFriendExpense, 
      onRemoveFriendExpense, 
      onAddCreditToExpense
    );
  } catch(error) {
    ui.stopSpinSpinnerFriends();
    ui.showError("Connection error. Please, try again later.");
    console.error(error);
  } finally {
    release();
  }
}