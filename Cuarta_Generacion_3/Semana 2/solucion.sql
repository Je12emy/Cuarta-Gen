SELECT  username,
        COUNT(*) AS session_count
FROM V$SESSION
WHERE username IS NOT NULL 
GROUP BY  username; -- Ejercicio 1

SELECT  SUM(BYTES)/1024/1024 AS db_size_in_mb
FROM dba_SEGMENTS; -- Ejercicio 2

SELECT  SEGMENT_NAME,
        BYTES,
        SEGMENT_TYPE
FROM DBA_SEGMENTS
WHERE SEGMENT_NAME LIKE 'CUSTOMER%'; -- Con esto se muestra la informacion sobre una tabla 

SELECT  SEGMENT_NAME    AS TABLE_NAME,
        SEGMENT_TYPE    AS SEGMENT_TYPE,
        BYTES/1024/1024 AS mb
FROM user_segments
WHERE rownum < 25 
AND (SEGMENT_TYPE <> 'INDEX' AND SEGMENT_TYPE = 'TABLE'); -- Ejercicio 3 

SELECT  SUM(bytes)/1024/1024 AS TABLE_SIZE_MB
FROM DBA_SEGMENTS
WHERE segment_name LIKE 'CUSTOMER%' 
AND (segment_type='TABLE' OR segment_type = 'INDEX'); -- Ejercicio 4 

SELECT  segment_name,
        segment_type,
        bytes/1024/1024 AS MB
FROM dba_segments
WHERE rownum < 25
ORDER BY mb desc; -- Ejercicio 5 

SELECT  s.tablespace_name,
        SUM(s.bytes)/1024/1024 || ' MB'                    AS used_space,-- used space 
        SUM((s.blocks * cf.block_size))/1024/1024 || ' MB' AS total_size,-- asigned blocks * blocksize = total size 
        SUBSTR(d.name,28)                                  AS DF_PATH
FROM dba_segments s, v$controlfile cf, v$datafile d
WHERE d.name LIKE '%'||s.tablespace_name||'%' 
GROUP BY  s.tablespace_name,
          d.name; -- Ejercicio 6 
