from view import View, run, ViewHandler
from model import Model


class Presenter(ViewHandler):
  def __init__(self, model: Model, view: View):
    self.model = model
    self.view = view
        
  def run(self, application_id: str):
    expenses = self.model.get_expenses()
    self.view.update_expenses(expenses)

    self.view.set_handler(self)
    run(application_id=application_id, on_activate=self.view.on_activate)


  def on_add_expense_clicked(self) -> None:
    self.view.show_add_expense()
    pass # TODO
  
  def on_search_expense_clicked(self) -> None:
    expenses = self.model.get_expenses()
    self.view.update(expenses)
    self.view.show_search_expense()
    pass # TODO
  
  def on_show_expense_info_clicked(self, data) -> None:
    self.view.show_expense_info(data)