------------------------------------------------------------------------------------------------
-- DNI_UTILS Package Body
------------------------------------------------------------------------------------------------
-- Implementación del paquete de utilidades para DNIs españoles
------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY dni_utils IS

    ------------------------------------------------------------------------------------------------
    -- CONSTANTES PRIVADAS
    ------------------------------------------------------------------------------------------------
    letras_validas      CONSTANT VARCHAR2(23)  := 'TRWAGMYFPDXBNJZSQVHLCKE';
    patron_dni          CONSTANT VARCHAR2(100) := '^(([0-9]{1,8})|([0-9]{1,2}([.][0-9]{3}){2})|([0-9]{1,3}[.][0-9]{3}))[ -]?[A-Za-z]$';
    patron_no_numerico  CONSTANT VARCHAR2(100) := '[^0-9]';

    ------------------------------------------------------------------------------------------------
    -- VALIDAR_DNI
    -- Implementación del procedimiento de validación
    ------------------------------------------------------------------------------------------------
    PROCEDURE validar_dni (
        dni IN VARCHAR2,
        valido OUT BOOLEAN,
        numero OUT NUMBER,
        letra OUT CHAR
    )
    IS
        letra_correcta CHAR(1);
    BEGIN
        -- Inicializar valores por defecto
        valido := FALSE;
        numero := NULL;
        letra  := NULL;

        -- Validar entrada NULL
        IF dni IS NULL THEN
            RETURN;
        END IF;

        -- Validar formato mediante expresión regular
        IF NOT REGEXP_LIKE(dni, patron_dni) THEN
            RETURN;
        END IF;

        -- Extraer número (eliminando caracteres no numéricos)
        numero := TO_NUMBER(REGEXP_REPLACE(dni, patron_no_numerico, ''));

        -- Extraer letra (último carácter en mayúsculas)
        letra := SUBSTR(dni, -1, 1);

        -- Calcular letra correcta según algoritmo DNI
        -- Índice: MOD(numero, 23) + 1 (SUBSTR inicia en 1)
        letra_correcta := SUBSTR(letras_validas, MOD(numero, 23) + 1, 1);

        -- Verificar correspondencia de la letra
        valido := (letra = letra_correcta);
    END;

    ------------------------------------------------------------------------------------------------
    -- ES_DNI_VALIDO
    -- Wrapper de validar_dni para uso en SQL
    --
    -- Nota: SQL no soporta tipo BOOLEAN, por lo que devuelve NUMBER (1=válido, 0=inválido)
    ------------------------------------------------------------------------------------------------
    FUNCTION es_dni_valido (
        dni IN VARCHAR2
    ) RETURN NUMBER
    IS
        dni_valido BOOLEAN;
        dni_numero NUMBER(8);
        dni_letra  CHAR(1);
    BEGIN
        validar_dni(dni, dni_valido, dni_numero, dni_letra);
        
        -- Convertir BOOLEAN a NUMBER para compatibilidad SQL
        RETURN CASE 
                WHEN dni_valido THEN 1
                ELSE 0
            END;
    END;

    ------------------------------------------------------------------------------------------------
    -- NORMALIZAR_DNI
    -- Convierte DNI a formato estándar según parámetros
    --
    -- Ejemplo de uso:
    --   SELECT normalizar_dni('12345678Z', 1, '-', 1, 0) FROM DUAL;
    --   Resultado: 12345678-Z
    ------------------------------------------------------------------------------------------------
    FUNCTION normalizar_dni (
        dni                 IN VARCHAR2,
        rellenar_con_ceros  IN NUMBER   DEFAULT 1,
        separador           IN VARCHAR2 DEFAULT '',
        letra_mayuscula     IN NUMBER   DEFAULT 1,
        puntos_en_numero    IN NUMBER   DEFAULT 0
    ) RETURN VARCHAR2
    IS
        dni_valido         BOOLEAN;
        dni_numero         NUMBER(8);
        dni_letra          CHAR(1);
        letra_normalizada  CHAR(1);
        numero_normalizado VARCHAR2(11);
    BEGIN
        -- Validar DNI
        validar_dni(dni, dni_valido, dni_numero, dni_letra);
        IF NOT dni_valido THEN
            RETURN NULL;
        END IF;

        -- Normalizar número
        numero_normalizado := TO_CHAR(dni_numero);
        
        IF puntos_en_numero = 1 THEN
            -- Aplicar formato con separadores de miles
            -- Formato: 00G000G000 rellena con ceros, 99G999G999 sin relleno
            IF rellenar_con_ceros = 1 THEN
                numero_normalizado := TO_CHAR(dni_numero, '00G000G000');
            ELSE
                numero_normalizado := TO_CHAR(dni_numero, '99G999G999');
            END IF;
        ELSE 
            -- Sin puntos: rellenar con LPAD si se solicita
            IF rellenar_con_ceros = 1 THEN
                numero_normalizado := LPAD(numero_normalizado, 8, '0');
            END IF;
        END IF;

        -- Normalizar letra (mayúscula/minúscula)
        -- Uso de CASE como expresión (alternativa a IF/THEN/ELSE como statement)
        letra_normalizada := CASE 
                                WHEN letra_mayuscula = 1 THEN UPPER(dni_letra)
                                ELSE LOWER(dni_letra)
                            END;

        -- Ensamblar resultado
        RETURN numero_normalizado || separador || letra_normalizada;
    END;
END dni_utils;
/


