# 📋 **INFORME ACCESIBILIDAD**

---

## 🎯 Objetivo
El objetivo de este informe es evaluar y validar la accesibilidad de nuestra 
página web, ajustándonos a las normas [WAI-ARIA](https://www.w3.org/WAI/standards-guidelines/aria/).

---

## ✏️ Pruebas exploratorias de accesibilidad

### 1️⃣ **Navegación por teclado**
- **Procedimiento**:   
Navegar usando TAB, Shift+TAB, Enter, Espacio y teclas de flechas.
- **Resultado esperado**:   
Todos los elementos interactivos son accesibles, el orden de tabulación es 
lógico y el foco visible se muestra correctamente en cada elemento.


### 2️⃣ **Lectura con lector de pantalla**
- **Procedimiento**:   
Usar un lector de pantalla para navegar por la página (Orca, Windows Narrator...).
- **Resultado esperado**:   
El contenido se anuncia de forma clara, comprensible y en el orden correcto, 
incluyendo encabezados, enlaces, botones y formularios.


### 3️⃣ **Mensajes para avisar de la terminación de acciones**
- **Procedimiento**:   
Ejecutar acciones que generan mensajes de confirmación o estado, como añadir 
a un amigo, editar un gasto, eliminar un participante de un gasto, etc.
- **Resultado esperado:**   
Los mensajes de estado se anuncian automáticamente mediante el lector de 
pantalla, incluso si no son visibles.


### 4️⃣ **Roles ARIA**
- **Procedimiento**:   
Inspeccionar los elementos interactivos y estructurales mediante las 
herramientas de desarrollo del navegador.
- **Resultado esperado**:   
Los roles ARIA corresponden correctamente a la 
función real de cada elemento.


### 5️⃣ **Contenido dinámico**
- **Procedimiento**:   
Realizar acciones que provoquen cambios dinámicos en la interfaz, como la recarga
de datos, añadir un amigo a un gasto...
- **Resultado esperado**:   
El lector de pantalla anuncia los cambios relevantes y el foco se gestiona de 
forma adecuada para no desorientar al usuario.


### 6️⃣ **Lighthouse**
- **Procedimiento**:   
Ejecutar la auditoría de accesibilidad mediante la herramienta Lighthouse.
- **Resultado esperado**:   
Obtener una puntuación alta en accesibilidad, sin errores críticos, y atendiendo las recomendaciones 
proporcionadas por la herramienta.


