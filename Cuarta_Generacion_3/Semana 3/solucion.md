# Solucion

**Crear Tablespace `tbs_datos`**

Camino a los datafiles

```sql
SELECT name FROM V$DATAFILE;
```

Salida

```
NAME
-----------------------------------------------------------------
C:\APP\JEREMYZELAYARODRIGUE\ORADATA\ORCL\SYSTEM01.DBF
```

Sentencia

```sql
CREATE TABLESPACE tbs_datos DATAFILE 'C:\APP\JEREMYZELAYARODRIGUE\ORADATA\ORCL\tbs_datos01.dbf' SIZE 20M EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;
```

Salida:

```
Tablespace created.
```

---

**Crear table space `tbs_index`**

Sentencia:

```sql
CREATE TABLESPACE tbs_index DATAFILE 'C:\APP\JEREMYZELAYARODRIGUE\ORADATA\ORCL\tbs_index01.dbf'
SIZE 20M EXTENT MANAGEMENT LOCAL UNIFORM SIZE 256K;
```

Salida:

```
Tablespace created.
```

---

**Crear usuario `test` con contraseña `abc`**

Sentencia:

```sql
CREATE USER test IDENTIFIED BY abc;
```

**Proporcionar permisos**

```sql
GRANT CREATE SESSION, CREATE TABLE, UNLIMITED TABLESPACE to test;
```

---

**Crear tablas cursos y carreras**

_Tabla carreras_

```sql
CREATE TABLE carreras (
id_carrera NUMBER(10) NOT NULL PRIMARY KEY,
carrera VARCHAR(20) NOT NULL);
```

```
desc carreras
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ID_CARRERA                                NOT NULL NUMBER(10)
 CARRERA                                   NOT NULL VARCHAR2(20)
```

_Tabla cursos_

```sql
CREATE TABLE cursos(
id_curso NUMBER(10,0) PRIMARY KEY,
curso varchar2(30),
id_carrera NUMBER(10,0),
FOREIGN KEY(id_carrera) REFERENCES carreras(id_carrera)
) TABLESPACE tbs_datos;
```

```
 desc cursos
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ID_CURSO                                  NOT NULL NUMBER(10)
 CURSO                                              VARCHAR2(30)
 ID_CARRERA                                         NUMBER(10)
```

---

**Verificar tablespace de la tabla creada**

```sql
SELECT table_name,tablespace_name FROM user_tables;
```

Salida

```
TABLE_NAME                     TABLESPACE_NAME
------------------------------ ------------------------------
CARRERAS                       USERS
CURSOS                         TBS_DATOS
```
