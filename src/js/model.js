import { Expense, Friend } from './dto.js';

const server_url = "http://localhost:8000";
const expense_endpoint = "expenses";
const friend_endpoint = "friends";

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
		let response = await fetch(
			`${server_url}/${expense_endpoint}`
		)
		const data = await response.json();
		return data.map((data) => new Expense(data.id, data.description,
			data.date, data.amount, data.numFriends, data.creditBalance,
			data.friends.map((friend) => new Friend(friend.id, friend.name,
			friend.credit_balance, friend.debit_balance)))
		);

	} catch (error) {
		throw new ConnectionError(error.message);
	}
}

async function retrieveFriends() {
	try {
		let response = await fetch(
			`${server_url}/${friend_endpoint}`
		)
		const data = await response.json();
		return data.map((data) => new Friend(data.id, data.name,
			data.credit_balance, data.debit_balance)
		);

	} catch (error) {
		throw new ConnectionError(error.message);
	}
}

async function retrieveFriendsOnExpense(expenseId) {
		try {
			let response = await fetch(
				`${server_url}/${expense_endpoint}/${expenseId}/${friend_endpoint}`
			)
			const data = await response.json();
			return data.map((data) => new Friend(data.id, data.name,
				data.credit_balance, data.debit_balance)
			);

		} catch (error) {
			throw new ConnectionError(error.message);
		}
}

async function editExpense(id, description, date) {
	let response;
	try {
		response = await fetch(); // TODO
	} catch (error) {
		throw new ConnectionError(error.message);
	}

	if (response.status == 409) {
		throw new RequestError('...'); // TODO
	}

	return "..."; // TODO
}

async function addFriendToExpense(expenseId, friendId) {
	let response;
	try {
		response = await fetch(); // TODO
	} catch (error) {
		throw new ConnectionError(error.message);
	}

	if (response.status == 409) {
		throw new RequestError('...'); // TODO
	}

	return "..."; // TODO
}

async function aaa() {
	let response;
	try {
		response = await fetch(); // TODO
	} catch (error) {
		throw new ConnectionError(error.message);
	}

	if (response.status == 409) {
		throw new RequestError('...'); // TODO
	}

	return "..."; // TODO
}

async function removeFriendFromExpense(friendId, expenseId) {
	let response;
	try {
		response = await fetch(); // TODO
	} catch (error) {
		throw new ConnectionError(error.message);
	}

	if (response.status == 409) {
		throw new RequestError('...'); // TODO
	}

	return "..."; // TODO
}

async function addCreditToFriend(friendId, expenseId, amount) {
	let response;
	try {
		response = await fetch(); // TODO
	} catch (error) {
		throw new ConnectionError(error.message);
	}

	if (response.status == 409) {
		throw new RequestError('...'); // TODO
	}

	return "..."; // TODO
}

export { retrieveExpenses, retrieveFriends, retrieveFriendsOnExpense, editExpense,
	addFriendToExpense, removeFriendFromExpense, addCreditToFriend, ConnectionError,
	RequestError
};
