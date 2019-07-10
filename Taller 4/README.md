# Taller de shaders

## Propósito

Estudiar los [patrones de diseño de shaders](http://visualcomputing.github.io/Shaders/#/4).

## Tarea

1. Hacer un _benchmark_ entre la implementación por software y la de shaders de varias máscaras de convolución aplicadas a imágenes y video.
2. Implementar un modelo de iluminación que combine luz ambiental con varias fuentes puntuales de luz especular y difusa. Tener presente _factores de atenuación_ para las fuentes de iluminación puntuales.
3. (grupos de dos o más) Implementar el [bump mapping](https://en.wikipedia.org/wiki/Bump_mapping).

## Integrantes

Complete la tabla:

|        Integrante        |  github nick   |
|--------------------------|----------------|
| Fabián Camilo Ordóñez    | fcordonezo     |
| Jair Alexis Villalba     | JairVillalba   |
| Daniel Esteban Rodriguez | Dandarprox     |

## Informe

1. 

### Objetivos.

* Medir la capacidad de procesamiento de imágenes, a las cuales se les aplicará una serie de filtros, así como también el procesamiento de vídeo con los mismos filtros. Ésto en un procesador, que en nuestro caso es un Intel Core i7-6500U con 4 núcleos, 8 hilos, 2.5 GHz de frecuencia base y 2.6GHz en turbo.
* Realizar esta misma medición pero ahora cargando el procesamiento de las imágenes y vídeo en una GPU, que para este caso es una gráfica Intel HD Graphics 520.
* Dar cuenta de la gran diferencia que existe entre una CPU y una GPU en cuanto a procesamiento de imágenes y vídeo se trata.

### Montaje experimental.

1. Los filtros que se aplicarán tanto a imágenes como a vídeo son:

* Escala de grises con Luma. (G)
* Desenfoque promedio.       (B) Matriz 3x3
* Detección de bordes.       (E) Matriz 3x3
* Enfoque.                   (F) Matriz 5x5
Nota: las letras entre paréntesis representan la tecla que se debe presionar para aplicar el filtro.

2. Se tienen seis programas diferentes escritos en Processing, los cuales son:

* imagen_software: Este programa carga dos imágenes (que son de hecho la misma) en la pantalla. Al momento de aplicar un filtro, la imágen de la derecha será la que se verá afectada, mientras que la de la izquierda quedará intacta. Ésto con el fin de hacer la comparación entre original y modificada.

Al momento de aplicar un filtro, en pantalla se podrá apreciar cuál fue el tiempo que le tomó al procesador realizar los cálculos y modificar la imagen.

Resolución de la imágen: 640px X 600px

* imagen_software_8k: Resulta ser muy similar al programa anterior, con la gran diferencia que en este caso sólo será dibujada una imágen, la cual tiene una resolución muy alta (8K).

Resolución de la imágen: 7680px X 4320px

* imagen_shaders: Este programa es el mismo que el de "imagen_software", pero en este caso las imágenes serán dibujadas utilizando shaders. Se utiliza la misma imágen que para "imagen_software"

* imagen_shaders: Este programa es el mismo que el de "imagen_software_8k", pero en este caso las imágenes serán dibujadas utilizando shaders. Se utiliza la misma imágen que para "imagen_software_8k"

* video_software: Se mostrará un vídeo de 2:30 minutos de duración sobre el cual se podrán ir cambiando los filtros. Cabe aclarar que todo este proceso será procesado en la CPU.

Resolución del vídeo: 1280px X 720px

* video_shaders: Se mostrará el mismo vídeo que para el caso de "video_software", con la clara diferencia de que en este caso el vídeo será procesado utilizando shaders.

### Resultados:

#### Comparación entre imagen_software e imagen_shaders.
Valor a medir: tiempo promedio de aplicación del filtro.

- ESCALA DE GRISES: 
Software: 26,2ms promedio
          34ms   Inicial
Shaders:  0.9ms  promedio
          8ms    Inicial

- BORDES: 
Software: 43,3ms promedio
          49ms   Inicial
Shaders:  1.9ms  promedio
          12ms   Inicial

- DESENFOQUE: 
Software: 54ms   promedio
          45ms   Inicial
Shaders:  1.2ms  promedio
          11ms   Inicial

- ENFOQUE: 
Software: 80,2ms promedio
          99ms   Inicial
Shaders:  1.5ms  promedio
          13ms   Inicial

#### Comparación entre imagen_software_8k e imagen_shaders_8k.
Valor a medir: tiempo promedio de aplicación del filtro en milisegundos (ms).


- ESCALA DE GRISES: 

Software: 3567.2ms promedio.
          3653ms   Inicial

Shaders:  2.5ms    promedio.
          24ms     Inicial


- BORDES: 

Software: 5156ms   promedio.
          5435ms   Inicial

Shaders:  4.9ms    promedio.
          46ms     Inicial


- DESENFOQUE: 

Software: 5625.4ms promedio.
          5738ms   Inicial

Shaders:  2.0ms    promedio.
          13ms     Inicial


- ENFOQUE: 

Software: 7025ms   promedio.
          7177ms   Inicial

Shaders:  1.4ms    promedio
          13ms     Inicial


#### Comparación entre video_software e shaders_shaders.
Valor a medir: Frames por segundo (FPS).

- SIN FILTRO:

Software: 60FPS  promedio

Shaders:  60FPS  promedio


- ESCALA DE GRISES: 

Software: 20FPS  promedio

Shaders:  60FPS  promedio


- BORDES: 

Software: 10FPS  promedio

Shaders:  60FPS  promedio


- DESENFOQUE: 

Software: 11FPS  promedio

Shaders:  60FPS  promedio


- ENFOQUE: 

Software: 6.5FPS promedio

Shaders:  60FPS  promedio


## Conclusiones.

* Si bien para el caso de una imagen pequeña (640px X 600px) la diferencia de rendimiento entre CPU y GPU no tiene un margen demasiado alto, a pesar de que se proclama superior la GPU, en cuanto la imagen se hace más y más grande, la diferencia se vuelve exponencialmente grande. Mientras que para el procesador, la carga extra se hace notar, la GPU no muestra siquiera aumento en el tiempo de ejecución.

* En el caso del vídeo, la GPU lo lleva siempre sobre los 60FPS sin importar qué filtro se le aplique, mientras que el procesador sí disminuye considerablemente los frames por segundo que es capáz de mostrar.

* Para la GPU el aumento de tamaño en el kernel de filtro a aplicar (es el caso de ENFOQUE) no supone ningún inconveniente, mientras que en el caso del procesador sí se evidencia un aumento en el tiempo de procesamiento en el caso de la foto, y una reducción en los FPS en el caso del vídeo, con respecto a los demás filtros.