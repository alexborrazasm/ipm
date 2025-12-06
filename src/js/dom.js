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

function showExpenseDetails(expense) {
  const detailsSection = document.querySelector('#details article');
  
  const date = new Date(expense.date);
  const formattedDate = date.toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  });
  
  detailsSection.innerHTML = `
    <header>
      <h3>${expense.description}</h3>
      <button class="circle-button" aria-label="Edit expense">
        <i class="fa-solid fa-pencil" aria-hidden="true"></i>
      </button>
    </header>
    <p>
      <span><i class="fa-solid fa-coins" aria-hidden="true"></i> Amount:</span>
      $${expense.amount.toFixed(2)}
    </p>
    <p>
      <span><i class="fa-solid fa-scale-balanced" aria-hidden="true"></i> Balance:</span>
      $${expense.creditBalance.toFixed(2)}
    </p>
    <p>
      <span><i class="fa-solid fa-calendar-days" aria-hidden="true"></i> Date:</span>
      <time datetime="${expense.date}">${formattedDate}</time>
    </p>
  `;
  
  return detailsSection.querySelector('button');
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