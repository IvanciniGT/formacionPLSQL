# DNI Utils

![Oracle](https://img.shields.io/badge/Oracle-PL%2FSQL-red?logo=oracle)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Tests](https://img.shields.io/badge/tests-passing-brightgreen)

## Tabla de Contenidos

- [Descripción](#descripción)
- [Ejemplos de Uso](#ejemplos-de-uso)
  - [Validar un DNI desde SQL](#validar-un-dni-desde-sql)
  - [Validar y extraer componentes desde PL/SQL](#validar-y-extraer-componentes-desde-plsql)
  - [Normalizar DNIs](#normalizar-dnis)
  - [Uso en queries de validación](#uso-en-queries-de-validación)
- [Instalación](#instalación)
  - [Requisitos](#requisitos)
  - [Paso 1: Crear esquema de utilidades](#paso-1-crear-esquema-de-utilidades)
  - [Paso 2: Instalar el paquete](#paso-2-instalar-el-paquete)
  - [Paso 3: Conceder permisos de ejecución](#paso-3-conceder-permisos-de-ejecución)
  - [Paso 4: Crear sinónimo público](#paso-4-crear-sinónimo-público-opcional)
- [API del Paquete](#api-del-paquete)
  - [VALIDAR_DNI (Procedure)](#validar_dni-procedure)
  - [ES_DNI_VALIDO (Function)](#es_dni_valido-function)
  - [NORMALIZAR_DNI (Function)](#normalizar_dni-function)
- [Tests](#tests)
- [Optimización de Almacenamiento](#optimización-de-almacenamiento)
- [Changelog](#changelog)
- [Roadmap](#roadmap)
- [Contribuir](#contribuir)
- [Contacto](#contacto)
- [Licencia](#licencia)

## Descripción

**DNI Utils** es un paquete PL/SQL para la validación y normalización de DNIs españoles. Proporciona funciones robustas para verificar la validez de un DNI según el algoritmo oficial y normalizar su formato para almacenamiento o presentación consistente.

### Características principales

- ✅ Validación de DNIs según el algoritmo oficial español
- 🔢 Extracción de número y letra del DNI
- 🎨 Normalización con múltiples opciones de formato
- 📊 Soporte para formatos variados de entrada (con/sin puntos, guiones, espacios)
- 🧪 Suite completa de tests (>200 casos válidos, >130 casos inválidos)
- 🚀 Optimizado para alto rendimiento

## Ejemplos de Uso

### Validar un DNI desde SQL

```sql
-- Función que retorna 1 si es válido, 0 si no lo es
SELECT dni_utils.es_dni_valido('23000000-T') AS es_valido FROM DUAL;
-- Resultado: 1

SELECT dni_utils.es_dni_valido('23000000-Z') AS es_valido FROM DUAL;
-- Resultado: 0 (letra incorrecta)
```

### Validar y extraer componentes desde PL/SQL

```sql
DECLARE
    v_valido BOOLEAN;
    v_numero NUMBER;
    v_letra  CHAR(1);
BEGIN
    dni_utils.validar_dni('23.000.000-T', v_valido, v_numero, v_letra);
    
    IF v_valido THEN
        DBMS_OUTPUT.PUT_LINE('DNI válido: ' || v_numero || v_letra);
        -- Salida: DNI válido: 23000000T
    ELSE
        DBMS_OUTPUT.PUT_LINE('DNI inválido');
    END IF;
END;
/
```

### Normalizar DNIs

```sql
-- Formato por defecto (sin ceros, sin separador, mayúscula)
SELECT dni_utils.normalizar_dni('23000000-t') FROM DUAL;
-- Resultado: 23000000T

-- Con ceros a la izquierda (8 dígitos)
SELECT dni_utils.normalizar_dni('2300000T', 1) FROM DUAL;
-- Resultado: 02300000T

-- Con guion separador
SELECT dni_utils.normalizar_dni('23000000T', 1, '-', 1, 0) FROM DUAL;
-- Resultado: 23000000-T

-- Con puntos en el número
SELECT dni_utils.normalizar_dni('23000000T', 1, '-', 1, 1) FROM DUAL;
-- Resultado: 23.000.000-T

-- Letra en minúscula
SELECT dni_utils.normalizar_dni('23000000T', 1, ' ', 0, 0) FROM DUAL;
-- Resultado: 23000000 t
```

### Uso en queries de validación

```sql
-- Filtrar registros con DNIs válidos
SELECT nombre, apellidos, dni
FROM personas
WHERE dni_utils.es_dni_valido(dni) = 1;

-- Normalizar DNIs en una migración de datos
UPDATE personas
SET dni = dni_utils.normalizar_dni(dni, 1, '-', 1, 0)
WHERE dni_utils.es_dni_valido(dni) = 1;

-- Identificar DNIs inválidos para corrección
SELECT nombre, apellidos, dni
FROM personas
WHERE dni_utils.es_dni_valido(dni) = 0;
```

## Instalación

### Requisitos

- Oracle Database 11g o superior
- Permisos para crear usuarios/esquemas y paquetes
- Acceso a SQL*Plus, SQL Developer o herramienta similar

### Paso 1: Crear esquema de utilidades

Se recomienda crear un esquema dedicado para paquetes de utilidades:

```sql
-- Crear el usuario/esquema utils
CREATE USER utils IDENTIFIED BY utils
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

-- Conceder los permisos necesarios
GRANT CONNECT, RESOURCE TO utils;
```

### Paso 2: Instalar el paquete

Conectar como usuario `utils` y ejecutar:

```sql
-- Instalar especificación del paquete
@src/dni_utils.sql

-- Instalar implementación del paquete
@src/dni_utils.impl.sql
```

### Paso 3: Conceder permisos de ejecución

Para que otros usuarios puedan utilizar el paquete:

```sql
-- Permitir a un usuario específico
GRANT EXECUTE ON utils.dni_utils TO nombre_usuario;

-- Permitir a todos los usuarios
GRANT EXECUTE ON utils.dni_utils TO PUBLIC;
```

### Paso 4: Crear sinónimo público (opcional)

Para facilitar el uso del paquete sin prefijo de esquema:

```sql
CREATE OR REPLACE PUBLIC SYNONYM dni_utils FOR utils.dni_utils;
```

Con el sinónimo, los usuarios pueden usar:
```sql
SELECT dni_utils.es_dni_valido('23000000-T') FROM DUAL;
```

En lugar de:
```sql
SELECT utils.dni_utils.es_dni_valido('23000000-T') FROM DUAL;
```

## API del Paquete

### VALIDAR_DNI (Procedure)

Valida un DNI y extrae sus componentes (número y letra).

**Parámetros:**
- `dni` IN VARCHAR2 - DNI a validar
- `valido` OUT BOOLEAN - TRUE si el DNI es válido
- `numero` OUT NUMBER - Número del DNI (solo si es válido)
- `letra` OUT CHAR - Letra del DNI (solo si es válido)

**Nota:** Solo puede ser llamado desde PL/SQL (no desde SQL).

### ES_DNI_VALIDO (Function)

Verifica si un DNI tiene formato y letra correctos.

**Parámetros:**
- `dni` IN VARCHAR2 - DNI a validar

**Retorna:** NUMBER - 1 si es válido, 0 en caso contrario

### NORMALIZAR_DNI (Function)

Convierte un DNI a un formato estándar según parámetros especificados.

**Parámetros:**
- `dni` IN VARCHAR2 - DNI a normalizar
- `rellenar_con_ceros` IN NUMBER - 1=rellenar con ceros, 0=no rellenar (default: 1)
- `separador` IN VARCHAR2 - Separador número-letra: '-', ' ' o '' (default: '')
- `letra_mayuscula` IN NUMBER - 1=mayúscula, 0=minúscula (default: 1)
- `puntos_en_numero` IN NUMBER - 1=formato con puntos, 0=sin puntos (default: 0)

**Retorna:** VARCHAR2 - DNI normalizado o NULL si no es válido

## Tests

El paquete incluye una suite completa de pruebas. Ver [test/README.md](test/README.md) para más detalles.

Para ejecutar las pruebas:

```sql
@test/dni_utils.test.sql
```

**Cobertura de tests:**
- ✅ 234+ casos de DNIs válidos
- ❌ 130+ casos de DNIs inválidos
- 🔄 Validación de extracción de componentes
- 🎨 Pruebas de normalización

## Optimización de Almacenamiento

### Recomendación para grandes volúmenes

Para más de 10 millones de registros, considerar almacenar el DNI separado:

```sql
-- Opción 1: VARCHAR2(9) - 9 bytes
dni VARCHAR2(9)

-- Opción 2: NUMBER(8) + CHAR(1) - 5 bytes (ahorro del 44%)
dni_numero NUMBER(8)
dni_letra  CHAR(1)
```

**Ventajas de la opción 2:**
- Menor espacio de almacenamiento
- Índices más eficientes
- Consultas por rangos de números más rápidas

## Changelog

Ver [CHANGELOG.md](CHANGELOG.md) para el histórico de cambios.

## Roadmap

### En desarrollo
- [ ] Soporte para NIE (Número de Identidad de Extranjero)
- [ ] Soporte para CIF (Código de Identificación Fiscal)

### Planificado
- [ ] Soporte para NIF de otros países
- [ ] Función de generación de DNIs válidos para testing
- [ ] Integración con pipelines CI/CD

## Contribuir

¿Quieres contribuir al proyecto? Consulta [CONTRIBUTING.md](CONTRIBUTING.md) para conocer las guías de contribución.

## Contacto

- **Proyecto:** formacionPLSQL
- **Repositorio:** [github.com/IvanciniGT/formacionPLSQL](https://github.com/IvanciniGT/formacionPLSQL)
- **Autor:** Iván Osuna Ayuste
- **Email:** ivan.osuna@example.com.ayuste@gmail.com

---

**Nota:** Este paquete forma parte de un proyecto educativo de formación en PL/SQL.
