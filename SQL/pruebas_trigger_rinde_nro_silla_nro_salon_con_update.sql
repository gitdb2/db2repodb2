INSERT INTO estudiante VALUES (1, 1, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (2, 2, 'paraguay', 'est2', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (3, 3, 'paraguay', 'est3', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (4, 4, 'paraguay', 'est4', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (5, 5, 'paraguay', 'est5', 'apellido', 'asuncion');
INSERT INTO institucion VALUES ('inst1', 'paraguay', 'asuncion', 'chilavert road 1354', '-04:00');
INSERT INTO salon VALUES ('inst1', 1, 2, 1);
INSERT INTO salon VALUES ('inst1', 2, 2, 1);
INSERT INTO examen VALUES (1, 'test de cooper', 'S');

INSERT INTO inscribe VALUES (1, 1);
INSERT INTO inscribe VALUES (2, 1);
INSERT INTO inscribe VALUES (3, 1);
INSERT INTO inscribe VALUES (4, 1);
INSERT INTO inscribe VALUES (5, 1);

INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011/01/01 16:00:', 'yyyy/mm/dd HH24:MI:'));

--PRE-(SILLA en salon original disponible)
DELETE FROM RINDE WHERE 1=1;
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
--POST 
--DEBE permitir el update pues la silla 2 en el salon 2 esta libre
UPDATE rinde
SET nro_salon= 2
WHERE nro_estudiante = 2;
--EXITO
---------

--PRE	(MISMO SALON NUEVA SILLA)
DELETE FROM RINDE WHERE 1=1;
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 1);

--POST  
--DEBE TIRAR ERROR  , no permitir el update y en el mensaje informar que se debe usar la 
-- silla 2 del salon 1, si se quiere realizar un update posible
UPDATE rinde
SET nro_salon= 1
WHERE nro_estudiante = 2;
---------


--PRE (NUEVO SALON MISMA SILLA)
DELETE FROM RINDE WHERE 1=1;
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
--POST  
--DEBE TIRAR ERROR  , no permitir el update y en el mensaje informar que se debe usar la 
-- silla 1 del salon 2, si se quiere realizar un update posible
UPDATE rinde
SET nro_salon= 1
WHERE nro_estudiante = 1;
--EXITO
---------

--PRE  (CUALQUIER SALON, CUALQUIER SILLA)
--cualquier silla y cualquier salon, si busco registrarme en salon 2 silla 1 
DELETE FROM RINDE WHERE 1=1;
UPDATE SALON SET nro_silla_max = 3 where nro_salon = 1 and nombre_institucion = 'inst1';
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
INSERT INTO rinde VALUES (1, 3, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 4, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 2);

--POST debe retornar salon 1 silla 3 
--DEBE TIRAR ERROR  , no permitir el update y en el mensaje informar que se debe usar la 
-- silla 3 del salon 1, si se quiere realizar un update posible
UPDATE rinde
SET nro_salon= 2
WHERE nro_estudiante = 3;

DELETE FROM RINDE WHERE 1=1;
UPDATE SALON SET nro_silla_max = 2 where nro_salon = 1 and nombre_institucion = 'inst1';
--EXITO
---------

--PRE	(LO SIENTO, NO PUEDES DAR EL EXAMEN, no hay lugar.)
--prueba de buscar y no encontrar lugar debe dar error no hay lugar
DELETE FROM RINDE WHERE 1=1;
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
INSERT INTO rinde VALUES (1, 3, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 4, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
--POST
--DEBE TIRAR ERROR  , no permitir el update y en el mensaje informar 
--es que para esa instancia de examen no hay mas lugares 
UPDATE rinde
SET nro_salon= 2
WHERE nro_estudiante = 3;
--EXITO
---------

