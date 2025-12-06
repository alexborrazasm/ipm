const expenseList = document.querySelector("section#expense-list ul");
const spinnerExpenses = document.querySelector("section#expense-list div.loading");
const reloadButton = document.querySelector("section#expense-list button#reload");
const errorMessageDiv = document.querySelector("div#error-message");

function init() {
  spinnerExpenses.classList.add("hidden");
}

function setReloadCallback(callback) {
  reloadButton.addEventListener("click", callback);
}

function showExpenseDetails(expense) {
  const detailsSection = document.querySelector('#details article');
  detailsSection.querySelector('header h3').textContent = expense.description;
  
  const amountSpan = detailsSection.querySelector('p:nth-of-type(1) span');
  amountSpan.nextSibling.textContent = ` $${expense.amount.toFixed(2)}`;
  
  const balanceSpan = detailsSection.querySelector('p:nth-of-type(2) span');
  balanceSpan.nextSibling.textContent = ` $${expense.creditBalance.toFixed(2)}`;
  
  const timeElement = detailsSection.querySelector('time');
  if (timeElement) {
    const date = new Date(expense.date);
    const formattedDate = date.toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
    timeElement.textContent = formattedDate;
    timeElement.setAttribute('datetime', expense.date);
  }
}

function addExpenseItem(expense, callback) {
  let listItem = document.createElement("li");
  let linkItem = document.createElement("a");
  let iconItem = document.createElement("i");
  let titleItem = document.createElement("h3");
  
  listItem.dataset.id = expense.id;
  titleItem.textContent = expense.description;
  linkItem.href = "#";
  linkItem.addEventListener("click", (event) => {
    event.preventDefault();
    callback(expense);
  });
  iconItem.className = "fa-solid fa-credit-card expense-icon";
  iconItem.setAttribute("aria-hidden", "true");
  
  linkItem.appendChild(iconItem);
  linkItem.appendChild(titleItem);
  listItem.appendChild(linkItem);
  
  linkItem.addEventListener('click', async (event) => {
    event.preventDefault(); 
    showExpenseDetails(expense);
  });
  
  expenseList.appendChild(listItem);
}

function clearExpenses() {
    expenseList.innerHTML = "";
}

function toggleLoadingExpenses() {
    spinnerExpenses.classList.toggle("hidden");
}

function showError(message) {
  // Clean prev content
  errorMessageDiv.innerHTML = "";

  let iconItem = document.createElement("i");
  let titleItem = document.createElement("h2");
  let buttonItem = document.createElement("button");
  
  
  iconItem.className = "fa-solid fa-triangle-exclamation expense-icon";
  iconItem.setAttribute("aria-hidden", "true");
  titleItem.textContent = "Error";
  buttonItem.type = "button";
  buttonItem.className = "form-button";
  buttonItem.textContent = "Dismiss";
  buttonItem.addEventListener("click", () => {
    errorMessageDiv.classList.add("hidden");
    errorMessageDiv.innerHTML = "";
  });
  
  titleItem.appendChild(iconItem);
  errorMessageDiv.appendChild(titleItem);
  titleItem.textContent = message;
  errorMessageDiv.appendChild(buttonItem);
  
  errorMessageDiv.setAttribute("role", "alert");
  errorMessageDiv.setAttribute("aria-live", "assertive");
  errorMessageDiv.className = "";
  
  buttonItem.focus;
}

function clearError() {
  errorMessageDiv.classList.add("hidden");
  errorMessageDiv.innerHTML = "";
}

function createExpenseDetails(expense, editCallback) {
  // TODO
}

function createExpenseFriends(expense, allFriends, addFriendsCallback) {
  // TODO
}

function createEditExpense(expense, callback) {
  // TODO
}

function createAddFriendExpense(expense, callback) {
  // TODO
}

function showRemoveFriend(removeCallback) {
  // TODO
}

function showAddCreditFriend(addCallback) {
  // TODO
}

export { 
  init, 
  setReloadCallback, 
  addExpenseItem,
  clearExpenses, 
  toggleLoadingExpenses,
  showError,
  clearError,
}; // TODO