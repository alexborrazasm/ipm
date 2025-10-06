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
