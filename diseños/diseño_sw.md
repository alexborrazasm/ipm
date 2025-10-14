
---
# 🧩 Diagrama estático
---
## Diagrama de clases

```mermaid
classDiagram

    class Presenter {
        - model: Model
        - view: View
        + Pesenter(model: Model, view: View)
        + run(application_id: str)
        + get_friends_by_expense(expense_id: int) list[dict] 
        + on_add_expense_clicked() 
        + on_confirm_add_new_expense_clicked(data: Any) 
        + on_cancel_add_expense_clicked() 
        + on_show_expense_info_clicked(data: Expense)
        + on_edit_expense_clicked(data: Any)
        + on_confirm_edit_expense_clicked(payload: Any, data: Any)
        + on_cancel_edit_expense_clicked(data: Any)
        + on_delete_expense(id: int)
        + on_delete_friend_expense(expense_id: int, friend_id: int, data: Expense)
        + on_delete_friend_expense(expense_id: int, friend_id: int, data)
        + on_confirm_add_credit_friend_expense(expense_id: int, friend_id: int, amount: float, expense: Any)
    }

    class Model {
        + Model()
        + get_expense(expense_id: int) list
        + get_expenses() list 
        + put_expense(expense_id: int, description: str, date: str, amount:float) bool
        + delete_expense(expense_id: int) bool
        + add_expense(description: str, date: str, amount:float) dict
        + get_friends() list
        + get_friend_by_id(friend_id: int) dict
        + get_friends_by_expense(expense_id: int) list
        + add_friend(name: str, credit_balance: float, debit_balance: float) dict
        + delete_friend(friend_id: int) bool
        + delete_friend_expense(expense_id: int, friend_id: int) bool
        + add_friend_expense(expense_id: int, friend_id: int) bool
        + add_friend_expense_credit(expense_id: int, friend_id: int, amount: float) bool
    }

    class ViewHandler {
        <<interface>>
        + get_friends_by_expense(expense_id: int) list[dict]
        + on_add_expense_clicked() 
        + on_confirm_add_new_expense_clicked(data: Expense) 
        + on_cancel_add_expense_clicked()
        + on_show_expense_info_clicked(data: Expense)
        + on_edit_expense_clicked(data: Expense) 
        + on_confirm_edit_expense_clicked(payload, data: Expense) 
        + on_cancel_edit_expense_clicked(data: Expense) 
        + on_delete_expense(id: int) 
        + on_add_friend_expense(expense_id, friend_id, data: Any)
        + on_delete_friend_expense(expense_id: int, friend_id: int, data: Expense) 
        + on_confirm_add_credit_friend_expense(expense_id: int, friend_id: int, amount: float, expense: Any)
    }

    class Friend {
        - id: int
        - name: str
        - credit_balance: float
        - debit_balance: float
    }

    class Expense {
        - id: int
        - description: str
        - date: str
        - amount: float
        - num_friends: int
        - credit_balance:float
        - friends: Gio.ListStore
        + set_friends(friends: list[dict])
    }

    class View {
        - handler: ViewHandler
        - data_model_friends: Gio.ListStore
        - data_model_expenses: Gio.ListStore
        - entry_description
        - entry_date
        - entry_amount
        - entry_friends
        - entry_credit_balance

        - window: Adw.ApplicationWindow
        - _expenses_list: Gtk.ListBox
        - _about: Adw.AboutDialog
        - _sidebar_header: Adw.HeaderBar
        - _split_view: Adw.NavigationSplitView
        - _content_page: Adw.NavigationPage
        - _sidebar_page: Gtk.Widget
        - _search_box: Gtk.box
        - _search_entry: Gtk.SearchEntry
        - _search_button: Gtk.ToggleButton
        - _form_entry_description
        - _form_entry_amount
        - _form_entry_date
        - _stack: Adw.ViewStack

        + set_handler(handler: ViewHandler) 
        + update_friends(data: list) 
        + update_expenses(data: list) 
        + update_expense(data: list) 
        + add_expense(item: Any) Expense
        + delete_expense(id: int) 
        - _build_menu() Gtk.Widget

        + on_activate(app: Adw.Application)
        + clear_expenses_list_selection() 
        + select_last_expenses_list_selection() 
        + set_sidebar_sensitive(boolean: bool)

        - _filter_expenses(search_text: Any)
        - _clear_filter_expense()
        - _toggle_search()
        - _show_about(action: Gio.SimpleAction, param: Any) 
        - _build(app: Adw.Application)
        - _build_side_bar() Gtk.Widget
        - _build_empty_expense_msg() Adw.ToolbarView
        - _build_loading_page() Adw.ToolbarView
        - _build_no_internet_page() Adw.ToolbarView
        - _build_clamp_content(child: Gtk.Widget) Adw.Clamp
        - _build_calendar(date: str) Adw.ActionRow
        - _build_edit_expense(expense: Expense) Adw.ToolbarView
        - _build_add_expense() Adw.ToolbarView
        - _build_expense_info(data: Expense) Adw.ToolbarView
        + show_pick_an_expense() 
        + show_no_one_expense
        + show_add_expense() 
        + show_expense_info(data: Expense) 
        + show_edited_expense_info(expense: Expense) 
        + show_edit_expense_info(expense: Expense) 
        + show_add_friend_credit_expense_info(amount: float, expense: Expense)
        + show_loading() 
        + show_no_internet() 
        + delete_expenses(id: Any)
        + show_empty_expense()
    }

    %% Relationships
    View "1" --> "0..*" Friend : data_model_friends
    View "1" --> "0..*" Expense : data_model_expenses
    Expense "1" --> "0..*" Friend : friends
    View --> ViewHandler : uses
    Friend --|> GObject.GObject
    Expense --|> GObject.GObject
    Presenter ..|> ViewHandler
    Presenter --> Model : model
    Presenter --> View : view
    
```
---
# 🔄 Diagramas dinámicos 
---
## Diagrama de secuencia Init

```mermaid
sequenceDiagram
    participant app as Main

    create participant model as Model
    app ->> model: create

    create participant view as View
    app ->> view: create
    create Participant Presenter
    app ->> Presenter: create(model, view)
    app ->> Presenter: run(application_id)
    Presenter ->> model: get_expenses()
    model -->> Presenter: expenses
    Presenter ->> model: get_friends()
    model -->> Presenter: friends
    Presenter ->> view : set_handler(self)  
    Presenter ->> view : update_expenses(expenses)
    Presenter ->> view : update_friends(friends) 

    Presenter ->> view : run(application_id, on_activate=view.on_activate)

    rect rgba(92, 130, 159, 1)
        create participant adw as Adw.App
        note right of view: view.run(application_id, AdwView.on_activate)
        view ->> adw : Adw.App(application_id)
        view ->> adw : connect('activate', on_activate)
        view ->> adw : run()
    end
    adw -->> view: 'activate'
    view ->> view : on_activate(app)
    view ->> view : _build(app)
    Note right of view: builds window, sidebar, stack...
    view->>view: show_empty_expense()
    Note right of view: depending on whether or not there are registered expenses
    view-->>adw: win.present()
   
```
## Diagrama de secuencia "Click Add Expense"
```mermaid
sequenceDiagram
    actor User
    participant View
    participant Presenter
    participant Model


    User->>View: Click "Add Expense" button
    View->>Presenter: on_add_expense_clicked()
    Presenter->>View: show_add_expense()
    View-->>User: Show add expense form

    User->>View: Fill form and click "Add" button
    View->>Presenter: on_confirm_add_new_expense_clicked(data)
    Presenter->>Model: add_expense(description, date, amount)
    Model-->>Presenter: New expense data
    Presenter->>View: add_expense(expense_data)
    Presenter->>View: show_expense_info(new_expense)
    View-->>User: Display new expense details
```

