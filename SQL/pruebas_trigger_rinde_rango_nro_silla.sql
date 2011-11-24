--prueba para rinde
INSERT INTO estudiante VALUES (1, 1, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (2, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (3, 3, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO institucion VALUES ('inst1', 'paraguay', 'asuncion', 'chilavert road 1354', '-04:00');
INSERT INTO salon VALUES ('inst1', 1, 30, 1);
INSERT INTO examen VALUES (1, 'test de cooper', 'S');

INSERT INTO inscribe VALUES (1, 1);
INSERT INTO inscribe VALUES (2, 1);
INSERT INTO inscribe VALUES (3, 1);

INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011-12-02 16:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);

--Inserto una tupla en Rinde donde el numero de silla esta dentro del rango de números de silla del salon.
INSERT INTO rinde VALUES (1, 2, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 2);

--Actualizo una tupla en Rinde donde el numero de silla esta dentro del rango de números de silla del salon.
UPDATE rinde 
SET nro_silla_asignado = 5 
WHERE nro_examen = 1
  AND nro_estudiante = 1
  AND nombre_institucion = 'inst1'
  AND nro_salon = 1
  AND fecha = to_date('2011/01/01', 'yyyy/mm/dd');

--Inserto una tupla en Rinde donde el número de silla esta fuera del rango de números de silla del salon.
INSERT INTO rinde VALUES (1, 3, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 900);

--Actualizo una tupla en Rinde donde el número de silla esta fuera del rango de números de silla del salon.
UPDATE rinde SET nro_silla_asignado = 900 
WHERE nro_examen = 1
  AND nro_estudiante = 1
  AND nombre_institucion = 'inst1'
  AND nro_salon = 1
  AND fecha = to_date('2011/01/01', 'yyyy/mm/dd');
