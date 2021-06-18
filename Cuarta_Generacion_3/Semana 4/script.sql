 ALTER TABLE carreras MOVE TABLESPACE tbs_datos; ALTER TABLESPACE tbs_index OFFLINE ALTER TABLE carreras MODIFY ( carrera VARCHAR2(22) );

INSERT INTO carreras (id_carrera, carrera) VALUES (1, 'Ingenieria Informatica'); ALTER TABLESPACE tbs_datos READ ONLY; ALTER TABLESPACE tbs_index ONLINE; ALTER TABLESPACE tbs_datos READ WRITE;

SELECT  table_name,
        (blocks*8)/1024 || ' MB'                          AS FRAGMENTED_SIZE,
        (num_rows*avg_row_len)/1024 ||' MB'               AS TABLE_SIZE,
        (blocks * 8)/1028 - (num_rows * avg_row_len)/1024 AS ROCOVERABLE_SPACE
FROM user_tables;

CREATE TABLE objetos STORAGE (INITIAL 50K NEXT 50K PCTINCREASE 10) AS (
SELECT  *
FROM dba_objects);

SELECT  table_name,
        initial_extent,
        next_extent,
        pct_increase
FROM dba_tables
WHERE table_name like 'OBJETOS'; 

INSERT INTO objetos (
SELECT  *
FROM dba_objects); EXECUTE DBMS_STATS.GATHER_TABLE_STATS (ownname => USER, tabname => 'OBJETOS');

SELECT  ROUND(((num_rows*avg_row_len)/1024/1024) ,2) || ' MB' AS TABLE_SIZE
FROM dba_tables
WHERE table_name LIKE 'OBJETOS'; DELETE 
FROM objetos
WHERE rownum < ( 
SELECT  COUNT(*)/2
FROM objetos);

SELECT  TABLE_NAME,
        ROUND((num_rows*avg_row_len)/1024/1024,2) || ' MB'                    AS CONSUMED_SPACE,
        ROUND((blocks*8)/1024,2) || ' MB'                                     AS TOTAL_SIZE,
        ROUND( (blocks*8)/1024 - (num_rows*avg_row_len)/1024/1024,2) || ' MB' AS RECLAIMABLE_SPACE
FROM dba_tables
WHERE table_name LIKE 'OBJETOS'; 

SELECT  a.table_name,
        a.tablespace_name,
        b.segment_space_management
FROM dba_tables a, dba_tablespaces b
WHERE a.tablespace_name = b.tablespace_name 
AND a.table_name = 'OBJETOS'; 

ALTER TABLE objetos MOVE;
ALTER TABLE objetos ENABLE ROW MOVEMENT;
ALTER TABLE objetos MOVE TABLESPACE system;
EXECUTE dbms_stats.gather_table_stats('&owner_name' , '&table_name');