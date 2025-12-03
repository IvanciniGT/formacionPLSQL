
CREATE OR REPLACE PROCEDURE validar_dni (
    dni IN VARCHAR2,
    valido OUT BOOLEAN,
    numero OUT NUMBER,
    letra OUT CHAR
)
IS
    -- Declaración de variables locales
    letras_validas      CONSTANT    VARCHAR2(23) := 'TRWAGMYFPDXBNJZSQVHLCKE';
    patron_dni          CONSTANT    VARCHAR2(100) := '^(([0-9]{1,8})|([0-9]{1,2}([.][0-9]{3}){2})|([0-9]{1,3}[.][0-9]{3}))[ -]?[A-Za-z]$';
    patron_no_numerico  CONSTANT    VARCHAR2(100) := '[^0-9]';
    letra_correcta                  CHAR(1);
BEGIN
    valido := FALSE; -- Valor por defecto
    -- Cuerpo de la función
    IF dni IS NULL THEN
        RETURN ;
    END IF;
    -- Validar si tiene pinta de DNI (Expresión regular)
    -- Si no tiene pinta, devolver FALSE
    IF NOT REGEXP_LIKE(dni, patron_dni) THEN
        RETURN ;
    END IF;
    -- Si si tiene pinta de dni: Debo verificar la letra
    -- Extraer el número, quitando puntos y guiones, espacios y cogiendo solo los dígitos
    -- Reemplazamos todo lo que haya en el texto que no sean dígitos por nada
    numero := TO_NUMBER(REGEXP_REPLACE(dni, patron_no_numerico, '')); -- Todo lo que no sean números me lo como!
    -- Extraer la letra (último carácter)
    letra := UPPER(SUBSTR(dni, -1, 1)); -- Tomo un caracter(1) desde el último (-1)... y además transformo a mayúsculas
    -- Calcular la letra correcta que debería traer ese dni, en base al número
    letra_correcta := SUBSTR(letras_validas, MOD(numero, 23) + 1, 1); -- +1 porque los índices en SUBSTR empiezan en 1
    -- Verificar que es la que se ha suminitrado
    valido := (letra = letra_correcta);
END;
/



CREATE OR REPLACE FUNCTION es_dni_valido (
    dni IN VARCHAR2
) RETURN NUMBER
IS
    dni_valido      BOOLEAN;
    dni_numero      NUMBER(8);
    dni_letra       CHAR(1);
BEGIN
    validar_dni(dni, dni_valido, dni_numero, dni_letra);
    --IF dni_valido THEN
    --    RETURN 1;
    --ELSE
    --    RETURN 0;
    --END IF;
    RETURN CASE 
               WHEN dni_valido THEN 1
               ELSE 0
           END;
END;
/



CREATE OR REPLACE FUNCTION normalizar_dni (
    dni                 IN VARCHAR2,
    rellenar_con_ceros  IN NUMBER   DEFAULT 1,
    separador           IN VARCHAR2 DEFAULT '',
    letra_mayuscula     IN NUMBER   DEFAULT 1,
    puntos_en_numero    IN NUMBER   DEFAULT 0
) RETURN VARCHAR2
IS
    dni_valido          BOOLEAN;
    dni_numero          NUMBER(8);
    dni_letra           CHAR(1);
    letra_normalizada   CHAR(1);
    numero_normalizado  VARCHAR2(11);
BEGIN
    validar_dni(dni, dni_valido, dni_numero, dni_letra);
    IF NOT dni_valido THEN
        RETURN NULL;
    END IF;
    -- Aquí realmente es donde normalizo el valor del DNI

    -- Normalización del número:
    numero_normalizado := TO_CHAR(dni_numero);
    -- Aplicar relleno con ceros a la izquierda si se ha pedido
    --IF rellenar_con_ceros = 1 THEN
        -- Opción 1                      0000000123
        -- Siempre le pongo delante 7 ceros y luego corto los que sobren
        -- numero_normalizado := SUBSTR('0000000' || numero_normalizado, -8, 8); -- Coge 8 (8), desde los 8 últimos (-8)
        -- Opción 2
    --    numero_normalizado := LPAD(numero_normalizado, 8, '0'); -- Rellenar por la izquierda hasta tener 8 caracteres con ceros
                                                                -- Otra función a conocer, similar es RPAD (rellena por la derecha)
    -- END IF;
    -- Aplicar los separadores de miles y millones
    IF puntos_en_numero = 1 THEN
        IF rellenar_con_ceros = 1 THEN
            numero_normalizado := TO_CHAR(dni_numero, '00G000G000');
        ELSE
            numero_normalizado := TO_CHAR(dni_numero, '99G999G999');
        END IF;
    ELSE 
        IF rellenar_con_ceros = 1 THEN
            numero_normalizado := LPAD(numero_normalizado, 8, '0');
        END IF;
    END IF;


    -- Normalización de la letra:

    -- OPCION 1, que ya conocíamos!
    -- IF letra_mayuscula = 1 THEN                   -- trabaja a nivel de statement: Es decir, lo que pongo dentro de las condiciones
    --                                           -- es un statement. Por ejemplo, en este caso hago una asignación
    --    letra_normalizada := UPPER(dni_letra);
    -- ELSE
    --    letra_normalizada := LOWER(dni_letra);
    -- END IF;
    -- OPCION 2: CASE:
    letra_normalizada := CASE                    -- trabaja a nivel de expresión: Lo que pongo dentro del CASE es una expresión
                                                 -- lo que asignamos en nuestro caso es el resultado de la expresión (CASE)
                             WHEN letra_mayuscula = 1 THEN UPPER(dni_letra)
                             ELSE LOWER(dni_letra)
                         END;


    -- empaqueto todo para devolverlo
    RETURN numero_normalizado || separador || letra_normalizada;
END;
/





SELECT 
    es_dni_valido('23000000T') AS dni_valido, 
    es_dni_valido('23000000t') AS dni_valido2, 
    es_dni_valido('23000000a') AS dni_valido3, 
    es_dni_valido('23000000 T') AS dni_valido4, 
    es_dni_valido('23000000 t') AS dni_valido5, 
    es_dni_valido('23.000.000T') AS dni_valido6, 
    es_dni_valido('23.000T') AS dni_valido7, 
    es_dni_valido('23.00.0000T') AS dni_valido8, 
    es_dni_valido('23000000$T') AS dni_valido9 
FROM 
    DUAL;



SELECT 
    normalizar_dni('23000000T') AS dni1, 
    normalizar_dni('23000000T', 1, '', 1, 0) AS dni2,
    normalizar_dni('23000000T', 1, '', 0, 0) AS dni3,
    normalizar_dni('23000000T', 0, '-', 1, 0) AS dni4,
    normalizar_dni('23000T', 1, ' ', 0, 1) AS dni5,
    normalizar_dni('23000000A') AS dni6
FROM 
    DUAL;