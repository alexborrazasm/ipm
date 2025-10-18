
---

# 🔨 Casos de Uso

---
- Añadir/Eliminar gasto
- Ver lista de gastos
- Editar gastos
- Buscar gastos
- Añadir/Eliminar amigos a gasto
- Añadir/Eliminar aportación
- Ver about

---

# ✏️ Wireframes
![](images/main_screen.jpeg)
![](images/search_and_add_expense.jpeg)
![](images/edit_remove_exp_and_add_friend.jpeg)
![](images/add_credit_and_remove_friend_errors.jpeg)
![](images/about_and_scale.jpeg)
![](images/error_handling.jpeg)

---

# 🔄 Diagramas dinámicos
---
##  Diagrama User Journey
```mermaid
journey
  title Edit an expense
  section Start
    Open the application: 5: User
    Initialize model, view, and presenter (run, on_activate): 4: System
    Display main screen or empty message: 4: System
  section Exploration
    View list of expenses: 3: User
    Load expenses: 3: System
  section View and edit expense
    Select an existing expense: 4: User
    Display expense details: 4: System
    Edit expense data: 3: User
    Save changes: 4: System
    Update view with edited data: 4: System
  section Close
    Review updated expenses: 4: User
    Close the application satisfied: 5: User
```
## Diagrama de flujo  
```mermaid
flowchart LR

    A[Loading Screen] -->|Internet OK| B[View Expenses]
    A -->|No Internet| C[No Internet Screen]

    B -->|There are expenses| D[Expenses List]
    B -->|No expenses| E[Add Your First Expense]

    D -->|Search| F[Search Expense]
    D -->|Add| G[Add Expense]
    D -->|About| H[About Screen]
    D -->|Edit| I[Edit Expense]
    D -->|Delete| J[Delete Expense]

    I -->|Cancel| D
    I -->|Save| D

    J -->|Cancel| D
    J -->|Confirm Delete| D

    G -->|Save| D
    G -->|Cancel| D

    H --> |Close| D

    F --> |View| D

    E --> |Add Expense| D

    C --> |Retry| A
```

> Nota: "Loading Screen" y "No Internet Screen" están las vistas hechas pero no
están conectadas al flujo de la aplicación (pendiente para la tarea 2)