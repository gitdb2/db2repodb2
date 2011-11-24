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
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
---------


--PRE-(SILLA en salon original disponible)
DELETE FROM RINDE WHERE 1=1;
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
--POST 
--Prueba de nueva rinde para salon 2 y silla 1, +> debe insertar en el salon 2 silla 1 
INSERT INTO rinde VALUES (1, 3, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
--exito !!!!
---------

--PRE	(MISMO SALON NUEVA SILLA)
DELETE FROM RINDE WHERE 1=1;
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 1);

--POST  
--Prueba de nueva rinde para salon 1 y silla 1, => debe insertar en el salon 1 silla 2
--(la silla en el salon actual esta ocupada y en el otro salon tambien)
INSERT INTO rinde VALUES (1, 3, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
--exito !!!!
---------


--PRE (NUEVO SALON MISMA SILLA)
DELETE FROM RINDE WHERE 1=1;
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
--POST  
--Prueba de estudiante nueva rinde para salon 1 y silla 2, +> debe insertar en el salon 2 silla 1
INSERT INTO rinde VALUES (1, 3, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
--exito!!!!!
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
INSERT INTO rinde VALUES (1, 5, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 1);

DELETE FROM RINDE WHERE 1=1;
UPDATE SALON SET nro_silla_max = 2 where nro_salon = 1 and nombre_institucion = 'inst1';
--exito!!!!!
---------

--PRE	(LO SIENTO PIBITO, NO PODES DAR EL EXAMEN, no hay lugar. SORI)
--prueba de buscar y no encontrar lugar debe dar error no hay lugar
DELETE FROM RINDE WHERE 1=1;
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
INSERT INTO rinde VALUES (1, 3, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 4, 'inst1', 2, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
--POST
--Al intentar con este (salon 2 silla 1) no deberia dejar porque no hay silla ni salon disponible:
INSERT INTO rinde VALUES (1, 5, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
--exito!!!!!
---------

