------------------------------------------------------------------------------------------------
-- DNI_UTILS - Test Suite
------------------------------------------------------------------------------------------------

# Ejecución de Pruebas

## Configuración del Entorno de Pruebas

Para ejecutar las pruebas de manera aislada, se recomienda crear un esquema dedicado donde instalar el paquete `dni_utils` y ejecutar los tests.

### 1. Crear el esquema de pruebas

```sql
-- Crear usuario/esquema para pruebas
CREATE USER dni_utils_test IDENTIFIED BY dni_utils_test
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

-- Conceder permisos necesarios
GRANT CONNECT, RESOURCE TO dni_utils_test;
```

### 2. Instalar el paquete dni_utils

Conectar como usuario `dni_utils_test` y ejecutar:

```sql
-- Instalar especificación del paquete
@../src/dni_utils.sql

-- Instalar implementación del paquete
@../src/dni_utils.impl.sql
```

### 3. Crear sinónimo (opcional)

Para facilitar el uso del paquete desde otros esquemas:

```sql
-- Desde un usuario con privilegios
CREATE OR REPLACE PUBLIC SYNONYM dni_utils FOR dni_utils_test.dni_utils;
```

## Ejecutar Suite de Pruebas

El directorio contiene los siguientes archivos:

- **`dni_utils.test.data.sql`**: Carga los datos de prueba (tablas `dni_test_data_ok` y `dni_test_data_nok`)
- **`dni_utils.test.sql`**: Script principal con las funciones de prueba y su ejecución

Para ejecutar todas las pruebas:

```sql
@dni_utils.test.sql
```

Este script:
1. Activa `SERVEROUTPUT` para mostrar mensajes
2. Carga automáticamente los datos de prueba desde `dni_utils.test.data.sql`
3. Define las funciones de prueba para cada función/procedimiento del paquete
4. Ejecuta las pruebas y muestra resultados detallados
5. Limpia las tablas de prueba al finalizar

## Estructura de los Datos de Prueba

### Tabla: dni_test_data_ok

Contiene DNIs válidos con todas las variantes de formato:

| Columna      | Tipo         | Descripción                                    |
|--------------|--------------|------------------------------------------------|
| `dni_input`  | VARCHAR2(15) | Formato de entrada del DNI                     |
| `es_valido`  | NUMBER       | Resultado esperado (siempre 1)                 |
| `numero`     | NUMBER       | Número extraído esperado                       |
| `letra`      | CHAR(1)      | Letra extraída esperada (normalizada mayúscula)|

**Cobertura de casos válidos:**
- DNIs de 1 a 8 dígitos
- Con y sin ceros a la izquierda (hasta 8 dígitos)
- Formato con puntos: `XX.XXX.XXX`
- Separadores: sin separador, espacio, guion
- Letras en mayúsculas y minúsculas

### Tabla: dni_test_data_nok

Contiene DNIs inválidos que deben ser rechazados:

| Columna           | Tipo          | Descripción                               |
|-------------------|---------------|-------------------------------------------|
| `dni_input`       | VARCHAR2(50)  | Formato de entrada del DNI inválido       |
| `motivo_invalido` | VARCHAR2(100) | Descripción del motivo de invalidez       |

**Cobertura de casos inválidos:**
- Letra incorrecta según algoritmo
- Más de 8 dígitos
- Sin letra o sin número
- Caracteres especiales inválidos
- Formato de puntos incorrecto
- Espacios en posiciones incorrectas
- Letras no válidas (Ñ, Ç, Ü)
- Formato NIE (X, Y, Z al inicio)
- Y muchos más...

## Funciones de Prueba

El script `dni_utils.test.sql` define las siguientes funciones de prueba:

### test_validar_dnis_ok

Prueba el procedimiento `validar_dni` con casos válidos:
- Verifica que `es_valido` devuelva `TRUE`
- Comprueba que `numero` y `letra` extraídos sean correctos
- Retorna 1 si todas las pruebas pasan, 0 si alguna falla

### test_validar_dnis_nok (futuro)

Prueba el procedimiento `validar_dni` con casos inválidos:
- Verifica que `es_valido` devuelva `FALSE`

### test_es_dni_valido_ok / test_es_dni_valido_nok (futuro)

Prueba la función `es_dni_valido` con casos válidos e inválidos.

### test_normalizar_dni_ok / test_normalizar_dni_nok (futuro)

Prueba la función `normalizar_dni` con diferentes opciones de normalización.

## Salida de las Pruebas

El script muestra información detallada:

```
-------------------------------------------------------------------------------------------------------
Iniciando ejecución de pruebas para el paquete dni_utils
-------------------------------------------------------------------------------------------------------
Pruebas de validar_dni - casos OK: EN PROGRESO
Pruebas de validar_dni - casos OK: FINALIZADAS
Resumen de resultados: 
. Casos totales: 234
. Casos exitosos: 234
. Casos fallidos: 0
Pruebas de validar_dni - casos OK: EXITOSAS
-------------------------------------------------------------------------------------------------------
RESUMEN: Todas las pruebas del paquete dni_utils han sido exitosas.
-------------------------------------------------------------------------------------------------------
```

En caso de fallos, se muestran mensajes específicos indicando:
- El DNI que falló
- El valor esperado
- El valor obtenido

## Limpieza

Las tablas de prueba se eliminan automáticamente al finalizar el script.

Para eliminar el esquema completo:

```sql
-- Como usuario con privilegios
DROP USER dni_utils_test CASCADE;
```

## Notas Importantes

- El procedimiento `validar_dni` utiliza el tipo `BOOLEAN`, por lo que **solo puede ser llamado desde PL/SQL** (no desde SQL puro).
- Para usar la validación en queries SQL, utilizar la función `es_dni_valido` que devuelve `NUMBER` (1=válido, 0=inválido).
- Los datos de prueba cubren exhaustivamente los casos de uso reales y edge cases.
- El script de pruebas usa cursores implícitos (FOR loops) y bloques DECLARE anidados para demostrar diferentes técnicas de PL/SQL.

