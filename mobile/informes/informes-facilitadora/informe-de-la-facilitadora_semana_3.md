# 📋 **INFORME FACILITADORA-ADMINISTRADORA**
## SEMANA 3

> A continuación se ofrece el informe de la facilitadora-administradora de la 
>semana 3 de trabajo 10/11/2025 - 16/11/2025, cuyo papel desempeña: 
>Nerea Pérez Pértega

---

## 🗂️ Registro de tareas llevadas a cabo durante la semana 3

###  **1. Implementación de la capa UI** (*tarea de la semana pasada*)
**Descripción:**  
Finalizar la implementación de la capa de interfaz de usuario (View) y la capa
de lógica de presentación (ViewModel).

**Responsables:**
- Generalización de componentes: Nerea y Daniel
- Añadir crédito a amigo: Daniel
- Añadir amigo a gasto: Nerea

**Estado:** *Completada* ✅ 

**Conflictos o incidencias:**   
N/A.

---

### **2. Manejo de mensajes (información y error) y gestión de la concurrencia**
**Descripción:**   
Implementar mensajes de información y error de la API, y gestionar
comportamiento concurrente de la aplicación.

**Responsables:**
- SnackBar: Nerea y Daniel
- Manejo de mensajes: Alexandre y Daniel
- Concurrencia: Alexandre

**Estado:** *Completada* ✅ 

**Conflictos o incidencias:**   
N/A.

---

### **3. Revisión y corrección**
**Descripción:**  
Revisar y corregir errores que se han ido produciendo a lo largo de la 
implementación. 

**Responsables:**
- Trabajo en grupo

**Estado:** *Completada* ✅ 

**Conflictos o incidencias:**  
N/A.

---

## 📊 Análisis final
Esta semana hemos avanzado menos que las dos semanas anteriores ya que también 
estaba previsto empezar con la implementación de los test pero no fue posible.
Aún así, conseguimos finalizar la tarea 2 de la práctica para la entrega. 

---

## 📂 Estado del repositorio en la semana 3
Estructura simplificada del proyecto:
```
📁 practica-de-mobiles-rage-against-the-machine  
├── 📁 splitwiththemachine  
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
        │   │       ├── 📄 generic_floating_button.dart
        │   │       ├── 📄 generic_sized_box.dart
        │   │       ├── 📄 generic_snack_bar.dart
        │   │       ├── 📄 info_bar.dart
        │   │       └── 📄 scrollable_sliver_list.dart
        │   └── 📁 features
        │       ├── 📁 expenses
        │       │   ├── 📁 view
        │       │   │   ├── 📄add_expense_view.dart
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
        │       │       └── 📄 generic_search.dart
        │       └── 📁 help_feedback
        │           └── 📁 view
        │               └── 📄 help_feedback_view.dart
        └── 📁 utils
            ├── 📄 command.dart
            └── 📄 result.dart
``` 