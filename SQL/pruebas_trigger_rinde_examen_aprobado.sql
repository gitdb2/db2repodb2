
--Prueba para Control de examen aprobado
INSERT INTO estudiante VALUES (1, 1, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (2, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (3, 3, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO institucion VALUES ('inst1', 'paraguay', 'asuncion', 'chilavert road 1354');
INSERT INTO salon VALUES ('inst1', 1, 30, 1);
INSERT INTO examen VALUES (1, 'test de cooper', 'S');

INSERT INTO inscribe VALUES (1, 1);
INSERT INTO inscribe VALUES (2, 1);
INSERT INTO inscribe VALUES (3, 1);

INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011-12-02 16:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 2);
INSERT INTO aprueba VALUES (1, 1, to_date('2011/01/10', 'yyyy/mm/dd'), 80);
INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/02/01', 'yyyy/mm/dd'), to_date('2011-12-02 18:00:', 'YYYY-MM-DD HH24:MI:'));

INSERT INTO examen VALUES (2, 'test drive MINI cooper XD', 'S');
INSERT INTO instancia_ex VALUES (2, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011-01-01 18:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO inscribe VALUES (1, 2);

--Aprueba un examen que no aprobó.
INSERT INTO aprueba VALUES (1, 2, to_date('2011/02/10', 'yyyy/mm/dd'), 80);

--Rinde un examen que ya tiene aprobado.
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/02/01', 'yyyy/mm/dd'), 1);

--Cambio un estudiante a un examen que ya tiene aprobado.
UPDATE rinde 
	SET  nro_examen = 2
WHERE
      nro_estudiante = 1
  AND nombre_institucion = 'inst1'
  AND nro_salon = 1
  AND nro_silla_asignado = 1
  AND fecha = to_date('2011/01/01', 'yyyy/mm/dd');
