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
  def on_show_expense_info_clicked(self, data: ExampleObject) -> None: pass


class ExampleObject(GObject.GObject):
  def __init__(self, id, name, credit_balance):
    super().__init__()
    self._id = id
    self._name = name
    self._credit_balance = credit_balance

  @GObject.Property(type=str)
  def name(self):
    return self._name

  def set_name(self, name):
    self._name = name

  @GObject.Property(type=int)
  def id(self):
    return self._id

  @GObject.Property(type=float)
  def credit_balance(self):
    return self._credit_balance

  def __repr__(self):
    return f"ExampleObject(id={self._id}, name={self._name}, credit_balance={self._credit_balance})"

class View:
  def __init__(self):
    self.handler = None
    self.data_model = Gio.ListStore(item_type=ExampleObject)

  def set_handler(self, handler: ViewHandler) -> None:
    self.handler = handler
    
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

class AdwView(View):
  def __init__(self):
    super().__init__()
    self.window = None # type: Adw.ApplicationWindow
    self._listbox = None # type: Gtk.ListBox
    self._about = None # type: Adw.AboutDialog

    # Stack of views
    self._stack = None # type: Adw.Stack
    self._views = [] # List for lazy loading of views

    # TODO for testing purposes
    self.data_model.append(ExampleObject(1, "Expense1", 23.5))
    self.data_model.append(ExampleObject(2, "Expense2", 12.0))
    self.data_model.append(ExampleObject(3, "Expense3", 5.75))
    
  def on_activate(self, app: Adw.Application) -> None:
    self.build(app)
  
  def build(self, app: Adw.Application) -> None:
    self.window = win = Adw.ApplicationWindow()
    app.add_window(win)
    win.connect("destroy", lambda win: win.close())
    win.set_default_size(800, 600)
  
    # Left panel (expenses list) 
    sidebar_header = self.build_left_header_bar()
    sidebar_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL,
      spacing=16, 
      margin_top=16,
      margin_bottom=16,
      margin_start=16,
      margin_end=16
    )
    self._listbox = self.build_listbox()
    scrolledWindow = Gtk.ScrolledWindow()
    scrolledWindow.set_vexpand(True) # Take all available vertical space 
    scrolledWindow.set_child(self._listbox)
    sidebar_box.append(scrolledWindow)
    sidebar_toolbar = Adw.ToolbarView()
    sidebar_toolbar.add_top_bar(sidebar_header)
    sidebar_toolbar.set_content(sidebar_box)
    sidebar_page = Adw.NavigationPage(title="Expenses", child=sidebar_toolbar)
    ####
    # Right panel (content)
    content_header = self.build_right_header_bar()

    # Stack for different right-side views (hidden switcher)
    self._stack = Adw.ViewStack()

    # Layout container for the right panel
    content_box = Gtk.Box(
        orientation=Gtk.Orientation.VERTICAL,
        spacing=12,
        margin_top=12
    )
    # Just append the stack directly (no visible switcher)
    content_box.append(self._stack)

    # Toolbar wrapper
    content_toolbar = Adw.ToolbarView()
    content_toolbar.add_top_bar(content_header)
    content_toolbar.set_content(content_box)

    content_page = Adw.NavigationPage(child=content_toolbar)
    
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
    breakpoint.add_setter(sidebar_header, "show_end_title_buttons", True)
    win.add_breakpoint(breakpoint)
      
    # App toolbar (main container)
    root_toolbar = Adw.ToolbarView()
    root_toolbar.set_content(split_view)
    
    win.set_content(root_toolbar)
    win.present()
    
  def build_left_header_bar(self) -> Adw.HeaderBar:
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
  
  def build_right_header_bar(self) -> Adw.HeaderBar:
    header = Adw.HeaderBar()
    
    return header
  
  def build_listbox(self) -> Gtk.ListBox:

    def on_build_row(item: ExampleObject, user_data: Any) -> Gtk.Widget:
      image = Gtk.Image.new_from_icon_name("view-list-symbolic")
      label1 = Gtk.Label(label=item._name, halign=Gtk.Align.START)
      label2 = Gtk.Label(label=f"{item._credit_balance:.2f}", halign=Gtk.Align.START)
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