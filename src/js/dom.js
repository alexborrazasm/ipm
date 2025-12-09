const expenseList = document.querySelector("section#expense-list ul");
const spinnerExpenses = document.querySelector("section#expense-list div.loading");
const reloadButton = document.querySelector("section#expense-list button#reload");
const errorMessageDiv = document.querySelector("div#error-message");
const detailsSection = document.querySelector("section#details");
const detailsSectionTitle = document.querySelector("section#details h2");
const detailsSectionArticle = document.querySelector("section#details article");
const friendsSection = document.querySelector("section#friends");
const friendsSectionTitle = document.querySelector("section#friends h2");
const friendsSectionList = document.querySelector('section#friends ul');

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
  
  detailsSectionTitle.innerHTML = `
    <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
    Expense Details
  `

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
  let editButton = detailsSectionArticle.querySelector('button');
  editButton.addEventListener("click", () => {
    editExpenseCallback(expense);
  });
}

function clearExpenseDetails() {
  detailsSectionTitle.innerHTML = `
      <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
      Expense Details
  `;
  detailsSectionArticle.innerHTML = `
      <h3>Pick an Expense</h3>
  `;
}

function clearExpenseSelection() {
  clearExpenseDetails();
  clearFriendsExpense();
}

function buildFriendsExpense(expense, addFriendsCallback, removeCallback,
   addCreditCallback) {
  friendsSectionList.innerHTML = '';
  
  expense.friends.forEach(friend => {
    const li = document.createElement('li');
    
    li.innerHTML = `
      <i class="fa-solid fa-user friend-icon" aria-hidden="true"></i>
      <article>
        <h3>${friend.name}</h3>
        <p><span>Credit:</span>$${friend.credit_balance.toFixed(2)}</p>
        <p><span>Debit:</span>$${friend.debit_balance.toFixed(2)}</p>
      </article>
      <button type="button" class="circle-button" aria-label="Open friend menu">
        <i class="fa-solid fa-ellipsis-vertical" aria-hidden="true"></i>
      </button>
    `;
    
    const menuButton = li.querySelector('button');

    menuButton.addEventListener('click', () => {
      const existingMenu = li.querySelector('.friend-menu');
      if (existingMenu) {
        existingMenu.classList.add('hidden');
        menuButton.classList.remove('hidden');
      }

      menuButton.classList.add('hidden');

      const menu = document.createElement('div');
      menu.className = 'friend-menu';
      
      const addCreditButton = document.createElement('button');
      addCreditButton.innerHTML = `Add credit`;
      addCreditButton.addEventListener('click', () => {
        addCreditCallback(friend, expense);
        menu.remove();
        menuButton.classList.remove('hidden');
      });

      const removeButton = document.createElement('button');
      removeButton.innerHTML = `Remove friend`;
      removeButton.addEventListener('click', () => {
        removeCallback(friend, expense);
        menu.remove();
        menuButton.classList.remove('hidden');
      });

      menu.appendChild(addCreditButton);
      menu.appendChild(removeButton);

      li.appendChild(menu);
    });
    friendsSectionList.appendChild(li);
  });
  
  friendsSectionTitle.innerHTML = `
    <i class="fa-solid fa-user-group" aria-hidden="true"></i>Friends on expense
  `;
  
  const addFriendLi = document.createElement('li');
  const addFriendLink = document.createElement('a');
  addFriendLink.href = '#';
  
  addFriendLink.innerHTML = `
    <i class="fa-solid fa-user-plus friend-icon" aria-hidden="true"></i>
    <h3>Add Friend</h3>
  `;
  
  addFriendLink.addEventListener('click', (event) => {
    event.preventDefault();
    addFriendsCallback(expense);
  });
  
  addFriendLi.appendChild(addFriendLink);
  friendsSectionList.appendChild(addFriendLi);

  friendsSection.className = "";
}

function clearFriendsExpense() {
  friendsSection.className = "hidden"
  friendsSectionTitle.innerHTML = "";
  friendsSectionList.innerHTML = "";
}

function buildEditExpense(expense, confirmCallback, cancelCallback) {

  detailsSectionTitle.innerHTML = `
    <i class="fa-solid fa-pen-to-square expense-icon" aria-hidden="true"></i>
    Edit expense
  `;

  detailsSectionArticle.innerHTML = `
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

  const form = detailsSectionArticle.querySelector('form');
  const cancelButton = detailsSectionArticle.querySelector('.cancel-button');

  form.addEventListener('submit', (event) => {
    event.preventDefault(); // Prevent from recharging the page
    const formData = new FormData(form);
    const description = formData.get('expense-title');
    const amount = parseFloat(formData.get('expense-amount'));
    const date = formData.get('expense-date');
    confirmCallback(expense, description, amount, date);
  });

  cancelButton.addEventListener('click', () => {
    cancelCallback(expense);
  });
}

function buildAddFriendExpense(expense, allFriends, confirmCallback, 
  cancelCallback) {

  let availableFriends = [];
  
  if (allFriends.length != expense.friends.length) {
    // Create a Set of IDs already in the expense for O(1) lookup
    const friendExpenseIds = new Set(expense.friends.map(f => f.id));

    // Filter out friends already in the expense
    availableFriends = allFriends.filter(f => !friendExpenseIds.has(f.id));
  }

  friendsSectionTitle.innerHTML = `
    <button class="back-circle-button"><i class="fa-solid fa-circle-chevron-left"></i></button>
    <i class="fa-solid fa-user-plus" aria-hidden="true"></i> 
    Add Friend
  `;
  
  let btn = friendsSectionTitle.querySelector("button");
  btn.addEventListener("click", (event) => {
    event.preventDefault();
    cancelCallback(expense);
  });

  friendsSectionList.innerHTML = "";

  if (availableFriends.length === 0) {
    let listItem = document.createElement("li");
    let titleItem = document.createElement("h3");

    titleItem.textContent = "No available friends";
    listItem.appendChild(titleItem);
    friendsSectionList.appendChild(listItem);
  } else {
    availableFriends.forEach((friend) => addFriendToAddFriendsItem(
      friend, expense, confirmCallback)
    );
  }
}

function addFriendToAddFriendsItem(friend, expense, callback) {
  let listItem = document.createElement("li");
  let linkItem = document.createElement("a");
  let iconItem = document.createElement("i");
  let titleItem = document.createElement("h3");

  listItem.dataset.id = friend.id;
  titleItem.textContent = friend.name;
  iconItem.className = "fa-solid fa-user friend-icon";
  iconItem.setAttribute("aria-hidden", "true");
  linkItem.href = "#";
  linkItem.addEventListener("click", (event) => {
    event.preventDefault();
    callback(friend, expense);
  });

  linkItem.appendChild(iconItem);
  linkItem.appendChild(titleItem);
  listItem.appendChild(linkItem);

  friendsSectionList.appendChild(listItem);
}

function showRemoveFriend(friend, removeCallback) {
  const removeFriend = document.querySelector('#remove-friend article');
  dialog.classList.remove('hidden');
  removeFriend.innerHTML = `
  <p> Do you want to remove "${friend.name}" from this expense? </p>
  <div class="two-buttons">
    <button type="button" class="form-button cancel-button">
      Cancel
    </button>
    <button type="submit" class="form-button confirm-button">
      Confirm
    </button>
  </div>
  `;

  const confirmButton = removeFriend.querySelector('.confirm-button');
  confirmButton.addEventListener('click', () => {
    removeCallback();
  });
}

function showAddCreditFriend(addCallback) {
  const addCreditFriend = document.querySelector('#add-credit article');
  
  addCreditFriend.innerHTML = `
    <form class="card">
      <label for="add-credit-input" class="form-label">
      How much credit do you want to add to 'Alex' for 'Travel to A Coruña'?
      </label>
      <input
        type="number"
        id="add-credit-input"
        name="add-credit"
        class="form-input"
        value="233.00" required
      >      
    </form>
    <div class="two-buttons">
      <button type="button" class="form-button cancel-button">
        Cancel
      </button>
      <button type="submit" class="form-button confirm-button">
        Confirm
      </button>
    </div>
  `
  const confirmButton = addCreditFriend.querySelector('.confirm-button');
  confirmButton.addEventListener('click', () => {
    const inputField = addCreditFriend.querySelector('#add-credit-input');
    const amount = parseFloat(inputField.value);
    addCallback(amount);
  });
}

export { 
  init, 
  setReloadCallback, 
  addExpenseItem,
  toggleLoadingExpenses,
  showError,
  buildExpenseDetails,
  buildFriendsExpense,
  buildEditExpense,
  buildAddFriendExpense,
  showRemoveFriend,
  showAddCreditFriend,
  clearExpenses, 
  clearError,
  clearExpenseSelection,
  clearExpenseDetails,
  clearFriendsExpense,
}; // TODO