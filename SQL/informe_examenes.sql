
CREATE OR REPLACE PROCEDURE informe_examenes (nro_examen NUMBER, fecha_inicio DATE, fecha_fin DATE) AS
  
descripcion VARCHAR2(200);

nombre_institucion VARCHAR2(50);
nombre_institucion_anterior VARCHAR2(50);
fecha DATE;
hora TIMESTAMP;
pais VARCHAR2(30);
nro_salon NUMBER;
nro_salon_anterior NUMBER;
nro_silla NUMBER;
nro_estudiante NUMBER;
nombre_estudiante VARCHAR2(50);
apellido VARCHAR2(50);
primero NUMBER;
aux_fecha_fin DATE;

CURSOR cursor_instancias_examenes (par_fecha_fin IN DATE) IS
SELECT i.fecha
FROM instancia_ex i
WHERE i.nro_examen = nro_examen
  AND i.fecha >= fecha_inicio
  AND i.fecha <= par_fecha_fin
GROUP BY fecha
ORDER BY fecha ASC;

CURSOR cursor_examenes (par_fecha IN DATE) IS
SELECT i.nombre_institucion, i.hora, t.pais
FROM instancia_ex i, institucion t
WHERE i.nro_examen = nro_examen
  AND i.fecha = par_fecha
  AND t.nombre = i.nombre_institucion
ORDER BY i.fecha ASC, i.hora DESC;

CURSOR cursor_salon_alumno (par_nombre_inst IN VARCHAR2, par_fecha IN DATE) IS
SELECT r.nro_salon, r.nro_silla_asignado, r.nro_estudiante, e.nombre, e.apellido
FROM rinde r, estudiante e
WHERE r.nro_examen = nro_examen
  AND r.nro_estudiante = e.nro_estudiante
  AND r.fecha = par_fecha
  AND r.nombre_institucion = par_nombre_inst
ORDER BY r.nro_salon ASC, r.nro_silla_asignado ASC;

BEGIN
    
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

  IF (fecha_fin IS NULL)
  THEN
    aux_fecha_fin := sysdate;
  ELSE
    aux_fecha_fin := fecha_fin;
  END IF;
  
  OPEN cursor_instancias_examenes (aux_fecha_fin);
  LOOP
    FETCH cursor_instancias_examenes INTO fecha;
      EXIT WHEN cursor_instancias_examenes%NOTFOUND;
      
      BEGIN
      
        DBMS_OUTPUT.PUT_LINE('-- ' || TO_CHAR(fecha, 'DD.MON.YYYY'));
        nombre_institucion_anterior := 'xxxxxxxxxxxxxxxxxxxxxx';
                        
        OPEN cursor_examenes(fecha);
        LOOP
          FETCH cursor_examenes INTO nombre_institucion, hora, pais;
            EXIT WHEN cursor_examenes%NOTFOUND;
                
            BEGIN  
            
              DBMS_OUTPUT.PUT_LINE('----- ' || nombre_institucion || ' (' || pais || ') - ' || TO_CHAR(hora, 'HH24:MI'));
              nro_salon_anterior := -1;
             
              primero := 1;
                                          
              OPEN cursor_salon_alumno(nombre_institucion, fecha);
              LOOP
                FETCH cursor_salon_alumno INTO nro_salon, nro_silla, nro_estudiante, nombre_estudiante, apellido;
                  EXIT WHEN cursor_salon_alumno%NOTFOUND;
                  
                  BEGIN
                                                        
                    IF (nro_salon <> nro_salon_anterior) 
                    THEN
                      
                      IF (primero <> 1)
                      THEN
                        DBMS_OUTPUT.PUT_LINE('------------------------------------------');
                      END IF;
                      
                      primero := 0;
                      
                      DBMS_OUTPUT.PUT_LINE('------- Salon: ' || nro_salon);
                      DBMS_OUTPUT.PUT_LINE('          Silla   -   NroEst   -   Nombre');
                      DBMS_OUTPUT.PUT_LINE('------------------------------------------');
                      
                    END IF;
                    
                    DBMS_OUTPUT.PUT_LINE('           ' || nro_silla || '   -   ' || nro_estudiante || '   -   ' || nombre_estudiante || ' ' || apellido);
                    
                    nro_salon_anterior := nro_salon;
                                        
                  END;
                  
              END LOOP;
              CLOSE cursor_salon_alumno;
              
              IF (nombre_institucion <> nombre_institucion_anterior)
              THEN
                DBMS_OUTPUT.PUT_LINE('------------------------------------------');
                DBMS_OUTPUT.PUT_LINE('');
              END IF;
              
              nombre_institucion_anterior := nombre_institucion;
                                              
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

