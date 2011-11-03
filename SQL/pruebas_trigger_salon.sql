
--prueba para t1_salon_control_rango_sillas
INSERT INTO estudiante VALUES (1, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO institucion VALUES ('inst1', 'paraguay', 'asuncion', 'chilavert road 1354');
INSERT INTO salon VALUES ('inst1', 1, 30, 1);
INSERT INTO institucion VALUES ('inst2', 'ARGENTINA', 'BS', 'Kichener');
INSERT INTO salon VALUES ('inst2', 1, 5, 1);
INSERT INTO examen VALUES (1, 'test de cooper', 'S');
INSERT INTO inscribe VALUES (1, 1);
INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011/01/01 16:00:', 'YYYY/MM/DD HH24:MI:'));
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 5);

--Actualizo los rangos de número de silla de un Salon de manera que todas las tuplas de Rinde quedan consistentes.
UPDATE salon
set nro_silla_min = 10, nro_silla_max = 17
where nombre_institucion = 'inst2';

--Actualizo el rango mínimo de número de silla de un Salon de manera que alguna tupla de Rinde queda inconsistente.
UPDATE salon
set nro_silla_min = 10
where nombre_institucion = 'inst1';

--Actualizo el rango máximo de número de silla de un Salon de manera que alguna tupla de Rinde queda inconsistente.
UPDATE salon
set nro_silla_max = 2
where nombre_institucion = 'inst1';
