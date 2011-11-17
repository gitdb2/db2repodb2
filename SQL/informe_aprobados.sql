
CREATE OR REPLACE PROCEDURE informe_aprobados (par_nro_examen NUMBER) AS
  
descripcion VARCHAR2(200);
nombre_institucion VARCHAR2(50);
nombre_institucion_anterior VARCHAR2(50);
pais VARCHAR2(30);
nombre VARCHAR2(50);
nro_estudiante NUMBER;
nro_estudiante_anterior NUMBER;
apellido VARCHAR2(50);
fecha DATE;
hora TIMESTAMP;

CURSOR cursor_institucion IS
SELECT i.nombre, i.pais
FROM rinde r, institucion i
WHERE r.nro_examen = par_nro_examen
GROUP BY i.nombre, i.pais
ORDER BY i.nombre ASC, i.pais ASC;

CURSOR cursor_rindieron (par_nombre_institucion IN VARCHAR2) IS
SELECT DISTINCT e.nro_estudiante, e.nombre, e.apellido, i.fecha, i.hora
FROM rinde r, estudiante e, instancia_ex i
WHERE r.nro_examen = par_nro_examen
  AND r.nro_estudiante = e.nro_estudiante
  AND r.nro_examen = i.nro_examen
  AND i.nombre_institucion = par_nombre_institucion
ORDER BY e.nro_estudiante ASC, i.fecha ASC;

BEGIN
    
  SELECT e.descripcion 
  INTO descripcion
  FROM examen e
  WHERE e.nro_examen = par_nro_examen;
  
  DBMS_OUTPUT.PUT_LINE('------------------------');
  DBMS_OUTPUT.PUT_LINE('- Informe de Aprobados -');
  DBMS_OUTPUT.PUT_LINE('------------------------');
  DBMS_OUTPUT.PUT_LINE('Examen: ' || descripcion || ' (' || par_nro_examen || ')');
  DBMS_OUTPUT.PUT_LINE('-----------------------');


  OPEN cursor_institucion;
    LOOP
      FETCH cursor_institucion INTO nombre_institucion, pais;
      EXIT WHEN cursor_institucion%NOTFOUND;
  
          DBMS_OUTPUT.PUT_LINE('');
          DBMS_OUTPUT.PUT_LINE('-- ' || nombre_institucion || ' (' || pais || ')');
          DBMS_OUTPUT.PUT_LINE('-----------------------');
      
          nro_estudiante_anterior := -1;
  
          OPEN cursor_rindieron (nombre_institucion);
          LOOP
            FETCH cursor_rindieron INTO nro_estudiante, nombre, apellido, fecha, hora;
            EXIT WHEN cursor_rindieron%NOTFOUND;
      
              IF (nro_estudiante <> nro_estudiante_anterior)
              THEN
                DBMS_OUTPUT.PUT_LINE(nro_estudiante || '  - ' || nombre || ' ' || apellido);
              END IF;
              
              DBMS_OUTPUT.PUT_LINE('       ' || TO_CHAR(fecha, 'DD.MON.YYYY') || ' - ' || TO_CHAR(hora, 'HH24:MI'));
              
              nro_estudiante_anterior := nro_estudiante;
              
          END LOOP;
          CLOSE cursor_rindieron;
                       
    END LOOP;
  CLOSE cursor_institucion;
    
  DBMS_OUTPUT.PUT_LINE('-----------------------');
  DBMS_OUTPUT.PUT_LINE('- Fin del Informe     -');
  DBMS_OUTPUT.PUT_LINE('-----------------------');

END informe_aprobados;

