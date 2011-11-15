
CREATE OR REPLACE PROCEDURE informe_examenes (nro_examen NUMBER, fecha_inicio DATE, fecha_fin DATE) AS
  
descripcion VARCHAR2(200);

CURSOR cursor_examenes IS
SELECT descripcion
FROM examen e
WHERE e.nro_examen = nro_examen;

BEGIN
    
  -----------------
  --mensaje inicial
  -----------------
  SELECT e.descripcion 
  INTO descripcion
  FROM examen e
  WHERE e.nro_examen = nro_examen;
  
  DBMS_OUTPUT.PUT_LINE('-----------------------');
  DBMS_OUTPUT.PUT_LINE('- Informe de Examenes -');
  DBMS_OUTPUT.PUT_LINE('-----------------------');
  DBMS_OUTPUT.PUT_LINE('Examen: ' || descripcion || ' (' || nro_examen || ')');
  DBMS_OUTPUT.PUT_LINE('Desde: ' || TO_CHAR(fecha_inicio, 'MM.MON.YYYY'));
  
  IF fecha_fin IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Hasta: Fin De Datos');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Hasta: ' || TO_CHAR(fecha_fin, 'MM.MON.YYYY'));
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('-----------------------');

  OPEN cursor_examenes;
  LOOP
    FETCH cursor_examenes INTO descripcion;
      EXIT WHEN cursor_examenes%NOTFOUND;
      
      BEGIN
        DBMS_OUTPUT.PUT_LINE('');
      END;
      
  END LOOP;
  CLOSE cursor_examenes;

  DBMS_OUTPUT.PUT_LINE('-----------------------');
  DBMS_OUTPUT.PUT_LINE('- Fin del Informe     -');
  DBMS_OUTPUT.PUT_LINE('-----------------------');

END informe_examenes;

