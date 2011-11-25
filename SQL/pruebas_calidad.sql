
DELETE FROM aprueba WHERE 1=1;
DELETE FROM rinde WHERE 1=1;
DELETE FROM instancia_ex WHERE 1=1;
DELETE FROM inscribe WHERE 1=1;
DELETE FROM salon WHERE 1=1;
DELETE FROM institucion WHERE 1=1;
DELETE FROM estudiante WHERE 1=1;
DELETE FROM examen WHERE 1=1;

INSERT INTO estudiante VALUES (1234, 2, 'UY', 'Juan', 'Perez', 'Tranqueras');
INSERT INTO estudiante VALUES (8945, 7, 'UY', 'Alicia', 'Perez', 'Lascano');
INSERT INTO estudiante VALUES (3234, 11, 'CL', 'Antonio', 'Marquez', 'Pando');
INSERT INTO estudiante VALUES (8888, 15, 'AR', 'Roberto', 'Abbondanzieri', 'Budge');
INSERT INTO estudiante VALUES (9999, 33, 'AR', 'Carlos Fernando', 'Navarro Montoya', 'La Boca');
INSERT INTO estudiante VALUES (1111, 22, 'UY', 'Fernando Harry', 'Alvez', 'Las Piedras');
INSERT INTO estudiante VALUES (2222, 12, 'CL', 'Gary', 'Medel', 'Chacabuco');
INSERT INTO estudiante VALUES (3333, 67, 'BR', 'Roberto Carlos', 'Da Silva', 'Parana');
INSERT INTO estudiante VALUES (4444, 88, 'BR', 'Bebeto', 'Do Nacimento', 'Brasilia');
INSERT INTO estudiante VALUES (5555, 99, 'PY', 'Jose Luis Felix', 'Chilavert', 'Asuncion');
INSERT INTO estudiante VALUES (6666, 201, 'PY', 'Roque', 'Santacruz', 'Asuncion');
INSERT INTO estudiante VALUES (7777, 123, 'PY', 'Carlos', 'Gamarra', 'Asuncion');

INSERT INTO examen VALUES (142, 'FCE - First Certificate', 'S');
INSERT INTO examen VALUES (150, 'Primeros Auxilios', 'S');
INSERT INTO examen VALUES (178, 'Bomberos', 'S');
INSERT INTO examen VALUES (290, 'Azafata', 'S');

INSERT INTO institucion VALUES ('Anglo', 'UY', 'Montevideo', 'San Martin y Chimborazo', '-03:00');
INSERT INTO institucion VALUES ('British School', 'CL', 'Valparaiso', 'Chupete Suazo 0004', '-04:00');
INSERT INTO institucion VALUES ('Russian Institute', 'RU', 'Vladivostok', 'Gestapo Road 1234', '-08:00');

INSERT INTO inscribe VALUES (1234, 142);
INSERT INTO inscribe VALUES (8945, 142);
INSERT INTO inscribe VALUES (3234, 142);
    
INSERT INTO inscribe VALUES (1111, 150);
INSERT INTO inscribe VALUES (2222, 150);
INSERT INTO inscribe VALUES (3333, 150);
INSERT INTO inscribe VALUES (4444, 150);

INSERT INTO inscribe VALUES (5555, 178);
INSERT INTO inscribe VALUES (6666, 178);

INSERT INTO inscribe VALUES (7777, 290);
INSERT INTO inscribe VALUES (8888, 290);
INSERT INTO inscribe VALUES (9999, 290);

INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2009/12/15', 'yyyy/mm/dd'), to_date('2009-12-15 10:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2010/12/20', 'yyyy/mm/dd'), to_date('2010-12-20 10:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2011/08/15', 'yyyy/mm/dd'), to_date('2011-08-15 10:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2011/08/25', 'yyyy/mm/dd'), to_date('2011-08-25 10:00:', 'YYYY-MM-DD HH24:MI:'));

INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2009/01/01', 'yyyy/mm/dd'), to_date('2009-01-01 10:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2010/01/01', 'yyyy/mm/dd'), to_date('2010-01-01 10:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011-01-01 10:00:', 'YYYY-MM-DD HH24:MI:'));

INSERT INTO instancia_ex VALUES (150, 'Russian Institute', to_date('2009/02/03', 'yyyy/mm/dd'), to_date('2009-02-03 10:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (150, 'Russian Institute', to_date('2010/02/03', 'yyyy/mm/dd'), to_date('2010-02-03 11:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (150, 'Russian Institute', to_date('2011/02/03', 'yyyy/mm/dd'), to_date('2011-02-03 12:00:', 'YYYY-MM-DD HH24:MI:'));

INSERT INTO instancia_ex VALUES (178, 'Anglo', to_date('2008/11/11', 'yyyy/mm/dd'), to_date('2008-11-11 11:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (178, 'British School', to_date('2008/11/11', 'yyyy/mm/dd'), to_date('2008-11-11 11:00:', 'YYYY-MM-DD HH24:MI:'));

INSERT INTO instancia_ex VALUES (290, 'Anglo', to_date('2010/10/15', 'yyyy/mm/dd'), to_date('2010-10-15 11:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (290, 'Anglo', to_date('2011/10/15', 'yyyy/mm/dd'), to_date('2011-10-15 12:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (290, 'Russian Institute', to_date('2010/10/15', 'yyyy/mm/dd'), to_date('2010-10-15 11:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (290, 'Russian Institute', to_date('2011/10/15', 'yyyy/mm/dd'), to_date('2011-10-15 12:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (290, 'British School', to_date('2010/10/15', 'yyyy/mm/dd'), to_date('2010-10-15 11:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO instancia_ex VALUES (290, 'British School', to_date('2011/10/15', 'yyyy/mm/dd'), to_date('2011-10-15 12:00:', 'YYYY-MM-DD HH24:MI:'));

INSERT INTO salon VALUES ('Anglo', 1, 5, 1);
INSERT INTO salon VALUES ('Anglo', 23, 12, 1);

INSERT INTO salon VALUES ('British School', 5, 15, 1);
INSERT INTO salon VALUES ('British School', 28, 67, 1);

INSERT INTO salon VALUES ('Russian Institute', 10, 50, 1);
INSERT INTO salon VALUES ('Russian Institute', 20, 90, 1);

INSERT INTO rinde VALUES (142, 1234, 'Anglo', 1, to_date('2009/12/15', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (142, 1234, 'Anglo', 1, to_date('2010/12/20', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (142, 1234, 'Anglo', 1, to_date('2011/08/15', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (142, 1234, 'Anglo', 1, to_date('2011/08/25', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (142, 3234, 'Anglo', 1, to_date('2010/12/20', 'yyyy/mm/dd'), 2);
INSERT INTO rinde VALUES (142, 3234, 'Anglo', 1, to_date('2011/08/15', 'yyyy/mm/dd'), 2);
INSERT INTO rinde VALUES (142, 3234, 'Anglo', 1, to_date('2011/08/25', 'yyyy/mm/dd'), 2);
INSERT INTO rinde VALUES (142, 8945, 'Anglo', 23, to_date('2009/12/15', 'yyyy/mm/dd'), 11);
INSERT INTO rinde VALUES (142, 8945, 'Anglo', 23, to_date('2010/12/20', 'yyyy/mm/dd'), 11);

INSERT INTO rinde VALUES (150, 1111, 'Russian Institute', 10, to_date('2009/02/03', 'yyyy/mm/dd'), 11);
INSERT INTO rinde VALUES (150, 1111, 'Russian Institute', 10, to_date('2010/02/03', 'yyyy/mm/dd'), 11);
INSERT INTO rinde VALUES (150, 1111, 'Russian Institute', 10, to_date('2011/02/03', 'yyyy/mm/dd'), 11);
INSERT INTO rinde VALUES (150, 2222, 'Russian Institute', 10, to_date('2009/02/03', 'yyyy/mm/dd'), 20);
INSERT INTO rinde VALUES (150, 2222, 'Russian Institute', 10, to_date('2010/02/03', 'yyyy/mm/dd'), 20);
INSERT INTO rinde VALUES (150, 3333, 'Russian Institute', 20, to_date('2009/02/03', 'yyyy/mm/dd'), 89);
INSERT INTO rinde VALUES (150, 3333, 'Russian Institute', 20, to_date('2010/02/03', 'yyyy/mm/dd'), 89);
INSERT INTO rinde VALUES (150, 3333, 'Russian Institute', 20, to_date('2011/02/03', 'yyyy/mm/dd'), 89);
INSERT INTO rinde VALUES (150, 4444, 'Russian Institute', 20, to_date('2010/02/03', 'yyyy/mm/dd'), 90);
INSERT INTO rinde VALUES (150, 4444, 'Russian Institute', 20, to_date('2011/02/03', 'yyyy/mm/dd'), 90);

INSERT INTO rinde VALUES (178, 5555, 'British School', 5, to_date('2008/11/11', 'yyyy/mm/dd'), 10);
INSERT INTO rinde VALUES (178, 6666, 'British School', 28, to_date('2008/11/11', 'yyyy/mm/dd'), 15);

INSERT INTO rinde VALUES (290, 7777, 'Anglo', 1, to_date('2010/10/15', 'yyyy/mm/dd'), 4);
INSERT INTO rinde VALUES (290, 7777, 'Anglo', 23, to_date('2011/10/15', 'yyyy/mm/dd'), 11);
INSERT INTO rinde VALUES (290, 8888, 'Russian Institute', 10, to_date('2010/10/15', 'yyyy/mm/dd'), 20);
INSERT INTO rinde VALUES (290, 8888, 'Russian Institute', 20, to_date('2011/10/15', 'yyyy/mm/dd'), 25);
INSERT INTO rinde VALUES (290, 9999, 'British School', 5, to_date('2010/10/15', 'yyyy/mm/dd'), 13);
INSERT INTO rinde VALUES (290, 9999, 'British School', 28, to_date('2011/10/15', 'yyyy/mm/dd'), 12);

INSERT INTO aprueba VALUES (1234, 142, to_date('2011/09/25', 'yyyy/mm/dd'), 100);
INSERT INTO aprueba VALUES (3234, 142, to_date('2011/09/25', 'yyyy/mm/dd'), 80);
INSERT INTO aprueba VALUES (8888, 142, to_date('2011/02/01', 'yyyy/mm/dd'), 95);
INSERT INTO aprueba VALUES (9999, 142, to_date('2011/02/01', 'yyyy/mm/dd'), 92);

INSERT INTO aprueba VALUES (1111, 150, to_date('2011/02/15', 'yyyy/mm/dd'), 70);
INSERT INTO aprueba VALUES (3333, 150, to_date('2011/02/15', 'yyyy/mm/dd'), 84);
INSERT INTO aprueba VALUES (5555, 178, to_date('2008/11/21', 'yyyy/mm/dd'), 99);

INSERT INTO aprueba VALUES (9999, 290, to_date('2011/12/01', 'yyyy/mm/dd'), 99);


