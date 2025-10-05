# Informe del Facilitador-Administrador

##  Registro de tareas llevadas a cabo durante la semana 1

### Primera reunión, asignación de roles, repositorio y lectura del enunciado

En primer lugar se hizo una reunión de los 3 miembros para ver que tenemos
que hacer, como lo vamos a hacer y leer el enunciado de la práctica.

En está tarea se decidieron los roles:
  - Analista -> Daniel.
  - Curadora-Traductora -> Nerea.
  - Facilitador-Administrador -> Alexandre (yo).
Como ya todos nos conocíamos, fué bastante fácil establecer los roles.

Se creo el repositorio de la práctica y nos unimos todos.

Se revisó el enunciado y lubricas.

#### Estado: `Completada`

### Puesta en común de los diseños de la PI

Como se sugería en el enunciado, pusimos en común los diseños usados en la 
práctica individual.

Luego de esto se decidió hacer una mezcla del diseño de Nerea y el mio
(Alexandre). Además de hacer una lluvia de ideas de casos de uso posibles y ideas
para simplificar la aplicación, dado que nuestros diseños de la PI tendían a ser
muy complejos.

#### Estado: `Completada`

### Creación del diseño IU y casos de uso (Tarea 1.1 enunciado)

Entre los 3 decidimos el camino a seguir para el diseño, en este caso como yo 
tengo una table me encargo de dibujarlo.

#### Responsabilidades:
- Alexandre -> dibujar el diseño y exportarlo a pdf.
- Nerea y Daniel -> revisión y retroalimentación.

#### Estado: 'En progreso'
Se hizo una iteración, es decir:
  - Como queremos el diseño?
  - Se dibuja
  - Feedback

En el feedback salieron cosas a cambiar y casos de uso a añadir.

#### Desviaciones:
Dado que hemos empezado tarde con el diseño está primera semana, llevamos la
primera tarea con un poco de retraso.

### Selección del patrón de diseño SW (Tarea 1.2 enunciado)

Se hablo el patrón a utilizar, al final hemos decidido usar MVP (Modelo-Vista-
Presentador), este patrón separa la lógica de la interfaz de usuario en 3 capas
facilitando las pruebas, mantenimiento y la escalabilidad.

#### Estado: 'Completada'

### Configuración del entorno
Para gestionar el entorno de trabajo he decido usar el gestor de paquetes
[Nix](https://nixos.org/) y sus `flakes`. Además vamos a usar `Adwaita` en lugar 
de GTK base.

#### Problemas
Un pequeño problema con el entorno que hacía que al ejecutar la app de prueba
(que nos envió la profesora) diese un error de fragmentación.

Se arreglo luego de buscar por la documentación añadiendo el paquete 
`wrapGAppsHook` el cual hace que Adwaita encuentra bien todas sus dependencias
en el entorno de Nix.

#### Responsabilidades
Dado que soy el único con experiencia con Nix me encargué yo.
Nerea y Daniel, simplemente siguieron un pequeño tutorial de como instalar Nix 
en sus máquinas y probaron que todo funcionase.

#### Estado: 'Completada'

### Resumen final

Vamos con un poco de retraso deberíamos corregir la siguiente semana, si 
queremos terminar la tarea 1 para el domingo 12 de Octubre.

Nos falta aún terminar el diseño iu, empezar-terminar el diseño sw y implementar.

Ideas:
  - Se puede empezar la capa modelo sin tener el diseño IU/SW terminado.

## Estado del repositorio en la semana 1

Tenemos los archivos de configuración de Nix y un .envrc para cargar 
automáticamente el entorno al entrar en el directorio.