const expenseList = document.querySelector("section#expense-list ul");
const spinnerExpenses = document.querySelector("section#expense-list div.loading");
const reloadButton = document.querySelector("section#expense-list button#reload");

function init() {
  spinnerExpenses.classList.add("hidden");
}

function setReloadCallback(callback) {
  reloadButton.addEventListener("click", callback);
}

function addExpenseItem(expense) {
  let listItem = document.createElement("li");
  let linkItem = document.createElement("a");
  let iconItem = document.createElement("i");
  let titleItem = document.createElement("h3");
  
  listItem.dataset.id = expense.id;
  titleItem.textContent = expense.description;
  linkItem.href = `#expense-${expense.id}`;
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





export { 
  init, 
  setReloadCallback, 
  addExpenseItem,
  clearExpenses, 
  toggleLoadingExpenses,
}; // TODO