"""Model module responsible for communicating with the external API"""
import requests

SERVER_URL="http://localhost:8000/"
TIMEOUT=10

class ModelError(Exception):
  """Custom exception for model-related errors"""
  def __init__(self, message: str):
    super().__init__(message)

class NetworkError(Exception):
  """Custom exception for network-related errors"""
  def __init__(self, message: str):
    super().__init__(message)

class Model:
  """Model class to interact with the external API"""
  def __init__(self):
    pass

  def get_expense(self, expense_id: int) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/expenses/{expense_id}", timeout=TIMEOUT)
      if r.ok:
        return r.json()

      # Generic error
      raise ModelError(_("Unexpected error"))

    except requests.RequestException as e:
      # Network-level errors (connection refused, timeout, DNS)
      raise NetworkError(_("Cannot connect to server, please check your network")) from e

    except ModelError:
      raise

    except Exception as e:
      print(_("Unexpected exception in get_expense: {error}").format(
          error=str(e)
      ))
      return []

  def get_expenses(self) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/expenses", timeout=TIMEOUT)
      if r.ok:
        return r.json()

      # Generic error
      raise ModelError(_("Unexpected error"))

    except requests.RequestException as e:
      # Network-level errors (connection refused, timeout, DNS)
      raise NetworkError(_("Cannot connect to server, please check your network")) from e

    except ModelError:
      raise

    except Exception as e:
      print(_("Unexpected exception in get_expenses: {error}").format(
          error=str(e)
      ))
      return []

  def put_expense(self, expense_id: int, description: str, date: str,
                  amount: float) -> None:
    payload = {
        "description": description,
        "date": date,
        "amount": amount
    }

    try:
      r = requests.put(f"{SERVER_URL}/expenses/{expense_id}", json=payload, timeout=TIMEOUT)
      if r.ok:
        return

      # Generic error
      raise ModelError(_("Unexpected error"))

    except requests.RequestException as e:
      # Network-level errors (connection refused, timeout, DNS)
      raise NetworkError(_("Cannot connect to server, please check your network")) from e

    except ModelError:
      raise

    except Exception as e:
      print(_("Unexpected exception in put_expense: {error}").format(
          error=str(e)
      ))
  def delete_expense(self, expense_id: int) -> None:
    try:
      r = requests.delete(f"{SERVER_URL}/expenses/{expense_id}", timeout=TIMEOUT)
      if r.ok:
        return

      # Generic error
      raise ModelError(_("Unexpected error"))

    except requests.RequestException as e:
      # Network-level errors (connection refused, timeout, DNS)
      raise NetworkError(_("Cannot connect to server, please check your network")) from e

    except ModelError:
      raise

    except Exception as e:
      print(_("Unexpected exception in delete_expense: {error}").format(
          error=str(e)
      ))
  def add_expense(self, description: str, date: str, amount: float) -> dict:
    payload = {
      # could be expense_id
      "description": description,
      "date": date,
      "amount": amount
    }

    try:
      r = requests.post(f"{SERVER_URL}/expenses", json=payload, timeout=TIMEOUT)
      if r.ok:
        return r.json()

      # Handle specific HTTP status codes
      if r.status_code == 409:
        raise ModelError(_("Expense already exists"))

      # Generic error
      raise ModelError(_("Unexpected error"))

    except requests.RequestException as e:
      # Network-level errors (connection refused, timeout, DNS)
      raise NetworkError(_("Cannot connect to server, please check your network")) from e

    except ModelError:
      raise

    except Exception as e:
      print(_("Unexpected exception in add_expense: {error}").format(
          error=str(e)
      ))
      return []

  def get_friends(self) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/friends", timeout=TIMEOUT)
      if r.ok:
        return r.json()

      # Generic error
      raise ModelError(_("Unexpected error"))

    except requests.RequestException as e:
      # Network-level errors (connection refused, timeout, DNS)
      raise NetworkError(_("Cannot connect to server, please check your network")) from e

    except ModelError:
      raise

    except Exception as e:
      print(_("Unexpected exception in get_friends: {error}").format(
          error=str(e)
      ))
      return []

  def get_friends_by_expenses(self, expense_id: int) -> list:
    try:
      r = requests.get(f"{SERVER_URL}/expenses/{expense_id}/friends", timeout=TIMEOUT)
      if r.ok:
        return r.json()

      # Generic error
      raise ModelError(_("Unexpected error"))

    except requests.RequestException as e:
      # Network-level errors (connection refused, timeout, DNS)
      raise NetworkError(_("Cannot connect to server, please check your network")) from e

    except ModelError:
      raise

    except Exception as e:
      print(_("Unexpected exception in get_friends_by_expenses: {error}").format(
          error=str(e)
      ))
      return []

  def delete_friend_expense(self, expense_id: int, friend_id: int) -> None:
    try:
      r = requests.delete(f"{SERVER_URL}/expenses/{expense_id}/friends/{friend_id}",
                          timeout=TIMEOUT)
      if r.ok:
        return

      # Handle specific HTTP status codes
      if r.status_code == 409:
        raise ModelError(_("Couldn't delete friend from expense"))

      # Generic error
      raise ModelError(_("Unexpected error"))

    except requests.RequestException as e:
      # Network-level errors (connection refused, timeout, DNS)
      raise NetworkError(_("Cannot connect to server, please check your network")) from e

    except ModelError:
      raise

    except Exception as e:
      print(_("Unexpected exception in delete_friend_expense: {error}").format(
          error=str(e)
      ))

  def add_friend_expense(self, expense_id: int, friend_id: int) -> None:
    try:
      r = requests.post(f"{SERVER_URL}/expenses/{expense_id}/friends",
        params={"friend_id": friend_id},
        timeout=TIMEOUT
      )
      if r.ok:
        return

      # Handle specific HTTP status codes
      if r.status_code == 409:
        raise ModelError(_("Couldn't add friend to expense"))

      # Generic error
      raise ModelError(_("Unexpected error"))

    except requests.RequestException as e:
      # Network-level errors (connection refused, timeout, DNS)
      raise NetworkError(_("Cannot connect to server, please check your network")) from e

    except ModelError:
      raise

    except Exception as e:
      print(_("Unexpected exception in add_friend_expense: {error}").format(
          error=str(e)
      ))
  def add_friend_expense_credit(self, expense_id: int, friend_id: int,
                                amount: float) -> None:
    url = f"{SERVER_URL}/expenses/{expense_id}/friends/{friend_id}"
    params = {"amount": amount}
    try:
      r = requests.put(url, params=params, timeout=TIMEOUT)
      if r.ok:
        return

      # Generic error
      raise ModelError(_("Unexpected error"))

    except requests.RequestException as e:
      # Network-level errors (connection refused, timeout, DNS)
      raise NetworkError(_("Cannot connect to server, please check your network")) from e

    except ModelError:
      raise

    except Exception as e:
      print(_("Unexpected exception in add_friend_expense_credit: {error}").format(
          error=str(e)
      ))
