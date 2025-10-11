from __future__ import annotations
from typing import Callable, Protocol, Any
from datetime import datetime

import gi

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import Gtk, Gio, GObject, Adw, GLib, Gdk

def run(application_id: str, on_activate: Callable) -> None:
  app = Adw.Application(application_id=application_id)
  app.connect('activate', on_activate)
  app.run()


# Abstract presenter interface
class ViewHandler(Protocol):
  def on_add_expense_clicked(self) -> None: pass
  def on_search_expense_clicked(self) -> None: pass
  def on_show_expense_info_clicked(self, data: Expense) -> None: pass
  def on_confirm_add_new_expense_clicked(self, data) -> None: pass
  def on_cancel_add_expense_clicked(self) -> None: pass
  def on_cancel_edit_expense_clicked(self, data) -> None: pass
  def on_edit_expense_clicked(self, data) -> None: pass
  def on_confirm_edit_expense_clicked(self, payload, data) -> None: pass
  def on_delete_expense(self, id: int) -> None: pass
  def on_delete_friend_expense(self, expense_id: int, friend_id: int, data) -> None: pass
  def get_friends_by_expense(self, expense_id: int) -> list[dict]: pass

# Data models
class Friend(GObject.GObject):
  id = GObject.Property(type=int)
  name = GObject.Property(type=str)
  credit_balance = GObject.Property(type=float)
  debit_balance = GObject.Property(type=float)

  def __init__(self, id, name, credit_balance, debit_balance):
    super().__init__()
    self.id = id
    self.name = name
    self.credit_balance = credit_balance
    self.debit_balance = debit_balance

class Expense(GObject.GObject):
  id = GObject.Property(type=int)
  description = GObject.Property(type=str)
  date = GObject.Property(type=str)
  amount = GObject.Property(type=float)
  num_friends = GObject.Property(type=int)
  credit_balance = GObject.Property(type=float)

  def __init__(self, id, description, date, amount, num_friends, credit_balance):
    super().__init__()
    self.id = id
    self.description = description
    self.date = date
    self.amount = amount
    self.num_friends = num_friends
    self.credit_balance = credit_balance
    self.friends = Gio.ListStore(item_type=Friend)

  def set_friends(self, friends: list[dict]):
    self.friends.remove_all()
    for f in friends:
        self.friends.append(Friend(f["id"], f["name"], f["credit_balance"], f["debit_balance"]))


# Abstract view interface
class View:
  def __init__(self):
    self.handler = None
    self.data_model_friends = Gio.ListStore(item_type=Friend)
    self.data_model_expenses = Gio.ListStore(item_type=Expense)
    self.entry_description = None
    self.entry_date = None
    self.entry_amount = None
    self.entry_friends = None
    self.entry_credit_balance = None

  def set_handler(self, handler: ViewHandler) -> None:
    self.handler = handler

  def update_friends(self, data: list) -> None:
    self.data_model_friends.remove_all()
    
    for item in data:
      friend = Friend(
        item["id"],
        item["name"],
        item["credit_balance"],
        item["debit_balance"]
      )

      self.data_model_friends.append(friend) 

  def update_expenses(self, data: list) -> None:
    self.data_model_expenses.remove_all()

    for item in data:
      expense = Expense(
        item['id'],
        item['description'],
        item['date'],
        item['amount'],
        item['num_friends'],
        item['credit_balance']
      )

      self.data_model_expenses.append(expense)

  def update_expense(self, data: list) -> None:

    id = data['id']
    for i in range(len(self.data_model_expenses)):
      expense = self.data_model_expenses[i]
      if expense.id == id:
        self.data_model_expenses[i].description = data['description']
        self.data_model_expenses[i].date = data['date']
        self.data_model_expenses[i].amount = data['amount']
        break
      
  def add_expense(self, item) -> Expense:
    expense = Expense(
      item['id'],
      item['description'],
      item['date'],
      item['amount'],
      item['num_friends'],
      item['credit_balance']
    )
    self.data_model_expenses.append(expense)
    
    return expense
    
  def delete_expense(self, id: int) -> None:

    for i in range(len(self.data_model_expenses)):
      expense = self.data_model_expenses[i]
      if expense.id == id:
        self.data_model_expenses.remove(i)
        break

  def build_menu(self) -> Gtk.Widget:
    about_action = Gio.SimpleAction.new("about", None)
    about_action.connect("activate", self.show_about)
    self.window.add_action(about_action)

    # Create a new menu, containing that action
    menu = Gio.Menu.new()
    menu.append("About", "win.about")

    # Create a popover
    popover = Gtk.PopoverMenu()  # Create a new popover menu
    popover.set_menu_model(menu)

    # Create a menu button
    dots = Gtk.MenuButton()
    dots.set_popover(popover)
    dots.set_icon_name("open-menu-symbolic")
    return dots

  # Abstract methods to be implemented by subclasses
  def show_empty_expense(self) -> None: pass
  def show_no_one_expense(self) -> None: pass
  def show_add_expense(self) -> None: pass
  def show_search_expense(self) -> None: pass
  def show_expense_info(self, data: Expense) -> None: pass
  def show_edit_expense_info(self, expense: Expense) -> None: pass
  def clear_expenses_list_selection(self) -> None: pass
  def show_edited_expense_info(self, expense: Expense) -> None: pass
  def select_last_expenses_list_selection(self) -> None: pass
  def show_no_one_expense(self) -> None: pass
  def show_loading(self) -> None: pass
  def show_no_internet(self) -> None: pass
  def show_pick_an_expense(self) -> None: pass
  def show_no_one_expense(self) -> None: pass
  def set_sidebar_sensitive(self, boolean: bool): pass

# Concrete implementation of the view using GTK and ADW
class AdwView(View):
  def __init__(self):
    super().__init__()
    self.window = None # type: Adw.ApplicationWindow
    self._expenses_list = None # type: Gtk.ListBox
    self._about = None # type: Adw.AboutDialog
    self._sidebar_header = None # type: Adw.HeaderBar
    self._split_view = None # type: Adw.NavigationSplitView
    self._content_page = None # type: Adw.NavigationPage
    self._sidebar_page = None # type: Gtk.Widget
    
    # Forms
    self._form_entry_description = None
    self._form_entry_amount = None
    self._form_entry_date = None

    # Stack of views
    self._stack = None # type: Adw.Stack

  def on_activate(self, app: Adw.Application) -> None:
    settings = Gtk.Settings.get_default()
    settings.set_property("gtk-decoration-layout", ":minimize,maximize,close")
    self._build(app)

  
  def clear_expenses_list_selection(self) -> None:
    self._expenses_list.unselect_all()
    
  def select_last_expenses_list_selection(self) -> None:

    total = self.data_model_expenses.get_n_items()
    if total > 0:
        last_row = self._expenses_list.get_row_at_index(total - 1)
        self._expenses_list.select_row(last_row)

  def set_sidebar_sensitive(self, boolean: bool) -> None:
    self._expenses_list.set_sensitive(boolean)

  def _build(self, app: Adw.Application) -> None:
    self.window = win = Adw.ApplicationWindow()
    app.add_window(win)
    win.connect("destroy", lambda win: win.close())
    win.set_default_size(800, 600)
    win.set_size_request(400, 200)

    # Left panel (expenses list)
    self._sidebar_page = self._build_side_bar()

    # Right panel (content)
    self._stack = Adw.ViewStack()
    self.show_empty_expense()
    
    self._content_page = Adw.NavigationPage(child=self._stack)
    self._content_page.set_title("Splitwithme")

    # Split view
    self._split_view = Adw.NavigationSplitView()
    self._split_view.set_sidebar(self._sidebar_page)
    self._split_view.set_content(self._content_page)
    self._split_view.set_max_sidebar_width(500)
    self._split_view.set_min_sidebar_width(300)
    
    # Breakpoint to collapse sidebar on small windows
    breakpoint = Adw.Breakpoint.new(Adw.BreakpointCondition.parse(
      "max-width: 600px"))
    breakpoint.add_setter(self._split_view, "collapsed", True)
    # Show window controls when sidebar is collapsed
    breakpoint.add_setter(self._sidebar_header, "show_end_title_buttons", True)
    win.add_breakpoint(breakpoint)
    
    # Show the window
    win.set_content(self._split_view)
    win.present()

  def _build_side_bar(self) -> Gtk.Widget:

    def build_header_bar() -> Adw.HeaderBar:
      add_button = Gtk.Button(icon_name="list-add-symbolic")
      add_button.connect(
        'clicked', lambda _wg: self.handler.on_add_expense_clicked())    

      search_button = Gtk.Button(icon_name="system-search-symbolic")
      search_button.connect(
        'clicked', lambda _wg: self.handler.on_search_expense_clicked())    

      header = Adw.HeaderBar()
      header.set_show_end_title_buttons(False)  # hide window controls
      menu = self.build_menu()
      header.pack_start(search_button)
      header.pack_start(add_button)
      header.pack_end(menu)

      return header

    def build_listbox(self) -> Gtk.ListBox:

      def on_build_row(item: Expense, user_data: Any) -> Gtk.Widget:

        image = Gtk.Image.new_from_icon_name("view-list-symbolic")
        
        label1 = Gtk.Label(label=item.description, halign=Gtk.Align.START)
        # Bind expense description reactively
        item.bind_property("description", label1, "label", 
                           flags=GObject.BindingFlags.SYNC_CREATE)

        label2 = Gtk.Label(label=f"{item.credit_balance:.2f}", 
                           halign=Gtk.Align.START)
        label2.add_css_class("caption")
        # Bind credit balance reactively
        item.bind_property("credit_balance", label2, "label", 
          transform_to=lambda binding, value: f"{float(value):.2f} €"
          if value not in (None, "") else "0.00 €",
          flags=GObject.BindingFlags.SYNC_CREATE
        )

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, hexpand=True, 
                       spacing=2)
        vbox.append(label1)
        vbox.append(label2)
        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL,
          hexpand=True, spacing=16,
          margin_start=8, margin_end=8,
          margin_bottom=8,
          margin_top=8
        )
        hbox.append(image)
        hbox.append(vbox)

        return hbox

      def on_listbox_row_activated(widget: Gtk.ListBox) -> None:
        row = widget.get_selected_row()
        if row is not None:
          idx = row.get_index()
          self.handler.on_show_expense_info_clicked(self.data_model_expenses[idx])
          self._split_view.set_show_content(True) # Show content on small windows
          
      listbox = Gtk.ListBox(hexpand=True)
      listbox.set_selection_mode(Gtk.SelectionMode.SINGLE)
      listbox.connect("selected-rows-changed", on_listbox_row_activated)
      listbox.add_css_class("boxed-list-separate")
      listbox.bind_model(self.data_model_expenses, on_build_row, None)

      return listbox

    self._sidebar_header = build_header_bar() # For use in responsive design
    box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL,
      spacing=16, 
      margin_top=16,
      margin_bottom=16,
      margin_start=16,
      margin_end=16
    )
    self._expenses_list = build_listbox(self)
    scrolledWindow = Gtk.ScrolledWindow()
    scrolledWindow.set_vexpand(True) # Take all available vertical space 
    scrolledWindow.set_child(self._expenses_list)
    box.append(scrolledWindow)
    toolbar = Adw.ToolbarView()
    toolbar.add_top_bar(self._sidebar_header)
    toolbar.set_content(box)

    page = Adw.NavigationPage(title="Expenses", child=toolbar)
    
    return page

  def _build_empty_expense_msg(self, msg: str, icon: str) -> Adw.ToolbarView:
    # Main content
    content_box = Gtk.Box(
      orientation=Gtk.Orientation.VERTICAL,
      spacing=12,
      halign=Gtk.Align.CENTER,
      valign=Gtk.Align.CENTER,
      vexpand=True,
      hexpand=True
    )

    # Big icon
    icon = Gtk.Image.new_from_icon_name(icon)
    icon.set_pixel_size(96)
    icon.add_css_class("flat")
    content_box.append(icon)

    # Text
    label = Gtk.Label(label=msg)
    label.set_margin_top(12)
    content_box.append(label)

    # Toolbar view
    toolbar_view = Adw.ToolbarView()
    toolbar_view.set_content(content_box)

    # Header bar (unique per page)
    header = Adw.HeaderBar()
    toolbar_view.add_top_bar(header)

    return toolbar_view

  def _build_loading_page(self) -> Adw.ToolbarView:
    # Main content box
    content_box = Gtk.Box(
        orientation=Gtk.Orientation.VERTICAL,
        spacing=12,
        halign=Gtk.Align.CENTER,
        valign=Gtk.Align.CENTER,
        vexpand=True,
        hexpand=True
    )

    # Spinner (loading indicator)
    spinner = Adw.Spinner()
    spinner.set_size_request(64, 64)
    content_box.append(spinner)

    # Label text
    label = Gtk.Label(label="Loading...")
    label.set_margin_top(12)
    label.set_css_classes(["title-2"])
    content_box.append(label)

    # ToolbarView
    toolbar_view = Adw.ToolbarView()
    toolbar_view.set_content(content_box)

    # HeaderBar
    header = Adw.HeaderBar()
    header.set_title_widget(Gtk.Label(label="Splitwithme"))
    toolbar_view.add_top_bar(header)

    return toolbar_view
  
  def _build_no_internet_page(self) -> Adw.ToolbarView:
    # Main content box
    content_box = Gtk.Box(
        orientation=Gtk.Orientation.VERTICAL,
        spacing=12,
        halign=Gtk.Align.CENTER,
        valign=Gtk.Align.CENTER,
        vexpand=True,
        hexpand=True
    )

    # Network error icon
    icon = Gtk.Image.new_from_icon_name("network-error-symbolic")
    icon.set_pixel_size(96)
    content_box.append(icon)


    title_label = Gtk.Label(label="No Internet Connection")
    title_label.set_margin_top(12)
    title_label.set_css_classes(["title-2"])
    content_box.append(title_label)

    subtitle_label = Gtk.Label(label="Please check your connection and try again.")
    subtitle_label.set_css_classes(["body"])
    subtitle_label.set_opacity(0.8)
    content_box.append(subtitle_label)


    retry_button = Gtk.Button(label="Retry")
    retry_button.set_margin_top(18)
    #retry_button.connect("clicked", self.handler.on_retry_conection(app))
    content_box.append(retry_button)


    # ToolbarView
    toolbar_view = Adw.ToolbarView()
    toolbar_view.set_content(content_box)

    # HeaderBar
    header = Adw.HeaderBar()
    header.set_title_widget(Gtk.Label(label="Splitwithme"))
    toolbar_view.add_top_bar(header)

    return toolbar_view

  # Clamp to limit max width
  def _build_clamp_content(self, child: Gtk.Widget) -> Adw.Clamp:
    clamp = Adw.Clamp()
    clamp.set_child(child)
    clamp.set_maximum_size(600)  # Max width
    clamp.set_hexpand(True)
    return clamp

  def _build_calendar(self, date: str | None = None) -> Adw.ActionRow:
    
    date_row = Adw.ActionRow(title="Date")
    date_row.set_activatable(True)
    date_row.set_selectable(False)
    calendar_icon = Gtk.Image()
    calendar_icon.set_from_icon_name("x-office-calendar-symbolic")
    calendar_icon.set_margin_end(10)
    date_row.add_suffix(calendar_icon)

    if date:
      formatted_date = date
    else:
      now = datetime.now()
      formatted_date = f"{now.year}-{now.month:02d}-{now.day:02d}" 

    date_row.set_subtitle(formatted_date)
    self._form_entry_date = formatted_date

    calendar = Gtk.Calendar()
    date_popover = Gtk.Popover()
    date_popover.set_child(calendar)
    date_popover.set_parent(date_row)
    
    def on_row_activated(row):
      date_popover.popup()

    def on_date_selected(gesture, n_press, x, y):
      if n_press == 1 or n_press == 2: 
        date_obj = calendar.get_date()
        year = date_obj.get_year()
        month = date_obj.get_month()
        day = date_obj.get_day_of_month()
        formatted_date = f"{year}-{month:02d}-{day:02d}"
        date_row.set_subtitle(formatted_date)
        self._form_entry_date = formatted_date
        date_popover.popdown()

    def on_key_pressed(controller, keyval, keycode, state):
      if keyval == Gdk.KEY_Return or keyval == Gdk.KEY_KP_Enter:
        date_obj = calendar.get_date()
        year = date_obj.get_year()
        month = date_obj.get_month()
        day = date_obj.get_day_of_month()
        formatted_date = f"{year}-{month:02d}-{day:02d}"
        date_row.set_subtitle(formatted_date)
        self._form_entry_date = formatted_date
        date_popover.popdown()
        return True
      return False

    date_row.connect("activated", on_row_activated)

    gesture = Gtk.GestureClick.new()
    gesture.connect("released", on_date_selected)
    calendar.add_controller(gesture)

    key_controller = Gtk.EventControllerKey.new()
    key_controller.connect("key-pressed", on_key_pressed)
    calendar.add_controller(key_controller)

    return date_row

  def _build_edit_expense(self, expense: Expense) -> Adw.ToolbarView:

    def on_edit_done_clicked(self, expense_id, data: Expense):

      payload = {
        "id": expense_id,
        "description": self._form_entry_description.get_text(),
        "date": self._form_entry_date,
        "amount": float(self._form_entry_amount.get_text())
      }
      self.handler.on_confirm_edit_expense_clicked(payload, data)

    # Scrollable content
    scrolled = Gtk.ScrolledWindow()
    scrolled.set_vexpand(True)
    scrolled.set_hexpand(True)
    scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)

    form = Gtk.ListBox()
    form.set_selection_mode(Gtk.SelectionMode.NONE)

    self._form_entry_description = Adw.EntryRow(title="Description")
    self._form_entry_description.set_text(expense.description)
    
    self._form_entry_date = Adw.ActionRow(title="Date")
    
    self._form_entry_amount = Adw.EntryRow(title="Amount")
    self._form_entry_amount.set_text(f"{expense.amount}")

    # Calendar widget
    date_row = self._build_calendar(date=expense.date)

    form.append(self._form_entry_description)
    form.append(self._form_entry_amount)
    form.append(date_row)
    form.add_css_class("boxed-list-separate")

    outer_box = Gtk.Box(
        orientation=Gtk.Orientation.VERTICAL,
        hexpand=True,
        vexpand=True,
        spacing=16,
        margin_top=16,
        margin_bottom=16,
        margin_start=16,
        margin_end=16
    )
    outer_box.append(self._build_clamp_content(form))
    scrolled.set_child(outer_box)

    # Toolbar view (for header + content)
    toolbar_view = Adw.ToolbarView()
    toolbar_view.set_content(scrolled)

    # Header bar
    header = Adw.HeaderBar()
    header.set_title_widget(Gtk.Label(label="Edit expense"))

    # Button Cancel
    cancel_button = Gtk.Button(label="Cancel")
    cancel_button.connect(
        'clicked', lambda _wg: self.handler.on_cancel_edit_expense_clicked(expense)
    )

    # Button Done
    add_button = Gtk.Button(label="Done")
    add_button.add_css_class("suggested-action")
    add_button.connect(
        'clicked', lambda _wg: on_edit_done_clicked(self, expense.id, expense)
    )

    header.set_show_end_title_buttons(False)
    header.pack_start(cancel_button)
    header.pack_end(add_button)
    toolbar_view.add_top_bar(header)

    return toolbar_view
  
  def _build_add_expense(self) -> Adw.ToolbarView:

    def on_add_done_clicked(self):
        
      data = {
        "description": self._form_entry_description.get_text(),
        "date": self._form_entry_date,
        "amount": float(self._form_entry_amount.get_text())
      }
      self.handler.on_confirm_add_new_expense_clicked(data)

    # Scrollable content
    scrolled = Gtk.ScrolledWindow()
    scrolled.set_vexpand(True)
    scrolled.set_hexpand(True)
    scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)

    form = Gtk.ListBox()
    form.set_selection_mode(Gtk.SelectionMode.NONE)
    form.add_css_class("boxed-list-separate")

    self._form_entry_description = Adw.EntryRow(title="Description")
    self._form_entry_amount = Adw.EntryRow(title="Amount")

    # Calendar widget
    date_row = self._build_calendar()

    form.append(self._form_entry_description)
    form.append(self._form_entry_amount)
    form.append(date_row)

    outer_box = Gtk.Box(
        orientation=Gtk.Orientation.VERTICAL,
        hexpand=True,
        vexpand=True,
        spacing=16,
        margin_top=16,
        margin_bottom=16,
        margin_start=16,
        margin_end=16
    )

    outer_box.append(self._build_clamp_content(form))

    scrolled.set_child(outer_box)

    # Toolbar view (for header + content)
    toolbar_view = Adw.ToolbarView()
    toolbar_view.set_content(scrolled)

    # Header bar (unique for this page)
    header = Adw.HeaderBar()
    header.set_title_widget(Gtk.Label(label="New Expense"))
    
    cancel_button = Gtk.Button(label="Cancel")
    cancel_button.connect(
      'clicked', lambda _wg: self.handler.on_cancel_add_expense_clicked())    
      
    add_button = Gtk.Button(label="Add")
    add_button.add_css_class("suggested-action")
    add_button.connect(
      'clicked', lambda _wg: on_add_done_clicked(self))

    header.set_show_end_title_buttons(False)  # hide window controls
    header.pack_start(cancel_button)
    header.pack_end(add_button)

    toolbar_view.add_top_bar(header)

    return toolbar_view

  def _build_expense_info(self, data: Expense) -> Adw.ToolbarView:
    
    def build_listbox_expense_info(data: Expense) -> Gtk.ListBox:

      listbox = Gtk.ListBox(hexpand=True)
      listbox.add_css_class("boxed-list")
      listbox.set_selection_mode(Gtk.SelectionMode.NONE)

      # Description
      row = Adw.ActionRow(title="Description")
      data.bind_property("description", row, "subtitle",
                         flags=GObject.BindingFlags.SYNC_CREATE)
      row.set_activatable(True)
      row.set_selectable(False)
      listbox.append(row)

      # Amount
      row = Adw.ActionRow(title="Amount")
      data.bind_property("amount", row, "subtitle",
        transform_to=lambda binding, value: f"{float(value):.2f} €"
        if value not in (None, "") else "0.00 €",
        flags=GObject.BindingFlags.SYNC_CREATE
      )
      row.set_activatable(True)
      row.set_selectable(False)
      listbox.append(row)
 
      # Date
      row = Adw.ActionRow(title="Date")
      data.bind_property("date", row, "subtitle",
                         flags=GObject.BindingFlags.SYNC_CREATE)
      row.set_activatable(True)
      row.set_selectable(False)
      listbox.append(row)

      return listbox
    
    def build_listbox_balance(data: Expense) -> Gtk.ListBox:
      
      listbox = Gtk.ListBox(hexpand=True)
      listbox.add_css_class("boxed-list")
      listbox.set_selection_mode(Gtk.SelectionMode.NONE)

      # Credit Balance
      balance_row = Adw.ActionRow(title="Balance")
      data.bind_property("credit_balance", balance_row, "subtitle", 
        transform_to=lambda binding, value: f"{float(value):.2f} €"
        if value not in (None, "") else "0.00 €",
        flags=GObject.BindingFlags.SYNC_CREATE
      )
      balance_row.set_activatable(True)
      balance_row.set_selectable(False)

      listbox.append(balance_row)
      
      return listbox
    
    def on_remove_friend_expense_clicked(button, expense: Expense, 
                                         friend: Friend) -> None:
      # Get the parent window from the button
      window = button.get_root()

      # Create confirmation dialog
      dialog = Adw.MessageDialog(
        transient_for=window,
        modal=True,
        heading="Confirm deletion",
        body=f"Are you sure you want to remove '{friend.name}'?",
      )

      # Add action buttons
      dialog.add_response("cancel", "Cancel")
      dialog.add_response("remove", "Remove")

      # Style the destructive one in red
      dialog.set_response_appearance("remove", Adw.ResponseAppearance.DESTRUCTIVE)

      # Connect signal when user responds
      def on_response(dialog, response):
        if response == "remove":
          # Call your delete logic here:
          self.handler.on_delete_friend_expense(expense.id, friend.id, expense)

        dialog.destroy()

      dialog.connect("response", on_response)

      # Show the dialog
      dialog.present()

    def on_build_row_friends(item: Friend, expense: Expense) -> Gtk.Widget:
      # Icon
      image = Gtk.Image.new_from_icon_name("avatar-default-symbolic")
      
      # Remove button
      delete_button = Gtk.Button.new_from_icon_name("user-trash-symbolic")
      delete_button.add_css_class("flat")
      delete_button.add_css_class("destructive-action")
      delete_button.connect("clicked", on_remove_friend_expense_clicked, 
                            expense, item)
      
      # Main labels
      name_label = Gtk.Label(halign=Gtk.Align.START)
      item.bind_property("name", name_label, "label", 
                         flags=GObject.BindingFlags.SYNC_CREATE)

      balance_label = Gtk.Label(halign=Gtk.Align.START)
      balance_label.add_css_class("caption")

      # Function to update balance label
      def update_balance_label(_obj=None, _pspec=None):
          credit = float(item.credit_balance)
          debit = float(item.debit_balance)
          balance_label.set_label(f"Credit: {credit:+.2f} €   |   "
                                  f"Debit: {debit:+.2f} €")

      # Initial update
      update_balance_label()

      # Connect to changes in credit_balance and debit_balance
      item.connect("notify::credit-balance", update_balance_label)
      item.connect("notify::debit-balance", update_balance_label)

      # Layout
      vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, hexpand=True, spacing=2)
      vbox.append(name_label)
      vbox.append(balance_label)
      hbox = Gtk.Box(
          orientation=Gtk.Orientation.HORIZONTAL,
          hexpand=True, spacing=16,
          margin_start=8, margin_end=8,
          margin_bottom=8, margin_top=8
      )
      hbox.append(image)
      hbox.append(vbox)
      hbox.append(delete_button)

      return hbox
    
    def build_add_friend_row(expense: Expense) -> Gtk.Widget:
      row = Adw.ActionRow(title="Add friend")
      row.add_prefix(Gtk.Image.new_from_icon_name("list-add-symbolic"))
      row.set_activatable(True)
      row.connect("activated", lambda _row: on_add_friend_clicked(expense))
      return row

    def on_add_friend_clicked(expense: Expense) -> None:
      # TODO dialogo y tal
      pass
    def on_remove_expense_clicked(button, expense: Expense):
      # Get the parent window from the button
      window = button.get_root()

      # Create confirmation dialog
      dialog = Adw.MessageDialog(
        transient_for=window,
        modal=True,
        heading="Confirm deletion",
        body=f"Are you sure you want to remove '{expense.description}'?",
      )

      # Add action buttons
      dialog.add_response("cancel", "Cancel")
      dialog.add_response("remove", "Remove")

      # Style the destructive one in red
      dialog.set_response_appearance("remove", Adw.ResponseAppearance.DESTRUCTIVE)

      # Connect signal when user responds
      def on_response(dialog, response):
        if response == "remove":
          self.handler.on_delete_expense(data.id)

        dialog.destroy()

      dialog.connect("response", on_response)

      # Show the dialog
      dialog.present()

    # Scrollable content
    scrolled = Gtk.ScrolledWindow()
    scrolled.set_vexpand(True)
    scrolled.set_hexpand(True)
    scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)

    outer_box = Gtk.Box(
        orientation=Gtk.Orientation.VERTICAL,
        hexpand=True,
        vexpand=True,
        spacing=16,
        margin_top=16,
        margin_bottom=16,
        margin_start=16,
        margin_end=16
    )
    
    # Expense details
    group_expenses = Adw.PreferencesGroup(title="Details")
    listbox_info = build_listbox_expense_info(data)
    group_expenses.add(listbox_info)
    clamp_info = self._build_clamp_content(group_expenses)
    outer_box.append(clamp_info)
    listbox_balance = build_listbox_balance(data)
    clamp_balance = self._build_clamp_content(listbox_balance)
    outer_box.append(clamp_balance)

    # Friends involved in the expense
    group_friends = Adw.PreferencesGroup(title="Friends")
    listbox_friends = Gtk.ListBox(hexpand=True)
    listbox_friends.add_css_class("boxed-list") 
    listbox_friends.set_selection_mode(Gtk.SelectionMode.NONE)
    listbox_friends.bind_model(data.friends, on_build_row_friends, data)
    # Append "Add friend" row (always at bottom)
    listbox_friends.append(build_add_friend_row(data))
    group_friends.add(listbox_friends)
    clamp_friends = self._build_clamp_content(group_friends)
    outer_box.append(clamp_friends)
    
    # Remove expense button
    remove_button = Gtk.Button(label="Remove expense")
    remove_button.add_css_class("destructive-action")
    remove_button.set_halign(Gtk.Align.CENTER)
    remove_button.connect("clicked", on_remove_expense_clicked, data)

    outer_box.append(remove_button)

    scrolled.set_child(outer_box)

    # Toolbar view (for header + content)
    toolbar_view = Adw.ToolbarView()
    toolbar_view.set_content(scrolled)

    # Header bar (unique for this page)
    header = Adw.HeaderBar()
    header.set_title_widget(Gtk.Label())
    # Bind reactive title to expense description
    data.bind_property("description", header.get_title_widget(), "label", 
                       flags=GObject.BindingFlags.SYNC_CREATE)
    edit_button = Gtk.Button(icon_name="document-edit-symbolic")
    edit_button.connect(
        'clicked', lambda _wg: self.handler.on_edit_expense_clicked(data))  
    header.pack_end(edit_button)

    toolbar_view.add_top_bar(header)

    return toolbar_view

  def show_about(self, action: Gio.SimpleAction, param: Any):
  
    self._about = Adw.AboutDialog()
    self._about.set_title("About")
    # Makes the dialog always appear in from of the parent window
    # Makes the parent window unresponsive while dialog is showing
    self._about.set_application_name("Splitwithme")
    self._about.set_developers([
      "Nerea Pérez",
      "Daniel García",
      "Alexandre Borrazás"
    ])
    self._about.set_designers([
      "Nerea Pérez",
      "Daniel García",
      "Alexandre Borrazás"
    ])
    self._about.set_copyright(
      "Copyright 2025 Nerea Pérez Pértega"
      ", Daniel García Figueroa "
      "and Alexandre Borrazás Mancebo"
    )
    self._about.set_license_type(Gtk.License.GPL_3_0)
    self._about.set_website(
      "https://github.com/GEI-IPM-614G010222526/practica-de-escritorio-rage-against-the-machine"
    )
    self._about.set_version("0.1")
    self._about.set_copyright(
      "© 2025 Nerea Pérez Pértega"
      ", Daniel García Figueroa"
      " and Alexandre Borrazás Mancebo"
    ) 

    #self.about.set_application_icon("icon.png")
    # myappicon.png must be uploaded in ~/.local/share/icons or /usr/share/icons

    self._about.present(self.window)
    
  def show_pick_an_expense(self) -> None:

    old = self._stack.get_child_by_name("pick_an_expense")
    if not old:
      pick_an_expense = self._build_empty_expense_msg("Pick an expense",
                                            "dialog-information-symbolic")
      self._stack.add_titled(pick_an_expense, "pick_an_expense", "Pick an expense")
    
    self._stack.set_visible_child_name("pick_an_expense")

  def show_no_one_expense(self) -> None:

    old = self._stack.get_child_by_name("no_one_expense")
    if not old:
      no_one_expense = self._build_empty_expense_msg("Add an expense", 
                                                     "list-add-symbolic")
      self._stack.add_titled(no_one_expense, "no_one_expense", "No One Expense")
    
    self._stack.set_visible_child_name("no_one_expense")

  def show_add_expense(self) -> Gtk.Box:

    old = self._stack.get_child_by_name("add_expense")
    if old:
      self._stack.remove(self._stack.get_child_by_name("add_expense"))

    # Build the view
    add_view = self._build_add_expense()
    self._stack.add_titled(add_view, "add_expense", "New Expense")
    # Show the view
    self._split_view.set_show_content(True) # Show content on small windows
    self._stack.set_visible_child_name("add_expense")

  def show_search_expense(self) -> None: 
    print("Search expense clicked")
    # TODO

  def show_expense_info(self, expense: Expense) -> None:
    
    # Lazy load the view only once
    old = self._stack.get_child_by_name(f"info{expense.id}")
    if not old:
      friends_expense = self.handler.get_friends_by_expense(expense.id)
      # Add friend data to expense
      expense.set_friends(friends_expense)
      # Build the view
      info = self._build_expense_info(expense)
      # Add to the stack
      self._stack.add_titled(info, f"info{expense.id}", expense.description)

    # Show the view
    self._stack.set_visible_child_name(f"info{expense.id}")

  def show_edited_expense_info(self, expense: Expense) -> None:
    
    # Remove old view
    self._stack.remove(self._stack.get_child_by_name(f"info{expense.id}"))
    # Update friend in expense
    friends_expense = self.handler.get_friends_by_expense(expense.id)
    # Add friend data to expense
    expense.set_friends(friends_expense)
    # Build the view
    info = self._build_expense_info(expense)
    # Add to the stack
    self._stack.add_titled(info, f"info{expense.id}", expense.description)

    # Show the view
    self._stack.set_visible_child_name(f"info{expense.id}")

  def show_edit_expense_info(self, expense: Expense) -> None:

    old = self._stack.get_child_by_name(f"edit{expense.id}")
    # Remove previous edit view for this expense if exists 
    if old:
      self._stack.remove(self._stack.get_child_by_name(f"edit{expense.id}"))

    # Build the view
    info = self._build_edit_expense(expense)
    self._stack.add_titled(info, f"edit{expense.id}", expense.description)
    # Show the view
    self._stack.set_visible_child_name(f"edit{expense.id}")

  def show_loading(self) -> None:
    print("Show loading")

  def show_no_internet(self) -> None:
    print("Show no internet")

  def delete_expense(self, id):

    self._stack.remove(self._stack.get_child_by_name(f"info{id}"))

    old = self._stack.get_child_by_name(f"edit{id}")
    # Remove previous edit view for this expense if exists 
    if old:
      self._stack.remove(self._stack.get_child_by_name(f"edit{id}"))

    super().delete_expense(id)
  
  def show_empty_expense(self) -> None:
    if self.data_model_expenses.get_n_items() == 0:
      self.show_no_one_expense()
    else:
      self.show_pick_an_expense()