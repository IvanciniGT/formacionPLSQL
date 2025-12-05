

    ESCRIBIMOS CODIGO <> PRUEBAS -> OK -> REFACTORIZAMOS CODIGO <> PRUEBAS -> OK -> LISTO!
    <--------------------------------->   <--------------------------------->
            50% del trabajo                       50% del trabajo    
                8 horas.                            8 horas.


Hay un hombrecillo que planteo un principio que a día de hoy está muy vgente: SoC (Separation of Concerns), y lo planteó nuestro amigo: David Parnas


Dónde ejecuto las pruebas(.. en genérico)?
- En la máquina del desarrollador?                  NO... Por qué? Porque no me fio... su entorno está maleao!
- En la máquina de un tester?                       NO... Por qué? Porque no me fio... su entorno está maleao!
- En un entorno de test/pruebas/integración/q&a ?   Tampoco.
    Hace 15 años... esta era la opción... la mejor que teníamos!
    Cuando arrancaba un proyecto de software, desde sistemas me creaban:
    - El entorno de desarrollo  <<< Desarrollo
           vvvvv  
    - El entorno de pruebas     <<< Testing
           vvvvv
    - El entorno de producción  <<< Usuarios finales
  Hoy en día, no me fio de ese entorno.
  La primera vez que instale allí, guay!... Después de 15 instalaciones, pruenas, desinstalaciones... cambios... parches...
  tios metiendo la mano, tias metiendo la mano... sabéis como estará ese entorno? maleao!
- Hoy en día la tendencia es tener entornos de pruebas de usar y tirar.
  Cuando necesito hacer pruebas, creo el entorno, hago las pruebas y lo destruyo: Containers, VMs, Cloud...

Traído a nuestro caso, básicamente será cada vez que quiera ejecutar las pruebas de mi paquete:
- Creo un esquema dentro de mi base de datos ... si puede ser en una bbdd nueva mejor que mejor.
- Instalo mi paquete y todo lo necesario.
- Ejecuto las pruebas -> Se genera un informe de resultados.
- Guardo/capturo el informe de resultados.
- Destruyo el esquema o la bbdd.

Esto es lo que se monta en uno de esos pipelines (scripts) de CI/CD Integración Continua.
Lo ideal que me generen una BBDD nueva, cada vez que quiero hacer las pruebas. Y eso con un contenedor se tarda 1 minuto en configurar...
Y una vez configurado, 10 segundos en crearlo cada vez que lo necesite y 3 en borrarlo.

---

Cosas que vamos a hacer:

- [x] Crear un paquete PL/SQL que contenga las pruebas de nuestro otro paquete de utilidades de DNI.
- [x] En ese paquete tendremos posibilidad de tener variables globales, en lugar de que cada función tenga sus propias variables.
- [x] Tendremos/Generaremos una función única encargada de ir sacando las cosas al log... y no tener en todas las funciones las mismas 15 líneas de código una y otra vez.
- [x] Utilizar un mejor patrón para las pruebas: ASSERTIONS. Es un patrón ampliamente utilizado en el mundo de las pruebas.
  Eso me quita todos los IFs que tengo en cada prueba.


- [x] Y más aún... vamos a simplificar la generación del log... el log de bajo nivel: Cada caso concreto que falla.
  Ahora mismo, cada caso que falla, lo estamos sacando con un DBMS_OUTPUT.PUT_LINE a la consola.
- En paralelo, vamos a ver si conseguimos mejorar alguna de las pruebas....

        SELECT dni_input, dni_utils.normalizar_dni(dni_input) as resultado FROM dni_test_data_nok
        Y luego recorrer el cursor y comparar si el resultado es NOT NULL

        INSERT INTO TABLA_LOG_PRUEBAS (DNI, MOTIVO_FALLO) 
        SELECT dni_input, 'El DNI por ser inválido no puede ser normalizado' FROM dni_test_data_nok WHERE dni_utils.normalizar_dni(dni_input) IS NOT NULL

- [] Los casos fallidos los vamos a ir guardando en una tabla temporal globales , que luego podremos volcar en el log de alto nivel.

---
Nuestro paquete del dni y su paquete asociado de pruebas están acabados!
No obstante vamos a meterle un pequeño cambio... tablas globales temporales.
No es necesario en este caso, pero vamos a hacerlo para aprender el cocnepto ya que es un concepto muy utilizado en el mundo real.

---

# Tablas Globales Temporales de Oracle

Son unas tablas, cuya definición (las columnas que tiene) es permanente, pero cuyos datos son temporales.
Además, no es solo que los datos sean temporales, sino que son temporales por sesión o por transacción.
Y no es todo... Desde cada sesión, veo solo los datos que yo he insertado desde mi sesión en esa tabla... no los datos de otras sesiones.

RESUMEN:
- Solo hay una definición permanente de la tabla, que etá disponible para todas las sesiones.
- Cada sesión ve solo los datos que ha insertado ella misma.
- Los datos pueden durar solo hasta el final de la sesión, o solo hasta el final de la transacción.

## COMO LAS CREAMOS

```sql
CREATE GLOBAL TEMPORARY TABLE nombre_tabla (
    columna1 TIPO,
    columna2 TIPO,
    ...
) ON COMMIT DELETE ROWS; -- O bien ON COMMIT PRESERVE ROWS

Si hago un:
- ON COMMIT DELETE ROWS     Las filas que inserte en esa tabla temporal, se borran automáticamente al hacer un COMMIT o ROLLBACK.
- ON COMMIT PRESERVE ROWS   Las filas que inserte en esa tabla temporal, permanecen hasta el final de la sesión, aunque haga COMMIT o ROLLBACK.

Nunca permanecen los datos en la tabla más allá de la sesión.

## Para que las usamos?

- En nuestro caso y otros similares para ir guardando un log de bajo nivel de tareas realizadas dentro de una sesión.
- ETLs (Extract, Transform, Load): Muchas veces cuando estamos haciendo procesos de transformación de datos, necesitamos ir guardando datos intermedios en tablas temporales.
  ETL: Datos -> Transformación1 -> Datos transformados (Tabla temporal) -> Transformación2 -> Datos transformados (Tabla temporal) -> Carga en destino final

Tienes todas las utilidades de BBDD normales (queries complejas sobre datos, o ir dejando datos intermedios en la tabla) pero sin la persistencia real (solo temporal).

INSERT INTO TABLA_PERSISTENTE SELECT * FROM TABLA_GLOBAL_TEMPORAL WHERE FLAG = 1;

---

# Para el caso de nuestras pruebas de DNIs

Podemos crear una tabla donde vayamos anotando el resultado de cada caso de prueba que falla.
En lugar de ir sacándolo a la consola con DBMS_OUTPUT.PUT_LINE, lo vamos insertando en esa tabla temporal.

Y luego haré con ellos lo que consideré:
- Sacarlos al log... pero todos juntos

TRANSACCION:
Desde un BEGIN hasta un COMMIT/ROLLBACK