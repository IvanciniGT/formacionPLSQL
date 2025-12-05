-- Esto es para que SQL*Plus muestre los mensajes de DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

-- Cargamos los datos de prueba para el paquete dni_utils
@dni_utils.test.data.sql


CREATE GLOBAL TEMPORARY TABLE test_cases_ko (
    funcion_de_test_actual   VARCHAR2(100),
    dni_input                VARCHAR2(20),
    motivo                   VARCHAR2(100),
    valor_esperado           VARCHAR2(100),
    valor_obtenido           VARCHAR2(100)
) ON COMMIT PRESERVE ROWS;


-- Crear el paquete conteniendo las funciones de prueba
CREATE OR REPLACE PACKAGE dni_utils_test AS
    PROCEDURE run_tests;
END dni_utils_test;

--- Implementación del paquete de pruebas
CREATE OR REPLACE PACKAGE BODY dni_utils_test IS
    -- ------------------------------------------------------------------------------------------------
    -- Variables para conteo de las pruebas que voy realizando y de los casos exitosos/fallidos
    -- ------------------------------------------------------------------------------------------------
    numero_de_test_ejecutados             NUMBER := 0;
    numero_de_test_exitosos               NUMBER := 0;
    numero_de_test_fallidos               NUMBER := 0;

    funcion_de_test_actual                VARCHAR2(100);
    descripcion_test_actual               VARCHAR2(400);

    numero_casos_total_en_test_actual     NUMBER := 0;
    numero_casos_fallidos_en_test_actual  NUMBER := 0;
    numero_casos_exitosos_en_test_actual  NUMBER := 0;

    aux_boolean_resultado                 BOOLEAN;

    -- ------------------------------------------------------------------------------------------------
    -- Generación de logs:
    -- ------------------------------------------------------------------------------------------------
    
    PROCEDURE mostrar_logs_de_inicio_test IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Ejecutando test #' || numero_de_test_ejecutados || ': ' || descripcion_test_actual);
    END;

    PROCEDURE mostrar_logs_de_fin_test IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Ejecución finalizada del test #' || numero_de_test_ejecutados || ': ' || descripcion_test_actual);
        DBMS_OUTPUT.PUT_LINE('  Casos totales: ' || numero_casos_total_en_test_actual );
        DBMS_OUTPUT.PUT_LINE('  Casos exitosos: ' || numero_casos_exitosos_en_test_actual );
        DBMS_OUTPUT.PUT_LINE('  Casos fallidos: ' || numero_casos_fallidos_en_test_actual );
        IF numero_casos_fallidos_en_test_actual = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Test  #' || numero_de_test_ejecutados || ': ' || descripcion_test_actual || ' - EXITOSO');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Test  #' || numero_de_test_ejecutados || ': ' || descripcion_test_actual || ' - FALLIDO');
        END IF;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
    END;

    PROCEDURE log_test_case_error (
        p_funcion_de_test    IN VARCHAR2,
        p_dni_test_actual    IN VARCHAR2,
        p_mensaje_error      IN VARCHAR2,
        p_valor_esperado     IN VARCHAR2,
        p_valor_obtenido     IN VARCHAR2
    ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('FALLO EN ' || p_funcion_de_test || 
                             ' para el DNI=' || p_dni_test_actual ||
                             ': ' || p_mensaje_error ||
                             ' - se esperaba ' || p_valor_esperado || ', pero se obtuvo ' || p_valor_obtenido);
    END;

    PROCEDURE mostrar_log_de_inicio IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Iniciando ejecución de pruebas para el paquete dni_utils');
    END;

    PROCEDURE mostrar_log_de_fin IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Ejecución de pruebas para el paquete dni_utils finalizada:');
        DBMS_OUTPUT.PUT_LINE('  Número de tests ejecutados: ' || numero_de_test_ejecutados);
        DBMS_OUTPUT.PUT_LINE('  Número de tests exitosos: ' || numero_de_test_exitosos);
        DBMS_OUTPUT.PUT_LINE('  Número de tests fallidos: ' || numero_de_test_fallidos); 
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');    
        IF numero_de_test_fallidos = 0 THEN
            DBMS_OUTPUT.PUT_LINE('RESUMEN: Todas las pruebas del paquete dni_utils han sido EXITOSAS.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('RESUMEN: Algunas pruebas del paquete dni_utils han FALLADO.');
        END IF;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('  Detalle de casos fallidos:');

        -- Mostrar los datos que tengo en la tabla temporal test_cases_ko
        FOR registro IN (
            SELECT funcion_de_test_actual, dni_input, motivo, valor_esperado, valor_obtenido
            FROM test_cases_ko
        ) LOOP
            log_test_case_error(
                registro.funcion_de_test_actual,
                registro.dni_input,
                registro.motivo,
                registro.valor_esperado,
                registro.valor_obtenido
            );
        END LOOP;
        -- Cuando las pruebas finalicen.. y cierre la sesión.. se borrarán los datos de la tabla temporal automáticamente.

        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
    END;

    -- ------------------------------------------------------------------------------------------------
    -- Funciones de tipo Assert
    -- ------------------------------------------------------------------------------------------------

    PROCEDURE register_test_case_error (
        p_dni_test_actual    IN VARCHAR2,
        p_mensaje_error      IN VARCHAR2,
        p_valor_esperado     IN VARCHAR2,
        p_valor_obtenido     IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO test_cases_ko (
            funcion_de_test_actual,
            dni_input,
            motivo,
            valor_esperado,
            valor_obtenido
        ) VALUES (
            funcion_de_test_actual,
            p_dni_test_actual,
            p_mensaje_error,
            p_valor_esperado,
            p_valor_obtenido
        );
    END;

    PROCEDURE assert_equals (
        p_valor_esperado   IN BOOLEAN,
        p_valor_obtenido   IN BOOLEAN,
        dni_test_actual    IN VARCHAR2,
        p_mensaje_error    IN VARCHAR2,
        p_resultado OUT BOOLEAN
    )
    IS
    BEGIN
        numero_casos_total_en_test_actual := numero_casos_total_en_test_actual + 1;
        IF p_valor_esperado != p_valor_obtenido THEN
            numero_casos_fallidos_en_test_actual := numero_casos_fallidos_en_test_actual + 1;
            register_test_case_error(
                dni_test_actual,
                p_mensaje_error,
                CASE WHEN p_valor_esperado THEN 'TRUE' ELSE 'FALSE' END,
                CASE WHEN p_valor_obtenido THEN 'TRUE' ELSE 'FALSE' END
            );
            p_resultado := FALSE;
        END IF;
        p_resultado := TRUE;
    END;

     PROCEDURE assert_equals (
        p_valor_esperado   IN NUMBER,
        p_valor_obtenido   IN NUMBER,
        dni_test_actual    IN VARCHAR2,
        p_mensaje_error    IN VARCHAR2,
        p_resultado OUT BOOLEAN
    ) IS
    BEGIN
        numero_casos_total_en_test_actual := numero_casos_total_en_test_actual + 1;
        IF p_valor_esperado != p_valor_obtenido THEN
            numero_casos_fallidos_en_test_actual := numero_casos_fallidos_en_test_actual + 1;
            register_test_case_error(
                dni_test_actual,
                p_mensaje_error,
                TO_CHAR(p_valor_esperado),
                TO_CHAR(p_valor_obtenido)
            );
            p_resultado := FALSE;
        END IF;
        p_resultado := TRUE;
    END;

    PROCEDURE assert_equals (
        p_valor_esperado   IN VARCHAR2,
        p_valor_obtenido   IN VARCHAR2,
        dni_test_actual    IN VARCHAR2,
        p_mensaje_error    IN VARCHAR2,
        p_resultado OUT BOOLEAN
    ) IS
    BEGIN
        numero_casos_total_en_test_actual := numero_casos_total_en_test_actual + 1;
        IF p_valor_esperado != p_valor_obtenido THEN
            numero_casos_fallidos_en_test_actual := numero_casos_fallidos_en_test_actual + 1;
            register_test_case_error(
                dni_test_actual,
                p_mensaje_error,
                p_valor_esperado,
                p_valor_obtenido
            );
            p_resultado := FALSE;
        END IF;
        p_resultado := TRUE;
    END;

    -- ------------------------------------------------------------------------------------------------
    -- Funciones auxiliares para la ejecución de tests
    -- ------------------------------------------------------------------------------------------------


    PROCEDURE reiniciar_contadores  (
        p_funcion_de_test_actual            VARCHAR2,
        p_descripcion_test_actual           VARCHAR2
    ) IS
    BEGIN
        funcion_de_test_actual                  := p_funcion_de_test_actual;
        descripcion_test_actual                 := p_descripcion_test_actual;
        numero_casos_total_en_test_actual       := 0;
        numero_casos_fallidos_en_test_actual    := 0;
        numero_casos_exitosos_en_test_actual    := 0;
        numero_de_test_ejecutados               := numero_de_test_ejecutados + 1;
    END;

    PROCEDURE ejecutar_funcion_test IS BEGIN
        -- Ejecuto la función/procedimiento que tenga por nombre p_funcion_de_test_actual
        -- A priori no puedo ejecutar una función por su nombre en una variable.
        -- Pero hay un comando EXECUTE IMMEDIATE, que me permite ejecutar código dinámico.
        -- A este comando le puedo pasar un texto con el código PL/SQL a ejecutar.
        EXECUTE IMMEDIATE 'BEGIN dni_utils_test.' || funcion_de_test_actual || '; END;';
        numero_casos_exitosos_en_test_actual := numero_casos_total_en_test_actual - numero_casos_fallidos_en_test_actual;
        -- OJO con el EXECUTE IMMEDIATE: Puede ser un hueco de seguridad GRANDE si se usa con datos de usuario.
        -- En nuestro caso, tengo eso en un procedimiento PRIVADO de mi paquete... eso me da toda la tranquilidad que necesito.
        IF numero_casos_fallidos_en_test_actual = 0 THEN
            numero_de_test_exitosos := numero_de_test_exitosos + 1;
        ELSE
            numero_de_test_fallidos := numero_de_test_fallidos + 1;
        END IF;        
    END;

    PROCEDURE ejecutar_test (
        p_funcion_de_test_actual            VARCHAR2,
        p_descripcion_test_actual           VARCHAR2
    ) IS
    BEGIN
        reiniciar_contadores( p_funcion_de_test_actual, p_descripcion_test_actual );
        -- Generamos entradas en el log:
        mostrar_logs_de_inicio_test;
        ejecutar_funcion_test;
        mostrar_logs_de_fin_test;
    END;

    PROCEDURE ejecutar_cada_test IS BEGIN
        ejecutar_test('test_validar_dni_ok', 'Pruebas de el procedimiento validar_dni con datos correctos');
        ejecutar_test('test_validar_dni_ko', 'Pruebas de el procedimiento validar_dni con datos incorrectos');
        ejecutar_test('test_es_dni_valido_ok', 'Pruebas de la función es_dni_valido con datos correctos');
        ejecutar_test('test_es_dni_valido_ko', 'Pruebas de la función es_dni_valido con datos incorrectos');
        ejecutar_test('test_normalizar_dni_ok', 'Pruebas de la función normalizar_dni con datos correctos');
        ejecutar_test('test_normalizar_dni_ko', 'Pruebas de la función normalizar_dni con datos incorrectos');
    END;

    PROCEDURE run_tests IS BEGIN
        mostrar_log_de_inicio;
        ejecutar_cada_test;
        mostrar_log_de_fin;
    END;

    -- En PLSQL existe ya un paquete estándar para poder hacer pruebas unitarias: UTL_UNIT.
    -- Que incluye montonón de funciones de tipo assert_equals, assert_not_null, etc.
    -- Y trae sus propias fuinciones de logging, de ejecución de tests, etc.
    -- Pero nosotros nos hemos creado nuestro propio framework de testing para entender mejor cómo funciona todo esto "bajo el capó".

    -- ------------------------------------------------------------------------------------------------
    -- Implementación de los tests individuales
    -- ------------------------------------------------------------------------------------------------

    PROCEDURE test_validar_dni_ok IS BEGIN
        FOR registro IN (
            SELECT dni_input, numero, letra FROM dni_test_data_ok
        ) LOOP
            DECLARE
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
                assert_equals(  TRUE, resultado_validacion, registro.dni_input, 'Validación fallida. Falso negativo.' , aux_boolean_resultado );
                IF aux_boolean_resultado THEN
                    assert_equals( registro.numero, resultado_numero, registro.dni_input, 'Número incorrecto.', aux_boolean_resultado );
                    IF aux_boolean_resultado THEN
                        assert_equals( registro.letra, resultado_letra, registro.dni_input, 'Letra incorrecta.', aux_boolean_resultado );
                    END IF;
                END IF;

            END;
        END LOOP;
    END;

    PROCEDURE test_validar_dni_ko IS 
        CURSOR cursor_nok IS      SELECT dni_input FROM dni_test_data_nok;
        registro cursor_nok%ROWTYPE;
    BEGIN
        OPEN cursor_nok;
        LOOP
            FETCH cursor_nok INTO registro;
            EXIT WHEN cursor_nok%NOTFOUND;

            DECLARE
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
                assert_equals( FALSE, resultado_validacion, registro.dni_input, 'Validación fallida. Falso positivo.' , aux_boolean_resultado );
            END;
        END LOOP;
        CLOSE cursor_nok;
    END;

    PROCEDURE test_es_dni_valido_ok IS BEGIN
        FOR registro IN (
            SELECT dni_input, dni_utils.es_dni_valido(dni_input) as resultado FROM dni_test_data_ok
        ) LOOP
            assert_equals( 1, registro.resultado, registro.dni_input, 'Validación fallida. Falso negativo.', aux_boolean_resultado );
        END LOOP;
    END;

    PROCEDURE test_es_dni_valido_ko IS BEGIN
        FOR registro IN (
            SELECT dni_input, dni_utils.es_dni_valido(dni_input) as resultado FROM dni_test_data_nok
        ) LOOP
            assert_equals( 0, registro.resultado, registro.dni_input, 'Validación fallida. Falso positivo.' , aux_boolean_resultado );
        END LOOP;
    END;

    PROCEDURE test_normalizar_dni_ko IS BEGIN
        FOR registro IN (
            SELECT dni_input, dni_utils.normalizar_dni(dni_input) as resultado FROM dni_test_data_nok
        ) LOOP
            assert_equals( NULL, registro.resultado, registro.dni_input, 'Normalización fallida. Se esperaba NULL para DNI inválido.', aux_boolean_resultado );
        END LOOP;
    END;

    PROCEDURE test_normalizar_dni_ok IS BEGIN
        FOR registro IN (
            SELECT dni_input,
                   dni_utils.normalizar_dni(dni_input, 0, '', 1, 0) AS normalizacion_basica_resultado,
                   normalizacion_basica,
                   dni_utils.normalizar_dni(dni_input, 1, '', 1, 0) AS normalizacion_con_ceros_resultado,
                   normalizacion_con_ceros,
                   dni_utils.normalizar_dni(dni_input, 0, '-', 1, 0) AS normalizacion_con_guion_resultado,
                   normalizacion_con_guion,
                   dni_utils.normalizar_dni(dni_input, 0, '', 0, 0) AS normalizacion_minuscula_resultado,
                   normalizacion_minuscula,
                   dni_utils.normalizar_dni(dni_input, 0, '', 1, 1) AS normalizacion_con_puntos_resultado,
                   normalizacion_con_puntos,
                   dni_utils.normalizar_dni(dni_input, 1, '-', 0, 1) AS normalizacion_todo_resultado,
                   normalizacion_todo
            FROM dni_test_data_ok
        ) LOOP
            assert_equals(
                registro.normalizacion_basica,
                registro.normalizacion_basica_resultado,
                registro.dni_input,
                'Normalización básica fallida.',
                aux_boolean_resultado
            );
            assert_equals(
                registro.normalizacion_con_ceros,
                registro.normalizacion_con_ceros_resultado,
                registro.dni_input,
                'Normalización con ceros fallida.',
                aux_boolean_resultado
            );
            assert_equals(
                registro.normalizacion_con_guion,
                registro.normalizacion_con_guion_resultado,
                registro.dni_input,
                'Normalización con guion fallida.',
                aux_boolean_resultado
            );
            assert_equals(
                registro.normalizacion_minuscula,
                registro.normalizacion_minuscula_resultado,
                registro.dni_input,
                'Normalización en minúscula fallida.',
                aux_boolean_resultado
            );
            assert_equals(
                registro.normalizacion_con_puntos,
                registro.normalizacion_con_puntos_resultado,
                registro.dni_input,
                'Normalización con puntos fallida.',
                aux_boolean_resultado
            );
            assert_equals(
                registro.normalizacion_todo,
                registro.normalizacion_todo_resultado,
                registro.dni_input,
                'Normalización completa fallida.',
                aux_boolean_resultado
            );
        END LOOP;
    END;

END dni_utils_test;
/

-- Ejecutar las pruebas
BEGIN dni_utils_test.run_tests; END;

-- Limpieza de datos de prueba
DROP TABLE dni_test_data_ok;
