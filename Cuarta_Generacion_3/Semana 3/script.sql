CREATE TABLESPACE tbs_datos DATAFILE 'C:\APP\JEREMYZELAYARODRIGUE\ORADATA\ORCL\tbs_datos01.dbf' 
SIZE 20M EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;


CREATE TABLESPACE tbs_index DATAFILE 'C:\APP\JEREMYZELAYARODRIGUE\ORADATA\ORCL\tbs_index01.dbf' 
SIZE 20M EXTENT MANAGEMENT LOCAL UNIFORM SIZE 256K;

CREATE USER test IDENTIFIED BY abc;

GRANT CREATE SESSION, CREATE TABLE, UNLIMITED TABLESPACE to test;


CREATE TABLE carreras(
id_carrera NUMBER(10) NOT NULL PRIMARY KEY,
carrera VARCHAR(20) NOT NULL);


CREATE TABLE cursos(
id_curso NUMBER(10,0) PRIMARY KEY,
curso varchar2(30),
id_carrera NUMBER(10,0),
FOREIGN KEY(id_carrera) REFERENCES carreras(id_carrera)
) TABLESPACE tbs_datos;

SELECT table_name,tablespace_name FROM user_tables;

