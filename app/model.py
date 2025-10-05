import requests

SERVER_URL="http://localhost:8000/"

class Model:
  def __init__(self):
    pass

  def do_search(self) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/friends")
      if r.ok:
        return r.json()
      else:
        return []
    except Exception as e:
      print(e)
      return [{"name": "Fake 1", "id": 1, "credit_balance": 100},
          {"name": "Fake 2", "id": 2, "credit_balance": 200},
          {"name": "Fake 3", "id": 3, "credit_balance": 300},] 
