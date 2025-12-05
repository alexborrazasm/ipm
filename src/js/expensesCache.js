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
