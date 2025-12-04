------------------------------------------------------------------------------------------------
-- DNI_UTILS - Test Data
------------------------------------------------------------------------------------------------
-- Conjunto de datos de prueba para validación automatizada del paquete dni_utils
--
-- Estructura:
--   - dni_input: Formato de entrada del DNI a validar
--   - es_valido: Resultado esperado (1=válido, 0=inválido)
--   - numero:    Número extraído esperado
--   - letra:     Letra extraída esperada (normalizada a mayúscula)
------------------------------------------------------------------------------------------------

CREATE TABLE dni_test_data_ok (
    dni_input VARCHAR2(15),
    es_valido NUMBER,
    numero    NUMBER,
    letra     CHAR(1)
);

-- DNIs válidos con 8 dígitos (formato estándar)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000000T', 1, 23000000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000000t', 1, 23000000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000000 T', 1, 23000000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000000 t', 1, 23000000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000000-T', 1, 23000000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000000-t', 1, 23000000, 'T');

-- DNIs válidos con 8 dígitos (formato con puntos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000.000T', 1, 23000000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000.000t', 1, 23000000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000.000 T', 1, 23000000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000.000 t', 1, 23000000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000.000-T', 1, 23000000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000.000-t', 1, 23000000, 'T');

-- DNIs válidos con 7 dígitos (sin ceros a la izquierda)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300000T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300000t', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300000 T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300000 t', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300000-T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300000-t', 1, 2300000, 'T');

-- DNIs válidos con 7 dígitos (con cero a la izquierda)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02300000T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02300000t', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02300000 T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02300000 t', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02300000-T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02300000-t', 1, 2300000, 'T');

-- DNIs válidos con 7 dígitos (formato con puntos, sin cero inicial)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2.300.000T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2.300.000t', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2.300.000 T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2.300.000 t', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2.300.000-T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2.300.000-t', 1, 2300000, 'T');

-- DNIs válidos con 7 dígitos (formato con puntos y cero inicial)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02.300.000T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02.300.000t', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02.300.000 T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02.300.000 t', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02.300.000-T', 1, 2300000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('02.300.000-t', 1, 2300000, 'T');

-- DNIs válidos con 6 dígitos (sin ceros a la izquierda)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230000T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230000t', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230000 T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230000 t', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230000-T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230000-t', 1, 230000, 'T');

-- DNIs válidos con 6 dígitos (con ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00230000T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00230000t', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00230000 T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00230000 t', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00230000-T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00230000-t', 1, 230000, 'T');

-- DNIs válidos con 6 dígitos (formato con puntos, sin ceros)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230.000T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230.000t', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230.000 T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230.000 t', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230.000-T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230.000-t', 1, 230000, 'T');

-- DNIs válidos con 6 dígitos (formato con puntos y ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.230.000T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.230.000t', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.230.000 T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.230.000 t', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.230.000-T', 1, 230000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.230.000-t', 1, 230000, 'T');

-- DNIs válidos con 5 dígitos (sin ceros a la izquierda)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000t', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000 T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000 t', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000-T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23000-t', 1, 23000, 'T');

-- DNIs válidos con 5 dígitos (con ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00023000T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00023000t', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00023000 T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00023000 t', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00023000-T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00023000-t', 1, 23000, 'T');

-- DNIs válidos con 5 dígitos (formato con puntos, sin ceros)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000t', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000 T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000 t', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000-T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23.000-t', 1, 23000, 'T');

-- DNIs válidos con 5 dígitos (formato con puntos y ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.023.000T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.023.000t', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.023.000 T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.023.000 t', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.023.000-T', 1, 23000, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.023.000-t', 1, 23000, 'T');

-- DNIs válidos con 4 dígitos (sin ceros a la izquierda)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300T', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300t', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300 T', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300 t', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300-T', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('2300-t', 1, 2300, 'T');

-- DNIs válidos con 4 dígitos (con ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00002300T', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00002300t', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00002300 T', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00002300 t', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00002300-T', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00002300-t', 1, 2300, 'T');

-- DNIs válidos con 4 dígitos (formato con puntos y ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.002.300T', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.002.300t', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.002.300 T', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.002.300 t', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.002.300-T', 1, 2300, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.002.300-t', 1, 2300, 'T');

-- DNIs válidos con 3 dígitos (sin ceros a la izquierda)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230t', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230 T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230 t', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230-T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230-t', 1, 230, 'T');

-- DNIs válidos con 3 dígitos (con ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000230T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000230t', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000230 T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000230 t', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000230-T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000230-t', 1, 230, 'T');

-- DNIs válidos con 3 dígitos (formato con puntos, sin ceros)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230t', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230 T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230 t', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230-T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('230-t', 1, 230, 'T');

-- DNIs válidos con 3 dígitos (formato con puntos y ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.230T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.230t', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.230 T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.230 t', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.230-T', 1, 230, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.230-t', 1, 230, 'T');

-- DNIs válidos con 2 dígitos (sin ceros a la izquierda)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23T', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23t', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23 T', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23 t', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23-T', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('23-t', 1, 23, 'T');

-- DNIs válidos con 2 dígitos (con ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000023T', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000023t', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000023 T', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000023 t', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000023-T', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000023-t', 1, 23, 'T');

-- DNIs válidos con 2 dígitos (formato con puntos y ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.023T', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.023t', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.023 T', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.023 t', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.023-T', 1, 23, 'T');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.023-t', 1, 23, 'T');

-- DNIs válidos con 1 dígito (MOD(1,23)=1 -> letra R, sin ceros a la izquierda)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('1R', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('1r', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('1 R', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('1 r', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('1-R', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('1-r', 1, 1, 'R');

-- DNIs válidos con 1 dígito (con ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000001R', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000001r', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000001 R', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000001 r', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000001-R', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00000001-r', 1, 1, 'R');

-- DNIs válidos con 1 dígito (formato con puntos y ceros hasta 8 dígitos)
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.001R', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.001r', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.001 R', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.001 r', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.001-R', 1, 1, 'R');
INSERT INTO dni_test_data_ok (dni_input, es_valido, numero, letra) VALUES ('00.000.001-r', 1, 1, 'R');

------------------------------------------------------------------------------------------------
-- DATOS DE PRUEBA INVÁLIDOS (DNIs NOK)
------------------------------------------------------------------------------------------------

CREATE TABLE dni_test_data_nok (
    dni_input           VARCHAR2(50),
    motivo_invalido     VARCHAR2(100)
);

-- DNIs con letra incorrecta (letra no corresponde al número)
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000A', 'Letra incorrecta para el número');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000Z', 'Letra incorrecta para el número');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23.000.000B', 'Letra incorrecta para el número');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('2300000-R', 'Letra incorrecta para el número');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('00023000K', 'Letra incorrecta para el número');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('1T', 'Letra incorrecta para el número (debería ser R)');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('00000001 T', 'Letra incorrecta para el número (debería ser R)');

-- DNIs con más de 8 dígitos
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('123456789T', 'Más de 8 dígitos');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('230000000T', 'Más de 8 dígitos');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('1234567890T', 'Más de 8 dígitos');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('999999999-Z', 'Más de 8 dígitos');

-- DNIs sin letra
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000', 'Sin letra');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('12345678', 'Sin letra');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23.000.000', 'Sin letra');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('00000001', 'Sin letra');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('1', 'Sin letra');

-- DNIs sin número (solo letra)
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('T', 'Solo letra, sin número');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('R', 'Solo letra, sin número');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('-T', 'Solo letra con separador');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES (' Z', 'Solo letra con separador');

-- DNIs con múltiples letras
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000TT', 'Múltiples letras');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000TR', 'Múltiples letras');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('12345678ABC', 'Múltiples letras');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('T23000000T', 'Letra al inicio y al final');

-- DNIs con caracteres especiales inválidos
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000@T', 'Carácter especial inválido');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23.000.000#T', 'Carácter especial inválido');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000$T', 'Carácter especial inválido');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23*000*000T', 'Carácter especial inválido');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23_000_000T', 'Carácter especial inválido');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23/000/000T', 'Separador inválido');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23,000,000T', 'Separador inválido (coma)');

-- DNIs con múltiples separadores
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000--T', 'Múltiples separadores');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000  T', 'Múltiples separadores (espacios)');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000- T', 'Múltiples separadores mixtos');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23-000-000T', 'Separadores en posiciones incorrectas');

-- DNIs con formato de puntos incorrecto
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('2.3.0.0.0.0.0.0T', 'Formato de puntos incorrecto');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('230.00.000T', 'Formato de puntos incorrecto');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000.000T', 'Formato de puntos incorrecto');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('2300.0000T', 'Formato de puntos incorrecto');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23.00.000T', 'Formato de puntos incorrecto');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('.23.000.000T', 'Punto al inicio');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23.000.000.T', 'Punto antes de letra');

-- DNIs con letras en posiciones numéricas
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('2300000OT', 'Letra O en lugar de 0');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23O00000T', 'Letra O en lugar de 0');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23I00000T', 'Letra I en lugar de 1');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('2300A000T', 'Letra A en parte numérica');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('A3000000T', 'Letra al inicio en parte numérica');

-- DNIs con números en posición de letra
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('230000001', 'Número en lugar de letra');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000-0', 'Número en lugar de letra');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('12345678 9', 'Número en lugar de letra');

-- DNIs con espacios en blanco al inicio o final
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES (' 23000000T', 'Espacio al inicio');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000T ', 'Espacio al final');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES (' 23000000T ', 'Espacios al inicio y final');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('  23000000T', 'Múltiples espacios al inicio');

-- DNIs con espacios en medio de los números
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23 000 000T', 'Espacios en medio de números');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('2 3000000T', 'Espacio en medio de números');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000 000T', 'Espacio en medio de números');

-- DNIs vacíos o NULL
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('', 'Cadena vacía');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES (NULL, 'Valor NULL');

-- DNIs con formato mixto incorrecto
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23.000000T', 'Formato mixto incorrecto');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000.000T', 'Formato mixto incorrecto');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23.0.00.000T', 'Formato mixto incorrecto');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('2.300.0000T', 'Formato mixto incorrecto');

-- DNIs demasiado cortos (sin dígitos suficientes para formato con puntos)
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('.000T', 'Formato con puntos incorrecto');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('0.000T', 'Formato con puntos incorrecto para 1 dígito');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('00.000T', 'Formato con puntos incorrecto para 2 dígitos');

-- DNIs con cero a la izquierda pero sin completar formato correcto
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('0.23.000T', 'Formato de puntos incorrecto con cero');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('000.230.000T', 'Formato de puntos con ceros incorrectos');

-- DNIs con letras no válidas en el algoritmo (aunque tengan formato correcto)
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000Ñ', 'Letra Ñ no válida');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000Ç', 'Letra Ç no válida');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('12345678Ü', 'Letra Ü no válida');

-- DNIs con formato casi correcto pero con pequeños errores
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('123456789', 'Sin letra y demasiados dígitos');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('0T', 'Sin número válido (solo cero)');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('00T', 'Sin número válido (solo ceros)');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('000000000T', 'Más de 8 dígitos (9 ceros)');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('00.000.000T', 'Todo ceros con formato');

-- DNIs con tabulaciones o caracteres no imprimibles
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000	T', 'Tabulación como separador');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000' || CHR(10) || 'T', 'Salto de línea');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000' || CHR(13) || 'T', 'Retorno de carro');

-- DNIs con números negativos
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('-23000000T', 'Número negativo');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('-1R', 'Número negativo');

-- DNIs con decimales o comas
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000,5T', 'Decimal con coma');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000000.5T', 'Decimal con punto');

-- DNIs con letras intermedias
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23T000000', 'Letra en medio de números');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('23000T000', 'Letra en medio de números');

-- DNIs con formato alfanumérico mixto
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('ABC123T', 'Letras antes de números');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('12AB34CD56T', 'Letras intercaladas');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('X23000000T', 'Letra X al inicio');

-- DNIs con paréntesis u otros delimitadores
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('(23000000)T', 'Paréntesis');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('[23000000]T', 'Corchetes');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('{23000000}T', 'Llaves');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('"23000000T"', 'Comillas');

-- DNIs con formato de otros países
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('X1234567T', 'Formato NIE (extranjeros)');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('Y1234567T', 'Formato NIE (extranjeros)');
INSERT INTO dni_test_data_nok (dni_input, motivo_invalido) VALUES ('Z1234567T', 'Formato NIE (extranjeros)');


