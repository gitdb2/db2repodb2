
CREATE OR REPLACE PROCEDURE informe_examenes (nro_examen NUMBER, fecha_inicio DATE, fecha_fin DATE) AS
  
descripcion VARCHAR2(200);

nombre_institucion VARCHAR2(50);
fecha DATE;
hora TIMESTAMP;
pais VARCHAR2(30);

CURSOR cursor_examenes (par_fecha IN DATE) IS
SELECT i.nombre_institucion, i.hora, t.pais
FROM instancia_ex i, institucion t
WHERE i.nro_examen = nro_examen
  AND i.fecha = par_fecha
  AND t.nombre = i.nombre_institucion
ORDER BY i.fecha ASC, i.hora DESC;

CURSOR cursor_instancias_examenes IS
SELECT i.fecha
FROM instancia_ex i
WHERE i.nro_examen = nro_examen
GROUP BY fecha
ORDER BY fecha ASC;

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
  DBMS_OUTPUT.PUT_LINE('Desde: ' || TO_CHAR(fecha_inicio, 'DD.MON.YYYY'));
  
  IF fecha_fin IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Hasta: Fin De Datos');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Hasta: ' || TO_CHAR(fecha_fin, 'DD.MON.YYYY'));
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('-----------------------');

  OPEN cursor_instancias_examenes;
  LOOP
    FETCH cursor_instancias_examenes INTO fecha;
      EXIT WHEN cursor_instancias_examenes%NOTFOUND;
      
      BEGIN
      
        DBMS_OUTPUT.PUT_LINE('-- ' || TO_CHAR(fecha, 'DD.MON.YYYY'));
                
        OPEN cursor_examenes(fecha);
        LOOP
          FETCH cursor_examenes INTO nombre_institucion, hora, pais;
            EXIT WHEN cursor_examenes%NOTFOUND;
                
            BEGIN  
            
              DBMS_OUTPUT.PUT_LINE('----- ' || nombre_institucion || ' (' || pais || ') - ' || TO_CHAR(hora, 'HH24:MI'));
                            
            END;
            
        END LOOP;
        CLOSE cursor_examenes;
        
      END;
      
  END LOOP;
  CLOSE cursor_instancias_examenes;

  DBMS_OUTPUT.PUT_LINE('-----------------------');
  DBMS_OUTPUT.PUT_LINE('- Fin del Informe     -');
  DBMS_OUTPUT.PUT_LINE('-----------------------');

END informe_examenes;

