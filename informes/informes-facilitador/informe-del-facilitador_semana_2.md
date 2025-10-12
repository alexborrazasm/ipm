# Informe del Facilitador-Administrador

##  Registro de tareas llevadas a cabo durante la semana 2

### [`Tarea heredada de la semana anterior`] Creación del diseño IU y casos de uso (Tarea 1.1 enunciado)

Entre los 3 decidimos el camino a seguir para el diseño, ~~en este caso como yo 
tengo una table me encargo de dibujarlo~~. Esta semana yo estuve más encargado 
de preparar el esqueleto y la arquitectura de la APP, está tarea pasó a hacerla
Nerea. Además se fue actualizando, según avanzaba la implementación adaptándose
a las posibilidades de GTK y Adwaita.

#### Responsabilidades:
- Alexandre -> comenzó a dibujar el diseño y exportarlo a pdf.
- Nerea -> terminó el dibujo y creo los diagramas necesarios.
- Todos -> revisión y retroalimentación.

#### Estado: `Completada`
Se hicieron dos iteraciones, es decir:
  - Como queremos el diseño?
  - Se dibuja
  - Feedback

En el feedback salieron cosas a cambiar y casos de uso a añadir.

Luego se modifico según la implementación.

#### Desviaciones:
~~Dado que hemos empezado tarde con el diseño está primera semana, llevamos la
primera tarea con un poco de retraso.~~ Hemos conseguido remontar las 
desviaciones para poder entregar todo el domingo.

### Implementar: Modelo
Implementación de modelo, la capa que se comunica con la API (servidor).

#### Responsabilidades
- Daniel: Primera aproximación viendo las API del servidor.
- Nerea: Añadió 2 métodos no contemplados inicialmente.
- Alexandre: Arreglé alguna función al conectar VIEW-PRESENTER-MODEL.

#### Estado: `Completada`

#### Desviaciones
Al principio se fue desarrollando en paralelo a la vista y presenter. Mientras
allí era complicado repartir tareas. Esto hizo que no estuvieran miembros del 
equipo parados. Pero luego a la hora de conectar todo, hubo que ajustar.

### Implementar: Vista
Implementación de la vista, la implementación más larga. La interfaz de la 
aplicación.

#### Responsabilidades
- Alexandre: creé una buena base para luego poder repartir las vistas a cada
  miembro del equipo. Luego trabajé en varias vistas, sobre todo en información
  de gasto, añadir crédito a un amigo en gasto y optimicé mucho comportamiento
  responsive.
- Daniel: se encargó de añadir amigo a gasto, los casos de uso de búsqueda y 
  editar gasto.
- Nerea: Nerea principalmente hizo añadir gasto, el calendario y dío una 
  aproximación de añadir amigo a gasto. 

#### Estado: `Completada`

#### Comentarios
Como dije la semana pasada, necesitábamos hacer está tarea rápido, la tare más
larga y complicada de todas, al no empezarla la primera semana. 

### Implementar: Presentador
Implementación de capa intermedia, conecta el Modelo con la Vista.

#### Responsabilidades
- Alexandre: la mayoría de las funciones y les expliqué a mis compañeros el 
  funcionamiento, para que pudiesen hacer cambios más cómodamente.
- Daniel: hizo la otra parte.

Es un capa que se va haciendo al ir conectando la vista con el modelo.

#### Estado: `Completada`

### Diagramas diseño Software
Crear los diagramas de como está diseñada la arquitectura de nuestra aplicación.

#### Responsabilidades
- Nerea: escribir los diagramas.
- Resto del equipo: revisar y facilitar la actualización según va creciendo el 
  código.

#### Estado: `Completada`

### Resumen final
Creo que hemos hecho un buen trabajo como equipo, cumpliendo los objetivos
previstos para este domingo. La finalización de la primera tarea.

Cosas que destaco, revisión por parejas del código para mejorar la claridad y
calidad del código antes de la entrega.

También hemos realizado programación por parejas para homogeneizar las 
habilidades de todo el equipo y entender bien como se hace cada parte.

También he intentando que todos realizáramos un poco de cada parte del código, y
no uno modelo otro vista y otro presentador. Así creamos un equipo mucho más
polivalente. 

## Estado del repositorio en la semana 2
Tenemos el primera versión de una aplicación funcional. Toda la interfaz y 
conectada con el servidor.

Además el diseño software y el diseño IU, actualizado con la aplicación.

Nos falta empezar a manejar errores, como por ejemplo campos incorrectos en un
formulario.
