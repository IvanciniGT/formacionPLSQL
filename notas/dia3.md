# PLSQL

Podemos usarlo para crear:
- Triggers
- Funciones
- Procedures

En el caso de funciones y procedures, tienen parametros de entrada (IN).
Y en el caso de procedures, pueden tener parametros de salida (OUT).
Y en el caso de las funciones podemos tener un valor de retorno (RETURN).

En todos ellos podemos definir variables / constantes locales.

## Operadores

- LOGICOS: AND, OR, NOT
- COMPARACION: =, != (! =), <>, >, <, >=(> =), <= (< =)
- CONCATENACION: ||
- ARITMETICOS: +, -, *, /
- ASIGNACION: :=

## Funciones

- MOD(numero, divisor): Devuelve el resto de la división entera.
- LPAD(string, longitud, caracter): Rellena a la izquierda una cadena hasta la longitud indicada con el caracter indicado.
- RPAD(string, longitud, caracter): Rellena a la derecha una cadena hasta la longitud indicada con el caracter indicado.
- SUBSTR(string, inicio, longitud): Devuelve una subcadena desde la posición inicio (1-based) y de la longitud indicada.
- UPPER(string): Convierte una cadena a mayúsculas.
- LOWER(string): Convierte una cadena a minúsculas.
- TO_NUMBER(string): Convierte una cadena a número.
- TO_CHAR(algo_que_no_es_un_texto, formato): Convierte un valor a cadena de texto.
- TO_DATE(string, formato): Convierte una cadena a fecha según el formato indicado.
- RAISE_APPLICATION_ERROR(código_error, mensaje): Lanza un error personalizado con el código y mensaje indicados.
- REGEXP_REPLACE(string, patrón, reemplazo): Reemplaza partes de una cadena que coinciden con un patrón de expresión regular.
- REGEXP_LIKE(string, patrón): Verifica si una cadena coincide con un patrón de expresión regular.

---

# EXPRESIONES REGULARES

El lenguaje que usamos para definir patrones de expresiones regulares se definió en **PERL**.

Y casi todo lenguaje de programación posterior a PERL ha adoptado ese mismo lenguaje de expresiones regulares.