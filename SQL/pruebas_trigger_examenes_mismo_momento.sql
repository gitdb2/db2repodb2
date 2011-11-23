SET serveroutput ON;

DELETE FROM rinde WHERE 1=1;
DELETE FROM instancia_ex WHERE 1=1;
DELETE FROM aprueba WHERE 1=1;
DELETE FROM inscribe WHERE 1=1;
DELETE FROM salon WHERE 1=1;
DELETE FROM institucion WHERE 1=1;
DELETE FROM estudiante WHERE 1=1;
DELETE FROM examen WHERE 1=1;

INSERT INTO examen VALUES (142, 'FCE - First Certificate', 'S');

INSERT INTO institucion VALUES ('Anglo', 'UY', 'Montevideo', 'San Martin y Chimborazo');
INSERT INTO institucion VALUES ('British School', 'CL', 'Valparaiso', 'Chupete Suazo 0004');

INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2011/08/15', 'yyyy/mm/dd'), to_date('2011-08-15 10:00:', 'YYYY-MM-DD HH24:MI:'));

--------------------
--pruebas con INSERT
--------------------

--mismo nro_examen y fecha que el primer insert, tiene la misma hora entonces funciona
INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2011/08/15', 'yyyy/mm/dd'), to_date('2011-08-15 10:00:', 'YYYY-MM-DD HH24:MI:'));

--mismo nro_examen y fecha que el primer insert, tiene diferente hora entonces el trigger no permite el insert
INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2011/08/15', 'yyyy/mm/dd'), to_date('2011-08-15 09:00:', 'YYYY-MM-DD HH24:MI:'));

--------------------
--pruebas con UPDATE
--------------------

--intento cambiar la hora de un examen, pero no puedo porque es diferente a la de los ya existentes
UPDATE instancia_ex
SET hora = to_date('2011-08-15 23:00:', 'YYYY-MM-DD HH24:MI:')
WHERE nro_examen = 142
AND fecha = to_date('2011/08/15', 'yyyy/mm/dd');


--inserto dos nuevass instancias de examen
INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2011/08/25', 'yyyy/mm/dd'), to_date('2011-08-25 10:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2011/08/26', 'yyyy/mm/dd'), to_date('2011-08-26 10:00:', 'YYYY-MM-DD HH24:MI:'));

--a la ultima le cambio el dia, deberia funcionar porque es la misma hora de la otra instancia existente
UPDATE instancia_ex
SET fecha = to_date('2011-08-25 10:00:', 'YYYY-MM-DD HH24:MI:'), hora = to_date('2011-08-25 10:00:', 'YYYY-MM-DD HH24:MI:')
WHERE nro_examen = 142
AND fecha = to_date('2011/08/26', 'yyyy/mm/dd')
AND nombre_institucion = 'Anglo';
