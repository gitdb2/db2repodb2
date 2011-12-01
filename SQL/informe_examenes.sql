
CREATE OR REPLACE PROCEDURE informe_examenes (nro_examen NUMBER, fecha_inicio DATE, fecha_fin DATE) AS

var_descripcion VARCHAR2(200);
var_nombre_inst VARCHAR2(50);
var_nombre_inst_ant VARCHAR2(50);
var_fecha DATE;
var_hora TIMESTAMP;
var_pais VARCHAR2(30);
var_nro_salon NUMBER;
var_nro_salon_anterior NUMBER;
var_nro_silla NUMBER;
var_nro_estudiante NUMBER;
var_nombre_estudiante VARCHAR2(50);
var_apellido VARCHAR2(50);
var_primero NUMBER;
var_aux_fecha_fin DATE;
var_timezone VARCHAR2(6);
var_fecha_local VARCHAR2(11);
var_hora_local VARCHAR2(8);

--itera las diferentes instancias de examen para el rango de fechas dado
CURSOR cursor_instancias_examenes (par_fecha_fin IN DATE) IS
SELECT i.fecha
FROM instancia_ex i
WHERE i.nro_examen = nro_examen
  AND i.fecha >= fecha_inicio
  AND i.fecha <= par_fecha_fin
GROUP BY fecha
ORDER BY fecha ASC;

--itera los datos de las instancias de examen del primer cursor
CURSOR cursor_examenes (par_fecha IN DATE) IS
SELECT i.nombre_institucion, i.hora, t.pais, t.timezone
FROM instancia_ex i, institucion t
WHERE i.nro_examen = nro_examen
  AND i.fecha = par_fecha
  AND t.nombre = i.nombre_institucion
ORDER BY i.fecha ASC, i.hora DESC;

--itera los datos de la rendicion y alumnos del segundo cursor
CURSOR cursor_salon_alumno (par_nombre_inst IN VARCHAR2, par_fecha IN DATE) IS
SELECT r.nro_salon, r.nro_silla_asignado, r.nro_estudiante, e.nombre, e.apellido
FROM rinde r, estudiante e
WHERE r.nro_examen = nro_examen
  AND r.nro_estudiante = e.nro_estudiante
  AND r.fecha = par_fecha
  AND r.nombre_institucion = par_nombre_inst
ORDER BY r.nro_salon ASC, r.nro_silla_asignado ASC;

BEGIN
    
  --imprimo el mensaje inicial  
  SELECT e.descripcion 
  INTO var_descripcion
  FROM examen e
  WHERE e.nro_examen = nro_examen;
  
  DBMS_OUTPUT.PUT_LINE('-----------------------');
  DBMS_OUTPUT.PUT_LINE('- Informe de Examenes -');
  DBMS_OUTPUT.PUT_LINE('-----------------------');
  DBMS_OUTPUT.PUT_LINE('Examen: ' || var_descripcion || ' (' || nro_examen || ')');
  DBMS_OUTPUT.PUT_LINE('Desde: ' || TO_CHAR(fecha_inicio, 'DD.MON.YYYY'));
  
  IF fecha_fin IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Hasta: Fin De Datos');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Hasta: ' || TO_CHAR(fecha_fin, 'DD.MON.YYYY'));
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('-----------------------');

  IF (fecha_fin IS NULL)
  THEN
    --La fecha maxima soportada por Oracle: 31/12/9999
    var_aux_fecha_fin := to_date(5373484, 'J'); 
  ELSE
    var_aux_fecha_fin := fecha_fin;
  END IF;
  
  OPEN cursor_instancias_examenes (var_aux_fecha_fin);
  LOOP
    FETCH cursor_instancias_examenes INTO var_fecha;
      EXIT WHEN cursor_instancias_examenes%NOTFOUND;
      
      BEGIN
      
        DBMS_OUTPUT.PUT_LINE('-- ' || TO_CHAR(var_fecha, 'DD.MON.YYYY'));
        var_nombre_inst_ant := 'xxxxxxxxxxxxxxxxxxxxxx';
                        
        OPEN cursor_examenes(var_fecha);
        LOOP
          FETCH cursor_examenes INTO var_nombre_inst, var_hora, var_pais, var_timezone;
            EXIT WHEN cursor_examenes%NOTFOUND;
                
            BEGIN  
            
              --convierto la hora y fecha de la instancia de examen a la hora y fecha
              --local del pais de la institucion donde se esta tomando el examen
              FORMATO_UTC_A_LOCAL(var_hora, var_timezone, var_fecha_local, var_hora_local);
              
              DBMS_OUTPUT.PUT('----- ' || var_nombre_inst || ' (' || var_pais || ') - ');
              
              IF (TO_CHAR(var_fecha, 'DD.MON.YYYY') <> var_fecha_local) THEN
                DBMS_OUTPUT.PUT (var_fecha_local || ' - ');
              END IF;
              
              DBMS_OUTPUT.PUT_LINE(var_hora_local);
              
              var_nro_salon_anterior := -1;
             
              var_primero := 1;
                                          
              OPEN cursor_salon_alumno(var_nombre_inst, var_fecha);
              LOOP
                FETCH cursor_salon_alumno INTO var_nro_salon, var_nro_silla, var_nro_estudiante, var_nombre_estudiante, var_apellido;
                  EXIT WHEN cursor_salon_alumno%NOTFOUND;
                  
                  BEGIN

                    --solo imprimo el los datos del salon una vez                                                        
                    IF (var_nro_salon <> var_nro_salon_anterior) 
                    THEN
                      
                      IF (var_primero <> 1)
                      THEN
                        DBMS_OUTPUT.PUT_LINE('------------------------------------------');
                      END IF;
                      
                      var_primero := 0;
                      
                      DBMS_OUTPUT.PUT_LINE('------- Salon: ' || var_nro_salon);
                      DBMS_OUTPUT.PUT_LINE('          Silla   -   NroEst   -   Nombre');
                      DBMS_OUTPUT.PUT_LINE('------------------------------------------');
                      
                    END IF;
                    
                    --imprimo los datos pedidos
                    DBMS_OUTPUT.PUT_LINE('           ' || var_nro_silla || '   -   ' || var_nro_estudiante || '   -   ' || var_nombre_estudiante || ' ' || var_apellido);
                    
                    var_nro_salon_anterior := var_nro_salon;
                                        
                  END;
                  
              END LOOP;
              CLOSE cursor_salon_alumno;
              
              --corte de control por institucion para cumplir con el formato pedido
              IF (var_nombre_inst <> var_nombre_inst_ant)
              THEN
                DBMS_OUTPUT.PUT_LINE('------------------------------------------');
                DBMS_OUTPUT.PUT_LINE('');
              END IF;
              
              var_nombre_inst_ant := var_nombre_inst;
                                              
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

