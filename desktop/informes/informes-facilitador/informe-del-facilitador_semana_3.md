# Informe del Facilitador-Administrador

##  Registro de tareas llevadas a cabo durante la semana 3

### Buscar los errores de la API a manejar

Apuntar los errores de la API que sea interesante tratar para enviar a la view.

#### Responsabilidades
- Daniel se encargo de toda la tarea.

#### Estado: `Completada`

### Rework de la capa modelo
Como ahora es importante que el backed tenga una forma de comunicar los errores
de la API o de conexión. Se modifico para poder implementar en las otras capas
el manejo de errores.

#### Responsabilidades
- Nerea: Hizo una primera versión.
- Daniel: Nos dimos cuenta luego de intentar conectar los errores del modelo al
  presenter que necesitábamos más información, Daniel se encargó de añadir otro
  tipo de error.

#### Estado: `Completada`

### Rework de la vista editar gasto
En el feedback, la vista editar era un poco rara para ser una app de escritorio.
La volvimos a hacer, ahora se edita directamente en información de gasto.

#### Responsabilidades
- Alexandre(Yo): Lo implemente.
- Resto de equipo: Ideas del diseño, revisión y feedback.
 
#### Estado: `Completada`

#### Conflictos
Por como teníamos organizados los widgets, teníamos errores de GTK con el focus.
Al final se solucionó cambiando la estructura de widgets.

### Manejo de errores de los formularios
En lugar de mandar datos no válidos a la API, optamos por modificar los 
formularios para que no hagan llamadas si los datos no son válidos.

#### Responsabilidades
- Daniel: Implementación y buscar información de como hacerlo.
- Resto del  equipo: Test de su funcionamiento.

#### Estado: `Completada`

#### Conflictos
Inicialmente no funcionaban bien, fue un problema chorra de como funciona Python
pero tardamos en encontrar el falo. Simplemente falta de experiencia con el 
lenguaje.

### Hacer las llamadas a la API de manera concurrente
No bloquear la interfaz mientras espera que lleguen los datos de la API.

#### Responsabilidades
- Alexandre(yo): Me encargué de implementar.
- Resto del equipo: Se encargó de hacer pruebas poniendo delays por el código.
#### Estado: `Completada`

### Cambio de iconos
Se cambiaron unos iconos, por otros más oportunos.

#### Responsabilidades
- Nerea
- Resto: feedback

#### Estado: `Completada`

#### Conflictos
Realmente GTK y ADW no tienen demasiada variedad de iconos y además como son 
simbólicos dependen del tema usado por tu distribución, Nerea en KDE ponía un 
icono, pero en GNOME con ADW nativo son otros.

### Cambio del las fechas
Las fechas las poníamos tal cual como salían de la API, no es muy normal poner
AÑO-MES-DIA, se pasó a un formato natural.

#### Responsabilidades
- Nerea
  
#### Estado: `Completada`

### Configurar Pylint
En general en el equipo, nos pasaba que python por su tipado dinámico y su no
compilación. Nos estaba costando no dejar variables de pruebas sin usar, sitios
con 1 tb de más, sobrescribir variables etc. 

Todo esto aparte de empeorar la calidad del código, nos hacer perder mucho más
tiempo de debug.

A finales de la semana descubrí esta herramienta.

#### Responsabilidades
- Alexandre(yo): Configuración inicial.
- Nerea: Terminó la configuración para ajustarse a nuestro proyecto.
  
#### Estado: `Completada`

### Refactoring general
La semana pasada, quizás todo el código base creció demasiado rápido, sobre todo
el view.py. Como esta semana teníamos menos carga y además describimos pylint.
Aprovechamos para mejorar un poco la legibilidad y buenas prácticas. Mejorando
la calidad de todo el código.

#### Responsabilidades
- Nerea: Refactoring y buenas prácticas en el View.
- Daniel: Refactoring y buenas prácticas en el Model.
- Alexandre(yo): Refactoring y buenas prácticas en el Presenter.
  
#### Estado: `Completada`

### Actualización de la documentación
Actualización del diseño IU y SW. Debido a todos los cambios por la 
refactoring, manejo de errores y concurrencia.

#### Responsabilidades
- Nerea: Actualizar
- Resto del equipo: Avisa a Nerea de cambios, para facilitarle el trabajo y
  revisar los cambios a terminar.
  
#### Estado: `Completada`

### Resumen final
Esta semana nos centramos el aplicar consejos de la profesora en el feedback,
implementar manejo de errores, concurrencia y mejorar la calidad del código.

Además hemos trabajado con herramientas muy interesantes como pylint y el ya 
descubierto Nix, que hizo muy sencillo añadir un paquete extra al proyecto sin
ir uno a uno con la instalación.

## Estado del repositorio en la semana 3
Tenemos nuestra APP, con llamadas concurrente a la API, manejo de errores y 
la calidad del código un poco más cuidada que la semana pasada.