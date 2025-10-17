from view import View, run, ViewHandler, run_on_main_thr
from model import Model
from threading import Thread


class Presenter(ViewHandler):
  def __init__(self, model: Model, view: View):
    self.model = model
    self.view = view
        
  def run(self, application_id: str) -> None:
      self.view.set_handler(self)
      # Run application
      run(application_id=application_id, on_activate=self.view.on_activate)
  
  def load_data(self, button=None) -> None:
    def do_request():
      try:
        # Get model data
        expenses = self.model.get_expenses()
        friends = self.model.get_friends()
        # Configure view
        run_on_main_thr(lambda: (
          self.view.update_expenses(expenses),
          self.view.update_friends(friends),
          self.view.set_search_btn_sensitive(True),
          self.view.set_add_btn_sensitive(True),
          self.view.show_start()
        ))
      except Exception as e:
        print(e)
        run_on_main_thr(self.view.show_no_internet)

    self.view.set_search_btn_sensitive(False)
    self.view.set_add_btn_sensitive(False)
    self.view.show_loading_page()
    Thread(target=do_request).start()

  # ===== START Add Expense event handlers =====
  def on_add_expense_clicked(self) -> None:
    self.view.clear_expenses_list_selection()
    self.view.set_sidebar_sensitive(False)
    self.view.show_add_expense()

  def on_confirm_add_new_expense_clicked(self, data) -> None:
    def do_request():
      try:
        new_expense = self.model.add_expense(
          data["description"], 
          data["date"],
          data["amount"])
        def update_view():
          if self.view.get_visible_expense() == -1:
            self.view.show_expense_info(self.view.add_expense(new_expense), 
                                        [], True)
          else:
            self.view.prepare_show_expense_info(
              self.view.add_expense(new_expense), [])
          self.view.set_add_btn_sensitive(True)
          self.view.show_info_toast("Expense added successfully")
          self.view.set_spinner(False)

        run_on_main_thr(update_view)
      except Exception as e:
        self.view.set_add_btn_sensitive(True)
        self.view.set_spinner(False)
        self.view.show_error_toast(str(e))

    self.view.set_sidebar_sensitive(True)
    self.view.set_add_btn_sensitive(False)
    self.view.set_spinner(True)
    self.view.show_empty_expense()
    Thread(target=do_request).start()
    # TODO API errors

  def on_cancel_add_expense_clicked(self) -> None:
    self.view.show_empty_expense()
    self.view.set_sidebar_sensitive(True)
  # ===== END Add Expense event handlers =====

  # ===== START Show Expense event handlers =====
  def on_show_expense_info_clicked(self, data, id:int, request: bool) -> None:
    def do_request():
      try:
        list = self.model.get_friends_by_expenses(id)
        def update_view():
          if self.view.get_visible_expense() == id:
            self.view.show_expense_info(data, list, True)
          else:
            self.view.prepare_show_expense_info(data, list)
          self.view.set_spinner(False)

        run_on_main_thr(update_view)
      except Exception as e:
        print(e);
        run_on_main_thr(self.view.show_no_internet)

    if request:
      self.view.set_spinner(True)
      self.view.show_expense_info(data, [], True)
      Thread(target=do_request).start()
    else:
      self.view.show_expense_info(data, None, False)
  # ===== END Show Expense event handlers =====

  # ===== START Edit Expense event handlers =====
  def on_confirm_edit_expense_clicked(self, payload, data) -> None:
    edited = self.model.put_expense(payload["id"], payload["description"], 
                                    payload["date"], payload["amount"])
    if edited:
      self.view.update_expense(payload)
      list = self.model.get_friends_by_expenses(payload["id"])
      self.view.show_expense_info(data, list, True)
    else:
      print("Error al editar api") # TODO
    
    self.view.set_sidebar_sensitive(True)
  # ===== END Edit Expense event handlers =====

  # ===== START Delete Expense event handlers =====
  def on_delete_expense(self, id: int) -> None:
    # TODO manage API errors
    self.model.delete_expense(expense_id=id)
    self.view.delete_expense(id)
    self.view.show_empty_expense()
  # ===== END Delete Expense event handlers =====
  
  # ===== START Friend Expense event handlers =====  
  def on_add_friend_expense(self, expense_id, friend_id, data) -> None:
    # TODO manage API errors
    self.model.add_friend_expense(expense_id, friend_id)
    list = self.model.get_friends_by_expenses(expense_id)
    self.view.show_expense_info(data, list, True)

  def on_delete_friend_expense(self, expense_id: int, friend_id: int, 
                               data) -> None:
    # TODO manage API errors
    self.model.delete_friend_expense(expense_id, friend_id)
    list = self.model.get_friends_by_expenses(expense_id)
    self.view.show_expense_info(data, list, True)
    
  def on_confirm_add_credit_friend_expense(self, expense_id: int, friend_id: int, 
                                           amount: float, expense) -> None:
    self.model.add_friend_expense_credit(expense_id, friend_id, amount)
    list = self.model.get_friends_by_expenses(expense_id)
    self.view.show_add_friend_credit_expense_info(amount, expense, list)
  # ===== END Friend Expense event handlers =====  

  
  