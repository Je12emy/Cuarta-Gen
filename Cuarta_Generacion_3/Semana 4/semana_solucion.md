Mover la tabla 1 al tablespace `tbs_datos`

```sql
ALTER TABLE carreras MOVE TABLESPACE tbs_datos;
```

Salida

```
Table Altered
```

Verificación

```sql
SELECT table_name,tablespace_name FROM user_tables;

TABLE_NAME                     TABLESPACE_NAME
------------------------------ ------------------------------
CURSOS                         TBS_DATOS
CARRERAS                       TBS_DATOS
```

---

Poner fuera de linea el tablespace the indices

```sql
ALTER TABLESPACE tbs_index OFFLINE;

Tablespace altered.
```

Verificación

```sql
SELECT tablespace_name, status from dba_tablespaces;

TABLESPACE_NAME                STATUS
------------------------------ ---------
SYSTEM                         ONLINE
SYSAUX                         ONLINE
UNDOTBS1                       ONLINE
TEMP                           ONLINE
USERS                          ONLINE
EXAMPLE                        ONLINE
TBS_DATOS                      ONLINE
TBS_INDEX                      OFFLINE*
```

---

Insertar datos en la tabla de carreras

```sql
ALTER TABLE carreras MODIFY ( carrera VARCHAR2(22) );

Table altered.

INSERT INTO carreras (id_carrera, carrera) VALUES (1, 'Ingenieria Informatica');

1 row created.

SELECT * FROM carreras;

ID_CARRERA CARRERA
---------- ----------------------
         1 Ingenieria Informatica
```

---

Poner el tablespace `tbs_datos` en modo de lectura

```sql
ALTER TABLESPACE tbs_datos READ ONLY;

Tablespace altered.
```

Verificación

```sql
SELECT tablespace_name, status FROM dba_tablespaces;

TABLESPACE_NAME                STATUS
------------------------------ ---------
SYSTEM                         ONLINE
SYSAUX                         ONLINE
UNDOTBS1                       ONLINE
TEMP                           ONLINE
USERS                          ONLINE
EXAMPLE                        ONLINE
TBS_DATOS                      READ ONLY*
TBS_INDEX                      OFFLINE
```

---

Se puede hacer un `delete` en la tabla de carreras? Justifie:

_Respuesta:_ No, el tablespace al que pertenece esta en modo de lectura por lo cual no sera posible insertar, modificar ni borrar datos.

---

Poner el tablespace `tbs_index` y el `tbs_datos` en lectura escritura.

```sql
ALTER TABLESPACE tbs_index ONLINE;

Tablespace altered.

ALTER TABLESPACE tbs_datos READ WRITE;

Tablespace altered.
```

Verificación

```sql
SELECT tablespace_name, status FROM dba_tablespaces;

TABLESPACE_NAME                STATUS
------------------------------ ---------
SYSTEM                         ONLINE
SYSAUX                         ONLINE
UNDOTBS1                       ONLINE
TEMP                           ONLINE
USERS                          ONLINE
EXAMPLE                        ONLINE
TBS_DATOS                      ONLINE*
TBS_INDEX                      ONLINE*
```

---

Verificar en cual tablespace quedaron creados los indices

```sql
SELECT index_name, tablespace_name, table_name from user_indexes;

INDEX_NAME      TABLESPACE_NAME                TABLE_NAME
--------------- ------------------------------ -----------------------------
SYS_C0011119    TBS_DATOS                      CURSOS
SYS_C0011118    USERS                          CARRERAS
```

---

Si los indices no estan en el tablespaces de indices, moverlo ahi.

```sql
ALTER INDEX SYS_C0011119 REBUILD TABLESPACE tbs_index;

Index altered.

ALTER INDEX SYS_C0011118 REBUILD TABLESPACE tbs_index;

Index altered.
```

Verificar

```sql
SELECT index_name, table_name, tablespace_name FROM USER_INDEXES;

INDEX_NAME      TABLE_NAME                     TABLESPACE_NAME
--------------- ------------------------------ ------------------------------
SYS_C0011119    CURSOS                         TBS_INDEX
SYS_C0011118    CARRERAS                       TBS_INDEX
```

---

Verifique el espacio usado por la tabla

```sql
SELECT  table_name,
        (blocks*8)/1024 || ' MB'            AS FRAGMENTED_SIZE,
        (num_rows*avg_row_len)/1024 ||' MB' AS TABLE_SIZE,
        (blocks * 8)/1028 - (num_rows * avg_row_len)/1024 AS ROCOVERABLE_SPACE
FROM user_tables;

TABLE_NAME      FRAGMENTED_SIZE TABLE_SIZE      ROCOVERABLE_SPACE
--------------- --------------- --------------- -----------------
CURSOS          0 MB            0 MB                            0
CARRERAS        .0390625 MB     .025390625 MB          .013519881
```

---

Crear una tabla objetos usando a la tabla `dba_object`, esta tendra un almacenamiento inicial de 100k, siguiente de 50k y con un porcentaje de crecimeiento del 10%.

```sql
CREATE TABLE objetos STORAGE (INITIAL 50K NEXT 50K PCTINCREASE 10) AS (
SELECT  *
FROM dba_objects);
```

_Nota:_ No es posible usar el `SELECT` antes de la clausula `STORAGE`

Verificación

```sql
SELECT  table_name,
        initial_extent,
        next_extent,
        pct_increase
FROM dba_tables
WHERE table_name like 'OBJETOS';

TABLE_NAME                     INITIAL_EXTENT NEXT_EXTENT PCT_INCREASE
------------------------------ -------------- ----------- ------------
OBJETOS                                 57344       57344
```

Insertar toda la información de la vista `dba_objects`.

```sql
INSERT INTO objetos (SELECT * FROM dba_objects);
```

Verificación:

```sql
SELECT COUNT(*) FROM objetos;

  COUNT(*)
----------
    145116
```

---

Verificar el tamaño de la tabla `OBJETOS`

Actualizar las estadisticas de la tabla

```sql
EXECUTE DBMS_STATS.GATHER_TABLE_STATS (ownname => USER, tabname => 'OBJETOS');
```

Verificar tamaño

```sql
 SELECT  ROUND(((num_rows*avg_row_len)/1024/1024) ,2) || ' MB' AS TABLE_SIZE
 FROM dba_tables
 WHERE table_name LIKE 'OBJETOS';

TABLE_SIZE
-------------------------------------------
6.71 MB
```

---

Borre la mita de los registros en la tabla `OBJETOS`.

```sql
DELETE FROM objetos WHERE rownum < (SELECT COUNT(*)/2 FROM objetos);
```

Verificación

Antes

```sql
SELECT COUNT(*) FROM  OBJETOS;

COUNT(*)
----------
72558
```

Despues

```sql
SELECT COUNT(*) FROM  OBJETOS;

COUNT(*)
----------
36280
```

---

Verifique el tamaño desperdiciado y desfragmente la tabla `OBJETOS`.

```sql
SELECT  TABLE_NAME,
        ROUND((num_rows*avg_row_len)/1024/1024,2) || ' MB'                    AS CONSUMED_SPACE,
        ROUND((blocks*8)/1024,2) || ' MB'                                     AS TOTAL_SIZE,
        ROUND((blocks*8)/1024 - (num_rows*avg_row_len)/1024/1024,2) || ' MB' AS RECLAIMABLE_SPACE
FROM dba_tables
WHERE table_name LIKE 'OBJETOS';

TABLE_NAME      CONSUMED_SPACE  TOTAL_SIZE      RECLAIMABLE_SPACE
--------------- --------------- --------------- ------------------
OBJETOS         6.71 MB         16.11 MB        9.4 MB
```

Desfragmentar la tabla

Verificar el modo de manejo del tablespace

```sql
SELECT  a.owner,
        a.table_name,
        a.tablespace_name,
        b.segment_space_management
FROM dba_tables a, dba_tablespaces b
WHERE a.tablespace_name = b.tablespace_name
AND a.table_name = 'OBJETOS';

OWNER           TABLE_NAME      TABLESPACE_NAME                SEGMENT_SPACE_MANAGE
--------------- --------------- ------------------------------ --------------------
SYS             OBJETOS         SYSTEM                         MANUAL
```

Puesto que no se esta usando Automatic Segment Space Management o ASSM no es posible usa el comando `SHRINK`, por lo cual se opta por mover la tabla y reconstuir los indices.

```sql
ALTER TABLE objetos MOVE;
ALTER TABLE objetos ENABLE ROW MOVEMENT;
ALTER TABLE objetos MOVE TABLESPACE system;
EXECUTE dbms_stats.gather_table_stats('&owner_name' , '&table_name');
Enter value for owner_name: SYS
Enter value for table_name: OBJETOS
ALTER TABLE objetos DISABLE ROW MOVEMENT;
```

Volviendo a verificar el espacio consumido y fragmentado.

```sql
SELECT  TABLE_NAME,
        ROUND((num_rows*avg_row_len)/1024/1024,2) || ' MB'                    AS CONSUMED_SPACE,
        ROUND((blocks*8)/1024,2) || ' MB'                                     AS TOTAL_SIZE,
        ROUND((blocks*8)/1024 - (num_rows*avg_row_len)/1024/1024,2) || ' MB' AS RECLAIMABLE_SPACE
FROM dba_tables
WHERE table_name LIKE 'OBJETOS';

TABLE_NAME      CONSUMED_SPACE  TOTAL_SIZE      RECLAIMABLE_SPA
--------------- --------------- --------------- ---------------
OBJETOS         3.43 MB         4.09 MB         .67 MB
```
