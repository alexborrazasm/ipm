"""Model module responsible for communicating with the external API"""
import requests

SERVER_URL="http://localhost:8000/"

class ModelError(Exception):
  def __init__(self, message: str):
    super().__init__(message)

class Model:
  def __init__(self):
    pass

  def get_expense(self, expense_id: int) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/expenses/{expense_id}")
      if r.ok:
        return r.json()
      
      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")

  def get_expenses(self) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/expenses")
      if r.ok:
        return r.json()
      
      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")
    
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
        return
      
      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")
  
  def delete_expense(self, expense_id: int) -> bool:
    try:
      r = requests.delete(f"{SERVER_URL}/expenses/{expense_id}")
      if r.ok:
        return True
      
      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")

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

      # Handle specific HTTP status codes
      if r.status_code == 409:
          raise ModelError("Expense already exists")

      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")

  def get_friends(self) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/friends")
      if r.ok:
        return r.json()
      
      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")

  def get_friend_by_id(self, friend_id: int) -> dict:
    try:
      r = requests.get(f"{SERVER_URL}/friends/{friend_id}")
      if r.ok:
        return r.json()
      
      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")

  def get_friends_by_expenses(self, expense_id: int) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/expenses/{expense_id}/friends")
      if r.ok:
        return r.json()
      
      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")
  
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
    
      # Handle specific HTTP status codes
      if r.status_code == 409:
          raise ModelError("Friend already exists")

      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")

  def delete_friend(self, friend_id: int) -> bool:
    try:
      r = requests.delete(f"{SERVER_URL}/friends/{friend_id}")
      if r.ok:
        return True
      
      # Handle specific HTTP status codes
      if r.status_code == 409:
          raise ModelError("Friend doesn't exist")

      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")

  def delete_friend_expense(self, expense_id: int, friend_id: int) -> bool:
    try:
      r = requests.delete(f"{SERVER_URL}/expenses/{expense_id}/friends/{friend_id}")
      if r.ok:
        return True
      
      # Handle specific HTTP status codes
      if r.status_code == 409:
          raise ModelError("Couldn't delete friend from expense")

      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")
  
  def add_friend_expense(self, expense_id: int, friend_id: int) -> bool:
    try:
      r = requests.post(
        f"{SERVER_URL}/expenses/{expense_id}/friends", 
        params={"friend_id": friend_id}               
      )
      if r.ok:
        return True
      
      # Handle specific HTTP status codes
      if r.status_code == 409:
          raise ModelError("Couldn't add friend to expense")

      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")
    
  def add_friend_expense_credit(self, expense_id: int, friend_id: int, 
                                amount: float) -> bool:
    url = f"{SERVER_URL}/expenses/{expense_id}/friends/{friend_id}"
    params = {"amount": amount}
    try:
      r = requests.put(url, params=params)
      if r.ok:
        return True
      
      # Generic error
      raise ModelError(f"Unknown error")

    except requests.RequestException:
        # Network-level errors (connection refused, timeout, DNS)
        raise ModelError("Cannot connect to server, please check your network")

