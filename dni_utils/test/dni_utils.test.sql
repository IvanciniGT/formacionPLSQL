SET SERVEROUTPUT ON; -- Esto es para que SQL*Plus muestre los mensajes de DBMS_OUTPUT.PUT_LINE


-- Cargamos los datos de prueba para el paquete dni_utils
-- Los tenemos en el script dni_utils.test.data.sql
@dni_utils.test.data.sql -- Con esto le decimos a SQL*Plus que ejecute ese script
-- CREATE TABLE dni_test_data_ok (
--    dni_input VARCHAR2(15),
--    es_valido NUMBER,
--    numero    NUMBER,
--    letra     CHAR(1)
--);

-- Vamos a definir unos procedimientos de prueba, para las funciones del paquete dni_utils

-- Para cada función/procedure que tenga, montaré 2 procedimientos de prueba:
-- Uno para los casos positivos (donde espero que funcione bien)
-- Otro para los casos negativos (donde espero que falle)

-- Tenemos 3 funciones/procedimientos en el paquete dni_utils:
-- 1. validar_dni (procedure)
-- 2. es_dni_valido (function)
-- 3. normalizar_dni (function)

-- Necesitamos 6 procedimientos de prueba en total.

-- Además, voy a montar un procedimiento maestro que llame a todos los procedimientos de prueba,
-- de forma que pueda ejecutar todas las pruebas con una sola llamada.

-- Cual debería ser la salida de cada procedimiento de prueba?
-- Necesitamos saber si cada uno de esos 6 procedimientos de prueba ha funcionado o no como se esperaba.

-- En caso que no haya funcionado, deberíamos mostrar un mensaje de error indicando qué prueba ha fallado y por qué...
-- Necesitaríamos saber qué casos de prueba han fallado.


CREATE OR REPLACE FUNCTION test_validar_dnis_ok RETURN NUMBER IS
  numero_casos_total        NUMBER := 0;
  numero_casos_fallidos     NUMBER := 0;
  numero_casos_exitosos     NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pruebas de validar_dni - casos OK: EN PROGRESO');
    -- Necesitamos ejecutar el procedimiento validar_dni para cada uno de los casos de prueba
    -- que tenemos en la tabla dni_test_data_ok
    -- Hay 2 formas de plantear esto. Creando un cursos explicito, o usando un cursor implícito con un FOR.
    -- En este primer caso, lo haremos con el cursos implicito. 
    -- La siguiente función de prueba la haremos con un cursor explicito.
    FOR registro IN (
        SELECT dni_input, es_valido, numero, letra FROM dni_test_data_ok
    ) LOOP
        numero_casos_total := numero_casos_total + 1;
        -- Aqui es donde pongo lo que quiero hacer con cada registro
        -- Llamo a mi procedimiento validar_dni
        DECLARE -- Con este bloque DECLARE puedo definir variables locales
                -- Que tiene un ámbito de aplicación/vida más limitado
                -- Solo dentro de este bloque BEGIN...END
            resultado_validacion    BOOLEAN;
            resultado_numero        NUMBER;
            resultado_letra         CHAR(1);
        BEGIN
            dni_utils.validar_dni(
                registro.dni_input,
                resultado_validacion,
                resultado_numero,
                resultado_letra
            );
            -- Ahora comparo los resultados obtenidos con los esperados
            IF resultado_validacion != (registro.es_valido = 1) THEN
                numero_casos_fallidos := numero_casos_fallidos + 1;
                -- BDMS_OUTPUT.PUT_LINE(MENSAJE) Esta función me permite mostrar mensajes en la consola de SQL*Plus
                DBMS_OUTPUT.PUT_LINE('FALLO EN validar_dni con DNI=' || registro.dni_input || 
                                     ': se esperaba es_valido=' || registro.es_valido || 
                                     ', pero se obtuvo es_valido=' || CASE WHEN resultado_validacion THEN '1' ELSE '0' END);
            ELSIF resultado_validacion = TRUE THEN
                -- Solo comparo numero y letra si el DNI es válido
                IF resultado_numero != registro.numero THEN
                    numero_casos_fallidos := numero_casos_fallidos + 1;
                    DBMS_OUTPUT.PUT_LINE('FALLO EN validar_dni con DNI=' || registro.dni_input || 
                                         ': se esperaba numero=' || registro.numero || 
                                         ', pero se obtuvo numero=' || resultado_numero);
                ELSIF resultado_letra != registro.letra THEN
                    numero_casos_fallidos := numero_casos_fallidos + 1;
                    DBMS_OUTPUT.PUT_LINE('FALLO EN validar_dni con DNI=' || registro.dni_input || 
                                         ': se esperaba letra=' || registro.letra || 
                                         ', pero se obtuvo letra=' || resultado_letra);
                END IF;
            END IF;
        END;
    END LOOP;
    numero_casos_exitosos := numero_casos_total - numero_casos_fallidos;
    DBMS_OUTPUT.PUT_LINE('Pruebas de validar_dni - casos OK: FINALIZADAS');
    DBMS_OUTPUT.PUT_LINE('Resumen de resultados: ');
    DBMS_OUTPUT.PUT_LINE('. Casos totales: ' || numero_casos_total );
    DBMS_OUTPUT.PUT_LINE('. Casos exitosos: ' || numero_casos_exitosos );
    DBMS_OUTPUT.PUT_LINE('. Casos fallidos: ' || numero_casos_fallidos );

    IF numero_casos_fallidos = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pruebas de validar_dni - casos OK: EXITOSAS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pruebas de validar_dni - casos OK: FALLIDAS');
    END IF;
    RETURN CASE (numero_casos_exitosos = numero_casos_total)
           WHEN TRUE THEN 1
           ELSE 0
           END;
END ;
/

CREATE OR REPLACE FUNCTION test_validar_dnis_nok RETURN NUMBER IS
  numero_casos_total        NUMBER := 0;
  numero_casos_fallidos     NUMBER := 0;
  numero_casos_exitosos     NUMBER := 0;
  -- Definimos un cursor explícito para recorrer los casos de prueba NOK
  -- Es una variable de tipo cursor, que apuntará al resultado de la consulta SQL
  CURSOR cursor_nok IS      SELECT dni_input FROM dni_test_data_nok;
  -- Definimos una variable para almacenar cada registro (fila) del cursor
  -- El tipo de dato de esta variable será el mismo que el de las filas devueltas por el cursor:   %ROWTYPE
  registro cursor_nok%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pruebas de validar_dni - casos NOK: EN PROGRESO');
    -- Abrimos el cursor explícito
    OPEN cursor_nok;
    -- Itero, en un bucle infinito, leyendo cada registro del cursor
    LOOP
        -- Extraigo el siguiente registro del cursor
        FETCH cursor_nok INTO registro;
        -- Si no hay más registros, salgo del bucle infinito
        EXIT WHEN cursor_nok%NOTFOUND;
        -- A partir de ahi, opero con la variable registro, que contiene la fila actual
        numero_casos_total := numero_casos_total + 1;
        -- Aqui es donde pongo lo que quiero hacer con cada registro
        -- Llamo a mi procedimiento validar_dni
        DECLARE -- Con este bloque DECLARE puedo definir variables locales
                -- Que tiene un ámbito de aplicación/vida más limitado
                -- Solo dentro de este bloque BEGIN...END
            resultado_validacion    BOOLEAN;
            resultado_numero        NUMBER;
            resultado_letra         CHAR(1);
        BEGIN
            dni_utils.validar_dni(
                registro.dni_input,
                resultado_validacion,
                resultado_numero,
                resultado_letra
            );
            -- Ahora comparo los resultados obtenidos con los esperados
            IF resultado_validacion != FALSE THEN
                numero_casos_fallidos := numero_casos_fallidos + 1;
                -- BDMS_OUTPUT.PUT_LINE(MENSAJE) Esta función me permite mostrar mensajes en la consola de SQL*Plus
                DBMS_OUTPUT.PUT_LINE('FALLO EN validar_dni con DNI=' || registro.dni_input || 
                                     ': se esperaba es_valido=' || 0 || 
                                     ', pero se obtuvo es_valido=' || CASE WHEN resultado_validacion THEN '1' ELSE '0' END);
            END IF;
        END;
    END LOOP;
    -- Cerramos el cursor explícito
    CLOSE cursor_nok;
    numero_casos_exitosos := numero_casos_total - numero_casos_fallidos;
    DBMS_OUTPUT.PUT_LINE('Pruebas de validar_dni - casos NOK: FINALIZADAS');
    DBMS_OUTPUT.PUT_LINE('Resumen de resultados: ');
    DBMS_OUTPUT.PUT_LINE('. Casos totales: ' || numero_casos_total );
    DBMS_OUTPUT.PUT_LINE('. Casos exitosos: ' || numero_casos_exitosos );
    DBMS_OUTPUT.PUT_LINE('. Casos fallidos: ' || numero_casos_fallidos );

    IF numero_casos_fallidos = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pruebas de validar_dni - casos NOK: EXITOSAS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pruebas de validar_dni - casos NOK: FALLIDAS');
    END IF;
    RETURN CASE (numero_casos_exitosos = numero_casos_total)
           WHEN TRUE THEN 1
           ELSE 0
           END;
END ;
/


CREATE OR REPLACE FUNCTION test_es_valido_dni_sql_ok RETURN NUMBER IS
  numero_casos_total        NUMBER := 0;
  numero_casos_fallidos     NUMBER := 0;
  numero_casos_exitosos     NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pruebas de es_dni_valido - casos OK: EN PROGRESO');
    FOR registro IN (
        SELECT dni_input, es_valido, dni_utils.es_dni_valido(dni_input) as resultado FROM dni_test_data_ok
    ) LOOP
        numero_casos_total := numero_casos_total + 1;
            IF registro.resultado != registro.es_valido THEN
                numero_casos_fallidos := numero_casos_fallidos + 1;
                DBMS_OUTPUT.PUT_LINE('FALLO EN es_dni_valido con DNI=' || registro.dni_input || 
                                     ': se esperaba es_valido=' || registro.es_valido || 
                                     ', pero se obtuvo es_valido=' || registro.resultado);
            END IF;
    END LOOP;
    numero_casos_exitosos := numero_casos_total - numero_casos_fallidos;
    DBMS_OUTPUT.PUT_LINE('Pruebas de es_dni_valido - casos OK: FINALIZADAS');
    DBMS_OUTPUT.PUT_LINE('Resumen de resultados: ');
    DBMS_OUTPUT.PUT_LINE('. Casos totales: ' || numero_casos_total );
    DBMS_OUTPUT.PUT_LINE('. Casos exitosos: ' || numero_casos_exitosos );
    DBMS_OUTPUT.PUT_LINE('. Casos fallidos: ' || numero_casos_fallidos );

    IF numero_casos_fallidos = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pruebas de es_dni_valido - casos OK: EXITOSAS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pruebas de es_dni_valido - casos OK: FALLIDAS');
    END IF;
    RETURN CASE (numero_casos_exitosos = numero_casos_total)
           WHEN TRUE THEN 1
           ELSE 0
           END;
END;
/


CREATE OR REPLACE FUNCTION test_es_valido_dni_sql_nok RETURN NUMBER IS
  numero_casos_total        NUMBER := 0;
  numero_casos_fallidos     NUMBER := 0;
  numero_casos_exitosos     NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pruebas de es_dni_valido - casos NOK: EN PROGRESO');
    FOR registro IN (
        SELECT dni_input, es_valido, dni_utils.es_dni_valido(dni_input) as resultado FROM dni_test_data_nok
    ) LOOP
        numero_casos_total := numero_casos_total + 1;
            IF registro.resultado != registro.es_valido THEN
                numero_casos_fallidos := numero_casos_fallidos + 1;
                DBMS_OUTPUT.PUT_LINE('FALLO EN es_dni_valido con DNI=' || registro.dni_input || 
                                     ': se esperaba es_valido=' || registro.es_valido || 
                                     ', pero se obtuvo es_valido=' || registro.resultado);
            END IF;
    END LOOP;
    numero_casos_exitosos := numero_casos_total - numero_casos_fallidos;
    DBMS_OUTPUT.PUT_LINE('Pruebas de es_dni_valido - casos NOK: FINALIZADAS');
    DBMS_OUTPUT.PUT_LINE('Resumen de resultados: ');
    DBMS_OUTPUT.PUT_LINE('. Casos totales: ' || numero_casos_total );
    DBMS_OUTPUT.PUT_LINE('. Casos exitosos: ' || numero_casos_exitosos );
    DBMS_OUTPUT.PUT_LINE('. Casos fallidos: ' || numero_casos_fallidos );

    IF numero_casos_fallidos = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pruebas de es_dni_valido - casos NOK: EXITOSAS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pruebas de es_dni_valido - casos NOK: FALLIDAS');
    END IF;
    RETURN CASE (numero_casos_exitosos = numero_casos_total)
           WHEN TRUE THEN 1
           ELSE 0
           END;
END;
/




CREATE OR REPLACE FUNCTION test_normalizar_dni_sql_ok RETURN NUMBER IS
  numero_casos_total        NUMBER := 0;
  numero_casos_fallidos     NUMBER := 0;
  numero_casos_exitosos     NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pruebas de normalizar_dni - casos OK: EN PROGRESO');
    FOR registro IN (
        SELECT dni_input, dni_utils.normalizar_dni(dni_input) as resultado FROM dni_test_data_ok
    ) LOOP
    -- TODO
    END LOOP;
    numero_casos_exitosos := numero_casos_total - numero_casos_fallidos;
    DBMS_OUTPUT.PUT_LINE('Pruebas de normalizar_dni - casos OK: FINALIZADAS');
    DBMS_OUTPUT.PUT_LINE('Resumen de resultados: ');
    DBMS_OUTPUT.PUT_LINE('. Casos totales: ' || numero_casos_total );
    DBMS_OUTPUT.PUT_LINE('. Casos exitosos: ' || numero_casos_exitosos );
    DBMS_OUTPUT.PUT_LINE('. Casos fallidos: ' || numero_casos_fallidos );

    IF numero_casos_fallidos = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pruebas de normalizar_dni - casos OK: EXITOSAS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pruebas de normalizar_dni - casos OK: FALLIDAS');
    END IF;
    RETURN CASE (numero_casos_exitosos = numero_casos_total)
           WHEN TRUE THEN 1
           ELSE 0
           END;
END;
/




CREATE OR REPLACE FUNCTION test_normalizar_dni_sql_nok RETURN NUMBER IS
  numero_casos_total        NUMBER := 0;
  numero_casos_fallidos     NUMBER := 0;
  numero_casos_exitosos     NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pruebas de normalizar_dni - casos NOK: EN PROGRESO');
    FOR registro IN (
        SELECT dni_input, dni_utils.normalizar_dni(dni_input) as resultado FROM dni_test_data_nok
    ) LOOP
        numero_casos_total := numero_casos_total + 1;
            IF registro.resultado IS NOT NULL THEN
                numero_casos_fallidos := numero_casos_fallidos + 1;
                DBMS_OUTPUT.PUT_LINE('FALLO EN normalizar_dni con DNI=' || registro.dni_input || 
                                     ': se esperaba = NULL' || 
                                     ', pero se obtuvo =' || registro.resultado);
            END IF;
    END LOOP;
    numero_casos_exitosos := numero_casos_total - numero_casos_fallidos;
    DBMS_OUTPUT.PUT_LINE('Pruebas de normalizar_dni - casos NOK: FINALIZADAS');
    DBMS_OUTPUT.PUT_LINE('Resumen de resultados: ');
    DBMS_OUTPUT.PUT_LINE('. Casos totales: ' || numero_casos_total );
    DBMS_OUTPUT.PUT_LINE('. Casos exitosos: ' || numero_casos_exitosos );
    DBMS_OUTPUT.PUT_LINE('. Casos fallidos: ' || numero_casos_fallidos );

    IF numero_casos_fallidos = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pruebas de normalizar_dni - casos NOK: EXITOSAS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pruebas de normalizar_dni - casos NOK: FALLIDAS');
    END IF;
    RETURN CASE (numero_casos_exitosos = numero_casos_total)
           WHEN TRUE THEN 1
           ELSE 0
           END;
END;
/


-- Ejecuto la función de prueba

DECLARE
    resultado NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Iniciando ejecución de pruebas para el paquete dni_utils');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
    resultado := test_validar_dnis_ok;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
    resultado := resultado + test_validar_dnis_nok;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
    resultado := resultado + test_es_valido_dni_sql_ok;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
    resultado := resultado + test_es_valido_dni_sql_nok;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
    resultado := resultado + test_normalizar_dni_sql_ok;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
    resultado := resultado + test_normalizar_dni_sql_nok;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');    
    IF resultado = 6 THEN
        DBMS_OUTPUT.PUT_LINE('RESUMEN: Todas las pruebas del paquete dni_utils han sido exitosas.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('RESUMEN: Algunas pruebas del paquete dni_utils han fallado.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
END;
/

-- Limpieza de datos de prueba

DROP TABLE dni_test_data_ok;
