# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo.
2. Sombrear su superficie a partir de los colores de sus vértices.
3. (opcional para grupos menores de dos) Implementar un [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) para sus aristas.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [nub](https://github.com/nakednous/nub/releases).

## Integrantes

|        Integrante        |  github nick   |
|--------------------------|----------------|
| Fabián Camilo Ordóñez    | fcordonezo     |
| Jair Alexis Villalba     | JairVillalba   |
| Daniel Esteban Rodriguez | Dandarprox     |

## Discusión

Describa los resultados obtenidos. En el caso de anti-aliasing describir las técnicas exploradas, citando las referencias.

Los resultados obtenidos en la implementación de rasterización y sombreado de superficie a partir de los colores de los vértices para un triángulo, así como también la implementación de un algoritmo de anti-aliasing para sus aristas son, en efecto, la coloración de cada uno de los pixeles dentro del triángulo mediante el uso de coordenadas baricéntricas. Con un color específico para cada pixel teniendo en cuenta la posición de éste con respecto al vértice, quien es el que define el color base.
Por otra parte, en la implementación del algoritmo de anti-aliasing se percibe una notable mejora en cuanto a la definición de las aristas del triángulo, eliminando en gran medida este problema recurrente que es el llamado "dientes de sierra". Utilizando este algoritmo, los pixeles que tuvieran una participación menor al 100% en el interior del triángulo se pintan de un tono más o menos intenso, dependiendo de su grado de participación (en cuanto más participación presente, más intenso será su tono).

La técnica utilizada para el anti-aliasing, cuya fuente está en el enlace de abajo, fue la de reducción de pixel.

[Rreferencia anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation)