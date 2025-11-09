# 📋 **INFORME FACILITADORA-ADMINISTRADORA**
## SEMANA 2

> A continuación se ofrece el informe de la facilitadorea-administradora de la semana 2 de trabajo 03/11/2025 - 09/11/2025,
> cuyo papel desempeña: Nerea Pérez Pértega

---

## 🗂️ Registro de tareas llevadas a cabo durante la semana 2

###  **1. Implementación y corrección de la capa Data** (*tarea de la semana pasada*)

**Descripción:**   
Finalizar la implementación y correción de los Models, Repositories y Services.   

**Responsables:**
- Implementación y corrección de la capa Data: Nerea, Daniel y Alexandre

**Estado:** *Completada* ✅

**Conflictos o incidencias:**   
Habíamos planteado incorrectamente el patrón commander y hubo que modificarlo.

---

###  **2. Implementación de la capa UI**
**Descripción:**  
Implementar la capa de interfaz de usuario (View) y la capa de lógica de 
presentación (ViewModel).

**Responsables:**
### **2.1 Core**
- Base general y estilo: Alexandre
- Generalización de widgets: Nerea

### **2.2 Features**
- Base general, Lista de gastos, Eliminar gastos: Alexandre
- Barra de búsqueda, Navigation bar, Menú help: Nerea
- Añadir gasto, Editar gasto y calendario: Daniel
- Vista tablet: Alexandre y Nerea
- Mejora del aspecto: Daniel y Alexandre

**Estado:** 🟡 *En proceso* 

**Conflictos o incidencias:**   
N/A.

---

## 📊 Análisis final
Esta semana el equipo se centró en la interfaz de usuario. Seguimos con un buen
ritmo.  
La semana siguiente está previsto acabar la implementación de la aplicación y 
comenzar con los test.

---

## 📂 Estado del repositorio en la semana 2
Estructura simplificada del proyecto:
```
📁 practica-de-mobiles-rage-against-the-machine  
├── 📁 splitwiththemachine  
    ├── 📁 lib  
        ├── 📁 data  
        │   ├── 📄 models.dart  
        │   ├── 📄 repositories.dart  
        │   └── 📄 services.dart  
        ├── 📄 main.dart  
        ├── 📁 ui  
        │   ├── 📁 core  
        │   │   ├── 📁 themes  
        │   │   │   └── 📄 app_theme.dart  
        │   │   └── 📁 widgets  
        │   │       ├── 📄 centered_message.dart  
        │   │       ├── 📄 generic_app_bar.dart  
        │   │       ├── 📄 generic_floating_button.dart  
        │   │       ├── 📄 info_bar.dart  
        │   │       └── 📄 scrollable_sliver_list.dart  
        │   └── 📁 features  
        │       ├── 📁 expenses  
        │       │   ├── 📁 view  
        │       │   │   ├── 📄 add_expense_view.dart  
        │       │   │   ├── 📄 expense_detail_view.dart  
        │       │   │   ├── 📄 expense_empty_view.dart  
        │       │   │   ├── 📄 expense_home_view.dart  
        │       │   │   └── 📄 expenses_list_view.dart  
        │       │   ├── 📁 viewmodel  
        │       │   │   └── 📄 expenses_viewmodel.dart  
        │       │   └── 📁 widgets  
        │       │       └── 📄 expense_calendar.dart  
        │       └── 📁 help_feedback  
        │           └── 📁 view  
        │               └── 📄 help_feedback_view.dart  
        └── 📁 utils  
            ├── 📄 command.dart  
            └── 📄 result.dart  
```            