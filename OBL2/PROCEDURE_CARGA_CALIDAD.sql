create or replace
Procedure CARGA_CALIDAD
(p_fecha IN DATE)
    IS

--salonTupla SALON%ROWTYPE; 

encontre NUMBER;

nro_examenTMP NUMBER;

fecha_TMP DATE;
cant_rendidos_TMP NUMBER;
cant_aprobados_TMP NUMBER;

CURSOR cursor_rinde_not_in_calidad (par_fecha in DATE ) IS
	SELECT *
	FROM salon s
	WHERE s.nombre_institucion = par_nombre_institucion;
  
BEGIN
	dbms_output.put_line('----'); 

			open cursor_salonesDeInstitucion(new_nombre_institucion);
			loop
				fetch cursor_salonesDeInstitucion into salonTupla;
	    			exit when cursor_salonesDeInstitucion%NOTFOUND OR encontre =1;

				-- busco si el salon salonTupla tiene sillas libres
				BEGIN
					SELECT count(*) 
					into controlSilla
					from rinde r
					where r.nro_SAlon = salonTupla.nro_SAlon
					and   r.nombre_institucion = new_nombre_institucion
					and   r.fecha = new_fecha
					and   r.nro_silla_asignado = new_nro_silla_asignado;
          
				END;
			
			end loop;

			close cursor_salonesDeInstitucion;
END CARGA_CALIDAD;
