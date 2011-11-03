
--prueba para t1_aprueba
INSERT INTO estudiante VALUES (1, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO institucion VALUES ('inst1', 'paraguay', 'asuncion', 'chilavert road 1354');
INSERT INTO salon VALUES ('inst1', 1, 30, 1);
INSERT INTO examen VALUES (1, 'test de cooper', 'S');
INSERT INTO inscribe VALUES (1, 1);
INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011-12-02 16:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 5);

--Apruebo un Examen 15 días después de la fecha en que se rindió.
INSERT INTO aprueba VALUES (1, 1, to_date('2011/01/15', 'yyyy/mm/dd'), 95);

--Apruebo un Examen 5 días después de la fecha en que se rindió.
INSERT INTO aprueba VALUES (1, 1, to_date('2011/01/05', 'yyyy/mm/dd'), 95);
