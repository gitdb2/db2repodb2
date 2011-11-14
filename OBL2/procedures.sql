create or replace
Procedure BUSCAR_SALON_SILLA
(new_nombre_institucion IN VARCHAR2, 
new_fecha IN DATE, new_nro_Salon IN OUT   NUMBER, new_nro_silla_asignado IN OUT   NUMBER)
    IS

numeroDeSillaNueva NUMBER;
controlSilla NUMBER;
salonTupla SALON%ROWTYPE;

encontre NUMBER;

nro_salonTMP NUMBER;

nro_silla_maxTMP NUMBER;
nro_silla_minTMP NUMBER;

nro_salonFinal NUMBER;
nro_sillaFinal NUMBER;

CURSOR cursor_salonesDeInstitucion (par_nombre_institucion in VARCHAR2 ) IS
	SELECT *
	FROM salon s
	WHERE s.nombre_institucion = par_nombre_institucion;
  
--Control de qu ela silla no este ocupada
BEGIN
--	dbms_output.put_line('new_nro_SAlo ='||new_nro_Salon);
--	dbms_output.put_line('new_nro_silla_asignado ='||new_nro_silla_asignado);
--	dbms_output.put_line('----'); 
--	dbms_output.put_line('new_nombre_institucion ='||new_nombre_institucion);
--	dbms_output.put_line('new_fecha ='||new_fecha);

	---Obtiene en controlSilla si el nro_silla ya esta ocupado.
  
	BEGIN
		SELECT count(*) 
		INTO controlSilla
    		FROM rinde r  
		WHERE r.nro_SAlon = new_nro_Salon
		AND   r.nombre_institucion = new_nombre_institucion
		AND   r.fecha = new_fecha
		AND   r.nro_silla_asignado = new_nro_silla_asignado;
	END;
	IF controlSilla = 0 THEN
      dbms_output.put_line('Mismo SALON MISMA SILLA : '||new_nro_Salon || ' y tu silla es: '|| new_nro_silla_asignado);
 	ELSE
		-- el numero de silla ya esta ocupado, entonces busco si el numero de silla esta libre en los otros salones.
		BEGIN 
			encontre := 0;
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
				--si no esta en uso me la quedo
				IF controlSilla = 0 THEN
					encontre := 1;
					nro_salonFinal := salonTupla.nro_SAlon;
					nro_sillaFinal := new_nro_silla_asignado;
				END IF;
			end loop;

			close cursor_salonesDeInstitucion;

			if(encontre = 1) THEN
	          dbms_output.put_line('NUEVO SALON MISMA SILLA Tu nuevo salon es '||nro_salonFinal || ' y tu silla es: '|| nro_sillaFinal);
          new_nro_Salon:= nro_salonFinal;
          new_nro_silla_asignado:= nro_sillaFinal;
			ELSE
				-- NO SE ENCONTRO otro salon con el numero de silla disponible.
				-- sillaLibre = busco la primer silla libre en mi salon
				BEGIN
					SELECT nro_silla_max , nro_silla_min 
					INTO nro_silla_maxTMP , nro_silla_minTMP 
					FROM salon 
					WHERE 	nombre_institucion = new_nombre_institucion
					AND 	nro_salon = new_nro_Salon;
				EXCEPTION
					WHEN NO_DATA_FOUND
					THEN RAISE_APPLICATION_ERROR(-20001,'EL SALON '|| new_nro_Salon ||' NO EXISTE en '||new_nombre_institucion);
				END;

				BEGIN
					--obtiene el numero de silla minimo no ocupado en el salon que tengo asignado
					SELECT min (number_Range)
					INTO numeroDeSillaNueva
					from ( --genero numeros desde min a max nro de silla
						SELECT number_Range 
						FROM (
							SELECT Rownum number_Range
							FROM dual
							Connect By Rownum <= nro_silla_maxTMP
						     )
						WHERE number_Range >=nro_silla_minTMP
					     )
					WHERE number_Range NOT IN (
								-- aca se saca los numeros de sillas que estan ocupados 
								-- en un salon.
								SELECT nro_silla_asignado
								FROM rinde r
								WHERE r.nro_salon = new_nro_Salon
								AND   r.nombre_institucion = new_nombre_institucion
								AND   r.fecha = new_fecha
							);
				EXCEPTION --pero si lo de arriba no da resultados, entocnes hay un error 
					  --y ponemos numero de silla en - para poder detectarlo. quiere decir:
					-- que no hay sillas disponibles en el salon
					WHEN NO_DATA_FOUND
					THEN 
						numeroDeSillaNueva := -1;
				END;
				IF numeroDeSillaNueva >0 THEN
					nro_salonFinal := new_nro_Salon;
					nro_sillaFinal := numeroDeSillaNueva;
					-- se encontro otra silla en el salon original
          dbms_output.put_line('MISMO SALON NUEVA SILLA - Tu nuevo salon es '||nro_salonFinal || ' y tu silla es: '|| nro_sillaFinal);

          new_nro_Salon:= nro_salonFinal;
          new_nro_silla_asignado:= nro_sillaFinal;
				ELSE
					-- no hay silla libre en el salon new_nro_Salon
					--entonces tengo que buscar una silla en el primero que encuentre

					BEGIN
						encontre := 0;
						open cursor_salonesDeInstitucion(new_nombre_institucion);
						loop
							fetch cursor_salonesDeInstitucion into salonTupla;
				    			exit when cursor_salonesDeInstitucion%NOTFOUND OR encontre = 1;

							--para el salon en salonTupla, busco una silla libre
							BEGIN
								--obtiene el numero de silla minimo no ocupado en el salon que tengo asignado
								SELECT min (number_Range)
								INTO numeroDeSillaNueva
								from ( --genero numeros desde min a max nro de silla
									SELECT number_Range 
									FROM (
										SELECT Rownum number_Range
										FROM dual
										Connect By Rownum <= salonTupla.nro_silla_max
									     )
									WHERE number_Range >=salonTupla.nro_silla_min
								     )
								WHERE number_Range NOT IN (
											-- aca se saca los numeros de sillas que estan ocupados 
											-- en un salon.
											SELECT nro_silla_asignado
											FROM rinde r
											WHERE r.nro_salon = salonTupla.nro_salon
											AND   r.nombre_institucion = salonTupla.nombre_institucion
											AND   r.fecha = new_fecha
										);
							EXCEPTION --pero si lo de arriba no da resultados, entocnes hay un error 
								  --y ponemos numero de silla en - para poder detectarlo. quiere decir:
								-- que no hay sillas disponibles en el salon
								WHEN NO_DATA_FOUND
								THEN 
									numeroDeSillaNueva := -1;
							END;

							IF numeroDeSillaNueva >0 THEN
								encontre := 1;
								nro_salonFinal := salonTupla.nro_salon;
								nro_sillaFinal := numeroDeSillaNueva;

                dbms_output.put_line('CUALQUIER SALON, CUALQUIER SILLA Tu nuevo salon es '||	nro_salonFinal || ' y tu silla es: '|| nro_sillaFinal);
              
                new_nro_Salon:= nro_salonFinal;
                new_nro_silla_asignado:= nro_sillaFinal;
              
              END IF;
						end loop;
						close cursor_salonesDeInstitucion;

						IF encontre = 0 THEN
							RAISE_APPLICATION_ERROR(-20001,'NO PUEDES DAR EL EXAMEN, no hay lugar');
						END IF;

					EXCEPTION
						WHEN NO_DATA_FOUND
						THEN RAISE_APPLICATION_ERROR(-20001,' NO DATA FOUND buscando uno cualquiera y cualquier silla libre');
					END;
				END IF;
			END IF;

		EXCEPTION
			WHEN NO_DATA_FOUND
				THEN RAISE_APPLICATION_ERROR(-20001,' NO DATA FOUND');
		END;
                     
	END IF;

EXCEPTION
    WHEN OTHERS THEN
	  raise_application_error(-20001, SQLERRM);
END;
