
SET serveroutput ON;

/
BEGIN
  
  DELETE FROM rinde WHERE 1=1;
  DELETE FROM instancia_ex WHERE 1=1;
  DELETE FROM inscribe WHERE 1=1;
  DELETE FROM institucion WHERE 1=1;
  DELETE FROM estudiante WHERE 1=1;
  DELETE FROM examen WHERE 1=1;
  
  INSERT INTO estudiante VALUES (1234, 2, 'UY', 'Juan', 'Perez', 'Tranqueras');
  INSERT INTO estudiante VALUES (2983, 5, 'UY', 'Jose', 'Alvarez', 'La Paz');
  INSERT INTO estudiante VALUES (8945, 7, 'UY', 'Alicia', 'Perez', 'Lascano');
  INSERT INTO estudiante VALUES (9523, 9, 'UY', 'Jose', 'Rodriguez', 'Canelon chico');
  
  INSERT INTO examen VALUES (142, 'FCE - First Certificate', 'S');
  
  INSERT INTO institucion VALUES ('Anglo', 'UY', 'Montevideo', 'San Martin y Chimborazo');
  INSERT INTO institucion VALUES ('British School', 'CL', 'Valparaiso', 'Chupete Suazo 0004');
  
  INSERT INTO inscribe VALUES (1234, 142);
  INSERT INTO inscribe VALUES (2983, 142);
  INSERT INTO inscribe VALUES (8945, 142);
  INSERT INTO inscribe VALUES (9523, 142);
  
  INSERT INTO instancia_ex VALUES (142, 'Anglo', to_date('2011/08/15', 'yyyy/mm/dd'), to_date('2011-08-15 10:00:', 'YYYY-MM-DD HH24:MI:'));
  INSERT INTO instancia_ex VALUES (142, 'British School', to_date('2011/08/15', 'yyyy/mm/dd'), to_date('2011-08-15 09:00:', 'YYYY-MM-DD HH24:MI:'));

  --informe_examenes(142, to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011/12/31', 'yyyy/mm/dd'));
  
  informe_examenes(142, to_date('2011/07/01', 'yyyy/mm/dd'), NULL);
  
END;
/
