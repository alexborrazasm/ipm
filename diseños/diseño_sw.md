```mermaid
classDiagram

    class Presenter {
        - model: Model
        - view: View
        + Pesenter(model: Model, view: View)
        + run(application_id: str)
        + on_add_expense_clicked() None
        + on_search_expense_clicked() None
        + on_show_expense_info_clicked (data: ExampleObject) None
    }

    class Model {
        + Model()
        + do_search() list
    }

    class ViewHandler {
        <<interface>>
        + on_add_expense_clicked() None
        + on_search_expense_clicked() None
        + on_show_expense_info_clicked(data: ExampleObject) None
    }

    class ExampleObject {
        - _id
        - _name
        - _credit_balance
        + name: str
        + id: int
        + credit_balance: float
        + set_name(name)
        + __repr__()
    }

    class View {
        <<abstract>>
        - handler: ViewHandler
        - data_model: Gio.ListStore
        + View()
        + set_handler(handler: ViewHandler) None
        - build_menu() Gtk.Widget
    }

    class AdwView {
        + on_activate(app: Adw.Application) None
        + build(app: Adw.Application) None
        - build_left_header_bar() Adw.HeaderBar
        - build_right_header_bar() Adw.HeaderBar
        - build_listbox() Gtk.ListBox
        + show_about(action: Gio.SimpleAction, param: Any)
    }

    %% Relationships
    View "1" --> "0..*" ExampleObject : data_model
    View --> ViewHandler : uses
    AdwView --|> View
    ExampleObject --|> GObject.GObject
    Presenter ..|> ViewHandler
    Presenter --> Model : model
    Presenter --> View : view


