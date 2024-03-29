
CREATE OR REPLACE PROCEDURE informe_aprobados (par_nro_examen NUMBER) AS
  
descripcion VARCHAR2(200);
var_nombre_institucion VARCHAR2(50);
pais VARCHAR2(30);
nombre VARCHAR2(50);
var_nro_estudiante NUMBER;
apellido VARCHAR2(50);
fecha DATE;
var_ultima_rendida DATE;
hora TIMESTAMP;
var_calificacion NUMBER;

var_timezone VARCHAR2(6);
var_fecha_local VARCHAR2(11);
var_hora_local VARCHAR2(8);

--itera todas las instituciones donde se rindio el examen que se paso por parametro
CURSOR cursor_institucion IS
SELECT i.nombre, i.pais, i.timezone
FROM rinde r, institucion i
WHERE r.nro_examen = par_nro_examen
GROUP BY i.nombre, i.pais, i.timezone
ORDER BY i.nombre ASC, i.pais ASC;

--itera los estudiantes que rindieron el exament que se paso por parametro
CURSOR cursor_rindieron (par_nombre_institucion IN VARCHAR2) IS
SELECT DISTINCT r.nro_estudiante, e.nombre, e.apellido
FROM rinde r, estudiante e
WHERE r.nro_examen = par_nro_examen
  AND r.nombre_institucion = par_nombre_institucion
  AND r.nro_estudiante = e.nro_estudiante
ORDER BY r.nro_estudiante ASC;

--itera los datos del estudiante, instancia examen y rendicion de los cursores anteriores
CURSOR cursor_datos_rindieron (par_nombre_institucion IN VARCHAR2, par_nro_estudiante IN NUMBER) IS
SELECT DISTINCT i.fecha, i.hora
FROM rinde r, estudiante e, instancia_ex i
WHERE r.nro_estudiante = par_nro_estudiante
  AND r.nro_estudiante = e.nro_estudiante
  AND r.nombre_institucion = par_nombre_institucion
  AND r.nombre_institucion = i.nombre_institucion
  AND i.nro_examen = par_nro_examen
  AND r.fecha = i.fecha
ORDER BY i.fecha ASC;

BEGIN

  --imprimo mensaje inicial
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
      FETCH cursor_institucion INTO var_nombre_institucion, pais, var_timezone;
      EXIT WHEN cursor_institucion%NOTFOUND;
  
          DBMS_OUTPUT.PUT_LINE('');
          DBMS_OUTPUT.PUT_LINE('-- ' || var_nombre_institucion || ' (' || pais || ')');
          DBMS_OUTPUT.PUT_LINE('-----------------------');
          
          OPEN cursor_rindieron (var_nombre_institucion);
            LOOP
              FETCH cursor_rindieron INTO var_nro_estudiante, nombre, apellido;
              EXIT WHEN cursor_rindieron%NOTFOUND;
              
                --imprimo nombre y apellido del estudiante
                DBMS_OUTPUT.PUT_LINE(var_nro_estudiante || '  - ' || nombre || ' ' || apellido);
                
                BEGIN
                
                  --obtengo la fecha de la instancia de examen en que aprobo
                  --si existe ademas me quedo con la calificacion
                  SELECT calificacion INTO var_calificacion 
                  FROM aprueba p
                  WHERE p.nro_estudiante = var_nro_estudiante
                    AND p.nro_examen = par_nro_examen;
                    
                  SELECT MAX(fecha) INTO var_ultima_rendida
                  FROM rinde r
                  WHERE r.nro_estudiante = var_nro_estudiante
                    AND r.nro_examen = par_nro_examen
                    AND r.nombre_institucion = var_nombre_institucion;
                    
                  EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN var_calificacion := 0;
                END;
                
                
                OPEN cursor_datos_rindieron (var_nombre_institucion, var_nro_estudiante);
                  LOOP
                    FETCH cursor_datos_rindieron INTO fecha, hora;
                    EXIT WHEN cursor_datos_rindieron%NOTFOUND;
                      
                      --itero todas las rendiciones del examen pedido del estudiante en la institucion
                      --imprimo los datos pedidos
                      IF (fecha = var_ultima_rendida AND var_calificacion > 0) THEN
                        DBMS_OUTPUT.PUT_LINE('       >>> Aprobado: ' || TO_CHAR(fecha, 'DD.MON.YYYY') || ' Calif: ' || var_calificacion);
                      ELSE
                      
                        --convierto la fecha y hora de la instancia en la fecha y hora locales al pais de la institucion
                        FORMATO_UTC_A_LOCAL(hora, var_timezone, var_fecha_local, var_hora_local);
                        
                        DBMS_OUTPUT.PUT('       ' || TO_CHAR(fecha, 'DD.MON.YYYY') || ' - ');
                        
                        IF (TO_CHAR(fecha, 'DD.MON.YYYY') <> var_fecha_local) THEN
                          DBMS_OUTPUT.PUT (var_fecha_local || ' - ');
                        END IF;
                      
                        DBMS_OUTPUT.PUT_LINE(var_hora_local);
                        
                      END IF;
                      
                  END LOOP;
                CLOSE cursor_datos_rindieron;
                
                IF (var_calificacion = 0) THEN
                  DBMS_OUTPUT.PUT_LINE('       >>> NO Aprobado <<<');
                END IF;
              
            END LOOP;
          CLOSE cursor_rindieron;
                             
    END LOOP;
  CLOSE cursor_institucion;
    
  DBMS_OUTPUT.PUT_LINE('-----------------------');
  DBMS_OUTPUT.PUT_LINE('- Fin del Informe     -');
  DBMS_OUTPUT.PUT_LINE('-----------------------');

END informe_aprobados;

