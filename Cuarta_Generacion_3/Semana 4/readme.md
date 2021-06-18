# Semana 4

- Mover la tabla 1 al tablespace tbs_datos

- Poner fuera de linea el tablespace de indices

- Hacer un insert sobre la tabla carreras con la siguiente info:
  ID Carrera:1, Carrera: Ingenieria Informatica

- Poner en modo lectura el tablespace tbs_datos

- Hacer un delete de la tabla carreras, se puede hacer? si/no justifique

- Vuelva a establecer el tablespace de indices en linea y el tablespace de datos en lectura escritura.

- Verificar en que tablespace quedaron almacenados los indices

- Si los index no están en el tablespace tbs_index, moverlos ahi.

- Borre la mitad de los registros de la tabla.

- Consulte el espacio desperdiciado y defragmente la tabla.
- Guarde los print-screen para que pueda ir verificando.

---

- Crear la tabla que se llamará: Objetos, con la estructura de la vista de objectos de la base de datos.
  - La tabla se creará con parametros iniciales de 50K, el siguiente con 25K y el porcentaje de incremento
    de un 10%.
- Llenar esa tabla toda la información contenida en esa vista (DBA_OBJECTS).
  Cálcule el tamaño de la tabla.
- Borre la mitad de los registros de la tabla.
- Consulte el espacio desperdiciado y defragmente la tabla.
- Guarde los print-screen para que pueda ir verificando.
