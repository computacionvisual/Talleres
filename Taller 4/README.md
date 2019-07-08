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

1. Se realizó una medición del tiempo transcurrido en aplicar una máscara de convolución a una imágen y los resultados fueron los siguientes:

Imagen por Software: 1300ms en promedio.
Imagen por Hardware: 14ms   en promedio.

