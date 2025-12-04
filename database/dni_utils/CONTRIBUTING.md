# Guía de Contribución

¡Gracias por tu interés en contribuir a **DNI Utils**! Este documento proporciona las guías y mejores prácticas para colaborar en el proyecto.

## Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [¿Cómo puedo contribuir?](#cómo-puedo-contribuir)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Mejoras](#sugerir-mejoras)
- [Tu Primera Contribución de Código](#tu-primera-contribución-de-código)
- [Proceso de Pull Request](#proceso-de-pull-request)
- [Guías de Estilo](#guías-de-estilo)
- [Estructura del Proyecto](#estructura-del-proyecto)

## Código de Conducta

Este proyecto y todos los participantes están comprometidos a mantener un ambiente respetuoso y acogedor. Se espera que todos los colaboradores:

- Usen lenguaje acogedor e inclusivo
- Respeten puntos de vista y experiencias diferentes
- Acepten críticas constructivas de manera profesional
- Se enfoquen en lo que es mejor para la comunidad
- Muestren empatía hacia otros miembros de la comunidad

## ¿Cómo puedo contribuir?

Hay muchas formas de contribuir al proyecto:

### 1. Reportar Bugs
¿Encontraste un error? Abre un issue con:
- Descripción clara del problema
- Pasos para reproducirlo
- Comportamiento esperado vs. obtenido
- Versión de Oracle Database utilizada
- Código de ejemplo que demuestre el problema

### 2. Sugerir Mejoras
¿Tienes ideas para nuevas funcionalidades? Abre un issue describiendo:
- El problema que resolverías
- La solución propuesta
- Casos de uso específicos
- Alternativas que hayas considerado

### 3. Mejorar la Documentación
- Corregir errores tipográficos
- Añadir ejemplos de uso
- Mejorar explicaciones
- Traducir documentación

### 4. Contribuir con Código
- Corregir bugs reportados
- Implementar nuevas funcionalidades
- Añadir casos de prueba
- Mejorar el rendimiento

## Reportar Bugs

### Antes de Reportar

1. **Verifica que sea un bug real** ejecutando el código de prueba
2. **Busca en los issues existentes** para evitar duplicados
3. **Asegúrate de usar la versión más reciente** del paquete

### Template para Reportar Bugs

```markdown
**Descripción del Bug**
Descripción clara y concisa del error.

**Pasos para Reproducir**
1. Conectar a la base de datos...
2. Ejecutar query...
3. Ver error...

**Comportamiento Esperado**
Qué esperabas que ocurriera.

**Comportamiento Actual**
Qué ocurrió en realidad.

**Entorno**
- Oracle Database: [ej. 19c]
- SO del servidor: [ej. Linux]
- Cliente: [ej. SQL Developer 21.2]

**Código de Ejemplo**
```sql
-- Tu código aquí
```

**Capturas de Pantalla**
Si aplica, añade capturas para ayudar a explicar el problema.

**Contexto Adicional**
Cualquier otra información relevante.
```

## Sugerir Mejoras

### Template para Sugerencias

```markdown
**¿Tu sugerencia está relacionada con un problema?**
Descripción clara del problema. Ej: "Me frustra cuando..."

**Describe la solución que te gustaría**
Descripción clara de lo que quieres que ocurra.

**Describe alternativas que hayas considerado**
Otras soluciones o características que hayas considerado.

**Casos de Uso**
Ejemplos concretos de cómo usarías la funcionalidad.

**Contexto Adicional**
Cualquier otra información, capturas, mockups, etc.
```

## Tu Primera Contribución de Código

¿No estás seguro por dónde empezar? Busca issues etiquetados con:

- `good first issue` - Issues adecuados para principiantes
- `help wanted` - Issues donde necesitamos ayuda
- `documentation` - Mejoras en documentación

### Configurar el Entorno de Desarrollo

1. **Fork el repositorio**
   ```bash
   # Clonar tu fork
   git clone https://github.com/TU_USUARIO/formacionPLSQL.git
   cd formacionPLSQL/database/dni_utils
   ```

2. **Crear esquema de desarrollo**
   ```sql
   CREATE USER dni_utils_dev IDENTIFIED BY dni_utils_dev
   DEFAULT TABLESPACE users
   TEMPORARY TABLESPACE temp
   QUOTA UNLIMITED ON users;
   
   GRANT CONNECT, RESOURCE TO dni_utils_dev;
   ```

3. **Instalar el paquete**
   ```sql
   @src/dni_utils.sql
   @src/dni_utils.impl.sql
   ```

4. **Ejecutar tests**
   ```sql
   @test/dni_utils.test.sql
   ```

## Proceso de Pull Request

1. **Crea una rama para tu feature/fix**
   ```bash
   git checkout -b feature/descripcion-corta
   # o
   git checkout -b fix/descripcion-bug
   ```

2. **Realiza tus cambios**
   - Sigue las guías de estilo (ver abajo)
   - Añade o actualiza tests si es necesario
   - Actualiza la documentación si es necesario

3. **Asegúrate de que los tests pasen**
   ```sql
   @test/dni_utils.test.sql
   ```

4. **Commit con mensajes descriptivos**
   ```bash
   git commit -m "feat: añadir soporte para NIE"
   git commit -m "fix: corregir validación con puntos"
   git commit -m "docs: actualizar ejemplos en README"
   ```

5. **Push a tu fork**
   ```bash
   git push origin feature/descripcion-corta
   ```

6. **Abre un Pull Request**
   - Describe claramente los cambios realizados
   - Referencias issues relacionados (#123)
   - Incluye ejemplos de uso si añades funcionalidad
   - Añade capturas si es relevante

### Checklist del Pull Request

- [ ] El código sigue las guías de estilo del proyecto
- [ ] He comentado mi código, especialmente en áreas complejas
- [ ] He actualizado la documentación correspondiente
- [ ] Mis cambios no generan nuevos warnings
- [ ] He añadido tests que prueban mi fix/funcionalidad
- [ ] Los tests nuevos y existentes pasan localmente
- [ ] He actualizado el CHANGELOG.md

## Guías de Estilo

### Estilo de Código PL/SQL

#### Nomenclatura
- **Paquetes**: minúsculas con guiones bajos (`dni_utils`)
- **Funciones/Procedimientos**: minúsculas con guiones bajos (`validar_dni`)
- **Variables locales**: minúsculas con guiones bajos (`letra_correcta`)
- **Constantes**: mayúsculas con guiones bajos (`LETRAS_VALIDAS`)
- **Parámetros**: minúsculas con guiones bajos (`dni_input`)

#### Formato
```sql
-- Usar 4 espacios para indentación (no tabs)
PROCEDURE validar_dni (
    dni IN VARCHAR2,
    valido OUT BOOLEAN,
    numero OUT NUMBER,
    letra OUT CHAR
)
IS
    letra_correcta CHAR(1);
BEGIN
    -- Inicializar valores
    valido := FALSE;
    numero := NULL;
    
    -- Lógica del procedimiento
    IF dni IS NULL THEN
        RETURN;
    END IF;
    
    -- Más código...
END;
```

#### Comentarios
```sql
-- Comentarios de una línea para explicaciones breves

-- Comentarios de bloque para secciones complejas
-- Se pueden usar múltiples líneas con --
-- para explicaciones más detalladas

------------------------------------------------------------------------------------------------
-- Separadores para secciones principales del código
------------------------------------------------------------------------------------------------
```

#### Documentación de funciones
```sql
------------------------------------------------------------------------------------------------
-- NOMBRE_FUNCION
-- Descripción breve de la funcionalidad
--
-- Parámetros:
--   param1    IN  TIPO      Descripción
--   param2    OUT TIPO      Descripción
--
-- Retorna:
--   TIPO      Descripción del valor de retorno
--
-- Notas:
--   Información adicional relevante
------------------------------------------------------------------------------------------------
```

### Estilo de Documentación

#### Markdown
- Usar encabezados jerárquicos (`#`, `##`, `###`)
- Código en bloques con lenguaje especificado: ` ```sql `
- Listas con guiones (`-`) o números según corresponda
- Enlaces descriptivos: `[texto visible](url)`

#### Ejemplos de Código
- Incluir comentarios explicativos
- Mostrar salidas esperadas
- Usar casos de uso realistas
- Mantener ejemplos simples y claros

## Estructura del Proyecto

```
dni_utils/
├── CHANGELOG.md              # Histórico de cambios
├── CONTRIBUTING.md           # Este archivo
├── README.md                 # Documentación principal
├── src/
│   ├── dni_utils.sql        # Especificación del paquete (CREATE PACKAGE)
│   └── dni_utils.impl.sql   # Implementación (CREATE PACKAGE BODY)
└── test/
    ├── README.md             # Documentación de tests
    ├── dni_utils.test.sql    # Script principal de pruebas
    └── dni_utils.test.data.sql # Datos de prueba
```

### Añadir Nueva Funcionalidad

1. **Especificación** (`src/dni_utils.sql`):
   - Añadir declaración de función/procedimiento
   - Documentar parámetros y comportamiento

2. **Implementación** (`src/dni_utils.impl.sql`):
   - Implementar la lógica
   - Añadir comentarios explicativos
   - Seguir patrones existentes

3. **Tests** (`test/dni_utils.test.data.sql` y `test/dni_utils.test.sql`):
   - Añadir casos de prueba válidos
   - Añadir casos de prueba inválidos
   - Crear función de test

4. **Documentación** (`README.md`):
   - Actualizar sección de API
   - Añadir ejemplos de uso
   - Actualizar tabla de contenidos

5. **Changelog** (`CHANGELOG.md`):
   - Añadir entrada en sección `[Unreleased]`

## Preguntas

Si tienes preguntas sobre cómo contribuir, puedes:
- Abrir un issue con la etiqueta `question`
- Contactar a los mantenedores del proyecto
- Consultar el README para información general

## Reconocimientos

Todos los contribuidores serán reconocidos en el proyecto. ¡Gracias por hacer que DNI Utils sea mejor!

---

**Nota:** Esta guía está inspirada en las mejores prácticas de proyectos open source y puede ser actualizada conforme el proyecto evolucione.
