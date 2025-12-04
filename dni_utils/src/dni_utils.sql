------------------------------------------------------------------------------------------------
-- DNI_UTILS Package
------------------------------------------------------------------------------------------------
-- Paquete de utilidades para la validación y normalización de DNIs españoles.
--
-- Formato DNI: 1-8 dígitos + letra mayúscula (puntos y guiones opcionales)
--
-- Optimización de almacenamiento:
--   - VARCHAR2(9):         9 bytes (1 byte por carácter)
--   - NUMBER(8) + CHAR(1): 5 bytes (1 byte por cada 2 dígitos + 1 byte para letra)
--   Recomendación: Valorar optimización con grandes volúmenes (>10M registros)
------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE dni_utils IS
    ------------------------------------------------------------------------------------------------
    -- VALIDAR_DNI
    -- Valida un DNI español y extrae sus componentes (número y letra)
    --
    -- Parámetros:
    --   dni        IN  VARCHAR2   DNI a validar
    --   valido     OUT BOOLEAN    TRUE si el DNI es válido
    --   numero     OUT NUMBER     Número del DNI (solo si es válido)
    --   letra      OUT CHAR       Letra del DNI (solo si es válido)
    -- Nota:
    --   Este procedimiento trabaja con el tipo de dato BOOLEAN, por lo que solo puede ser llamado
    --   desde PL/SQL (por ejemplo desde triggers o procedimientos almacenados).
    ------------------------------------------------------------------------------------------------
    PROCEDURE validar_dni (
        dni IN VARCHAR2,
        valido OUT BOOLEAN,
        numero OUT NUMBER,
        letra OUT CHAR
    );

    ------------------------------------------------------------------------------------------------
    -- ES_DNI_VALIDO
    -- Verifica si un DNI tiene formato y letra correctos
    --
    -- Parámetros:
    --   dni        IN  VARCHAR2   DNI a validar
    --
    -- Retorna:
    --   NUMBER     1 si es válido, 0 en caso contrario
    ------------------------------------------------------------------------------------------------
    FUNCTION es_dni_valido (
        dni IN VARCHAR2
    ) RETURN NUMBER;

    ------------------------------------------------------------------------------------------------
    -- NORMALIZAR_DNI
    -- Convierte un DNI a un formato estándar según parámetros especificados
    --
    -- Parámetros:
    --   dni                 IN VARCHAR2   DNI a normalizar
    --   rellenar_con_ceros  IN NUMBER     1=rellenar con ceros, 0=no rellenar (default: 1)
    --   separador           IN VARCHAR2   Separador número-letra: '-', ' ' o '' (default: '')
    --   letra_mayuscula     IN NUMBER     1=mayúscula, 0=minúscula (default: 1)
    --   puntos_en_numero    IN NUMBER     1=formato con puntos, 0=sin puntos (default: 0)
    --
    -- Retorna:
    --   VARCHAR2   DNI normalizado o NULL si no es válido
    ------------------------------------------------------------------------------------------------
    FUNCTION normalizar_dni (
        dni                 IN VARCHAR2,
        rellenar_con_ceros  IN NUMBER   DEFAULT 1,
        separador           IN VARCHAR2 DEFAULT '',
        letra_mayuscula     IN NUMBER   DEFAULT 1,
        puntos_en_numero    IN NUMBER   DEFAULT 0
    ) RETURN VARCHAR2;

END dni_utils;
/




