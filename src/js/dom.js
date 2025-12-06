const expenseList = document.querySelector("section#expense-list ul");
const spinnerExpenses = document.querySelector("section#expense-list div.loading");
const reloadButton = document.querySelector("section#expense-list button#reload");
const errorMessageDiv = document.querySelector("div#error-message");
const detailsSectionArticle = document.querySelector('#details article');

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
}

function clearError() {
  errorMessageDiv.classList.add("hidden");
  errorMessageDiv.innerHTML = "";
}

function buildExpenseDetails(expense, editExpenseCallback) {
  const date = new Date(expense.date);
  const formattedDate = date.toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  });
  
  detailsSectionArticle.innerHTML = `
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
  
  // Get the button we just inserted
  let editButton = detailsSectionArticle.querySelector("#details header button");
  editButton.addEventListener("click", () => {
    editExpenseCallback(expense);
  });
}

function clearExpenseDetails() {
  detailsSectionArticle.innerHTML = `
    <article>
      <h3>Pick an Expense</h3>
    </article>
  `;
}

function buildFriendsExpense(expense, addFriendsCallback) {
  // TODO
}

function buildEditExpense(expense, confirmCallback, cancelCallback) {
  const editSection = document.querySelector('#edit article');

  editSection.innerHTML = `
    <form>
      <label for="expense-title-input" class="form-label">
        <i class="fa-solid fa-pen" aria-hidden="true"></i> 
        Description:
      </label>
      <input 
        type="text"
        id="expense-title-input"
        name="expense-title"
        class="form-input"
        value="${expense.description}" required
      >

      <label for="expense-amount-input" class="form-label">
        <i class="fa-solid fa-coins" aria-hidden="true"></i>
        Amount:
      </label>
      <input
        type="number"
        id="expense-amount-input"
        name="expense-amount"
        class="form-input"
        value="${expense.amount.toFixed(2)}" required
      >

      <label for="expense-date-input" class="form-label">
        <i class="fa-solid fa-calendar-days" aria-hidden="true"></i> 
        Date:
      </label>
      <input
        type="date"
        id="expense-date-input"
        name="expense-date"
        class="form-input"
        value="${expense.date}" required
      >

      <div class="two-buttons">
        <button type="button" class="form-button cancel-button">
          Cancel
        </button>
        <button type="submit" class="form-button confirm-button">
          Save
        </button>
      </div>
    </form>
  `;

  const form = editSection.querySelector('#form');
  const cancelButton = editSection.querySelector('.cancel-button');

  form.addEventListener('submit', (event) => {
    event.preventDefault(); // Prevent from recharging the page
    const formData = new FormData(form);
    const description = formData.get('expense-title');
    const amount = parseFloat(formData.get('expense-amount'));
    const date = formData.get('expense-date');
    confirmCallback(expense.id, description, amount, date);
  });

  cancelButton.addEventListener('click', () => {
    cancelCallback();
  });
}

function buildAddFriendExpense(expense, allFriends,  callback) {
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
  buildExpenseDetails,
  clearExpenseDetails,
  buildFriendsExpense,
  buildEditExpense,
  buildAddFriendExpense,
  showRemoveFriend,
  showAddCreditFriend
}; // TODO