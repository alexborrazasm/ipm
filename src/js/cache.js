// Map: key = expenseId, value = Expense object completo con friends
export const expenseCache = new Map();

// Add or update an expense in cache
export function setExpense(expense) {
  expenseCache.set(expense.id, expense);
}

// Get an expense from cache
export function getExpense(expenseId) {
  return expenseCache.get(expenseId);
}

// Get all expenses from cache
export function getAllExpenses() {
  return Array.from(expenseCache.values());
}

// Clear the cache if needed
export function clearCache() {
  expenseCache.clear();
}

// Map: key = friendId, value = Friend object completo
export const friendsCache = new Map();

// Add or update a friend in cache
export function setFriend(friend) {
  friendsCache.set(friend.id, friend);
}

// Get a friend from cache
export function getFriend(friendId) {
  return friendsCache.get(friendId);
}

// Get all friends from cache
export function getAllFriends() {
  return Array.from(friendsCache.values());
}

// Remove a friend from cache
export function removeFriend(friendId) {
  friendsCache.delete(friendId);
}

// Clear the cache if needed
export function clearFriendsCache() {
  friendsCache.clear();
}
