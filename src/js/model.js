import { Expense, Friend } from './dtos.js';
import { appFetch, fetchConfig } from './appFetch.js';

class ConnectionError extends Error {
  constructor(message) {
    super(message);
    this.name = "ConnectionError";
  }
}

class RequestError extends Error {
  constructor(message) {
    super(message);
    this.name = "ServerError";
  }
}

async function retrieveExpenses() {
  try {
    const expenses = await appFetch(`/expenses`, fetchConfig('GET'));

    // Load friends for each expense in parallel
    const expensesWithFriends = await Promise.all(
      expenses.map(async (item) => {
        const friends = await retrieveFriendsOnExpense(item.id);

        return new Expense(
          item.id,
          item.description,
          item.date,
          item.amount,
          item.num_friends,
          item.credit_balance,
          friends
        );
      })
    );
    
    return expensesWithFriends;

  } catch (error) {
    throw new ConnectionError(error.message);
  }
}

async function retrieveFriends() {
  try {
    const data = await appFetch(`/friends`, fetchConfig('GET'));
    return data.map(item => new Friend(
      item.id,
      item.name,
      item.credit_balance,
      item.debit_balance
    ));
  } catch (error) {
    throw new ConnectionError(error.message);
  }
}

async function retrieveFriendsOnExpense(expenseId) {
  try {
    const data = await appFetch(`/expenses/${expenseId}/friends`, fetchConfig('GET'));
    return data.map(item => new Friend(
      item.id,
      item.name,
      item.credit_balance,
      item.debit_balance
    ));
  } catch (error) {
    throw new ConnectionError(error.message);
  }
}

async function editExpense(id, description, date) {
  try {
    return await appFetch(`/expenses/${id}`, fetchConfig('PUT', { description, date }));
  } catch (error) {
    if (error.message.includes('409')) throw new RequestError(error.message);
    throw new ConnectionError(error.message);
  }
}

async function addFriendToExpense(expenseId, friendId) {
  try {
    return await appFetch(`/expenses/${expenseId}/friends`, fetchConfig('POST', { friendId }));
  } catch (error) {
    if (error.message.includes('409')) throw new RequestError(error.message);
    throw new ConnectionError(error.message);
  }
}

async function removeFriendFromExpense(friendId, expenseId) {
  try {
    return await appFetch(`/expenses/${expenseId}/friends/${friendId}`, fetchConfig('DELETE'));
  } catch (error) {
    throw new ConnectionError(error.message);
  }
}

async function addCreditToFriend(friendId, expenseId, amount) {
  try {
    return await appFetch(`/expenses/${expenseId}/friends/${friendId}/credit`, fetchConfig('POST', { amount }));
  } catch (error) {
    throw new ConnectionError(error.message);
  }
}

export {
  retrieveExpenses,
  retrieveFriends,
  retrieveFriendsOnExpense,
  editExpense,
  addFriendToExpense,
  removeFriendFromExpense,
  addCreditToFriend,
  ConnectionError,
  RequestError
};
