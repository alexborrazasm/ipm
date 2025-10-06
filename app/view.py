from __future__ import annotations
from typing import Callable, Protocol, Any

import gi

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import Gtk, Gio, GObject, Adw

def run(application_id: str, on_activate: Callable) -> None:
  app = Adw.Application(application_id=application_id)
  app.connect('activate', on_activate)
  app.run()


class ViewHandler(Protocol):
  def on_add_expense_clicked() -> None: pass
  def on_search_expense_clicked() -> None: pass
  def on_show_expense_info_clicked(self, data: Expense) -> None: pass

class Expense(GObject.GObject):
  def __init__(self, id, description, date, amount, num_friends , credit_balance):
    super().__init__()
    self._id = id
    self._description = description
    self._date = date
    self._amount = amount
    self._num_friends = num_friends
    self._credit_balance = credit_balance

  @GObject.Property(type=int)
  def id(self):
    return self._id

  @GObject.Property(type=str)
  def description(self):
    return self._description

  def set_description(self, description):
    self._description = description

  @GObject.Property(type=str)
  def date(self):
    return self._date
  
  def set_date(self, date):
    self._date = date

  @GObject.Property(type=float)
  def amount(self):
    return self._amount

  def set_amount(self, amount):
    self._amount = amount
    
  @GObject.Property(type=int)
  def num_friends(self):
    return self._num_friends

  @GObject.Property(type=float)
  def credit_balance(self):
    return self._credit_balance

  def __repr__(self):
    return (
      f"Expense(id={self._id}, description={self._description}, "
      f"date={self._date}, amount={self._amount}, "
      f"num_friends={self._num_friends}, credit_balance={self._credit_balance})"
    )

class View:
  def __init__(self):
    self.handler = None
    self.data_model = Gio.ListStore(item_type=Expense)

  def set_handler(self, handler: ViewHandler) -> None:
    self.handler = handler
    
  def update(self, data: list) -> None:
    self.data_model.remove_all()
    for item in data:
      example_object = Expense(
        item['id'], item['description'], item['date'], 
        item['amount'], item['num_friends'], item['credit_balance']
      )
      self.data_model.append(example_object)
    
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
  def show_add_expense(self) -> None: pass
  def show_search_expense(self) -> None: pass
  def show_expense_info(self, data: Expense) -> None: pass

class AdwView(View):
  def __init__(self):
    super().__init__()
    self.window = None # type: Adw.ApplicationWindow
    self._expenses_list = None # type: Gtk.ListBox
    self._about = None # type: Adw.AboutDialog
    self._sidebar_header = None # type: Adw.HeaderBar

    # Stack of views
    self._stack = None # type: Adw.Stack
    self._views = [] # List for lazy loading of views

  def on_activate(self, app: Adw.Application) -> None:
    self._build(app)
  
  def _build(self, app: Adw.Application) -> None:
    self.window = win = Adw.ApplicationWindow()
    app.add_window(win)
    win.connect("destroy", lambda win: win.close())
    win.set_default_size(800, 600)

    # Left panel (expenses list)
    sidebar_page = self._build_expenses_list()

    # Right panel (content)
    self._stack = Adw.ViewStack()
    content_page = self._build_empty_expense()
    
    # Split view
    split_view = Adw.NavigationSplitView()
    split_view.set_sidebar(sidebar_page)
    split_view.set_content(content_page)
    split_view.set_sidebar_width_fraction(0.4)
    
    split_view.set_show_content(True)
    
    # Breakpoint to collapse sidebar on small windows
    breakpoint = Adw.Breakpoint.new(Adw.BreakpointCondition.parse(
      "max-width: 600px"))
    breakpoint.add_setter(split_view, "collapsed", True)
    # Show window controls when sidebar is collapsed
    breakpoint.add_setter(self._sidebar_header, "show_end_title_buttons", True)
    win.add_breakpoint(breakpoint)
    
    # Show the window
    win.set_content(split_view)
    win.present()

  def _build_expenses_list(self) -> Gtk.Widget:

    def _build_header_bar() -> Adw.HeaderBar:
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

    self._sidebar_header = _build_header_bar() # For use in responsive design
    box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL,
      spacing=16, 
      margin_top=16,
      margin_bottom=16,
      margin_start=16,
      margin_end=16
    )
    self._expenses_list = self._build_listbox_expenses()
    scrolledWindow = Gtk.ScrolledWindow()
    scrolledWindow.set_vexpand(True) # Take all available vertical space 
    scrolledWindow.set_child(self._expenses_list)
    box.append(scrolledWindow)
    toolbar = Adw.ToolbarView()
    toolbar.add_top_bar(self._sidebar_header)
    toolbar.set_content(box)

    page = Adw.NavigationPage(title="Expenses", child=toolbar)
    
    return page

  def _build_empty_expense(self) -> Adw.NavigationPage:
      
    content_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
    content_box.set_valign(Gtk.Align.CENTER)
    content_box.set_halign(Gtk.Align.CENTER)
    content_box.set_vexpand(True)
    content_box.set_hexpand(True)
    
    # Big icon
    icon = Gtk.Image.new_from_icon_name("dialog-information-symbolic")
    icon.set_pixel_size(96)
    content_box.append(icon)
    
    # Text
    label = Gtk.Label(label="Pick an expense")
    label.set_margin_top(12)
    label.set_css_classes(["title-1"])
    content_box.append(label)
    
    # Add to stack of views
    self._stack.add_titled(content_box, "empty", "Empty")
    # Save for lazy loading
    self._views.append(content_box)
    
    toolbar_view = Adw.ToolbarView()
    toolbar_view.set_content(self._stack)  # Stack as content
    
    # Header bar in the top
    header = Adw.HeaderBar()
    toolbar_view.add_top_bar(header)
    
    # Navigation page
    page = Adw.NavigationPage(child=toolbar_view)
    page.set_title("Splitwithme")
    
    return page
  
  def _build_listbox_expenses(self) -> Gtk.ListBox:

    def on_build_row(item: Expense, user_data: Any) -> Gtk.Widget:
      image = Gtk.Image.new_from_icon_name("view-list-symbolic")
      label1 = Gtk.Label(label=item.description, halign=Gtk.Align.START)
      label2 = Gtk.Label(label=f"{item.credit_balance:.2f}", halign=Gtk.Align.START)
      label2.add_css_class("caption")

      vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, hexpand=True, spacing=2)
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
      idx = widget.get_selected_row().get_index()
      self.handler.on_show_expense_info_clicked(self.data_model[idx])
        
    listbox = Gtk.ListBox(hexpand=True)
    listbox.set_selection_mode(Gtk.SelectionMode.SINGLE)
    listbox.connect("selected-rows-changed", on_listbox_row_activated)
    listbox.add_css_class("boxed-list-separate")
    listbox.bind_model(self.data_model, on_build_row, None)

    return listbox
  
  def _build_expense_info(self, data: Expense) -> Adw.ToolbarView:
    # Info layout
    info_box = Gtk.Box(
        orientation=Gtk.Orientation.VERTICAL,
        spacing=12,
        margin_top=24,
        margin_bottom=24,
        margin_start=24,
        margin_end=24
    )

    # Example fields
    title_label = Gtk.Label(label=f"Expense: {data.description}")
    title_label.set_css_classes(["title-1"])
    title_label.set_halign(Gtk.Align.START)
    info_box.append(title_label)

    amount_label = Gtk.Label(label=f"Amount: {data.amount:.2f} €")
    amount_label.set_halign(Gtk.Align.START)
    info_box.append(amount_label)

    date_label = Gtk.Label(label=f"Date: {data.date}")
    date_label.set_halign(Gtk.Align.START)
    info_box.append(date_label)

    # Wrap it inside a scroll view in case it grows
    scrolled = Gtk.ScrolledWindow()
    scrolled.set_child(info_box)

    # Build a ToolbarView
    view = Adw.ToolbarView()
    view.set_content(scrolled)

    return view

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
    
  def show_empty_expense(self) -> None:
    self._stack.set_visible_child_name("empty")

  def show_add_expense(self) -> None:
    print("Add expense clicked")
    self._stack.set_visible_child_name("empty")
    # TODO

  def show_search_expense(self) -> None: 
    print("Search expense clicked")
    # TODO

  def show_expense_info(self, data: Expense) -> None:
    if not f"info{data.id}" in self._views:
      info = self._build_expense_info(data)
      self._views.append(f"info{data.id}")
      self._stack.add_titled(info, f"info{data.id}", data.description)
    self._stack.set_visible_child_name(f"info{data.id}")
