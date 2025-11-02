## Flowchart

```mermaid
flowchart LR

%% LAYERS
%% TODO
A[User Interface Widgets: MyApp, FriendsScreen,<br>FriendRow, FriendDialog, InfoBar] 
B[ExpenseViewModel<br>FriendViewModel]
C[ Repositories<br>ExpenseRepository<br>FriendRepository]
D[ Services<br>SplitWithMeService,<br>SplitWithMeAPIService,]
E[ DTOs<br>Expense<br>Friend]

%% FLOW
B -- fetches / modifies data --> MODEL
MODEL -- returns data / errors --> B
A -- observes & sends user actions --> B
B -- updates View via notifyListeners() --> A

%% DECORATION
subgraph VIEW
A
end

subgraph VIEWMODEL
B
end

subgraph MODEL
C
D
E
end
```

## Class Diagram: View: ExpensesScreen
```mermaid

classDiagram

%%=========================
%% UI Layer
%%=========================
class MyApp:::group1 {
  +build(context: BuildContext) Widget
}

class ExpensesScreen:::group2 {
  +title: String
  +viewModel: ExpensesViewModel
  +createState() State<ExpensesScreen>
}

class _ExpensesScreenState:::group2 {
  +build(context: BuildContext) Widget
}

class ExpenseRow:::group2 {
  +expense: Expense
  +onRemove: Command1
  +build(context: BuildContext) Widget
}

class InfoBar:::group2 {
  +message: String
  +onPressed: Function
  +isError: bool
  +build(context: BuildContext) Widget
}

class ExpenseDetailsScreen:::group4 {
  +title: String
  +viewModel: ExpenseViewModel
  +createState() State<ExpenseDetailsScreen>
}

class ExpenseAddScreen:::group6 {
  +title: String
  +viewModel: ExpenseViewModel
  +createState() State<ExpenseAddScreen>
}

class AppHelpScreen:::group7 {
  +title: String
  +createState() State<AppHelpScreen>
}

class RemoveDialog:::group3 {
  +viewModel: ExpenseViewModel
  +createState() State<RemoveDialog>
}

class _RemoveDialogState:::group3 {
  +build(context: BuildContext) Widget
}

%%=========================
%% ViewModel Layer
%%=========================
class ExpenseViewModel { }

class Expense:::group5 {
  +id: int?
  +description: String
  +date: String
  +amount: double
  +numFriends: int
  +creditBalance: double
  +friends: List<Friend>
  +Expense.fromJson(Map)
  +toString() String
}

classDef group1 fill:#e4fff6,stroke:#000,color:#000;
classDef group2 fill:#e3ffd7,stroke:#000,color:#000;
classDef group3 fill:#ddc2ff,stroke:#000,color:#000;
classDef group4 fill:#cdd3ff,stroke:#000,color:#000;
classDef group5 fill:#ffdcf1,stroke:#000,color:#000;
classDef group6 fill:#158c88,stroke:#000,color:#000;
classDef group7 fill:#015c7d,stroke:#000,color:#000;

%%=========================
%% Relationships
%%=========================
MyApp --> ExpensesScreen : creates
_ExpensesScreenState ..> ExpenseViewModel : observes
ExpensesScreen --> ExpenseViewModel : uses
_ExpensesScreenState --> ExpensesScreen : state of
_ExpensesScreenState --> InfoBar : displays messages on
_ExpensesScreenState --> ExpenseRow : creates
ExpenseViewModel --> Expense : manages
ExpenseRow --> Expense : displays
_ExpensesScreenState ..> ExpenseDetailsScreen : navigates to
_ExpensesScreenState ..> ExpenseAddScreen : navigates to
_ExpensesScreenState ..> AppHelpScreen : navigates to
ExpenseAddScreen --> ExpenseViewModel : uses
ExpenseDetailsScreen --> ExpenseViewModel : uses
RemoveDialog --> ExpenseViewModel : interacts with
_RemoveDialogState --> RemoveDialog: state of
_ExpensesScreenState ..> RemoveDialog : opens
```

> [!NOTE] Note
Shows only the details of the `ExpensesScreen` to keep things simple.

## Class Diagram: View: ExpenseDetailsScreen
```mermaid

classDiagram

%%=========================
%% UI Layer
%%=========================
class MyApp:::group1 {
  +build(context: BuildContext) Widget
}

class ExpenseDetailsScreen:::group2 {
  +title: String
  +viewModel: ExpensesViewModel
  +createState() State<ExpenseDetailScreen>
}

class _ExpenseDetailsScreenState:::group2 {
  +build(context: BuildContext) Widget
}

class ExpenseDetails:::group2 {
  +expense: Expense
  +build(context: BuildContext) Widget
}

class InfoBar:::group2 {
  +message: String
  +onPressed: Function
  +isError: bool
  +build(context: BuildContext) Widget
}

class ExpensesScreen:::group4 {
  +title: String
  +viewModel: ExpenseViewModel
  +createState() State<ExpensesScreen>
}

class ExpenseEditScreen:::group6 {
  +title: String
  +viewModel: ExpenseViewModel
  +createState() State<ExpenseEditScreen>
}

class AddFriendToExpenseScreen:::group7 {
  +title: String
  +viewModel: ExpenseViewModel
  +createState() State<AddFriendToExpenseScreen>
}

class RemoveDialog:::group3 {
  +viewModel: ExpenseViewModel
  +createState() State<RemoveDialog>
}

class _RemoveDialogState:::group3 {
  +build(context: BuildContext) Widget
}

class AddCreditDialog:::group3 {
  +viewModel: FriendViewModel
  +createState() State<AddCreditDialog>
}

class _AddCreditDialogState:::group3 {
  -_formKey: GlobalKey<FormState>
  -nameController: TextEditingController
  +build(context: BuildContext) Widget
}

%%=========================
%% ViewModel Layer
%%=========================
class ExpenseViewModel { }

class Expense:::group5 {
  +id: int?
  +description: String
  +date: String
  +amount: double
  +numFriends: int
  +creditBalance: double
  +friends: List<Friend>
  +Expense.fromJson(Map)
  +toString() String
}

classDef group1 fill:#e4fff6,stroke:#000,color:#000;
classDef group2 fill:#e3ffd7,stroke:#000,color:#000;
classDef group3 fill:#ddc2ff,stroke:#000,color:#000;
classDef group4 fill:#cdd3ff,stroke:#000,color:#000;
classDef group5 fill:#ffdcf1,stroke:#000,color:#000;
classDef group6 fill:#158c88,stroke:#000,color:#000;
classDef group7 fill:#015c7d,stroke:#000,color:#000;

%%=========================
%% Relationships
%%=========================
MyApp --> ExpenseDetailsScreen : creates
_ExpenseDetailsScreenState ..> ExpenseViewModel : observes
ExpenseDetailsScreen --> ExpenseViewModel : uses
_ExpenseDetailsScreenState --> ExpenseDetailsScreen : state of
_ExpenseDetailsScreenState --> InfoBar : displays messages on
_ExpenseDetailsScreenState --> ExpenseDetails : creates
ExpenseViewModel --> Expense : manages
ExpenseDetails --> Expense : displays
_ExpenseDetailsScreenState ..> ExpensesScreen : navigates to
_ExpenseDetailsScreenState ..> ExpenseEditScreen : navigates to
_ExpenseDetailsScreenState ..> AddFriendToExpenseScreen : navigates to
ExpensesScreen --> ExpenseViewModel : uses
ExpenseEditScreen --> ExpenseViewModel : uses
AddFriendToExpenseScreen --> ExpenseViewModel : uses
RemoveDialog --> ExpenseViewModel : interacts with
_RemoveDialogState --> RemoveDialog: state of
_ExpenseDetailsScreenState ..> RemoveDialog : opens
AddCreditDialog --> ExpenseViewModel : interacts with
_AddCreditDialogState --> AddCreditDialog: state of
_ExpenseDetailsScreenState ..> AddCreditDialog : opens
```

> [!NOTE] Note
Shows only the details of the `ExpenseDetailsScreen` to keep things simple.

## Class diagram: ViewModels, Repositories and Services

```mermaid
classDiagram

%%=========================
%% ViewModel Layer
%%=========================
class ExpenseViewModel:::group3 {
  -_expenseRepository: ExpenseRepository
  -_friendRepository: FriendRepository

  +expenses: List<Friend>
  +friends: List<Friend>
  +errorMessage: String?

  +loadExpenses: Command0
  +loadFriends: Command0
  +addExpense: Command1<void, Expense>
  +removeExpense: Command1<void, int>
  +editExpense: Command1<void, Expense>
  +addFriendToExpense: Command1<void, FriendExpenseArgs>
  +deleteFriendFromExpense: Command1<void, FriendExpenseArgs>
  +addCreditToFriend: Command1<void, CreditArgs>

  +_loadFriends() Future<Result<void>>
  +_loadExpenses() Future<Result<void>>
  +_addExpense(expense: Expense) Future<Result<void>>
  +_removeExpense(id: int) Future<Result<void>>
  +_editExpense(expense: Expense) Future<Result<void>>
  +_addFriendToExpense(args: FriendExpenseArgs) Future<Result<void>>
  +_deleteFriendFromExpense(args: FriendExpenseArgs) Future<Result<void>>
  +_addCreditToFriend(args: CreditArgs) Future<Result<void>>
}

%%=========================
%% Data Layer Service
%%=========================
class SplitWithMeService:::group2 {
  <<abstract>>
  +fetchExpenses() Future
  +fetchFriends() Future
  +addExpense(expense: Expense) Future
  +editExpense(expense: Expense) Future
  +deleteExpense(id: int) Future
  +addFriendToExpense(expenseId: int, friendId: int) Future
  +deleteFriendFromExpense(expenseId: int, friendId: int) Future
  +addCreditToFriend(expenseId: int, friendId: int, amount: double) Future
}

class SplitWithMeAPIService:::group2 {
  +serverURL: String
  +serverPort: String
}

%%=========================
%% Data Layer Repository
%%=========================
class FriendExpenseArgs {
  +int expenseId
  +List<int> friendIds
}

class CreditArgs {
  +int expenseId
  +int friendId
  +double amount
}

class FriendRepository:::group1 {
  -_service: SplitWithMeService
  +fetchFriends() Future
}

class ExpenseRepository:::group1 {
  -_service: SplitWithMeService
  +fetchExpenses() Future
  +addExpense(expense: Expense) Future
  +editExpense(expense: Expense) Future
  +removeExpense(id: int) Future
  +addFriendToExpense(args: FriendExpenseArgs) Future
  +deleteFriendFromExpense(args: FriendExpenseArgs) Future
  +addCreditToFriend(args: CreditArgs) Future
}

%%=========================
%% Data Layer Model
%%=========================

class Friend:::group5 {
  +id: int?
  +name: String
  +creditBalance: double?
  +debitBalance: double?
  +Friend.fromJson(Map)
  +toString() String
}

class Expense:::group5 {
  +id: int?
  +description: String
  +date: String
  +amount: double
  +numFriends: int
  +creditBalance: double
  +friends: List<Friend>
  +Expense.fromJson(Map)
  +toString() String
}

class ServerException:::group5 {
  +errorMessage: String
}

%%=========================
%% External/Utility Classes
%%=========================
class Command0 {
  <<generic>>
  +execute()
  +running: bool
  +error: bool
  +clearResult()
}

class Command1 {
  <<generic>>
  +execute(arg)
  +running: bool
  +error: bool
  +clearResult()
}

class Result {
  <<sealed>>
  +ok(value)
  +error(error)
}

classDef group1 fill:#e4fff6,stroke:#000,color:#000;
classDef group2 fill:#e3ffd7,stroke:#000,color:#000;
classDef group3 fill:#ddc2ff,stroke:#000,color:#000;
classDef group4 fill:#cdd3ff,stroke:#000,color:#000;
classDef group5 fill:#ffdcf1,stroke:#000,color:#000;

SplitWithMeAPIService --|> SplitWithMeService
SplitWithMeService ..> Friend :uses 
SplitWithMeService ..> Expense :uses 
Expense "1" --> "*" Friend : includes
SplitWithMeService ..> ServerException : throws
FriendRepository --> SplitWithMeService
ExpenseRepository --> SplitWithMeService
ExpenseViewModel --> FriendRepository
note for FriendRepository "Uses shared SplitWithMeAPIService instance\ninjected in main()"
note for ExpenseRepository "Uses shared SplitWithMeAPIService instance\ninjected in main()"
FriendRepository ..> Result : uses
ExpenseRepository ..> Result : uses
ExpenseRepository ..> FriendExpenseArgs : uses
ExpenseRepository ..> CreditArgs : uses
ExpenseViewModel ..> Result : uses
ExpenseViewModel ..> Command0 : uses
ExpenseViewModel ..> Command1 : uses
ExpenseViewModel ..> FriendExpenseArgs : uses
ExpenseViewModel ..> CreditArgs : uses
```

## Mobile Flowchart
```mermaid
flowchart LR

    A[Loading Screen] -->|Internet OK| B[View Expenses]
    A -->|No Internet| C[No Internet Screen]

    B -->|There are expenses| D[Expenses List]
    B -->|No expenses| E[Add Your First Expense]

    D -->|Search| F[Search Expense]
    D -->|Add| G[Add Expense]
    D -->|About| H[About Screen]
    D -->|View expense| I[Expense Details info]
    D -->|Delete| J[Delete Expense]

    I -->|Go back| D
    I -->|Delete| J
    I -->|Edit| L[Edit Expense]
    I -->|View expense friends| K[Expense Details friends]

    K -->|View expense info| I
    K --> |View About| H

    K -->|Add friend to expense| M[Add Friend Expense]
    K -->|Add credit to expense| N[Add Credit Expense]
    K -->|Remove friend from expense| O[Remove Expense Friend]

    O --> |Confirm| K
    O --> |Back| K

    N -->|Confirm| K
    N -->|Back| K

    M --> |Save| K
    M --> |Cancel| K
    
    L -->|Save| I
    L -->|Cancel| I
 
    J -->|Cancel| D
    J -->|Confirm Delete| D

    G -->|Save| D
    G -->|Cancel| D

    H -->|Close| D
    H --> |Go back| K

    F -->|View| D

    E -->|Add Expense| D

    C -->|Retry| A

```


## Tablet Flowchart
```mermaid
flowchart LR

    A[Loading Screen] -->|Internet OK| B[View Expenses]
    A -->|No Internet| C[No Internet Screen]

    B -->|There are expenses| D[Expenses List]
    B -->|No expenses| E[Add Your First Expense]

    D -->|Search| F[Search Expense]
    D -->|Add| G[Add Expense]
    D -->|About| H[About Screen]
    D -->|View expense| I[Expense Details]
    D -->|Delete| J[Delete Expense]

    I -->|Go back| D
    I -->|View about| H
    I -->|Delete| J
    I -->|Edit| L[Edit Expense]
    I -->|Add friend to expense| M[Add Friend Expense]
    I -->|Add credit to expense| N[Add Credit Expense]
    I -->|Remove friend expense| O[Remove Expense Friend]

    O -->|Confirm| I
    O -->|Back| I

    H -->|Go back| I
    
    N -->|Confirm| I
    N -->|Back| I

    M -->|Save| I
    M -->|Cancel| I

    L -->|Save| I
    L -->|Cancel| I

    J -->|Cancel| D
    J -->|Confirm Delete| D

    G -->|Save| D
    G -->|Cancel| D

    H -->|Close| D

    F -->|View| D

    E -->|Add Expense| D

    C -->|Retry| A


```

## Sequence diagram: Load initial data
```mermaid
sequenceDiagram
    autonumber
    participant User
    participant ExpensesScreen
    participant ExpenseViewModel
    participant Command0
    participant ExpenseRepository
    participant FriendRepository
    participant SplitWithMeAPIService
    participant ExpenseList as List<Expense>
    participant FriendList as List<Friend>

    Note over ExpensesScreen: App starts or user opens ExpensesScreen

    User ->> ExpensesScreen: View appears

    %% ---- LOAD EXPENSES ----
    ExpensesScreen ->> ExpenseViewModel: loadExpenses.execute()
    ExpenseViewModel ->> Command0: set running = true
    Note over Command0: Command0 notifies listeners (running = true)
    Command0 ->> ExpensesScreen: notifies listeners (running = true)
    ExpensesScreen ->> ExpensesScreen: show CircularProgressIndicator()

    Note over ExpenseViewModel: _loadExpenses() is invoked
    ExpenseViewModel ->> ExpenseRepository: fetchExpenses()
    ExpenseRepository ->> SplitWithMeAPIService: GET /expenses
    SplitWithMeAPIService -->> ExpenseRepository: List<Expense> or Error

    alt success (Ok)
        ExpenseRepository -->> ExpenseViewModel: Result.ok(List<Expense>)
        ExpenseViewModel ->> ExpenseList: update expenses list
    else failure (Error)
        ExpenseRepository -->> ExpenseViewModel: Result.error(Exception)
        ExpenseViewModel ->> ExpenseViewModel: set errorMessage = "Cannot retrieve the list of expenses"
    end

    ExpenseViewModel ->> Command0: set running = false
    Command0 ->> ExpensesScreen: notifies listeners (running = false)
    ExpensesScreen ->> ExpensesScreen: hide CircularProgressIndicator()

    %% ---- LOAD FRIENDS (initial) ----
    Note over ExpenseViewModel,FriendRepository: Friends are loaded once at startup and kept in memory
    ExpenseViewModel ->> FriendRepository: fetchFriends()
    FriendRepository ->> SplitWithMeAPIService: GET /friends
    SplitWithMeAPIService -->> FriendRepository: List<Friend> or Error

    alt success (Ok)
        FriendRepository -->> ExpenseViewModel: Result.ok(List<Friend>)
        ExpenseViewModel ->> FriendList: store friends in memory
    else failure (Error)
        FriendRepository -->> ExpenseViewModel: Result.error(Exception)
        ExpenseViewModel ->> ExpenseViewModel: set errorMessage = "Cannot retrieve the list of friends"
    end

    %% ---- FINAL STATE ----
    alt success
        ExpensesScreen ->> ExpensesScreen: rebuild UI with friends + expenses
    else error
        ExpensesScreen ->> ExpensesScreen: display InfoBar with errorMessage
    end

    Note over ExpensesScreen: UI shows final state (lists or error)


```
