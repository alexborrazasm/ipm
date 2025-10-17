""" Presenter module that connects the view and the model in the application"""
from threading import Thread
from view import View, run, ViewHandler, run_on_main_thr
from model import Model


class Presenter(ViewHandler):
  def __init__(self, model: Model, view: View):
    self.model = model
    self.view = view

  def run(self, application_id: str) -> None:
    self.view.set_handler(self)
    # Run application
    run(application_id=application_id, on_activate=self.view.on_activate)

  def load_data(self) -> None:
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
        msg = str(e)
        print(f"EXCEPTION in load_data: {msg}")
        def update_view_error():
          self.view.show_error_toast(msg)
          run_on_main_thr(self.view.show_no_internet)

        run_on_main_thr(update_view_error)

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
        msg = str(e)
        print(f"EXCEPTION in confirm_add_new_expense_clicked: {msg}")
        def update_view_error():
          self.view.show_error_toast(msg)
          run_on_main_thr(self.view.show_no_internet)
          self.view.set_add_btn_sensitive(True)
          self.view.set_spinner(False)

        run_on_main_thr(update_view_error)

    self.view.set_sidebar_sensitive(True)
    self.view.set_add_btn_sensitive(False)
    self.view.set_spinner(True)
    self.view.show_empty_expense()
    Thread(target=do_request).start()

  def on_cancel_add_expense_clicked(self) -> None:
    self.view.show_empty_expense()
    self.view.set_sidebar_sensitive(True)
  # ===== END Add Expense event handlers =====

  # ===== START Show Expense event handlers =====
  def on_show_expense_info_clicked(self, data, exp_id: int, request: bool) -> None:
    def do_request():
      try:
        l = self.model.get_friends_by_expenses(exp_id)
        def update_view():
          if self.view.get_visible_expense() == exp_id:
            self.view.show_expense_info(data, l, True)
          else:
            self.view.prepare_show_expense_info(data, l)
          self.view.set_spinner(False)

        run_on_main_thr(update_view)

      except Exception as e:
        print(f"EXCEPTION in on_show_expense_info_clicked: {e}")
        def update_view_error():
          self.view.show_error_toast(str(e))
          run_on_main_thr(self.view.show_no_internet)

        run_on_main_thr(update_view_error)

    if request:
      self.view.set_spinner(True)
      self.view.show_expense_info(data, [], True)
      Thread(target=do_request).start()
    else:
      self.view.show_expense_info(data, None, False)
  # ===== END Show Expense event handlers =====

  # ===== START Edit Expense event handlers =====
  def on_confirm_edit_expense_clicked(self, payload, data) -> None:
    def do_request():
      try:
        self.model.put_expense(payload["id"], payload["description"],
                               payload["date"], payload["amount"])
        l = self.model.get_friends_by_expenses(payload["id"])
        def update_view():
          self.view.update_expense(payload)
          if self.view.get_visible_expense() == -1:
            self.view.show_expense_info(data, l, True)
          else:
            self.view.prepare_show_expense_info(data, l)
          self.view.set_add_btn_sensitive(True)
          self.view.show_info_toast("Expense edited successfully")
          self.view.set_spinner(False)

        run_on_main_thr(update_view)

      except Exception as e:
        msg = str(e)
        print(f"EXCEPTION in on_confirm_edit_expense_clicked: {msg}")
        def update_view_error():
          self.view.set_spinner(False)
          self.view.show_error_toast(msg)
          run_on_main_thr(self.view.show_no_internet)

        run_on_main_thr(update_view_error)

    self.view.set_spinner(True)
    self.view.set_sidebar_sensitive(True)
    Thread(target=do_request).start()
  # ===== END Edit Expense event handlers =====

  # ===== START Delete Expense event handlers =====
  def on_delete_expense(self, exp_id: int) -> None:
    def do_request():
      try:
        self.model.delete_expense(exp_id)
        def update_view():
          self.view.delete_expense(exp_id)
          self.view.set_spinner(False)
          self.view.show_info_toast("Expense successfully deleted")

        run_on_main_thr(update_view)

      except Exception as e:
        msg = str(e)
        print(f"EXCEPTION in on_delete_expense_clicked: {msg}")
        def update_view_error():
          self.view.set_spinner(False)
          self.view.show_error_toast(msg)
          run_on_main_thr(self.view.show_no_internet)

        run_on_main_thr(update_view_error)

    self.view.set_spinner(True)
    self.view.show_empty_expense()
    self.view.clear_expenses_list_selection()
    Thread(target=do_request).start()
  # ===== END Delete Expense event handlers =====

  # ===== START Friend Expense event handlers =====
  def on_add_friend_expense(self, expense_id, friend_id, data) -> None:
   # def do_request():
   #   try:
   #     def update_view():

   #     run_on_main_thr(update_view)

   #   except Exception as e:
   #     msg = str(e)
   #     print(f"EXCEPTION in on_confirm_edit_expense_clicked: {msg}")
   #     def update_view_error():
   #       self.view.set_spinner(False)
   #       self.view.show_error_toast(msg)
   #       run_on_main_thr(self.view.show_no_internet)

   #     run_on_main_thr(update_view_error)

   #self.view.set_spinner(True)
   #Thread(target=do_request).start()

    self.model.add_friend_expense(expense_id, friend_id)
    l = self.model.get_friends_by_expenses(expense_id)
    self.view.show_expense_info(data, l, True)

  def on_delete_friend_expense(self, expense_id: int, friend_id: int,
                               data) -> None:
   # def do_request():
   #   try:
   #     def update_view():

   #     run_on_main_thr(update_view)

   #   except Exception as e:
   #     msg = str(e)
   #     print(f"EXCEPTION in on_confirm_edit_expense_clicked: {msg}")
   #     def update_view_error():
   #       self.view.set_spinner(False)
   #       self.view.show_error_toast(msg)
   #       run_on_main_thr(self.view.show_no_internet)

   #     run_on_main_thr(update_view_error)

   #self.view.set_spinner(True)
   #Thread(target=do_request).start()

    self.model.delete_friend_expense(expense_id, friend_id)
    l = self.model.get_friends_by_expenses(expense_id)
    self.view.show_expense_info(data, l, True)

  def on_confirm_add_credit_friend_expense(self, expense_id: int, friend_id: int,
                                           amount: float, expense) -> None:
   # def do_request():
   #   try:
   #     def update_view():

   #     run_on_main_thr(update_view)

   #   except Exception as e:
   #     msg = str(e)
   #     print(f"EXCEPTION in on_confirm_edit_expense_clicked: {msg}")
   #     def update_view_error():
   #       self.view.set_spinner(False)
   #       self.view.show_error_toast(msg)
   #       run_on_main_thr(self.view.show_no_internet)

   #     run_on_main_thr(update_view_error)

   #self.view.set_spinner(True)
   #Thread(target=do_request).start()

    self.model.add_friend_expense_credit(expense_id, friend_id, amount)
    l = self.model.get_friends_by_expenses(expense_id)
    self.view.show_add_friend_credit_expense_info(amount, expense, l)
  # ===== END Friend Expense event handlers =====
