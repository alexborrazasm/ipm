# 📋 **INFORME CURADORA-TRADUCTORA**
## SEMANA 3

> A continuación se ofrece el informe de la curadora-traductora de la semana 
>3 de trabajo 13/10/2025 - 19/10/2025, cuyo papel desempeña: Nerea Pérez Pértega

--- 

## 🎯 **Objetivos de aprendizaje**
### 1️⃣ **Documentación**
- Uso de threads en los diagramas
### 2️⃣ **Identificar operaciones que pueden resultar erróneas**
- Distinción entre errores de usuario y errores de E/S
### 3️⃣ **Gestión de errores**
- Evitar bloqueos de la interfaz 
### 4️⃣ **Gestión de la concurrencia en IGUs**
- Manejo de threads en GTK4/Adwaita para Python
 
---

## 📚 **Recursos recuperados**

---

### 1. Documentación
**🧾 Cómo usarlo:**  
Consulta estos enlaces para conocer los diagramas UML de aplicaciones multithreaded.

**🔗 Enlaces:**
- [UML Diagrams of Multi-Threaded Applications](https://softwareengineering.stackexchange.com/questions/120859/uml-diagrams-of-multi-threaded-applications)
- [Multithreading Example](https://sdedit.sourceforge.net/multithreading/example/index.html)

**🏆 Cómo ayuda:**  
Proporciona una guía y referencia sobre cómo incluir multithreading en los 
diagramas de secuencia.

---

### 1. Concurrencia
**🧾 Cómo usarlo:**   
Aunque esté escrito pensando en código C/GNOME, este artículo contextualiza cómo
en el ecosistema GNOME / GTK se piensa la concurrencia, los pools de trabajo, 
cómo interaccionar con GMainContext, etc.

**🔗 Enlaces:**
- [Concurrency, Parallelism, IO Scheduling...](https://blogs.gnome.org/chergert/2022/11/24/concurrency-parallelism-i-o-scheduling-thread-pooling-and-work-stealing)  
- [Implementing threading in a Python GTK app](https://stackoverflow.com/questions/73665239/implementing-threading-in-a-python-gtk-application-pygobject-to-prevent-ui-fre)

**🏆 Cómo ayuda:**  
Visión de la programación asíncrona. Sirve de inspiración y/o guía. 

---

### 2. Manejo de errores  
**🧾 Cómo usarlo:**  
Lee para conocer el manejo de errores en Python.   

**🔗 Enlaces:**
- [Error handling by Miguel Grinberg](https://blog.miguelgrinberg.com/post/the-ultimate-guide-to-error-handling-in-python)
- [Handling exceptions in Python](https://guicommits.com/handling-exceptions-in-python-like-a-pro)

**🏆 Cómo ayuda:**  
Obtención de una base para el control de errores y evitar problemas de concurrencia.

---

### 3. Documentación GTK4/Adwaita
**🧾 Cómo usarlo:**  
Consulta esta documentación para conocer los iconos de adwaita y métodos concretos
disponibles en GTK4/Adwaita que utilizaremos en nuestra aplicación.

**🔗 Enlaces:**  
- [Adw - Icons](https://github.com/StorageB/icons/blob/main/GNOME46Adwaita/icons.md)   
- [Adw - Entry Row](https://gnome.pages.gitlab.gnome.org/libadwaita/doc/1.3/property.EntryRow.input-purpose.html)  
- [Gtk - InputPurpose](https://docs.gtk.org/gtk4/enum.InputPurpose.html)

**🏆 Cómo ayuda:**   
Proporciona referencia y ejemplos sobre cómo implementar elementos visuales de 
la aplicación.  

---

### 4. Pylint
**🧾 Cómo usarlo:**  
Lee esta documentación sobre la herramienta de análisis estático de código para
Python que analiza el código fuente para encontrar errores, imponer un estándar
de codificación... 

**🔗 Enlaces:**  
- [Pylint User Manual](https://docs.pylint.org/)
- [Pylint Doc](https://pylint.readthedocs.io/en/latest/index.html#how-to-use-pylint)

**🏆 Cómo ayuda:**   
Buscar posibles mejoras en la calidad del código y aplicación de buenas prácticas
en Python.

---