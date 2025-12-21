import * as model from "./model.js";
import * as ui from "./dom.js";
import * as cache from "./cache.js";

ui.init();
ui.setReloadCallback(reload);
await load();
ui.showAccessibilityMsgSidebar("data loaded");

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

let reloadLock = false;

async function reload() {
  if (reloadLock) return;

  reloadLock = true;

  try {
    ui.clearExpenses();
    ui.clearExpenseSelection();

    await load();

    ui.showAccessibilityMsgSidebar("data reloaded");
  } finally {
    reloadLock = false;
  }
}

async function onShowExpense(expenseId) {
  console.log("on show expense");
  const release = await cache.lockExpense(expenseId);

  try {
    let expense = cache.getExpense(expenseId);
    ui.buildExpenseDetails(expense, onEditExpense);
    ui.buildFriendsExpense(
      expense,
      onAddFriendExpense, 
      onRemoveFriendExpense, 
      onAddCreditToExpense
    );
  } finally {
    release();
  }
}

async function onEditExpense(expenseId) {
  console.log("on edit expense");
  ui.spinSpinnerEditDetails();    
  const release = await cache.lockExpense(expenseId);
  ui.stopSpinSpinnerEditDetails();
  try {
    let expense = cache.getExpense(expenseId);
    if (ui.isSelected(expenseId)) {
      ui.buildEditExpense(expense, onConfirmEditExpense, onCancelEditExpense);
    }
  } finally {
    release();
  }
}

async function onConfirmEditExpense(expenseId, description, date, amount) {
  console.log("on confirm edit expense");
  ui.spinSpinnerEditDetails();
  const release = await cache.lockExpense(expenseId);

  try {
    let expense = cache.getExpense(expenseId);

    const changed = 
      expense.description !== description ||
      expense.date !== date ||
      expense.amount !== amount;
    
    if (!changed) {
      console.log("no changes detected");
      ui.buildExpenseDetails(expense, onEditExpense);
      ui.showAccessibilityMsgContent(`${expense.description} not updated`);
      return;
    }
    await model.editExpense(expense.id, description, date, amount);
    let newExpense = {... expense};
    newExpense.description = description;
    newExpense.date = date;
    newExpense.amount = amount;

    if (ui.isSelected(expenseId)) {
      ui.buildExpenseDetails(newExpense, onEditExpense);
    }
    if (expense.amount !== amount) {
      newExpense.friends = await model.retrieveFriendsOnExpense(expense.id);
      if (ui.isSelected(expenseId)) {
        ui.buildFriendsExpense(
          newExpense,
          onAddFriendExpense, 
          onRemoveFriendExpense, 
          onAddCreditToExpense
        );
      }
    }
    cache.setExpense(newExpense);

    ui.showAccessibilityMsgContent(`${expense.description} updated`);

    if (expense.description !== description) {
      let expenses = cache.getAllExpenses();
      ui.clearExpenses();
      expenses.forEach((expense) => ui.addExpenseItem(expense, onShowExpense));
    }

  } catch(error) {
    ui.showError("Connection error. Please, try again later.");
    console.error(error);
  } finally {
    ui.stopSpinSpinnerEditDetails();
    release();
  }
}

async function onCancelEditExpense(expenseId) {
  console.log("on cancel edit expense");
  let expense = cache.getExpense(expenseId);
  if (ui.isSelected(expenseId)) {
    ui.buildExpenseDetails(expense, onEditExpense);
  }
}

async function onAddFriendExpense(expenseId) {
  console.log("on add friends expense");
  ui.spinSpinnerFriends();
  const release = await cache.lockExpense(expenseId);
  ui.stopSpinSpinnerFriends();
  try {
    let expense = cache.getExpense(expenseId);
    if (ui.isSelected(expenseId)) {
      ui.buildAddFriendExpense(
        expense, 
        cache.getAllFriends(), 
        onConfirmAddFriendExpense,
        onCancelAddFriendExpense
      );
    }
  } finally {
    release();
  }
}

async function onConfirmAddFriendExpense(friendId, expenseId) {
  console.log("on confirm add friends expense");
  ui.spinSpinnerFriends();
  const release = await cache.lockExpense(expenseId);

  try {
    let expense = cache.getExpense(expenseId);
    let friend = cache.getFriend(friendId);
  
    await model.addFriendToExpense(expense.id, friend.id);
    
    expense.friends = await model.retrieveFriendsOnExpense(expense.id);
    cache.setExpense(expense);
    ui.showAccessibilityMsgContent(`${friend.name} added to ${expense.description}`);
    if (ui.isSelected(expenseId)) {
      ui.buildFriendsExpense(
        expense,
        onAddFriendExpense, 
        onRemoveFriendExpense, 
        onAddCreditToExpense
      );
    }
  } catch(error) {
    ui.showError("Connection error. Please, try again later.");
    console.error(error);
  } finally {
    ui.stopSpinSpinnerFriends();
    release();
  }
}

async function onCancelAddFriendExpense(expenseId) {
  console.log("on cancel add friends expense");
  
  const release = await cache.lockExpense(expenseId);

  try {
    let expense = cache.getExpense(expenseId);
  
    ui.buildFriendsExpense(
      expense,
      onAddFriendExpense, 
      onRemoveFriendExpense, 
      onAddCreditToExpense
    );
  } finally {
    release();
  }
}

async function onRemoveFriendExpense(friendId, expenseId) {
  console.log("on remove credit to expense");

  ui.spinSpinnerFriends();
  const release = await cache.lockExpense(expenseId);
  ui.stopSpinSpinnerFriends();

  try {
    let expense = cache.getExpense(expenseId);
    let friend = cache.getFriend(friendId);
    if (ui.isSelected(expenseId)) {
      ui.showRemoveFriend(friend, expense, onConfirmRemoveFriendExpense);
    }
  } finally {
    release();
  }
}

async function onConfirmRemoveFriendExpense(friendId, expenseId) {
  console.log("on confirm remove friends expense");

  ui.spinSpinnerFriends();
  const release = await cache.lockExpense(expenseId);

  try {
    await model.removeFriendFromExpense(friendId, expenseId);
    
    let expense = cache.getExpense(expenseId);

    expense.friends = await model.retrieveFriendsOnExpense(expense.id);

    cache.setExpense(expense);

    ui.showAccessibilityMsgContent(
      `${cache.getFriend(friendId).name} removed from ${expense.description}`
    );
    ui.buildFriendsExpense(
      expense,
      onAddFriendExpense, 
      onRemoveFriendExpense, 
      onAddCreditToExpense
    );
  } catch(error) {
    if (error.message.includes("409")) {
      let friend = cache.getFriend(friendId);
      ui.showError(`Cannot remove ${friend.name}.`);
    } else {
      ui.showError("Connection error. Please, try again later.");
      console.error(error);
    }
  } finally {
    ui.stopSpinSpinnerFriends();
    release();
  }
}

async function onAddCreditToExpense(friendId, expenseId) {
  console.log("on add credit to expense");

  ui.spinSpinnerFriends();
  const release = await cache.lockExpense(expenseId);
  ui.stopSpinSpinnerFriends();

  try {
    let expense = cache.getExpense(expenseId);
    let friend = cache.getFriend(friendId);
    if (ui.isSelected(expenseId)) {
      ui.showAddCreditFriend(friend, expense, onConfirmAddCreditFriendExpense);
    }
  } finally {
    release();
  }
}

async function onConfirmAddCreditFriendExpense(friendId, expenseId, amount) {
  console.log("on confirm add credit to friend expense");
  
  ui.spinSpinnerFriends();
  const release = await cache.lockExpense(expenseId);

  try {
    let expense = cache.getExpense(expenseId);

    if (amount == 0) {
      ui.buildFriendsExpense(
        expense,
        onAddFriendExpense, 
        onRemoveFriendExpense, 
        onAddCreditToExpense
      );
      return;
    }

    await model.addCreditToFriend(friendId, expenseId, amount);
      
    expense.creditBalance = expense.creditBalance + amount;
    expense.friends = await model.retrieveFriendsOnExpense(expense.id);

    cache.setExpense(expense);

    ui.showAccessibilityMsgContent(
      `added ${amount} dollars to ${cache.getFriend(friendId).name} on 
      ${expense.description}`
    );
    ui.buildExpenseDetails(expense, onEditExpense);
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
    ui.stopSpinSpinnerFriends();
    release();
  }
}