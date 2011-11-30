DELETE FROM aprueba WHERE 1=1;
DELETE FROM rinde WHERE 1=1;
DELETE FROM instancia_ex WHERE 1=1;
DELETE FROM inscribe WHERE 1=1;
DELETE FROM salon WHERE 1=1;
DELETE FROM institucion WHERE 1=1;
DELETE FROM estudiante WHERE 1=1;
DELETE FROM examen WHERE 1=1;

--prueba para t1_aprueba
INSERT INTO estudiante VALUES (1, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO institucion VALUES ('inst1', 'paraguay', 'asuncion', 'chilavert road 1354', '-04:00');
INSERT INTO salon VALUES ('inst1', 1, 30, 1);
INSERT INTO examen VALUES (1, 'test de cooper', 'S');
INSERT INTO inscribe VALUES (1, 1);
INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011-12-02 16:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 5);

--Apruebo un Examen 15 días después de la fecha en que se rindió. (OK)
INSERT INTO aprueba VALUES (1, 1, to_date('2011/01/15', 'yyyy/mm/dd'), 95);

--Apruebo un Examen 5 días después de la fecha en que se rindió. (ERROR)
INSERT INTO aprueba VALUES (1, 1, to_date('2011/01/05', 'yyyy/mm/dd'), 95);


--CONTROL DE insersion en aprueba si no se rindio examen (ERROR)
INSERT INTO estudiante VALUES (2222, 2222, 'UY', 'est2222', 'apellido2222', 'Maldonado');
INSERT INTO aprueba VALUES (2222, 1, to_date('2011/01/15', 'yyyy/mm/dd'), 95);

--control de que si hay 2 instancias de examen una posterior a la otra se 
--compare con la ultima pa fecha del aprueba
INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/11/01', 'yyyy/mm/dd'), to_date('2011/11/01 16:00:', 'yyyy/mm/dd HH24:MI:'));
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/11/01', 'yyyy/mm/dd'), 5);

-----(ERROR)
INSERT INTO aprueba VALUES (1, 1, to_date('2011/11/02', 'yyyy/mm/dd'), 95);
-----(OK)
INSERT INTO aprueba VALUES (1, 1, to_date('2011/11/15', 'yyyy/mm/dd'), 95);




