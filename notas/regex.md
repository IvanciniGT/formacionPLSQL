

# Expresiones Regulares

## Patrón de un DNI

```regex
^(([0-9]{1,8})|([0-9]{1,2}([.][0-9]{3}){2})|([0-9]{1,3}[.][0-9]{3}))[ -]?[A-Za-z]$
```

Ejemplos válidos:
- `23000000-T`
- `23.000.000-T`
- `2.300.000-T`
- `23.000-T`

Web para verificar: [regex101.com](https://regex101.com)

## Sintaxis

### Caracteres

| Patrón | Descripción |
|--------|-------------|
| `hola` | Texto literal 'hola' |
| `[hola]` | Cualquier letra: h, o, l, a |
| `[a-zA-Z]` | Cualquier letra mayúscula o minúscula |
| `[0-9]` | Cualquier dígito |
| `[^hola]` | Cualquier carácter excepto h, o, l, a |
| `.` | Cualquier carácter |

### Cuantificadores

| Modificador | Descripción |
|-------------|-------------|
| (sin modificador) | Exactamente 1 vez |
| `?` | 0 o 1 veces |
| `+` | 1 o más veces |
| `*` | 0 o más veces |
| `{n}` | Exactamente n veces |
| `{n,}` | n o más veces |
| `{n,m}` | Entre n y m veces |

### Operadores especiales

| Operador | Descripción |
|----------|-------------|
| `^` | Inicio del texto |
| `$` | Final del texto |
| `()` | Agrupa subpatrones |
| `\|` | OR lógico |