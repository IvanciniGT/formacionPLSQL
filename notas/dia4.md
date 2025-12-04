
# DEVOPS

Es una cultura, movimiento en pro de la automatización!

PLAN -> CODE -> BUILD -> TEST -> RELEASE -> DEPLOY -> OPERATE -> MONITOR

---------------------------->                           Integración Continua 
------------------------------------------>             Entrega Continua
---------------------------------------------------->   Despliegue Continuo

Los programas que nos ayudan a automatizar esas tareas (algunas de ellas) son lo que llamamos pipelines de CI/CD (Integración Continua / Despliegue Continuo / Entrega Continua).

Cuando automatizamos en general cualquier tarea, esa autoamtización tiene 2 fases/niveles.

Persiana... motor + botón                                   Primer nivel de automatización
                ^^^ (eventos, programación horaria)
               Asistente de Hogar (Alexa, Google Home...)   Segundo nivel de automatización <<< Este es el guay! Ya me olvido!

Esos pipelines de CI/CD son una automatización de segundo nivel. Ejemplo:
Pipeline de Integración continua:
- Cuando(TRIGGER - EVENTO) un desarrollador sube a gitlab una nueva versión del código quiero que:
  - Se compile el código
  - Se ejecuten unas pruebas automáticas
  - Se genere un informe de resultados

Pipeline de Despliegue continuo:
- Cuando el pipeline de integración continua finaliza correctamente (es decir, las pruebas se superan) quiero que:
  - Se despliegue automáticamente la nueva versión del programa en un entorno de producción
  - Se notifique a quien sea relevante de que hay una nueva versión en producción

---

# Vamos a llevar todos estos conceptos a vuestro mundo!

Y vamos a aplicarlos a todo este tinglao que estamos haciendo de base de datos y PLSQL.

---

Esas funciones de DNIs que estamos montando...

Consideramos que pueden ser útiles para otros proyectos? SI
Puede ser que esas funciones sufran cambios y mejoras en el futuro? SI

Vamos a crear un PAQUETE PLSQL con esas funciones.
Los paquetes no son solo una forma de crear una variable cutre de tipo flag (que es lo que hemos hecho hasta ahora).
Los paquetes son una forma de agrupar funciones y procedimientos relacionados entre sí, para tenerlos organizados y poder reutilizarlos en mi proyecto y en otros proyectos.

Ese paquete en si mismo será un proyecto de software, totalmente independiente del proyecto desde el que lo usemos.
Motivado por mi proyecto de la academia, he creado este paquete, pero en lugar de hacerlo vivir (atarlo) dentro del proyecto de la academia, lo voy a crear como un proyecto independiente, para que pueda ser usado en otros proyectos.

Ese paquete querré poder instalarlo en mi servidor de BBDD Oracle, y que en cualquier esquema (usuario) de cualquier app pueda usarlo ( o no... solo los elegidos, que también puedo hacerlo).

Vamos a montar un repositorio de gitlab propio para ese paquete.
Y vamos a darle cobertura de pruebas automáticas.
De forma que, con ayuda de los compis de DEVOPS, podamos montar luego pipelines de CI/CD para ese paquete.



---

## Paquetes PLSQL
Un paquete tiene 2 partes:

Especificación (spec): Declaraciones públicas (visibles desde fuera del paquete). Esto puede incluir: 
- Declaraciones de tipos (TYPE)
- Declaraciones de constantes (CONSTANT)
- Declaraciones de variables (VARIABLE)
- Declaraciones de excepciones (EXCEPTION)
- Declaraciones de procedimientos (PROCEDURE)
- Declaraciones de funciones (FUNCTION)
- Cuerpo (body): Implementación de las funciones y procedimientos declarados
- Aquí también puedo declarar variables, tipos, constantes y excepciones privadas (no visibles desde fuera del paquete). De uso interno