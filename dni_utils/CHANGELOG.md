# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.0] - 2025-12-04

### Añadido

#### Funcionalidades principales
- **Procedimiento `validar_dni`**: Valida DNIs y extrae número y letra
  - Soporte para DNIs de 1 a 8 dígitos
  - Validación según algoritmo oficial español (MOD 23)
  - Extracción de componentes (número y letra)
  - Parámetro de salida `BOOLEAN` para validación
  
- **Función `es_dni_valido`**: Validación de DNIs desde SQL
  - Retorna `NUMBER` (1=válido, 0=inválido) para uso en queries SQL
  - Compatible con WHERE, SELECT y otras cláusulas SQL
  
- **Función `normalizar_dni`**: Normalización de formato
  - Opción de relleno con ceros a la izquierda (hasta 8 dígitos)
  - Separadores configurables: sin separador, espacio o guion
  - Letra en mayúscula o minúscula
  - Formato con puntos (XX.XXX.XXX) o sin puntos
  - Retorna `NULL` si el DNI no es válido

#### Validación de formatos
- Soporte para múltiples formatos de entrada:
  - Sin separador: `23000000T`
  - Con guion: `23000000-T`
  - Con espacio: `23000000 T`
  - Con puntos: `23.000.000T`, `23.000.000-T`, `23.000.000 T`
  - Letras en mayúsculas y minúsculas
  - Con o sin ceros a la izquierda

#### Suite de tests
- **234+ casos de prueba válidos**:
  - DNIs de 1 a 8 dígitos
  - Todas las combinaciones de formato
  - Con y sin ceros a la izquierda
  - Formatos con puntos y separadores

- **130+ casos de prueba inválidos**:
  - Letra incorrecta según algoritmo
  - Más de 8 dígitos
  - Sin letra o sin número
  - Caracteres especiales inválidos
  - Formato de puntos incorrecto
  - Espacios en posiciones incorrectas
  - Letras no válidas (Ñ, Ç, Ü)
  - Formato NIE (no soportado)
  - Y muchos más edge cases

- **Script automatizado de pruebas** (`dni_utils.test.sql`):
  - Función `test_validar_dnis_ok` para casos válidos
  - Carga automática de datos de prueba
  - Informes detallados de resultados
  - Limpieza automática al finalizar

#### Documentación
- `README.md` completo con:
  - Badges de estado del proyecto
  - Tabla de contenidos
  - Descripción detallada de características
  - Ejemplos exhaustivos de uso
  - Guía de instalación paso a paso
  - Documentación completa de la API
  - Información sobre optimización de almacenamiento
  
- `test/README.md` con:
  - Guía completa de ejecución de pruebas
  - Descripción de la estructura de datos de test
  - Ejemplos de queries de validación
  - Instrucciones de limpieza

- `CONTRIBUTING.md`: Guía para colaboradores
- `CHANGELOG.md`: Histórico de cambios

#### Optimización
- Constantes privadas para tabla de letras y patrones regex
- Uso eficiente de expresiones regulares
- Algoritmo optimizado de cálculo de letra
- Documentación sobre opciones de almacenamiento (VARCHAR2 vs NUMBER+CHAR)

### Detalles técnicos

#### Expresiones regulares utilizadas
- `patron_dni`: `^(([0-9]{1,8})|([0-9]{1,2}([.][0-9]{3}){2})|([0-9]{1,3}[.][0-9]{3}))[ -]?[A-Za-z]$`
- `patron_no_numerico`: `[^0-9]`

#### Tabla de letras válidas
- Secuencia oficial: `TRWAGMYFPDXBNJZSQVHLCKE`

### Notas de implementación

- El procedimiento `validar_dni` utiliza tipo `BOOLEAN` y solo puede ser llamado desde PL/SQL
- La función `es_dni_valido` retorna `NUMBER` para permitir su uso en SQL estándar
- La función `normalizar_dni` retorna `NULL` para DNIs inválidos
- Todos los formatos de entrada son normalizados internamente antes de la validación
- La validación es case-insensitive (acepta letras en mayúsculas y minúsculas)

### Estructura del proyecto

```
dni_utils/
├── CHANGELOG.md
├── CONTRIBUTING.md
├── README.md
├── src/
│   ├── dni_utils.sql          # Especificación del paquete
│   └── dni_utils.impl.sql     # Implementación del paquete
└── test/
    ├── README.md               # Guía de pruebas
    ├── dni_utils.test.sql      # Script de pruebas
    └── dni_utils.test.data.sql # Datos de prueba
```

### Requisitos

- Oracle Database 11g o superior
- Permisos para crear usuarios/esquemas y paquetes
- SQL*Plus, SQL Developer o herramienta compatible

---

## [Unreleased]

### Planeado para futuras versiones
- Soporte para NIE (Número de Identidad de Extranjero)
- Soporte para CIF (Código de Identificación Fiscal)
- Función de generación de DNIs válidos para testing
- Integración con pipelines CI/CD
- Soporte para NIF de otros países

---

[1.0.0]: https://github.com/IvanciniGT/formacionPLSQL/releases/tag/v1.0.0
