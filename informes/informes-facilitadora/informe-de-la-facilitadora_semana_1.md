# 📋 **INFORME FACILITADORA-ADMINISTRADORA**
## SEMANA 1

> A continuación se ofrece el informe de la facilitadorea-administradora de la 
>semana 1 de trabajo 27/10/2025 - 02/11/2025, cuyo papel desempeña: 
> Nerea Pérez Pértega

---

## 🎯 **Objetivo de la semana:**   
Organización inicial, diseño de interfaz, elección del patrón arquitectónico y 
diseño software.

---

##  🗂️ Registro de tareas llevadas a cabo durante la semana 1

### 🤝 **1. Primera reunión: creación repositorio, asignación de roles y lectura del enunciado**

**Descripción:**  
- Leer y comprender el enunciado de la práctica.
- Revisar rúbricas y definir la organización del trabajo.  
- Crear el repositorio y unir a todos los miembros.

Roles asignados:
  - Analista -> Alexandre
  - Curador-Traductor -> Daniel
  - Facilitadora-Administradora -> Nerea

**Responsables:** Trabajo en grupo

**Estado:** *Completada* ✅

**Conflictos o incidencias:** ninguno. Como ya nos conocíamos, la coordinación 
fue fluida.

---

### ✏️ **2. Diseño de la interfaz de usuario para móvil y tablet**

**Descripción:**   
Adaptación del diseño de la aplicación de escritorio a una versión para móvil y 
tablet.

**Responsables:**
- Ideas y revisión: Trabajo en grupo
- Wireframes: Nerea
- Diagramas de flujo: Daniel

**Estado:** *Completada* ✅

**Conflictos o incidencias:**  el primer diseño fue ajustado para adaptarse 
mejor a las limitaciones de Flutter.

---

### 🏛️ **3. Selección del patrón de diseño SW**

**Descripción:**  
Discusión sobre diferentes patrones de arquitectura. Finalmente, se decidió 
usar el MVVM, por su capacidad de separar responsabilidades y facilitar la 
escalabilidad del proyecto.

**Asignación de responsables:** Trabajo en grupo.

**Estado:** *Completada* ✅

**Conflictos o incidencias:** N/A. 

---

### 💻 **4. Diseño Software**
**Descripción:**  
Se realizó el diseño sw siguiendo el patrón MVVM, 
incluyendo los diagramas de la parte estática y dinámica.

**Asignación de responsables:**
- Parte estática: Alexandre
- Parte dinámica: Daniel

**Estado:** *Completada* ✅

**Conflictos o incidencias:** N/A.

---

### ⚙️ **5. Configuración del entorno de trabajo**
**Descripción:**  
Para gestionar el entorno de trabajo se ha decido 
usar el gestor de paquetes [Nix](https://nixos.org/) y sus *flakes* para 
garantizar reproducibilidad y consistencia entre equipos.

**Asignación de responsables:**
- Preparación del entorno: Alexandre

**Estado:** *Completada* ✅

**Conflictos o incidencias:** Nerea experimentó un problema al usar la shell 
*fish*, resuelto fácilmente.

---

### 🧩 **6. Creación de la base del proyecto**
**Descripción:**  
Estructuración de la base del proyecto para asegurar un estilo y organización 
comunes.

**Asignación de responsables:**
- Base general: Alexandre
- Base view, viewModels y utils: Daniel
- Base modelo de datos: Nerea

**Estado:** *Completada* ✅

**Conflictos o incidencias:** N/A.

---

### 👩‍💻 **7. Implementación de los Models**
**Descripción:**   
Inicio de la implementación de la capa Models, que gestiona los datos y la lógica
 de negocio del sistema.

**Asignación de responsables:**
- Peticiones a la API: Nerea

**Estado de completitud:** 🟡 *En proceso* 

**Conflictos o incidencias:** N/A.

---

## 📊 Análisis final
El equipo lleva el proyecto bastante adelantado.
Según el enunciado de la práctica, estaba planificado que esta semana solo se 
completase el diseño de la interfaz, pero ya se inició también la fase de 
implementación.

---

## 📂 Estado del repositorio en la semana 1
- Archivos de configuración de Nix y un .envrc para cargar automáticamente el 
entorno al entrar en el directorio.
- El proyecto sigue el patrón arquitectónico MVVM, separando claramente la lógica 
de negocio, la vista y el modelo de datos.
La carpeta `/splitwiththemachine/lib/` concentra la lógica principal del proyecto.

