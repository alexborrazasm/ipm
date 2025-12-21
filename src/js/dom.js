const expenseList = document.querySelector("div#expense-list ul");
const spinnerExpenses = document.querySelector("div#expense-list div.loading");
const reloadButton = document.querySelector("div#expense-list button#reload");
const errorMessageDiv = document.querySelector("div#error-message");
const detailsSection = document.querySelector("section#details");
const detailsSectionTitle = document.querySelector("section#details h2");
const spinnerEditDetails = document.querySelector("section#details div.loading");
const detailsSectionArticle = document.querySelector("section#details article");
const friendsSection = document.querySelector("section#friends");
const friendsSectionTitle = document.querySelector("section#friends h2");
const friendsSectionList = document.querySelector('section#friends ul');
const spinnerFriends = document.querySelector("section#friends div.loading");
const searchInput = document.querySelector("#expense-list search input");
const liveRegion = document.querySelector("div#accessible-live-region");

let friendsSpinnerCount = 0;
let editSpinnerCount = 0;

let selectedExpense = -1;

function init() {
  spinnerExpenses.classList.add("hidden");
  spinnerEditDetails.classList.add("hidden");
  spinnerFriends.classList.add("hidden");
  searchInput.addEventListener("input", onSearchExpenses);

}

function onSearchExpenses() {
  const removeAccents = (str) => {
    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
  };

  const query = removeAccents(searchInput.value.toLowerCase());
  const items = expenseList.querySelectorAll("li");

  items.forEach(li => {
    const title = li.querySelector(".expense-detail");
    if (title){
      const text = removeAccents(title.textContent.toLowerCase());
      if(!text.includes(removeAccents(query))){
        li.classList.add("hidden");
      }else{
        li.classList.remove("hidden");
      }

    };
  });
}

function showAccessibilityMsg(msg) {
  liveRegion.textContent = '';
  liveRegion.textContent = msg;
  //setTimeout(() => {
  //  liveRegion.textContent = message;
  //}, 100);
  //setTimeout(() => {
  //  liveRegion.textContent = '';
  //}, 4000); 
}

function isSelected(expenseId) {
  return expenseId === selectedExpense;
}

function setReloadCallback(callback) {
  reloadButton.addEventListener("click", callback);
}

function addExpenseItem(expense, callback) {
  let listItem = document.createElement("li");
  let linkItem = document.createElement("a");
  let iconItem = document.createElement("i");
  let titleItem = document.createElement("span");
  
  listItem.dataset.id = expense.id;
  titleItem.className = "can-break expense-detail";
  titleItem.textContent = expense.description;
  linkItem.href = "#";
  linkItem.addEventListener("click", (event) => {
    event.preventDefault(); 
    
    const currentSelected = expenseList.querySelector("li.selected");
    if (currentSelected) {
      currentSelected.classList.remove("selected");
    }

    listItem.classList.add("selected");
    callback(expense.id);
  });
  iconItem.className = "fa-solid fa-credit-card expense-icon";
  iconItem.setAttribute("aria-hidden", "true");
  
  linkItem.appendChild(iconItem);
  linkItem.appendChild(titleItem);
  listItem.appendChild(linkItem);

  if (expense.id === selectedExpense)
    listItem.classList.add("selected");

  expenseList.appendChild(listItem);
}

function clearExpenses() {
  expenseList.innerHTML = "";
}

function toggleLoadingExpenses() {
  spinnerExpenses.classList.toggle("hidden");
}

function showError(message) {
  errorMessageDiv.innerHTML = "";

  const iconItem = document.createElement("i");
  const titleItem = document.createElement("h2");
  const textSpan = document.createElement("span");

  iconItem.className = "fa-solid fa-triangle-exclamation expense-icon";
  iconItem.setAttribute("aria-hidden", "true");
  titleItem.appendChild(iconItem);

  textSpan.textContent = message;
  titleItem.appendChild(textSpan);

  const buttonItem = document.createElement("button");
  buttonItem.type = "button";
  buttonItem.className = "form-button";
  buttonItem.textContent = "Dismiss";
  buttonItem.addEventListener("click", () => {
    clearError();
  });

  errorMessageDiv.appendChild(titleItem);
  errorMessageDiv.appendChild(buttonItem);

  errorMessageDiv.setAttribute("role", "alert");
  errorMessageDiv.setAttribute("aria-live", "assertive");
  errorMessageDiv.classList.remove("visually-hidden");
  
  errorMessageDiv.scrollIntoView({ behavior: 'smooth' });
}

function clearError() {
  errorMessageDiv.classList.add("visually-hidden");
  errorMessageDiv.innerHTML = `
  <i class="fa-solid fa-triangle-exclamation expense-icon" aria-hidden="true"></i>
  <label></label>
  `;
}

function spinSpinnerEditDetails() {
  if (editSpinnerCount === 0) {
    spinnerEditDetails.classList.toggle("hidden");
  }
  editSpinnerCount++;
}

function stopSpinSpinnerEditDetails() {
  editSpinnerCount--;
  if (editSpinnerCount === 0) {
    spinnerEditDetails.classList.toggle("hidden");
  }
}

function buildExpenseDetails(expense, editExpenseCallback) {
  const date = new Date(expense.date);
  const formattedDate = date.toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  });
  
  selectedExpense = expense.id;

  let iconItem = detailsSection.querySelector("i");
  iconItem.className = "fa-solid fa-circle-info";
  iconItem.setAttribute("aria-hidden", "true");

  let span = detailsSectionTitle.querySelector("span");
  span.textContent = "Expense Details";
  
  detailsSectionArticle.innerHTML = `
    <header>
      <h3 class="can-break">${expense.description}</h3>

      <button
        class="circle-button"
        aria-label="Edit expense ${expense.description}"
      >
        <i class="fa-solid fa-pencil" aria-hidden="true"></i>
      </button>
    </header>

    <dl class="expense-details">
      <dt>
        <i class="fa-solid fa-coins" aria-hidden="true"></i>
        Amount:
      </dt>
      <dd>
        $${expense.amount.toFixed(2)}
      </dd>

      <dt>
        <i class="fa-solid fa-scale-balanced" aria-hidden="true"></i>
        Balance:
      </dt>
      <dd>
        $${expense.creditBalance.toFixed(2)}
      </dd>

      <dt>
        <i class="fa-solid fa-calendar-days" aria-hidden="true"></i>
        Date:
      </dt>
      <dd>
        <time datetime="${expense.date}">${formattedDate}</time>
      </dd>
    </dl>
  `;
  
  // Get the button we just inserted
  let editButton = detailsSectionArticle.querySelector('button');
  editButton.addEventListener("click", () => {
    editExpenseCallback(expense.id);
  });
}

function clearExpenseDetails() {

  let iconItem = detailsSection.querySelector("i");
  iconItem.className = "fa-solid fa-circle-info";
  iconItem.setAttribute("aria-hidden", "true");

  let span = detailsSectionTitle.querySelector("span");
  span.textContent = "Expense Details";

  detailsSectionArticle.innerHTML = "<h3>Pick an Expense</h3>";
}

function clearExpenseSelection() {
  clearExpenseDetails();
  clearFriendsExpense();
  selectedExpense = -1;
}

function buildFriendsExpense(expense, addFriendCallback, removeFriendCallback,
   addCreditCallback) {

  // Title
  let existingButton = friendsSectionTitle.querySelector(".back-circle-button");
  if (existingButton) existingButton.remove();

  let span = friendsSectionTitle.querySelector("span");
  span.textContent = "Friends on expense";
  
  let iconItem = friendsSectionTitle.querySelector("i");
  iconItem.className = "fa-solid fa-user-group";
  iconItem.setAttribute("aria-hidden", "true");
    
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
    addFriendCallback(expense.id);
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

    <div class="body-wrapper">
      <h3>${friend.name}</h3>

      <dl class="friend-balances">
        <dt>Credit:</dt>
        <dd class="can-break">
          $${friend.credit_balance.toFixed(2)}
        </dd>

        <dt>Debit:</dt>
        <dd class="can-break">
          $${friend.debit_balance.toFixed(2)}
        </dd>
      </dl>
    </div>

    <div class="menu-wrapper">
      <button
        type="button"
        class="circle-button"
        aria-label="Open menu for ${friend.name}"
      >
        <i class="fa-solid fa-ellipsis-vertical" aria-hidden="true"></i>
      </button>

      <div class="friend-menu hidden">
        <button class="menu-item">Add credit</button>
        <button class="menu-item remove">Delete</button>
      </div>
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
    addCallback(friend.id, expense.id);
  });

  deleteBtn.addEventListener("click", () => {
    removeCallback(friend.id, expense.id);
  });

  friendsSectionList.appendChild(li);
}

function clearFriendsExpense() {
  let existingButton = friendsSectionTitle.querySelector(".back-circle-button");
  if (existingButton) existingButton.remove();
  friendsSection.className = "hidden"
  
  let span = friendsSectionTitle.querySelector("span");
  span.textContent = "";
  
  let iconItem = friendsSectionTitle.querySelector("i");
  iconItem.innerHTML = "";
  iconItem.className = "";
  
  friendsSectionList.innerHTML = "";
}

function spinSpinnerFriends() {
  if (friendsSpinnerCount === 0) {
    spinnerFriends.classList.toggle("hidden");
  }
  friendsSpinnerCount++;
}

function stopSpinSpinnerFriends() {
  friendsSpinnerCount--;
  if (friendsSpinnerCount === 0) {
    spinnerFriends.classList.toggle("hidden");
  }
}

function buildEditExpense(expense, confirmCallback, cancelCallback) {

  let span = detailsSectionTitle.querySelector("span");
  span.textContent = "Edit expense";
  
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
    confirmCallback(expense.id, description, date, amount);
  });

  cancelButton.addEventListener('click', () => {
    cancelCallback(expense.id);
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

  // Remove existing back button if it already exists
  const existingBtn = friendsSectionTitle.querySelector(".back-circle-button");
  if (existingBtn) {
    existingBtn.remove();
  }

  // Title
  let span = friendsSectionTitle.querySelector("span");
  span.textContent = "Add Friend";
  
  let iconItem = friendsSectionTitle.querySelector("i");
  iconItem.className = "fa-solid fa-user-plus";
  iconItem.setAttribute("aria-hidden", "true");

  let btn = document.createElement("button");
  btn.className = "back-circle-button";
  btn.innerHTML = `<i class="fa-solid fa-circle-chevron-left"></i>`;

  friendsSectionTitle.prepend(btn);
  
  btn.addEventListener("click", (event) => {
    event.preventDefault();
    cancelCallback(expense.id);
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
    callback(friend.id, expense.id);
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
      <label class="form-label can-break">Do you want to remove '${friend.name}' from this expense?</label>
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
    removeCallback(friend.id, expense.id);
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
      <label for="add-credit-input" class="form-label can-break">
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
    addCreditCallback(friend.id, expense.id, Number(input.value));
    dialog.close();
  });
}

export { 
  init, 
  setReloadCallback, 
  addExpenseItem,
  toggleLoadingExpenses,
  showError,
  showAccessibilityMsg,
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
  spinSpinnerEditDetails,
  stopSpinSpinnerEditDetails,
  spinSpinnerFriends,
  stopSpinSpinnerFriends,
  isSelected,
};