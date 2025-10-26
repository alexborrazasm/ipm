# Informe del Facilitador-Administrador

##  Registro de tareas llevadas a cabo durante la semana 4

### Mejorar comportamiento cuando no hay conexión con la API
Cuando salía la pantalla de reintentar gasto, el usuario podía seguir navegando,
esto permite romper el flujo de la app.

#### Responsabilidades
- Daniel, se encargó de revisar esta parte, dado que la semana pasaba fué el que
menos puedo aportar por otras asignaturas.

#### Estado: `Completada`

### Arreglar error al editar gastos
En ciertas ocasiones al editar gasto con valores inválidos ponía que se ha 
editado correctamente, pero en la API no surgía efecto.

#### Responsabilidades
- Alexandre (Yo), código
- Resto, buscar cuando se produce el fallo y test.

#### Conflictos
Fué un bug complicado de arreglar, dado que no eramos capaces de replicar el 
error encontrado por Noelia. Al final era problema de reutilizar los mismos 3
formularios para todos los gastos y la implementación de las operaciones 
concurrentes.

#### Estado: `Completada`

### Internacionalización
Traducir la aplicación a más idiomas utilizando i18n.

#### Responsabilidades
- Daniel: Sacó la mayor parte del trabajo inicial y nos explicó como funcionaban
  todos los comandos de crear un nuevo idioma, compilar las traducciones o sacar 
  de nuevo las cadenas a traducir y actualizar todas las traducciones.
- Nerea: Cambió cosas de sitios según nos explico Noelia en clase, las teníamos
  ordenadas de otra manera y añadió muchas cadenas que inicialmente se había
  olvidado.
- Alexandre (Yo): Añadir la traducción al gallego y alguna mejora de los locales,
  los usamos para establecer las fechas y la moneda. Si no tenemos el 
  idioma del locale, se pone en inglés pero sus fechas y monedas del locale.

#### Estado: `Completada`

### Resumen final
Esta semana el trabajo fué mucho más ligero, aunque un poco lioso las traducciones,
dado que sí haces cambios en el código toca regenerar las traducciones.

## Estado del repositorio en la semana 4

Tenemos la práctica terminada a falta de obtener el feedback de la última parte.
Con 3 idiomas, Inglés (idioma del código), español y gallego con i18n.
