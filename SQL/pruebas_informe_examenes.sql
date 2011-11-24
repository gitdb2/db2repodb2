
SET serveroutput ON;

/
BEGIN
  
  DELETE FROM rinde WHERE 1=1;
  DELETE FROM instancia_ex WHERE 1=1;
  DELETE FROM inscribe WHERE 1=1;
  DELETE FROM salon WHERE 1=1;
  DELETE FROM institucion WHERE 1=1;
  DELETE FROM estudiante WHERE 1=1;
  DELETE FROM examen WHERE 1=1;
  
  INSERT INTO estudiante VALUES (1234, 2, 'UY', 'Juan', 'Perez', 'Tranqueras');
  INSERT INTO estudiante VALUES (2983, 5, 'UY', 'Jose', 'Alvarez', 'La Paz');
  INSERT INTO estudiante VALUES (8945, 7, 'UY', 'Alicia', 'Perez', 'Lascano');
  INSERT INTO estudiante VALUES (9523, 9, 'UY', 'Jose', 'Rodriguez', 'Canelon chico');
  INSERT INTO estudiante VALUES (3234, 11, 'CL', 'Antonio', 'Marquez', 'Pando');
  INSERT INTO estudiante VALUES (3483, 15, 'CL', 'Silvia', 'Jumint', 'Empalme Olmos');
  
  INSERT INTO examen VALUES (142, 'FCE - First Certificate', 'S');
  
  INSERT INTO institucion VALUES ('Anglo', 'UY', 'Montevideo', 'San Martin y Chimborazo', '-03:00');
  INSERT INTO institucion VALUES ('British School', 'CL', 'Valparaiso', 'Chupete Suazo 0004', '-04:00');
  
  INSERT INTO inscribe VALUES (1234, 142);
  INSERT INTO inscribe VALUES (2983, 142);
  INSERT INTO inscribe VALUES (8945, 142);
  INSERT INTO inscribe VALUES (9523, 142);
  INSERT INTO inscribe VALUES (3234, 142);
  INSERT INTO inscribe VALUES (3483, 142);
  
  INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2011/08/15', 'yyyy/mm/dd'), to_date('2011-08-15 10:00:', 'YYYY-MM-DD HH24:MI:'));
  INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2011/08/15', 'yyyy/mm/dd'), to_date('2011-08-15 09:00:', 'YYYY-MM-DD HH24:MI:'));

  INSERT INTO salon VALUES ('Anglo', 1, 5, 1);
  INSERT INTO salon VALUES ('Anglo', 23, 12, 1);
  INSERT INTO salon VALUES ('British School', 123, 12, 1);

  INSERT INTO rinde VALUES (142, 1234, 'Anglo', 1, to_date('2011/08/15', 'yyyy/mm/dd'), 1);
  INSERT INTO rinde VALUES (142, 2983, 'Anglo', 1, to_date('2011/08/15', 'yyyy/mm/dd'), 2);
  INSERT INTO rinde VALUES (142, 8945, 'Anglo', 23, to_date('2011/08/15', 'yyyy/mm/dd'), 11);
  INSERT INTO rinde VALUES (142, 9523, 'Anglo', 23, to_date('2011/08/15', 'yyyy/mm/dd'), 12);
  INSERT INTO rinde VALUES (142, 3234, 'British School', 123, to_date('2011/08/15', 'yyyy/mm/dd'), 8);
  INSERT INTO rinde VALUES (142, 3483, 'British School', 123, to_date('2011/08/15', 'yyyy/mm/dd'), 12);

  informe_examenes(142, to_date('2011/07/01', 'yyyy/mm/dd'), NULL);
  
END;
/
