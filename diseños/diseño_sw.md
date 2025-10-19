
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
        + load_data()
        + on_confirm_add_new_expense_clicked(data: Any) 
        + on_show_expense_info_clicked(data: Expense, exp_id: int, request: bool)
        + on_confirm_edit_expense_clicked(payload: Any, data: Any)
        + on_delete_expense(exp_id: int)
        + on_add_friend_expense(expense_id: Any, friend_id: Any, data: Any)
        + on_delete_friend_expense(expense_id: int, friend_id: int, data: Any)
        + on_confirm_add_credit_friend_expense(expense_id: int, friend_id: int, amount: float, expense: Any)
    }

    class Model {
        + Model()
        + get_expense(expense_id: int) list
        + get_expenses() list 
        + put_expense(expense_id: int, description: str, date: str, amount:float)
        + delete_expense(expense_id: int)
        + add_expense(description: str, date: str, amount:float) dict
        + get_friends() list
        + get_friends_by_expenses(expense_id: int) list
        + delete_friend_expense(expense_id: int, friend_id: int)
        + add_friend_expense(expense_id: int, friend_id: int)
        + add_friend_expense_credit(expense_id: int, friend_id: int, amount: float) 
    }

    class ModelError {
        + ModelError(message: str)
    }

    class NetworkError {
        + NetworkError(message: str)
    }

    class ViewHandler {
        <<interface>>
        + load_data()
        + on_add_expense_clicked() 
        + on_confirm_add_new_expense_clicked(data) 
        + on_show_expense_info_clicked(data: Expense, exp_id: int, request: bool)
        + on_confirm_edit_expense_clicked(payload, data) 
        + on_cancel_edit_expense_clicked(data) 
        + on_delete_expense(exp_id: int) 
        + on_add_friend_expense(expense_id, friend_id, data)
        + on_delete_friend_expense(expense_id: int, friend_id: int, data) 
        + on_confirm_add_credit_friend_expense(expense_id: int, friend_id: int, amount: float, expense)
    }

    class Friend {
        - id: int
        - name: str
        - credit_balance: float
        - debit_balance: float
        + Friend(id: int, name: str, credit_balance: float, debit_balance: float)
    }

    class Expense {
        - id: int
        - description: str
        - date: str
        - amount: float
        - num_friends: int
        - credit_balance:float
        - friends: Gio.ListStore
        + Expense(exp_id: int, description: str, date: str, amount: float, num_friends: int, credit_balance: float)
        + set_friends(friends: list[dict])
    }

    class View {
        - handler: ViewHandler
        - data_model_friends: Gio.ListStore
        - data_model_expenses: Gio.ListStore
        
        - _stack: Adw.ViewStack

        + set_handler(handler: ViewHandler) 
        + update_friends(data: list) 
        + update_expenses(data: list) 
        + update_expense(data: list) 
        + add_expense(item) Expense
        - _build_menu() Gtk.Widget

        + on_activate(app: Adw.Application)

        - _show_about(action: Gio.SimpleAction, param: Any) 
        - _build(app: Adw.Application)
        - _build_side_bar() Gtk.Widget
        - _build_empty_expense_msg(msg: str, icon: str) Adw.ToolbarView
        + show_pick_an_expense() 
        + show_no_one_expense
        + show_add_expense() 
        + show_expense_info(data: Expense) 
        + show_add_friend_credit_expense_info(amount: float, data: Expense)
        + show_loading_page() 
        + show_no_internet() 
        + delete_expenses(id: Any)
        + show_empty_expense()
        + show_start()
    }

    %% Exceptions relationships
    Model ..> ModelError : raises
    Model ..> NetworkError : raises

    Presenter ..> ModelError : handles (catch)
    Presenter ..> NetworkError : handles (catch)

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
    participant model as Model
    participant view as View
    participant presenter as Presenter
    participant adw as Adw.App
    participant thread as Thread

    note over app,presenter: Component initialization
    app->>model: create()
    app->>view: create()
    app->>presenter: create(model, view)

    rect rgba(92, 130, 159, 0.2)
    note over app,presenter: Application start
    app->>presenter: run(application_id)
    presenter->>view: set_handler(presenter)
    presenter->>view: run(application_id, on_activate=view.on_activate)
    end

    note over view,adw: Interface configuration
    view->>adw: Adw.Application(application_id)
    view->>adw: connect('activate', on_activate)
    view->>adw: run()
    adw-->>adw: 'activate'
    adw->>view: on_activate(app)
    view->>view: _build(app)

    rect rgba(92, 130, 159, 1)
    note over view,thread: Asynchronous data loading
    view->>presenter: load_data()
    presenter->>view: show_loading_page()
    presenter->>thread: start do_request()
    end

    note over thread,model: Get data
    thread->>model: get_expenses()
    model-->>thread: expenses
    thread->>model: get_friends()
    model-->>thread: friends

    rect rgba(92, 130, 159, 0.2)
    note over thread,view: Interface actualization
    thread->>view: update_expenses(expenses)
    thread->>view: update_friends(friends)
    thread->>view: show_start()
    view->>view: win.present()
    end

```
## Diagrama de secuencia "Click Add Expense"
```mermaid
sequenceDiagram
    actor User
    participant View
    participant Presenter
    participant Thread
    participant Model

    User->>View: Click "Add Expense" button
    View->>Presenter: on_add_expense_clicked()
    Presenter->>View: show_add_expense()
    View-->>User: Show add expense form

    User->>View: Fill form and click "Add" button
    View->>Presenter: on_confirm_add_new_expense_clicked(data)
    Presenter ->> Thread: start do_request (add_expense)
    Thread ->> Model: add_expense(description, date, amount)
    Model -->> Thread: New expense data
    Thread ->> View: add_expense(expense_data)
    Thread ->> View: show_expense_info(new_expense)
    View-->>User: Display new expense details
```

## Diagrama de secuencia "Error al añadir gasto duplicado"
```mermaid
sequenceDiagram
    actor User
    participant View
    participant Presenter
    participant Thread
    participant Model

    User->>View: Fill form and click "Add"
    View->>Presenter: on_confirm_add_new_expense_clicked(data)
    
    rect rgba(92, 130, 159, 0.2)
        Presenter ->> Thread: do_request (add_expense)
        Thread ->> Model: add_expense(description, date, amount)
        note right of Model: The server responds with 409 Conflict
        Model -->> Thread: raises ModelError("Expense already exists")
        
        Thread ->> View: show_error_toast("Expense already exists")
    end
    
    View-->>User: Shows error message
```
