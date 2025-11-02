
---

# 🔨 Use Cases

---
- Add/Remove Expense
- View Expenses List
- Edit Expense
- Search Expenses
- Add/Remove Friends to/from Expense
- Add/Remove Credit
- View Help

---

# ✏️ Wireframes
## Mobile Wireframes
![](wireframes/m1.jpeg)
![](wireframes/m2.jpeg)
![](wireframes/m3.jpeg)
![](wireframes/m4.jpeg)
![](wireframes/m5.jpeg)
![](wireframes/m6.jpeg)
![](wireframes/m7.jpeg)

## Tablet Wireframes
![](wireframes/t1.jpeg)
![](wireframes/t2.jpeg)
![](wireframes/t3.jpeg)
![](wireframes/t4.jpeg)
![](wireframes/t5.jpeg)

---

# 🔄 Flowcharts

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