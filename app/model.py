import requests

SERVER_URL="http://localhost:8000/"

class Model:
  def __init__(self):
    pass
  
  def get_expenses(self) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/expenses")
      if r.ok:
        return r.json()
      else:
        return []
    except Exception as e:
      print(e)
      return [] # TODO proper error handling
    
  def put_expense(self, expense_id: int, description: str, date: str, amount: float) -> dict:
      payload = {
          "description": description,
          "date": date,
          "amount": amount
      }

      try:
          r = requests.put(f"{SERVER_URL}/expenses/{expense_id}", json=payload)
          if r.ok:
              return r.json()
          else:
              print(f"Failed to update expense {expense_id}: {r.status_code} {r.text}")
              return {}
      except Exception as e:
          print(e)
          return {}  # TODO: proper error handling
      

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
    

  def get_friends_by_expenses(self, expense_id: int) -> dict:
    try:
      r = requests.get(f"{SERVER_URL}/expenses/{expense_id}/friends")
      if r.ok:
        return r.json()
      else:
        return {}
    except Exception as e:
      print(e)
      return {} # TODO proper error handling
    






