/* Universidad Argentina de la Empresa (UADE) */
/* Diseno y Administracion de Base de Datos */
/* Trabajo Practico N 2 - Lenguajes de Consulta */
/* Grupo 8 - Base Libros */
/* 27 oct 2026 */


IF DB_ID('tp_libros_g8') IS NULL
    CREATE DATABASE tp_libros_g8;
GO

USE tp_libros_g8;
GO

-- ==================================================================================================================
-- PARTE 1 - CREACION DE ESQUEMA
-- Limpieza de objetos previos, DDL con PK/FK y carga DML
-- ==================================================================================================================

DROP TABLE IF EXISTS PRESTAMO;
DROP TABLE IF EXISTS COPIAS;
DROP TABLE IF EXISTS LIBRO;
DROP TABLE IF EXISTS LECTOR;
DROP TABLE IF EXISTS TIPOLIBRO;
GO

/* Tabla de tipos de libro */
CREATE TABLE TIPOLIBRO (
    TIPO     CHAR(2)  NOT NULL,
    DESCTIPO CHAR(40) NULL,
    CONSTRAINT PK_TIPOLIBRO PRIMARY KEY (TIPO)
);

/* Catalogo de libros */
CREATE TABLE LIBRO (
    NRO_LIBRO  INT         NOT NULL,
    TITULO     CHAR(40)    NULL,
    AUTOR      CHAR(30)    NULL,
    TIPO       CHAR(2)     NULL,
    PRECIO_ORI SMALLMONEY  NULL,
    PRECIO_ACT SMALLMONEY  NULL,
    EDICION    SMALLINT    NULL,
    ESTADO     CHAR(1)     NULL,
    CONSTRAINT PK_LIBRO PRIMARY KEY (NRO_LIBRO),
    CONSTRAINT FK_LIBRO_TIPOLIBRO FOREIGN KEY (TIPO) REFERENCES TIPOLIBRO (TIPO)
);

/* Lectores / socios */
CREATE TABLE LECTOR (
    NRO_LECTOR INT         NOT NULL,
    NOMBRE     CHAR(22)    NULL,
    DIRECCION  CHAR(30)    NULL,
    TRABAJO    CHAR(10)    NULL,
    SALARIO    SMALLMONEY  NULL,
    ESTADO     CHAR(1)     NULL,
    CONSTRAINT PK_LECTOR PRIMARY KEY (NRO_LECTOR)
);

/* Ejemplares fisicos de cada libro */
CREATE TABLE COPIAS (
    NRO_LIBRO INT      NOT NULL,
    NRO_COPIA SMALLINT NOT NULL,
    ESTADO    CHAR(1)  NULL,
    CONSTRAINT PK_COPIAS PRIMARY KEY (NRO_LIBRO, NRO_COPIA),
    CONSTRAINT FK_COPIAS_LIBRO FOREIGN KEY (NRO_LIBRO) REFERENCES LIBRO (NRO_LIBRO)
);

/* Prestamos: una misma copia puede prestarse en fechas distintas.
La PK incluye NRO_LECTOR porque el DML registra la copia 2 de LA HOJARASCA
(10545377) prestada el mismo dia (2018-03-02) a dos lectores distintos
(123491 y 123456). Con PK (NRO_LIBRO, NRO_COPIA, F_PREST) la carga fallaria.
*/
CREATE TABLE PRESTAMO (
    NRO_LECTOR INT      NOT NULL,
    NRO_LIBRO  INT      NOT NULL,
    NRO_COPIA  SMALLINT NOT NULL,
    F_PREST    DATETIME NOT NULL,
    F_DEVOL    DATETIME NULL,
    CONSTRAINT PK_PRESTAMO PRIMARY KEY (NRO_LECTOR, NRO_LIBRO, NRO_COPIA, F_PREST),
    CONSTRAINT FK_PRESTAMO_LECTOR FOREIGN KEY (NRO_LECTOR) REFERENCES LECTOR (NRO_LECTOR),
    CONSTRAINT FK_PRESTAMO_COPIAS FOREIGN KEY (NRO_LIBRO, NRO_COPIA) REFERENCES COPIAS (NRO_LIBRO, NRO_COPIA)
);
GO

/*
NOTA: El DML original inserta LIBRO con TIPO = 'ez' (ETICA Y DEONTOLOGIA DOCENTE),
pero TIPOLIBRO no define 'ez'.
Lo consideramos un error de tipeo de 'es' (Estudio). Se corrige el dato
en el INSERT de LIBRO (8235698).
*/
INSERT INTO TIPOLIBRO VALUES ('cu', 'Cuentos');
INSERT INTO TIPOLIBRO VALUES ('di', 'Diccionario');
INSERT INTO TIPOLIBRO VALUES ('es', 'Estudio');
INSERT INTO TIPOLIBRO VALUES ('ju', 'Juegos');
INSERT INTO TIPOLIBRO VALUES ('no', 'Novela');

/* --------------------------- Carga LIBRO --------------------------- */
INSERT INTO LIBRO VALUES (5078912,  'LAS MIL Y UNA NOCHES',                  'GALLAND A.',                'no', 20.30,  34.20,  1948, NULL);
INSERT INTO LIBRO VALUES (6094527,  'FUENTEOVEJUNA',                         'LOPE DE VEGA',              'no', 18.35,  32.10,  1978, NULL);
INSERT INTO LIBRO VALUES (7034567,  'DICCIONARIO ITALIANO-ESPANOL',          'CERRUTI J.',                'di', 32.70,  32.70,  1992, NULL);
INSERT INTO LIBRO VALUES (8235698,  'ETICA Y DEONTOLOGIA DOCENTE',           'RUIZ DANIEL J.',            'es', 54.20,  76.30,  1990, NULL);  -- 'ez' corregido a 'es'
INSERT INTO LIBRO VALUES (8753124,  'TABLE GAMES',                           'MARRAN',                    'ju', 12.50,  13.25,  1991, NULL);
INSERT INTO LIBRO VALUES (9076234,  'BOTANICA MEDICINAL',                    'TRABUT L.',                 'es', 123.48, 143.20, 1978, NULL);
INSERT INTO LIBRO VALUES (9456789,  'EL CORONEL NO TIENE QUIEN LE ESCRIBA',  'GARCIA MARQUEZ GABRIEL',    'no', 23.20,  31.21,  1978, NULL);
INSERT INTO LIBRO VALUES (9876079,  'HISTORIA DE JULIO CESAR',               'OCHOA EUGENIO',             'es', 154.30, 167.20, 1946, NULL);
INSERT INTO LIBRO VALUES (10545377, 'LA HOJARASCA',                          'GABRIEL GARCIA MARQUEZ',    'no', 12.10,  15.20,  1988, NULL);
INSERT INTO LIBRO VALUES (10558904, 'FICCIONES',                             'BORGES JORGE LUIS',         'cu', 23.70,  25.40,  1979, NULL);
INSERT INTO LIBRO VALUES (10574387, 'SALON DE LECTURA',                      'DENEVI MARCO',              'cu', 14.50,  16.10,  1980, NULL);
INSERT INTO LIBRO VALUES (10654324, 'HISTORIA ARGENTINA',                    'BUSANICHE J.L.',            'es', 56.30,  59.30,  1985, NULL);
INSERT INTO LIBRO VALUES (10789443, 'DICCIONARIO INGLES-ESPANOL',            'APPLETON-CUYAS',            'di', 98.30,  123.50, 1986, NULL);
GO

/* --------------------------- Carga COPIAS --------------------------- */
INSERT INTO COPIAS VALUES (5078912, 1, NULL);
INSERT INTO COPIAS VALUES (6094527, 1, NULL);
INSERT INTO COPIAS VALUES (7034567, 1, NULL);
INSERT INTO COPIAS VALUES (8235698, 1, NULL);
INSERT INTO COPIAS VALUES (8753124, 1, NULL);
INSERT INTO COPIAS VALUES (9076234, 1, NULL);
INSERT INTO COPIAS VALUES (9456789, 1, NULL);
INSERT INTO COPIAS VALUES (9876079, 1, NULL);
INSERT INTO COPIAS VALUES (10545377, 1, NULL);
INSERT INTO COPIAS VALUES (10558904, 1, NULL);
INSERT INTO COPIAS VALUES (10574387, 1, NULL);
INSERT INTO COPIAS VALUES (10654324, 1, NULL);
INSERT INTO COPIAS VALUES (10789443, 1, NULL);

INSERT INTO COPIAS VALUES (5078912, 2, NULL);
INSERT INTO COPIAS VALUES (6094527, 2, NULL);
INSERT INTO COPIAS VALUES (7034567, 2, NULL);
INSERT INTO COPIAS VALUES (8235698, 2, NULL);
INSERT INTO COPIAS VALUES (8753124, 2, NULL);
INSERT INTO COPIAS VALUES (9076234, 2, NULL);
INSERT INTO COPIAS VALUES (9456789, 2, NULL);
INSERT INTO COPIAS VALUES (9876079, 2, NULL);
INSERT INTO COPIAS VALUES (10545377, 2, NULL);
INSERT INTO COPIAS VALUES (10558904, 2, NULL);
INSERT INTO COPIAS VALUES (10574387, 2, NULL);
INSERT INTO COPIAS VALUES (10654324, 2, NULL);
INSERT INTO COPIAS VALUES (10789443, 2, NULL);

INSERT INTO COPIAS VALUES (5078912, 3, NULL);
INSERT INTO COPIAS VALUES (6094527, 3, NULL);
INSERT INTO COPIAS VALUES (7034567, 3, NULL);
INSERT INTO COPIAS VALUES (8235698, 3, NULL);
INSERT INTO COPIAS VALUES (8753124, 3, NULL);
INSERT INTO COPIAS VALUES (9076234, 3, NULL);
INSERT INTO COPIAS VALUES (9456789, 3, NULL);
INSERT INTO COPIAS VALUES (9876079, 3, NULL);
INSERT INTO COPIAS VALUES (10545377, 3, NULL);
INSERT INTO COPIAS VALUES (10558904, 3, NULL);
INSERT INTO COPIAS VALUES (10574387, 3, NULL);
INSERT INTO COPIAS VALUES (10654324, 3, NULL);
INSERT INTO COPIAS VALUES (10789443, 3, NULL);

INSERT INTO COPIAS VALUES (5078912, 4, NULL);
INSERT INTO COPIAS VALUES (6094527, 4, NULL);
INSERT INTO COPIAS VALUES (7034567, 4, NULL);
INSERT INTO COPIAS VALUES (8235698, 4, NULL);
INSERT INTO COPIAS VALUES (8753124, 4, NULL);
INSERT INTO COPIAS VALUES (9076234, 4, NULL);

/* --------------------------- Carga LECTOR --------------------------- */
INSERT INTO LECTOR VALUES (123456, 'GOMEZ Arnoldo',           'Avda. La Reja 2234 - Capital',  'EMPLEADO',   1234.50, NULL);
INSERT INTO LECTOR VALUES (123467, 'FERNANDEZ Guillermo',     'San Pedro 987 - Moron',         'EJECUTIVO',  3245.50, NULL);
INSERT INTO LECTOR VALUES (123478, 'GARCIA Manuel',           'Avda de los Sioux 2211 - Korn', 'VENDEDOR',   1345.50, NULL);
INSERT INTO LECTOR VALUES (123489, 'VALLEJOS Pancracio',      'San Martin 231 - Capital Fed.', 'EMPLEADO',    734.60, NULL);
INSERT INTO LECTOR VALUES (123490, 'APPICCIAFUOCO Gerardo',   'De los Rosales 234 - Merlo',    'EMPLEADO',    534.20, NULL);
INSERT INTO LECTOR VALUES (123491, 'BANKO Lou',               'Tres Sargentos 333 - V.Plot',   'VENDEDOR',   1215.30, NULL);
INSERT INTO LECTOR VALUES (123494, 'CASTAÑA Jorge',           'Avda. de los Peruanos 1234',    'EJECUTIVO',  2453.90, NULL);
INSERT INTO LECTOR VALUES (124200, 'MARENGHI Pick',           'De las Rosas 234 - Palomar',    'EMPLEADO',    975.40, NULL);
INSERT INTO LECTOR VALUES (124230, 'PEREZ GIL Miguel',        'Los Tomatoes 125 - V.Adelina',  'COMERCIANT', 1345.45, NULL);
INSERT INTO LECTOR VALUES (124231, 'MIRANDA Hermenegildo',    'San Cono 901 - V.Milagros',     'VENDEDOR',    856.30, NULL);
INSERT INTO LECTOR VALUES (124392, 'MOLINO Gualterio',        'Potatoes 29357 - Palermo',      'COMERCIANT', 2356.45, NULL);
INSERT INTO LECTOR VALUES (125376, 'PIE Lemon',               'Rivadavia 2890 - V.Tesei',      'EJECUTIVO',  3020.40, NULL);
INSERT INTO LECTOR VALUES (125678, 'MARTINEZ Charles',        'De las Amapolas 124 B.Chino',   'COMERCIANT', 2357.40, NULL);
INSERT INTO LECTOR VALUES (125789, 'YAMIMOTO Scutter',        'Biela 4325 Dpto.3 4P - Cap.',   'COMERCIANT', 1876.50, NULL);

/* --------------------------- Carga PRESTAMO --------------------------- */
INSERT INTO PRESTAMO VALUES (123456, 10545377, 1, '2018-03-01', '2018-03-10');
INSERT INTO PRESTAMO VALUES (123491, 10545377, 2, '2018-03-02', NULL);
INSERT INTO PRESTAMO VALUES (123478, 10545377, 3, '2018-03-03', NULL);
INSERT INTO PRESTAMO VALUES (125376, 10545377, 1, '2018-03-15', '2018-03-20');
INSERT INTO PRESTAMO VALUES (123456, 10545377, 2, '2018-03-02', '2018-06-10');
INSERT INTO PRESTAMO VALUES (123456, 10558904, 1, '2018-03-01', NULL);
INSERT INTO PRESTAMO VALUES (124231, 10558904, 2, '2018-03-02', '2018-03-03');
INSERT INTO PRESTAMO VALUES (124231, 10558904, 2, '2018-03-05', NULL);
INSERT INTO PRESTAMO VALUES (123478, 9456789,  1, '2018-03-02', '2018-03-08');
INSERT INTO PRESTAMO VALUES (123490, 5078912,  4, '2018-03-03', NULL);
GO

/* Control de carga */
SELECT 'TIPOLIBRO' AS tabla, COUNT(*) AS filas FROM TIPOLIBRO
UNION ALL SELECT 'LIBRO',    COUNT(*) FROM LIBRO
UNION ALL SELECT 'COPIAS',   COUNT(*) FROM COPIAS
UNION ALL SELECT 'LECTOR',   COUNT(*) FROM LECTOR
UNION ALL SELECT 'PRESTAMO', COUNT(*) FROM PRESTAMO;
GO

-- ==================================================================================================================
-- PARTE 2 - RESOLUCION DE SENTENCIAS SQL
-- ==================================================================================================================

-- ==================================================================================================================
-- EJERCICIO 1
-- Titulos y autores de libros tipo 'no' con precio original > 21.
-- ==================================================================================================================
SELECT
    TITULO,
    AUTOR
FROM LIBRO
WHERE TIPO = 'no'
AND PRECIO_ORI > 21;

-- ==================================================================================================================
-- EJERCICIO 2
-- Titulos y autores: tipo 'no' O precio original > 21.
-- ==================================================================================================================
SELECT
    TITULO,
    AUTOR
FROM LIBRO
WHERE TIPO = 'no'
OR PRECIO_ORI > 21;

-- ==================================================================================================================
-- EJERCICIO 3
-- Nro, precio original y edicion: tipo 'no' O (precio original > 21 Y edicion > 1985).
-- Precedencia AND > OR.
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    PRECIO_ORI,
    EDICION
FROM LIBRO
WHERE TIPO = 'no'
OR (PRECIO_ORI > 21 AND EDICION > 1985);

-- ==================================================================================================================
-- EJERCICIO 4
-- Nro, precio original y edicion: edicion > 1985 Y (tipo 'no' O precio original > 21).
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    PRECIO_ORI,
    EDICION
FROM LIBRO
WHERE EDICION > 1985
AND (TIPO = 'no' OR PRECIO_ORI > 21);

-- ==================================================================================================================
-- EJERCICIO 5
-- Titulos y precios originales editados en 1948, 1978 y 1985.
-- ==================================================================================================================
SELECT
    TITULO,
    PRECIO_ORI
FROM LIBRO
WHERE EDICION IN (1948, 1978, 1985);

-- ==================================================================================================================
-- EJERCICIO 6
-- Titulos y ediciones con precio original entre 12 y 25 inclusive.
-- ==================================================================================================================
SELECT
    TITULO,
    EDICION
FROM LIBRO
WHERE PRECIO_ORI BETWEEN 12 AND 25;

-- ==================================================================================================================
-- EJERCICIO 7
-- Autores y ediciones cuyo nombre de autor comienza con L.
-- ==================================================================================================================
SELECT
    AUTOR,
    EDICION
FROM LIBRO
WHERE AUTOR LIKE 'L%';

-- ==================================================================================================================
-- EJERCICIO 8
-- Autores, precios originales y ediciones con hilera "RR" en el nombre del autor.
-- ==================================================================================================================
SELECT
    AUTOR,
    PRECIO_ORI,
    EDICION
FROM LIBRO
WHERE AUTOR LIKE '%RR%';

-- ==================================================================================================================
-- EJERCICIO 9
-- Titulos, precios originales y ediciones con "R" y luego "S" en el titulo (ese orden).
-- ==================================================================================================================
SELECT
    TITULO,
    PRECIO_ORI,
    EDICION
FROM LIBRO
WHERE TITULO LIKE '%R%S%';

-- ==================================================================================================================
-- EJERCICIO 10
-- Titulos, precios originales y ediciones con "A" en la segunda posicion del titulo.
-- ==================================================================================================================
SELECT
    TITULO,
    PRECIO_ORI,
    EDICION
FROM LIBRO
WHERE TITULO LIKE '_A%';

-- ==================================================================================================================
-- EJERCICIO 11
-- Autores y ediciones cuyo nombre de autor NO comienza con G.
-- ==================================================================================================================
SELECT
    AUTOR,
    EDICION
FROM LIBRO
WHERE AUTOR NOT LIKE 'G%';

-- ==================================================================================================================
-- EJERCICIO 12
-- Titulos y ediciones cuyo precio original NO esta entre 12 y 25.
-- ==================================================================================================================
SELECT
    TITULO,
    EDICION
FROM LIBRO
WHERE PRECIO_ORI NOT BETWEEN 12 AND 25;

-- ==================================================================================================================
-- EJERCICIO 13
-- Titulos y edicion de tipo 'no', ordenados por anio de edicion ascendente.
-- ==================================================================================================================
SELECT
    TITULO,
    EDICION
FROM LIBRO
WHERE TIPO = 'no'
ORDER BY EDICION ASC;

-- ==================================================================================================================
-- EJERCICIO 14
-- Nro, edicion y tipo con precio original > 20.
-- Orden: edicion DESC, nro libro ASC.
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    EDICION,
    TIPO
FROM LIBRO
WHERE PRECIO_ORI > 20
ORDER BY EDICION DESC, NRO_LIBRO ASC;

-- ==================================================================================================================
-- EJERCICIO 15
-- Idem 14, orden: edicion ASC, nro libro DESC.
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    EDICION,
    TIPO
FROM LIBRO
WHERE PRECIO_ORI > 20
ORDER BY EDICION ASC, NRO_LIBRO DESC;

-- ==================================================================================================================
-- EJERCICIO 16
-- Todos los tipos y ediciones de los libros.
-- ==================================================================================================================
SELECT
    TIPO,
    EDICION
FROM LIBRO;

-- ==================================================================================================================
-- EJERCICIO 17
-- Idem 16, ordenado por Tipo y Edicion ascendente.
-- ==================================================================================================================
SELECT
    TIPO,
    EDICION
FROM LIBRO
ORDER BY TIPO ASC, EDICION ASC;

-- ==================================================================================================================
-- EJERCICIO 18
-- Tipos y ediciones DISTINTAS, ordenado por Edicion ascendente.
-- Diferencia con 17: la 17 devuelve 13 filas y la 18 devuelve 12.
-- El par ('no', 1978) aparece dos veces en la 17, porque FUENTEOVEJUNA y
-- EL CORONEL NO TIENE QUIEN LE ESCRIBA son novelas editadas en 1978.
-- Por que: sin DISTINCT se devuelve una fila por libro; DISTINCT elimina
-- las filas cuyo par (TIPO, EDICION) esta repetido y deja una sola.
-- ==================================================================================================================
SELECT DISTINCT
    TIPO,
    EDICION
FROM LIBRO
ORDER BY EDICION ASC;

-- ==================================================================================================================
-- EJERCICIO 19
-- Nro, edicion, tipo, precios y diferencia para libros de estudio (tipo 'es').
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    EDICION,
    TIPO,
    PRECIO_ORI,
    PRECIO_ACT,
    (PRECIO_ACT - PRECIO_ORI) AS DIFERENCIA
FROM LIBRO
WHERE TIPO = 'es';

-- ==================================================================================================================
-- EJERCICIO 20
-- Idem campos, pero diferencia de precio > 10.
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    EDICION,
    TIPO,
    PRECIO_ORI,
    PRECIO_ACT,
    (PRECIO_ACT - PRECIO_ORI) AS DIFERENCIA
FROM LIBRO
WHERE (PRECIO_ACT - PRECIO_ORI) > 10;

-- ==================================================================================================================
-- EJERCICIO 21
-- Idem 20, ordenado por diferencia descendente.
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    EDICION,
    TIPO,
    PRECIO_ORI,
    PRECIO_ACT,
    (PRECIO_ACT - PRECIO_ORI) AS DIFERENCIA
FROM LIBRO
WHERE (PRECIO_ACT - PRECIO_ORI) > 10
ORDER BY DIFERENCIA DESC;

-- ==================================================================================================================
-- EJERCICIO 22
-- Todos los libros con diferencia, orden: tipo ASC, diferencia ASC.
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    EDICION,
    TIPO,
    PRECIO_ORI,
    PRECIO_ACT,
    (PRECIO_ACT - PRECIO_ORI) AS DIFERENCIA
FROM LIBRO
ORDER BY TIPO ASC, DIFERENCIA ASC;

-- ==================================================================================================================
-- EJERCICIO 23
-- Suma y promedio de precios originales; min y max de precios actuales.
-- Solo edicion > 1970.
-- ==================================================================================================================
SELECT
    SUM(PRECIO_ORI) AS SUMA_PRECIO_ORI,
    AVG(PRECIO_ORI) AS PROM_PRECIO_ORI,
    MIN(PRECIO_ACT) AS MIN_PRECIO_ACT,
    MAX(PRECIO_ACT) AS MAX_PRECIO_ACT
FROM LIBRO
WHERE EDICION > 1970;

-- ==================================================================================================================
-- EJERCICIO 24
-- Suma total de (precio original + actual), promedio de esa suma,
-- min y max de diferencias. Edicion > 1970.
-- ==================================================================================================================
SELECT
    SUM(PRECIO_ORI + PRECIO_ACT) AS SUMA_TOTAL_ORI_ACT,
    AVG(PRECIO_ORI + PRECIO_ACT) AS PROM_SUMA_ORI_ACT,
    MIN(PRECIO_ACT - PRECIO_ORI) AS MIN_DIFERENCIA,
    MAX(PRECIO_ACT - PRECIO_ORI) AS MAX_DIFERENCIA
FROM LIBRO
WHERE EDICION > 1970;

-- ==================================================================================================================
-- EJERCICIO 25
-- Cantidad de libros, distintos tipos, min y max precio original.
-- Solo precio original > 30.
-- ==================================================================================================================
SELECT
    COUNT(*) AS CANTIDAD_LIBROS,
    COUNT(DISTINCT TIPO) AS DISTINTOS_TIPOS,
    MIN(PRECIO_ORI) AS MIN_PRECIO_ORI,
    MAX(PRECIO_ORI) AS MAX_PRECIO_ORI
FROM LIBRO
WHERE PRECIO_ORI > 30;

-- ==================================================================================================================
-- EJERCICIO 26
-- Promedio y total de precios actuales, con titulos "PROMEDIO --->" y "TOTAL --->".
-- ==================================================================================================================
SELECT
    AVG(PRECIO_ACT) AS [PROMEDIO --->],
    SUM(PRECIO_ACT) AS [TOTAL --->]
FROM LIBRO;

-- ==================================================================================================================
-- EJERCICIO 27
-- Tipos, total precios originales y promedio precios actuales.
-- Excluye edicion 1946. Agrupado por tipo.
-- ==================================================================================================================
SELECT
    TIPO,
    SUM(PRECIO_ORI) AS TOTAL_PRECIO_ORI,
    AVG(PRECIO_ACT) AS PROM_PRECIO_ACT
FROM LIBRO
WHERE EDICION <> 1946
GROUP BY TIPO;

-- ==================================================================================================================
-- EJERCICIO 28
-- Idem 27, ordenado por promedio de precios actuales ASC.
-- ==================================================================================================================
SELECT
    TIPO,
    SUM(PRECIO_ORI) AS TOTAL_PRECIO_ORI,
    AVG(PRECIO_ACT) AS PROM_PRECIO_ACT
FROM LIBRO
WHERE EDICION <> 1946
GROUP BY TIPO
ORDER BY PROM_PRECIO_ACT ASC;

-- ==================================================================================================================
-- EJERCICIO 29
-- Idem 27, pero solo tipos cuya suma de precios originales > 40.
-- ==================================================================================================================
SELECT
    TIPO,
    SUM(PRECIO_ORI) AS TOTAL_PRECIO_ORI,
    AVG(PRECIO_ACT) AS PROM_PRECIO_ACT
FROM LIBRO
WHERE EDICION <> 1946
GROUP BY TIPO
HAVING SUM(PRECIO_ORI) > 40;

-- ==================================================================================================================
-- EJERCICIO 30
-- Primeros cinco caracteres del nombre de todos los lectores.
-- ==================================================================================================================
SELECT
    LEFT(NOMBRE, 5) AS PRIMEROS_5
FROM LECTOR;

-- ==================================================================================================================
-- EJERCICIO 31
-- Nombre y direccion de lectores con libros a prestamo vigente (subconsulta).
-- Interpretacion: "tienen libros a prestamo" = prestamos aun no devueltos
-- (F_DEVOL IS NULL). Sin ese filtro se listarian todos los que alguna vez
-- pidieron un libro.
-- ==================================================================================================================
SELECT
    NOMBRE,
    DIRECCION
FROM LECTOR
WHERE NRO_LECTOR IN (
    SELECT NRO_LECTOR
    FROM PRESTAMO
    WHERE F_DEVOL IS NULL
);

-- ==================================================================================================================
-- EJERCICIO 32
-- Nro, titulo y precio original > promedio de precios actuales de todos los libros.
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    TITULO,
    PRECIO_ORI
FROM LIBRO
WHERE PRECIO_ORI > (
    SELECT AVG(PRECIO_ACT)
    FROM LIBRO
);

-- ==================================================================================================================
-- EJERCICIO 33
-- Nro, titulo y precio actual del libro con maximo precio original.
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    TITULO,
    PRECIO_ACT
FROM LIBRO
WHERE PRECIO_ORI = (
    SELECT MAX(PRECIO_ORI)
    FROM LIBRO
);

-- ==================================================================================================================
-- EJERCICIO 34
-- Nro, titulo y precio original mayores que TODOS los precios originales de novelas.
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    TITULO,
    PRECIO_ORI
FROM LIBRO
WHERE PRECIO_ORI > ALL (
    SELECT PRECIO_ORI
    FROM LIBRO
    WHERE TIPO = 'no'
);

-- ==================================================================================================================
-- EJERCICIO 35
-- Nro, titulo y precio original mayores que ALGUNO de los precios originales de novelas.
-- ==================================================================================================================
SELECT
    NRO_LIBRO,
    TITULO,
    PRECIO_ORI
FROM LIBRO
WHERE PRECIO_ORI > ANY (
    SELECT PRECIO_ORI
    FROM LIBRO
    WHERE TIPO = 'no'
);

-- ==================================================================================================================
-- EJERCICIO 36
-- Tipos y promedio de precios originales, solo tipos con promedio por arriba
-- del promedio general de precios originales.
-- ==================================================================================================================
SELECT
    TIPO,
    AVG(PRECIO_ORI) AS PROM_PRECIO_ORI
FROM LIBRO
GROUP BY TIPO
HAVING AVG(PRECIO_ORI) > (
    SELECT AVG(PRECIO_ORI)
    FROM LIBRO
);

-- ==================================================================================================================
-- EJERCICIO 37
-- Hay error de sintaxis en: Select * from (select nro_libro, titulo from Libro)
-- RESPUESTA: SI. Falta alias de la tabla derivada.
-- En SQL Server toda subconsulta en FROM necesita alias.
-- Sintaxis correcta:
-- ==================================================================================================================
SELECT *
FROM (
    SELECT NRO_LIBRO, TITULO
    FROM LIBRO
) AS T;

-- ==================================================================================================================
-- EJERCICIO 38
-- Nombres de Lectores y Autores, orden ASC, con campo que identifique 'Autor' o 'Lector'.
-- ==================================================================================================================
SELECT
    RTRIM(AUTOR) AS NOMBRE,
    'Autor' AS TIPO_PERSONA
FROM LIBRO
UNION
SELECT
    RTRIM(NOMBRE) AS NOMBRE,
    'Lector' AS TIPO_PERSONA
FROM LECTOR
ORDER BY NOMBRE ASC;

-- ==================================================================================================================
-- EJERCICIO 39
-- Titulo, fecha de prestamo y fecha de devolucion de libros prestados.
-- ==================================================================================================================
SELECT
    L.TITULO,
    P.F_PREST,
    P.F_DEVOL
FROM PRESTAMO AS P
INNER JOIN LIBRO AS L ON P.NRO_LIBRO = L.NRO_LIBRO;

-- ==================================================================================================================
-- EJERCICIO 40
-- Nro de libro, titulo, fecha de prestamo y fecha de devolucion.
-- ==================================================================================================================
SELECT
    L.NRO_LIBRO,
    L.TITULO,
    P.F_PREST,
    P.F_DEVOL
FROM PRESTAMO AS P
INNER JOIN LIBRO AS L ON P.NRO_LIBRO = L.NRO_LIBRO;

-- ==================================================================================================================
-- EJERCICIO 41
-- Nro de lector, nombre y cantidad de prestamos realizados.
-- ==================================================================================================================
SELECT
    LE.NRO_LECTOR,
    LE.NOMBRE,
    COUNT(*) AS CANTIDAD_PRESTAMOS
FROM LECTOR AS LE
INNER JOIN PRESTAMO AS P ON LE.NRO_LECTOR = P.NRO_LECTOR
GROUP BY LE.NRO_LECTOR, LE.NOMBRE;

/* Otra opción incluyendo a los lectores sin prestamos. */
SELECT
    LE.NRO_LECTOR,
    LE.NOMBRE,
    COUNT(P.NRO_LECTOR) AS CANTIDAD_PRESTAMOS
FROM LECTOR AS LE
LEFT JOIN PRESTAMO AS P ON LE.NRO_LECTOR = P.NRO_LECTOR
GROUP BY LE.NRO_LECTOR, LE.NOMBRE;

-- ==================================================================================================================
-- EJERCICIO 42
-- Nro de libro, titulo y cantidad de prestamos desde el anio 2012.
-- ==================================================================================================================
SELECT
    L.NRO_LIBRO,
    L.TITULO,
    COUNT(*) AS CANTIDAD_PRESTAMOS
FROM LIBRO AS L
INNER JOIN PRESTAMO AS P ON L.NRO_LIBRO = P.NRO_LIBRO
WHERE YEAR(P.F_PREST) >= 2012
GROUP BY L.NRO_LIBRO, L.TITULO;

-- ==================================================================================================================
-- EJERCICIO 43
-- Nro libro, titulo, nro copia y cantidad de prestamos por cada copia.
-- ==================================================================================================================
SELECT
    L.NRO_LIBRO,
    L.TITULO,
    P.NRO_COPIA,
    COUNT(*) AS CANTIDAD_PRESTAMOS
FROM LIBRO AS L
INNER JOIN PRESTAMO AS P ON L.NRO_LIBRO = P.NRO_LIBRO
GROUP BY L.NRO_LIBRO, L.TITULO, P.NRO_COPIA;

-- ==================================================================================================================
-- EJERCICIO 44
-- Idem 43, solo copias prestadas mas de 1 vez.
-- ==================================================================================================================
SELECT
    L.NRO_LIBRO,
    L.TITULO,
    P.NRO_COPIA,
    COUNT(*) AS CANTIDAD_PRESTAMOS
FROM LIBRO AS L
INNER JOIN PRESTAMO AS P ON L.NRO_LIBRO = P.NRO_LIBRO
GROUP BY L.NRO_LIBRO, L.TITULO, P.NRO_COPIA
HAVING COUNT(*) > 1;

-- ==================================================================================================================
-- EJERCICIO 45
-- Titulos prestados y nombres de lectores que los tienen en prestamo (sin devolver).
-- Interpretacion: "los tienen en prestamo" = prestamo vigente (F_DEVOL IS NULL).
-- ==================================================================================================================
SELECT
    L.TITULO,
    LE.NOMBRE
FROM PRESTAMO AS P
INNER JOIN LIBRO AS L ON P.NRO_LIBRO = L.NRO_LIBRO
INNER JOIN LECTOR AS LE ON P.NRO_LECTOR = LE.NRO_LECTOR
WHERE P.F_DEVOL IS NULL;

-- ==================================================================================================================
-- EJERCICIO 46
-- Nro lector, nombre y fecha prestamo: prestamos NO devueltos (F_DEVOL IS NULL).
-- ==================================================================================================================
SELECT
    LE.NRO_LECTOR,
    LE.NOMBRE,
    P.F_PREST
FROM LECTOR AS LE
INNER JOIN PRESTAMO AS P ON LE.NRO_LECTOR = P.NRO_LECTOR
WHERE P.F_DEVOL IS NULL;

-- ==================================================================================================================
-- EJERCICIO 47
-- Nro lector, nombre, nro libro, titulo, fecha prestamo: prestamos DEVUELTOS.
-- ==================================================================================================================
SELECT
    LE.NRO_LECTOR,
    LE.NOMBRE,
    L.NRO_LIBRO,
    L.TITULO,
    P.F_PREST
FROM PRESTAMO AS P
INNER JOIN LECTOR AS LE ON P.NRO_LECTOR = LE.NRO_LECTOR
INNER JOIN LIBRO AS L ON P.NRO_LIBRO = L.NRO_LIBRO
WHERE P.F_DEVOL IS NOT NULL;

-- ==================================================================================================================
-- EJERCICIO 48
-- Idem 47, tipo Novela o Cuentos ('no' o 'cu').
-- ==================================================================================================================
SELECT
    LE.NRO_LECTOR,
    LE.NOMBRE,
    L.NRO_LIBRO,
    L.TITULO,
    P.F_PREST
FROM PRESTAMO AS P
INNER JOIN LECTOR AS LE ON P.NRO_LECTOR = LE.NRO_LECTOR
INNER JOIN LIBRO AS L ON P.NRO_LIBRO = L.NRO_LIBRO
WHERE P.F_DEVOL IS NOT NULL
AND L.TIPO IN ('no', 'cu');

-- ==================================================================================================================
-- EJERCICIO 49
-- Idem 48, agregando descripcion del tipo de libro.
-- ==================================================================================================================
SELECT
    LE.NRO_LECTOR,
    LE.NOMBRE,
    L.NRO_LIBRO,
    L.TITULO,
    T.DESCTIPO,
    P.F_PREST
FROM PRESTAMO AS P
INNER JOIN LECTOR AS LE ON P.NRO_LECTOR = LE.NRO_LECTOR
INNER JOIN LIBRO AS L ON P.NRO_LIBRO = L.NRO_LIBRO
INNER JOIN TIPOLIBRO AS T ON L.TIPO = T.TIPO
WHERE P.F_DEVOL IS NOT NULL
AND L.TIPO IN ('no', 'cu');

-- ==================================================================================================================
-- EJERCICIO 50
-- Nro lector, nombre y fecha prestamo de TODOS los lectores (con o sin prestamo).
-- ==================================================================================================================
SELECT
    LE.NRO_LECTOR,
    LE.NOMBRE,
    P.F_PREST
FROM LECTOR AS LE
LEFT JOIN PRESTAMO AS P ON LE.NRO_LECTOR = P.NRO_LECTOR;

-- ==================================================================================================================
-- EJERCICIO 51
-- Nro libro, titulo, nro copia y fecha prestamo de TODAS las copias (prestadas o no).
-- ==================================================================================================================
SELECT
    C.NRO_LIBRO,
    L.TITULO,
    C.NRO_COPIA,
    P.F_PREST
FROM COPIAS AS C
INNER JOIN LIBRO AS L ON C.NRO_LIBRO = L.NRO_LIBRO
LEFT JOIN PRESTAMO AS P
    ON C.NRO_LIBRO = P.NRO_LIBRO
    AND C.NRO_COPIA = P.NRO_COPIA;

-- ==================================================================================================================
-- EJERCICIO 52
-- Sentencia que involucre TODOS los campos de TODAS las tablas.
-- Es posible? SI.
--   a) Con SELECT * FROM LIBRO, TIPOLIBRO, COPIAS,
--      LECTOR, PRESTAMO (sin condiciones) devuelve todos los campos, pero sería un
--      producto cartesiano (13 x 5 x 45 x 14 x 10 filas).
--   b) Uniendo las tablas por sus claves (PK/FK).
-- Nota: LEFT JOIN a PRESTAMO conserva las copias nunca prestadas.
-- LECTOR se une a traves de PRESTAMO, asi que los lectores sin prestamos
-- no aparecerían. Para conservarlos usamos FULL JOIN con LECTOR, lo que hace que las 
-- columnas de LIBRO queden en NULL.
-- Los datos de libro/copia se repiten una vez por cada prestamo.
-- ==================================================================================================================
SELECT
    L.NRO_LIBRO,
    L.TITULO,
    L.AUTOR,
    L.TIPO,
    L.PRECIO_ORI,
    L.PRECIO_ACT,
    L.EDICION,
    L.ESTADO AS ESTADO_LIBRO,
    T.TIPO AS TIPO_CATALOGO,
    T.DESCTIPO,
    C.NRO_LIBRO AS NRO_LIBRO_COPIA,
    C.NRO_COPIA,
    C.ESTADO AS ESTADO_COPIA,
    LE.NRO_LECTOR,
    LE.NOMBRE,
    LE.DIRECCION,
    LE.TRABAJO,
    LE.SALARIO,
    LE.ESTADO AS ESTADO_LECTOR,
    P.NRO_LECTOR AS NRO_LECTOR_PRESTAMO,
    P.NRO_LIBRO AS NRO_LIBRO_PRESTAMO,
    P.NRO_COPIA AS NRO_COPIA_PRESTAMO,
    P.F_PREST,
    P.F_DEVOL
FROM LIBRO AS L
INNER JOIN TIPOLIBRO AS T ON L.TIPO = T.TIPO
INNER JOIN COPIAS AS C ON L.NRO_LIBRO = C.NRO_LIBRO
LEFT JOIN PRESTAMO AS P
    ON C.NRO_LIBRO = P.NRO_LIBRO
    AND C.NRO_COPIA = P.NRO_COPIA
FULL JOIN LECTOR AS LE ON P.NRO_LECTOR = LE.NRO_LECTOR;

-- ==================================================================================================================
-- EJERCICIO 53
-- Sentencia:
--   select * from PRESTAMO
--   where NRO_COPIA < 5
--     and 'no' in (select TIPO from LIBRO L where L.NRO_LIBRO = NRO_LIBRO)
--
-- Objetivo: devolver los prestamos con NRO_COPIA < 5 cuyo libro sea tipo 
-- novela ('no').
--
-- Error: en la subconsulta, NRO_LIBRO no tiene alias, entonces, sql busca una
-- columna sin alias primero en las tablas de la propia subconsulta; como
-- LIBRO L tiene NRO_LIBRO, la resuelve como L.NRO_LIBRO. La condicion queda 
-- L.NRO_LIBRO = L.NRO_LIBRO, que es siempre verdadera, y la subconsulta no 
-- queda correlacionada con PRESTAMO.
-- Entonces, la subconsulta devuelve los tipos de TODOS los libros. Como
-- existe alguna novela, 'no' IN (...) es siempre verdadero y la sentencia
-- devuelve los 10 prestamos (todos tienen NRO_COPIA < 5), en lugar de
-- los 7 que corresponden a novelas (quedan afuera los 3 de FICCIONES, 'cu').
-- La solución sería calificar la columna externa con el alias de PRESTAMO.
--
-- Sintaxis correcta:
-- ==================================================================================================================
SELECT *
FROM PRESTAMO AS P
WHERE P.NRO_COPIA < 5
AND 'no' IN (
    SELECT L.TIPO
    FROM LIBRO AS L
    WHERE L.NRO_LIBRO = P.NRO_LIBRO
    );

/* Otra opción con JOIN */
SELECT P.*
FROM PRESTAMO AS P
INNER JOIN LIBRO AS L ON P.NRO_LIBRO = L.NRO_LIBRO
WHERE P.NRO_COPIA < 5
AND L.TIPO = 'no';
GO
