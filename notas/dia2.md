# Triggers

Básicamente son programas que podemos asociar a ciertos eventos en la base de datos, para que se ejecuten automáticamente cuando esos eventos ocurren.

Eventos?
- INSERT: Cuando se inserta un nuevo registro en una tabla.
- UPDATE: Cuando se actualiza un registro existente.
- DELETE: Cuando se elimina un registro de una tabla.

Los defino a nivel de tabla, y pueden ser antes (BEFORE) o después (AFTER) del evento.

Vamos a usar sintaxis PLSQL para definir el cuerpo del trigger.
Pero... en estos casos, cuando usamos PLSQL dentro de un trigger, cambia un poquito la sintaxis con respecto a otro tipo de bloques PLSQL. 
Además, en este caso, tendremos que usar los alias :NEW y :OLD para referirnos a los valores nuevos y viejos de las columnas afectadas por el trigger.

```plsql
CREATE OR REPLACE TRIGGER nombre_del_trigger
BEFORE|AFTER INSERT|UPDATE|DELETE ON nombre_de_la_tabla -- inlsuco podemos poner varios, con OR
FOR EACH ROW

BEGIN
  -- cuerpo del trigger
  -- Aqui dentro es donde podremos usar las variables :NEW y :OLD
  -- Con esas variables me referiré a los valores de las columnas:
    -- :NEW.columna  --> valor nuevo (después del cambio)
    -- :OLD.columna  --> valor viejo (antes del cambio)
END;
/
```

# FUNCTIONS

Una función es un bloque PLSQL que devuelve un valor.
Puede recibir parámetros de entrada, y puede tener variables locales.

```plsql
CREATE OR REPLACE FUNCTION nombre_de_la_funcion (
    parametro1 IN TIPO,
    parametro2 IN TIPO
) RETURN TIPO_RETORNO
IS
    -- Declaración de variables locales
    variable_local TIPO;
BEGIN
    -- Cuerpo de la función
    variable_local := parametro1 + parametro2; -- Ejemplo de operación
    RETURN variable_local; -- Devuelve el valor
END;
/
```

# PROCEDURES

Un procedimiento es un bloque PLSQL que NO devuelve un valor.
Puede recibir parámetros de entrada, y puede tener variables locales.
Y algo raro... puede recibir parámetros de salida (OUT), que son variables que se pasan por referencia, y que el procedimiento puede modificar para devolver valores a quien lo llamó.

---

# Diagrama de nuestra BBDD

Lo vamos a crear usando MERMAID.
Esta librería nos permite escribir diagramas en texto plano, y luego renderizarlos en imágenes.

Además, el lenguaje que me da esta librería se soporta por una cantidad enorme de maquetadores de documentos MarkDown.



```mermaid
erDiagram
    Direction LR

    TIPOS_CURSOS {
        NUMBER ID PK
        VARCHAR CODIGO
        VARCHAR NOMBRE
        VARCHAR DESCRIPCION
    }

    CURSOS {
        NUMBER ID PK
        VARCHAR CODIGO
        VARCHAR NOMBRE
        NUMBER DURACION
        NUMBER TIPO
        NUMBER PRECIO_PARA_EMPRESAS
        NUMBER PRECIO_PARA_PARTICULARES
        VARCHAR DESCRIPCION
    }

    TIPOS_CURSOS ||--o{ CURSOS : "tiene"

    PROFESORES {
        NUMBER ID PK
        VARCHAR NOMBRE
        VARCHAR APELLIDOS
        VARCHAR DNI
    }

    PROFESORES_CURSOS {
        NUMBER PROFESOR_ID PK 
        NUMBER CURSO_ID PK
    }

    PROFESORES ||--o{ PROFESORES_CURSOS : "imparte"
    CURSOS ||--o{ PROFESORES_CURSOS : "es impartido por"

    EMPRESAS {
        NUMBER ID PK
        VARCHAR NOMBRE
        VARCHAR CIF
        VARCHAR DIRECCION
        VARCHAR EMAIL
    }
    EMPRESAS_TELEFONOS {
        NUMBER EMPRESA_ID PK
        VARCHAR TELEFONO PK
    }
    EMPRESAS ||--o{ EMPRESAS_TELEFONOS : "tiene"

    ESTADOS_CONVOCATORIA {
        NUMBER ID PK
        VARCHAR CODIGO
        VARCHAR NOMBRE
    }

    CONVOCATORIAS {
        NUMBER ID PK
        NUMBER CURSO_ID FK
        DATE FECHA_INICIO
        DATE FECHA_FIN
        NUMBER ESTADO_ID FK
    }

    ESTADOS_CONVOCATORIA ||--o{ CONVOCATORIAS : "tiene"
    CURSOS ||--o{ CONVOCATORIAS : "tiene"

    ALUMNOS {
        NUMBER ID PK
        VARCHAR NOMBRE
        VARCHAR APELLIDOS
        VARCHAR DNI
        VARCHAR EMAIL
    }

    ALUMNOS_EMPRESAS {
        NUMBER ALUMNO_ID PK
        NUMBER EMPRESA_ID PK
    }

    ALUMNOS ||--o{ ALUMNOS_EMPRESAS : "pertenece a"
    EMPRESAS ||--o{ ALUMNOS_EMPRESAS : "tiene"

    ESTADOS_MATRICULA {
        NUMBER ID PK
        VARCHAR CODIGO
        VARCHAR NOMBRE
    }

    MATRICULAS {
        NUMBER ID PK
        NUMBER ALUMNO_ID FK
        NUMBER EMPRESA_ID FK
        NUMBER CONVOCATORIA_ID FK
        NUMBER ESTADO_ID FK
        DATE FECHA_MATRICULA
        NUMBER PRECIO
        NUMBER DESCUENTO
        NUMBER PRECIO_FINAL
    }

    ALUMNOS ||--o{ MATRICULAS : "tiene"
    ALUMNOS_EMPRESAS ||--o{ MATRICULAS : "tiene"
    CONVOCATORIAS ||--o{ MATRICULAS : "tiene"
    ESTADOS_MATRICULA ||--o{ MATRICULAS : "tiene"

    EVALUACIONES {
        NUMBER MATRICULA_ID PK FK
        DATE FECHA_EVALUACION PK
        NUMBER NOTA
        VARCHAR OBSERVACIONES
    }

    MATRICULAS ||--o{ EVALUACIONES : "tiene"

```
