
SET serveroutput ON;

/
BEGIN
  
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
  INSERT INTO estudiante VALUES (9999, 20, 'AR', 'Carlos Fernando', 'Navarro Montoya', 'La Boca');
  
  INSERT INTO examen VALUES (142, 'FCE - First Certificate', 'S');
  
  INSERT INTO institucion VALUES ('Anglo', 'UY', 'Montevideo', 'San Martin y Chimborazo');
  INSERT INTO institucion VALUES ('British School', 'CL', 'Valparaiso', 'Chupete Suazo 0004');
  
  INSERT INTO inscribe VALUES (1234, 142);
  INSERT INTO inscribe VALUES (8945, 142);
  INSERT INTO inscribe VALUES (3234, 142);
  
  INSERT INTO inscribe VALUES (8888, 142);
  INSERT INTO inscribe VALUES (9999, 142);
  
  INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2009/12/15', 'yyyy/mm/dd'), to_date('2009-12-15 10:00:', 'YYYY-MM-DD HH24:MI:'));
  INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2010/12/20', 'yyyy/mm/dd'), to_date('2010-12-20 10:00:', 'YYYY-MM-DD HH24:MI:'));
  INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2011/08/15', 'yyyy/mm/dd'), to_date('2011-08-15 10:00:', 'YYYY-MM-DD HH24:MI:'));
  INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2011/08/25', 'yyyy/mm/dd'), to_date('2011-08-25 10:00:', 'YYYY-MM-DD HH24:MI:'));
  
  INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2009/01/01', 'yyyy/mm/dd'), to_date('2009-01-01 10:00:', 'YYYY-MM-DD HH24:MI:'));
  INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2010/01/01', 'yyyy/mm/dd'), to_date('2010-01-01 10:00:', 'YYYY-MM-DD HH24:MI:'));
  INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011-01-01 10:00:', 'YYYY-MM-DD HH24:MI:'));

  INSERT INTO salon VALUES ('Anglo', 1, 5, 1);
  INSERT INTO salon VALUES ('Anglo', 23, 12, 1);
  
  INSERT INTO salon VALUES ('British School', 5, 15, 1);
  INSERT INTO salon VALUES ('British School', 28, 67, 1);

  INSERT INTO rinde VALUES (142, 1234, 'Anglo', 1, to_date('2009/12/15', 'yyyy/mm/dd'), 1);
  INSERT INTO rinde VALUES (142, 1234, 'Anglo', 1, to_date('2010/12/20', 'yyyy/mm/dd'), 1);
  INSERT INTO rinde VALUES (142, 1234, 'Anglo', 1, to_date('2011/08/15', 'yyyy/mm/dd'), 1);
  INSERT INTO rinde VALUES (142, 1234, 'Anglo', 1, to_date('2011/08/25', 'yyyy/mm/dd'), 1);
  
  INSERT INTO rinde VALUES (142, 3234, 'Anglo', 1, to_date('2010/12/20', 'yyyy/mm/dd'), 2);
  INSERT INTO rinde VALUES (142, 3234, 'Anglo', 1, to_date('2011/08/15', 'yyyy/mm/dd'), 2);
  INSERT INTO rinde VALUES (142, 3234, 'Anglo', 1, to_date('2011/08/25', 'yyyy/mm/dd'), 2);
  
  INSERT INTO rinde VALUES (142, 8945, 'Anglo', 23, to_date('2009/12/15', 'yyyy/mm/dd'), 11);
  INSERT INTO rinde VALUES (142, 8945, 'Anglo', 23, to_date('2010/12/20', 'yyyy/mm/dd'), 11);
  
  INSERT INTO rinde VALUES (142, 8888, 'British School', 5, to_date('2009/01/01', 'yyyy/mm/dd'), 12);
  INSERT INTO rinde VALUES (142, 8888, 'British School', 5, to_date('2010/01/01', 'yyyy/mm/dd'), 12);
  INSERT INTO rinde VALUES (142, 8888, 'British School', 5, to_date('2011/01/01', 'yyyy/mm/dd'), 12);

  INSERT INTO rinde VALUES (142, 9999, 'British School', 28, to_date('2011/01/01', 'yyyy/mm/dd'), 18);
  
  INSERT INTO aprueba VALUES (1234, 142, to_date('2011/09/25', 'yyyy/mm/dd'), 100);
  
  INSERT INTO aprueba VALUES (3234, 142, to_date('2011/09/25', 'yyyy/mm/dd'), 80);
  
  INSERT INTO aprueba VALUES (8888, 142, to_date('2011/02/01', 'yyyy/mm/dd'), 95);
  
  INSERT INTO aprueba VALUES (9999, 142, to_date('2011/02/01', 'yyyy/mm/dd'), 92);

  informe_aprobados(142);
  
END;
/
