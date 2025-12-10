const expenseList = document.querySelector("section#expense-list ul");
const spinnerExpenses = document.querySelector("section#expense-list div.loading");
const reloadButton = document.querySelector("section#expense-list button#reload");
const errorMessageDiv = document.querySelector("div#error-message");
const detailsSection = document.querySelector("section#details");
const detailsSectionTitle = document.querySelector("section#details h2");
const spinnerEditDetails = document.querySelector("section#details div.loading");
const detailsSectionArticle = document.querySelector("section#details article");
const friendsSection = document.querySelector("section#friends");
const friendsSectionTitle = document.querySelector("section#friends h2");
const friendsSectionList = document.querySelector('section#friends ul');

function init() {
  spinnerExpenses.classList.add("hidden");
  spinnerEditDetails.classList.add("hidden");
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

function toggleLoadingEditDetails() {
  spinnerEditDetails.classList.toggle("hidden");
}

function buildExpenseDetails(expense, editExpenseCallback) {
  const date = new Date(expense.date);
  const formattedDate = date.toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  });

  let label = detailsSectionTitle.querySelector("label");
  label.textContent = "Expense Details";
  
  let iconItem = detailsSection.querySelector("i");

  iconItem.className = "fa-solid fa-circle-info";
  iconItem.setAttribute("aria-hidden", "true");

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

  let label = detailsSectionTitle.querySelector("label");
  label.textContent = "Expense Details";
  
  let iconItem = detailsSection.querySelector("i");

  iconItem.className = "fa-solid fa-circle-info";
  iconItem.setAttribute("aria-hidden", "true");

  detailsSectionArticle.innerHTML = "<h3>Pick an Expense</h3>";
}

function clearExpenseSelection() {
  clearExpenseDetails();
  clearFriendsExpense();
}

function buildFriendsExpense(expense, addFriendCallback, removeFriendCallback,
   addCreditCallback) {

  // Title
  friendsSectionTitle.innerHTML = `
    <i class="fa-solid fa-user-group" aria-hidden="true"></i>
    Friends on expense
  `;
  friendsSectionList.innerHTML = '';
  
  // Build friends cards or not
  if (expense.friends.length === 0) { // No friends
    let noFriendsLi = document.createElement('li');
    noFriendsLi.innerHTML = `
      <i class="fa-solid fa-user-xmark friend-icon" aria-hidden="true"></i>
      <h3 class="big">No friends</h3>
    `;
   friendsSectionList.appendChild(noFriendsLi);
  } else {
    expense.friends.forEach((item) => buildFriendsRow(
      item, expense, addCreditCallback, removeFriendCallback)
    );
  }
  
  // Add friends btn
  let addFriendLi = document.createElement('li');
  let addFriendLink = document.createElement('a');
  addFriendLink.href = '#';
  
  addFriendLink.innerHTML = `
    <i class="fa-solid fa-user-plus friend-icon" aria-hidden="true"></i>
    <h3 class="big">Add Friend</h3>
  `;
  
  addFriendLink.addEventListener('click', (event) => {
    event.preventDefault();
    addFriendCallback(expense);
  });
  
  addFriendLi.appendChild(addFriendLink);
  friendsSectionList.appendChild(addFriendLi);

  // Show friends section/ remove hidden css class
  friendsSection.className = "";
}

function buildFriendsRow(friend, expense, addCallback, removeCallback) {
  let li = document.createElement('li');

  li.dataset.friendId = friend.id;
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
    
    <div class="friend-menu hidden">
      <button class="menu-item">Add credit</button>
      <button class="menu-item remove">Delete</button>
    </div>
  `;
  
  const menuButton = li.querySelector("button.circle-button");
  const menu = li.querySelector(".friend-menu");

  menuButton.addEventListener("click", (event) => {
    event.stopPropagation();
    menu.classList.toggle("hidden");
  });

  document.addEventListener("click", () => {
    menu.classList.add("hidden");
  });

  // Get specific menu items
  const addCreditBtn = menu.querySelector(".menu-item:not(.remove)");
  const deleteBtn = menu.querySelector(".menu-item.remove");

  // Add callbacks
  addCreditBtn.addEventListener("click", () => {
    addCallback(friend, expense);
  });

  deleteBtn.addEventListener("click", () => {
    removeCallback(friend, expense);
  });

  friendsSectionList.appendChild(li);
}

function clearFriendsExpense() {
  friendsSection.className = "hidden"
  friendsSectionTitle.innerHTML = "";
  friendsSectionList.innerHTML = "";
}

function buildEditExpense(expense, confirmCallback, cancelCallback) {

  let label = detailsSectionTitle.querySelector("label");
  label.textContent = "Edit expense";
  
  let iconItem = detailsSection.querySelector("i");

  iconItem.className = "fa-solid fa-pen-to-square expense-icon";
  iconItem.setAttribute("aria-hidden", "true");

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
    confirmCallback(expense, description, date, amount);
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

function showRemoveFriend(friend, expense, removeCallback) {
  const dialog = document.querySelector('#add-credit-remove-friends');

  dialog.innerHTML = `
    <h2>
      <i class="fa-solid fa-user-minus" aria-hidden="true"></i>
      Remove Friend
    </h2>

    <article>
      <p>Do you want to remove "${friend.name}" from this expense?</p>
      <div class="two-buttons">
        <button type="button" class="form-button cancel-button">Cancel</button>
        <button type="submit" class="form-button confirm-button">Confirm</button>
      </div>
    </article>
  `;

  dialog.showModal();

  const cancelButton = dialog.querySelector('.cancel-button');
  const confirmButton = dialog.querySelector('.confirm-button');

  cancelButton.addEventListener('click', () => dialog.close());
  confirmButton.addEventListener('click', () => {
    removeCallback(friend, expense);
    dialog.close();
  });
}

function showAddCreditFriend(friend, expense, addCreditCallback) {
  const dialog = document.querySelector('#add-credit-remove-friends');

  dialog.innerHTML = `
    <h2>
      <i class="fa-solid fa-coins" aria-hidden="true"></i> Add Credit
    </h2>
    <form class="card">
      <label for="add-credit-input" class="form-label">
        How much credit do you want to add to '${friend.name}' for '${expense.description}'?
      </label>
      <input
        type="number"
        id="add-credit-input"
        name="add-credit"
        class="form-input"
        value="0.00" required
      >
    </form>
    <div class="two-buttons">
      <button type="button" class="form-button cancel-button">Cancel</button>
      <button type="submit" class="form-button confirm-button">Confirm</button>
    </div>
  `;

  dialog.showModal();

  const cancelButton = dialog.querySelector('.cancel-button');
  const confirmButton = dialog.querySelector('.confirm-button');
  const input = dialog.querySelector('#add-credit-input');

  cancelButton.addEventListener('click', () => dialog.close());

  confirmButton.addEventListener('click', () => {
    addCreditCallback(friend, expense, Number(input.value));
    dialog.close();
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
  toggleLoadingEditDetails
}; // TODO