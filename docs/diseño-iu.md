
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
    D -->|Help and Feedback| H[Help and Feedback Screen]
    D -->|View expense| I[Expense Details info]
    D -->|Delete| J[Delete Expense]

    I -->|Go back| D
    I -->|Delete| J
    I -->|Edit| L[Edit Expense]
    I -->|Add friend to expense| M[Add Friend Expense]
    I -->|Add credit to friend| N[Add Credit Friend]
    I -->|Remove friend from expense| O[Remove Expense Friend]

    O --> |Confirm| I
    O --> |Back| I

    N -->|Confirm| I
    N -->|Back| I

    M --> |Save| I
    M --> |Cancel| I
    
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


## Tablet Flowchart
```mermaid
flowchart LR

    A[Loading Screen] -->|Internet OK| B[View Expenses]
    A -->|No Internet| C[No Internet Screen]

    B -->|There are expenses| D[Expenses List]
    B -->|No expenses| E[Add Your First Expense]

    D -->|Search| F[Search Expense]
    D -->|Add| G[Add Expense]
    D -->|Help| H[Help and Feedback Screen]
    D -->|View expense| I[Expense Details]
    D -->|Delete| J[Delete Expense]

    I -->|Go back| D
    I -->|View about| H
    I -->|Delete| J
    I -->|Edit| L[Edit Expense]
    I -->|Add friend to expense| M[Add Friend Expense]
    I -->|Add credit to friend| N[Add Credit Friend]
    I -->|Remove friend| O[Remove Expense Friend]

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