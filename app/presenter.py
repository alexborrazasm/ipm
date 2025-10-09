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
    self.view.show_add_expense()
    pass # TODO
  def on_confirm_add_new_expense_clicked(self):
    print("Confirm add new expense clicked")
    pass # TODO
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
  def on_confirm_edit_expense_clicked(self, data) -> None:
    print("Confirm edit expense clicked")
    pass # TODO
  def on_cancel_edit_expense_clicked(self, data) -> None:
    self.on_show_expense_info_clicked(data)