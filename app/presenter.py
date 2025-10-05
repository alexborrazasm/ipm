from view import View, run, ViewHandler
from model import Model


class Presenter(ViewHandler):
  def __init__(self, model: Model, view: View):
    self.model = model
    self.view = view
        
  def run(self, application_id: str):
    self.view.set_handler(self)
    run(application_id=application_id, on_activate=self.view.on_activate)

  def on_add_expense_clicked(self) -> None:
    print("Add expense clicked")
    pass # TODO
  
  def on_search_expense_clicked(self) -> None:
    print("Search expense clicked")
    pass # TODO