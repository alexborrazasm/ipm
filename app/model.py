import requests

SERVER_URL="http://localhost:8000/"

class Model:
  def __init__(self):
    pass

  def get_expense(self, expense_id: int) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/expenses/{expense_id}")
      if r.ok:
        return r.json()
      else:
        return []
    except Exception as e:
      raise
  
  def get_expenses(self) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/expenses")
      if r.ok:
        return r.json()
      else:
        return []
    except Exception as e:
      raise
    
  def put_expense(self, expense_id: int, description: str, date: str, 
                  amount: float) -> bool:
    payload = {
        "description": description,
        "date": date,
        "amount": amount
    }

    try:
      r = requests.put(f"{SERVER_URL}/expenses/{expense_id}", json=payload)
      if r.ok:
        return True
      else:
        print(f"Failed to update expense {expense_id}: {r.status_code} {r.text}")
        return False
    except Exception as e:
      print(e)
      return False  # TODO: proper error handling
  
  def delete_expense(self, expense_id: int) -> bool:
    try:
      r = requests.delete(f"{SERVER_URL}/expenses/{expense_id}")
      if r.ok:
        return True
      else:
        print(f"Failed to delete expense {expense_id}: {r.status_code} {r.text}")
        return False
    except Exception as e:
      print(e)
      return False  # TODO: proper error handling
    
  def add_expense(self, description: str, date: str, amount: float) -> dict:
    payload = {
      # could be expense_id
      "description": description,
      "date": date,
      "amount": amount
    }

    try:
      r = requests.post(f"{SERVER_URL}/expenses", json=payload)
      if r.ok:
        return r.json()
      else:
        print(f"Failed to add expense: {r.status_code} {r.text}")
        return {}
    except Exception as e:
      print(e)
      return {}  # TODO: proper error handling

  def get_friends(self) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/friends")
      if r.ok:
        return r.json()
      else:
        return []
    except Exception as e:
      print(e)
      return [] # TODO proper error handling
    
  def get_friend_by_id(self, friend_id: int) -> dict:
    try:
      r = requests.get(f"{SERVER_URL}/friends/{friend_id}")
      if r.ok:
        return r.json()
      else:
        return {}
    except Exception as e:
      print(e)
      return {} # TODO proper error handling
    
  def get_friends_by_expenses(self, expense_id: int) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/expenses/{expense_id}/friends")
      if r.ok:
        return r.json()
      else:
        return []
    except Exception as e:
      print(e)
      return [] # TODO proper error handling
    
  def add_friend(self, name: str, credit_balance: float, 
                 debit_balance: float) -> dict:
    payload = {   
      # could be friend_id
      "name": name,
      "credit_balance": credit_balance,
      "debit_balance": debit_balance
    }

    try:
      r = requests.post(f"{SERVER_URL}/friends", json=payload)
      if r.ok and r.content:
        return r.json() 
      else:
        print(f"Failed to add friend: {r.status_code} {r.text}")
        return {}
    except Exception as e:
      print(e)
      return {}  # TODO: proper error handling

  def delete_friend(self, friend_id: int) -> bool:
    try:
      r = requests.delete(f"{SERVER_URL}/friends/{friend_id}")
      if r.ok:
        return True
      else:
        print(f"Failed to delete friend {friend_id}: {r.status_code} {r.text}")
        return False
    except Exception as e:
      print(e)
      return False  # TODO: proper error handling

  def delete_friend_expense(self, expense_id: int, friend_id: int) -> bool:
    try:
      r = requests.delete(f"{SERVER_URL}/expenses/{expense_id}/friends/{friend_id}")
      if r.ok:
        return True
      else:
        print(f"Error delete: {r.text}")
        return False
    except Exception as e:
      print(e)
      return False  # TODO: proper error handling
    
  def add_friend_expense(self, expense_id: int, friend_id: int) -> bool:
    try:
      r = requests.post(
        f"{SERVER_URL}/expenses/{expense_id}/friends", 
        params={"friend_id": friend_id}               
      )
      if r.ok:
        return True
      else:
        print("Failed to add friend to expense")
        return False
    except Exception as e:
        print(e)
        return False  # TODO: proper error handling
    
  def add_friend_expense_credit(self, expense_id: int, friend_id: int, 
                                amount: float) -> bool:
    url = f"{SERVER_URL}/expenses/{expense_id}/friends/{friend_id}"
    params = {"amount": amount}
    try:
      r = requests.put(url, params=params)
      if r.ok:
        return True
      else:
        print(f"Failed to update friend credit{friend_id}: {r.status_code} {r.text}")
        return False
    except Exception as e:
      print(e)
      return False  # TODO: proper error handling  




