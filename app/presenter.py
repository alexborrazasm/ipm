from view import View, run, ViewHandler
from model import Model


class Presenter(ViewHandler):
  def __init__(self, model: Model, view: View):
    self.model = model
    self.view = view
        
  def run(self, application_id: str):
    expenses = self.model.get_expenses()
    friends = self.model.get_friends()

    self.view.set_handler(self)

    self.view.update_expenses(expenses)
    self.view.update_friends(friends)

    run(application_id=application_id, on_activate=self.view.on_activate)

  def get_friends_by_expense(self, expense_id: int) -> list[dict]:
    return self.model.get_friends_by_expenses(expense_id)

  # Add new expense
  def on_add_expense_clicked(self) -> None:
    self.view.clear_expenses_list_selection()
    self.view.show_add_expense()

  def on_confirm_add_new_expense_clicked(self, data):
    added_expense = self.model.add_expense(data["description"], data["date"], data["amount"])
    self.view.show_empty_expense()
    
    #PROVISIONAL too many requests TODO manage dinamic view 
    expenses = self.model.get_expenses()
    self.view.update_expenses(expenses)

  def on_cancel_add_expense_clicked(self) -> None:
    self.view.show_empty_expense()

  # Search expenses
  def on_search_expense_clicked(self) -> None:
    self.view.show_search_expense()
    pass # TODO
  
  # Show expense
  def on_show_expense_info_clicked(self, data) -> None:
    self.view.show_expense_info(data)

  # Edit expense
  def on_edit_expense_clicked(self, data) -> None:
    self.view.show_edit_expense_info(data)

  def on_confirm_edit_expense_clicked(self, payload, data):
    edited = self.model.put_expense(payload["id"], payload["description"], 
                                    payload["date"], payload["amount"])
    if edited:
      self.view.update_expense(payload)
      self.view.show_expense_info(data)
    else:
      print("Error al editar api") # TODO
  
  def on_cancel_edit_expense_clicked(self, data) -> None:
    self.on_show_expense_info_clicked(data)
    
  # Delete expense
  def on_delete_expense(self, id: int) -> None:
    # TODO manage API errors
    self.model.delete_expense(expense_id=id)
    self.view.delete_expense(id)
    self.view.show_empty_expense()
  
  # Remove a friend from one expense
  def on_delete_friend_expense(self, expense_id: int, friend_id: int, data) -> None:
    # TODO manage API errors
    self.model.delete_friend_expense(expense_id, friend_id)
    self.view.delete_expense(expense_id)
    self.view.show_expense_info(data)