# 📋 **INFORME FACILITADORA-ADMINISTRADORA**
## SEMANA 4

> A continuación se ofrece el informe de la facilitadora-administradora de la 
>semana 4 de trabajo 17/11/2025 - 23/11/2025, cuyo papel desempeña: 
>Nerea Pérez Pértega

---

## 🗂️ Registro de tareas llevadas a cabo durante la semana 4

### **1. Implementación tests end2end**
**Descripción:**  
Implementar pruebas de tipo end to end para los distintos casos de uso de la 
aplicación, tanto errores de E/S como errores del usuario.

**Responsables:**
- Base general: Daniel y Alexandre
- Tests carga inicial, ver gasto, añadir amigo a gasto: Alexandre
- Tests añadir gasto, editar gasto, borrar amigo de gasto: Nerea
- Tests borrar gasto, añadir crédito, buscar (gastos y amigos): Daniel

**Estado:** *Completada* ✅ 

**Conflictos o incidencias:**   
N/A

---

## 📊 Análisis final
Esta semana nos dedicamos a realizar los tests para nuestra aplicación. Además 
Alexandre se encargó de corregir los errores de las anteriores entregas.

---

## 📂 Estado del repositorio en la semana 3
Estructura simplificada del proyecto:
```
📁 practica-de-mobiles-rage-against-the-machine  
├── 📁 splitwiththemachine  
    ├── 📁 integration_test
    |   ├── 📄 app_test.dart
    |   ├── 📄 pp_test.mocks.dart
    |   └── 📄 mock_setup.dart
    ├── 📁 lib
        ├── 📁 data
        │   ├── 📄 models.dart
        │   ├── 📄 repositories.dart
        │   └── 📄 services.dart
        ├── 📄 main.dart
        ├── 📁 ui
        │   ├── 📁 core
        │   │   ├── 📁 themes
        │   │   │   └── 📄 app_theme.dart
        │   │   ├── 📁 utils
        │   │   │   └── 📄 search_utils.dart
        │   │   └── 📁 widgets
        │   │       ├── 📄 centered_message.dart
        │   │       ├── 📄 generic_app_bar.dart
        │   │       ├── 📄 generic_fab.dart
        │   │       ├── 📄 generic_sized_box.dart
        │   │       ├── 📄 generic_snack_bar.dart
        │   │       └── 📄 scrollable_sliver_list.dart
        │   └── 📁 features
        │       ├── 📁 expenses
        │       │   ├── 📁 view
        │       │   │   ├── 📄 add_expense_view.dart
        │       │   │   ├── 📄 add_friend_to_expense_view.dart
        │       │   │   ├── 📄 edit_expense_view.dart
        │       │   │   ├── 📄 expense_detail_view.dart
        │       │   │   ├── 📄 expense_empty_view.dart
        │       │   │   ├── 📄 expense_home_view.dart
        │       │   │   └── 📄 expenses_list_view.dart
        │       │   ├── 📁 viewmodel
        │       │   │   └── 📄 expenses_viewmodel.dart
        │       │   └── 📁 widgets
        │       │       ├── 📄 expense_calendar.dart
        │       │       ├── 📄 generic_search.dart
        │       │       └── 📄 reusable_form_body.dart
        │       └── 📁 help_feedback
        │           └── 📁 view
        │               └── 📄 help_feedback_view.dart
        └── 📁 utils
            ├── 📄 command.dart
            └── 📄 result.dart
```

