# Practica de Tablespaces

Crear 2 tablespaces:

1. tbs_datos --> tbs_datos01.dbf (20 M)
   manejo local autoasignado, segmento auto

2. tbs_index --> tbs_index01.dbf (20 M)
   manejo local uniforme de 256k cada extension

\*Ruta va a ser la misma del system que se ubica en ORADATA

Crear un usuario llamado test con contrase�a abc
Dar los privilegios necesarios (conectar, crear tablas, acceso a tablespaces ilimitado)

conectese con el usuario test y realice las siguientes tablas

Crear 2 tabla con una llave primaria

Tabla: Carreras
ID Carrera numerico 10 PK
Carrera varchar2 30

Tabla: Cursos
ID Curso numerico 10 PK
Curso varchar2 30
ID Carrera numerico 10 FK

La primer tabla la graban en el tablespace por default de la BD
La segunda va al tablespace tbs_datos

Hacer una consulta que muestre el nombre de la tabla y el tablespace donde esta almacenada.
