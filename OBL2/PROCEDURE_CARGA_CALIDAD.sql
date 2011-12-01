create or replace
Procedure CARGA_CALIDAD (p_fecha IN DATE)
    IS



encontre NUMBER;
nro_examenTMP NUMBER;

fecha_TMP DATE;
cant_rendidos_TMP NUMBER;
cant_aprobados_TMP NUMBER;

CURSOR cursor_rinde_not_in_calidad (par_fecha in DATE ) IS
	SELECT r.nro_examen, r.fecha, count(*)
	FROM rinde r
	WHERE 
    (par_fecha - 7) >r.fecha
  AND 
    NOT EXISTS 
    (
      SELECT 1
      FROM calidad cal
      WHERE 
            cal.fecha = r.fecha
      AND   
            cal.nroexamen = r.nro_examen
    )
  
  GROUP BY r.nro_examen, r.fecha;
  
BEGIN
	dbms_output.put_line('----'); 
  	dbms_output.put_line('Tabla temporal Creada'); 

			OPEN cursor_rinde_not_in_calidad(p_fecha);
			LOOP
				FETCH cursor_rinde_not_in_calidad 
        INTO nro_examentmp, fecha_tmp, cant_rendidos_tmp;
	    			EXIT WHEN cursor_rinde_not_in_calidad%NOTFOUND;

				BEGIN
        
          cant_aprobados_TMP:= 0;
          for i in (
              select distinct(r.nro_estudiante)
              from rinde r 
              where 
                r.nro_examen = nro_examentmp
              and 
                r.fecha = fecha_tmp
          )
          loop
              incrementar_si_aprueba( nro_examentmp,i.nro_estudiante, fecha_tmp, cant_aprobados_TMP);
           end loop;
        
         dbms_output.put_line('Aprobados = '||cant_aprobados_TMP);
        
          INSERT INTO calidad_temp 
          VALUES(nro_examentmp,fecha_tmp, cant_rendidos_tmp, cant_aprobados_tmp, (cant_rendidos_tmp - cant_aprobados_tmp));
          
          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
              dbms_output.put_line('NO DATA FOUND en aprueba para nro_examen='||nro_examentmp||' fecha=' ||fecha_tmp); 
              cant_aprobados_TMP := 0;
             
				END;
			
			end loop;

			close cursor_rinde_not_in_calidad;
      
     for i in( select * from calidad_temp)
     loop 
      dbms_output.put_line( i.NROEXAMEN ||' ' || i.FECHA ||' ' || i.TOTALALUMNOS ||' ' || i.TOTALAPROBADOS ||' ' || i.TOTALELIMINADOS);
     
     END LOOP;
      
      INSERT INTO calidad (NROEXAMEN, FECHA, TOTALALUMNOS,  TOTALAPROBADOS,TOTALELIMINADOS)
      SELECT  NROEXAMEN, FECHA, TOTALALUMNOS,  TOTALAPROBADOS,TOTALELIMINADOS
      FROM calidad_temp;
     
     COMMIT;
      
      
  EXCEPTION
          WHEN OTHERS
					THEN 
            RAISE_APPLICATION_ERROR(-20001, 'ERROR DE CALIDAD');
            close cursor_rinde_not_in_calidad;
            ROLLBACK ;
          
END CARGA_CALIDAD;
