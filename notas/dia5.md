

    ESCRIBIMOS CODIGO <> PRUEBAS -> OK -> REFACTORIZAMOS CODIGO <> PRUEBAS -> OK -> LISTO!


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

- Crear un paquete PL/SQL que contenga las pruebas de nuestro otro paquete de utilidades de DNI.
- En ese paquete tendremos posibilidad de tener variables globales, en lugar de que cada función tenga sus propias variables.
- Tendremos/Generaremos una función única encargada de ir sacando las cosas al log... y no tener en todas las funciones las mismas 15 líneas de código una y otra vez.
- Utilizar un mejor patrón para las pruebas: ASSERTIONS. Es un patrón ampliamente utilizado en el mundo de las pruebas.
  Eso me quita todos los IFs que tengo en cada prueba.


- Y más aún... vamos a simplificar la generación del log... el log de bajo nivel: Cada caso concreto que falla.
  Ahora mismo, cada caso que falla, lo estamos sacando con un DBMS_OUTPUT.PUT_LINE a la consola.
  Los casos fallidos los vamos a ir guardando en una tabla temporal, que luego podremos volcar en el log de alto nivel.
- En paralelo, vamos a ver si conseguimos mejorar alguna de las pruebas....

        SELECT dni_input, dni_utils.normalizar_dni(dni_input) as resultado FROM dni_test_data_nok
        Y luego recorrer el cursor y comparar si el resultado es NOT NULL

        INSERT INTO TABLA_LOG_PRUEBAS (DNI, MOTIVO_FALLO) 
        SELECT dni_input, 'El DNI por ser inválido no puede ser normalizado' FROM dni_test_data_nok WHERE dni_utils.normalizar_dni(dni_input) IS NOT NULL