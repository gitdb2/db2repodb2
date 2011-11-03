
--Controla que cuando se inserta un registro, el nroSilla este dentro del rango de nroSillas valido

create or replace
TRIGGER t1_rinde_insteadof
INSTEAD OF INSERT OR UPDATE ON rinde
FOR EACH ROW
DECLARE
	salon_nro_silla_max NUMBER;
	salon_nro_silla_min NUMBER;
	cantidad NUMBER;
	cant_aprobadoExamen NUMBER;


	numeroDeSillaNueva NUMBER;
	controlSilla NUMBER;
	salonTupla SALON%ROWTYPE;

	encontre NUMBER;

	nro_salonTMP NUMBER;

	nro_silla_maxTMP NUMBER;
	nro_silla_minTMP NUMBER;

	nro_salonFinal NUMBER;
	nro_sillaFinal NUMBER;
--cursor que retorna todos los salones de una institucion que tenga el examen asignado 
---(puede pasar que se mesclen estudiantes de mas de un examen en el mismo salon)
CURSOR cursor_salonesDeInstitucion (par_nombre_institucion in VARCHAR2 ) IS
	SELECT *
	FROM salon s
	WHERE s.nombre_institucion = par_nombre_institucion;

BEGIN

--control de que no se permita rendir un examen si ya se aprobo
	BEGIN
		SELECT count(*) 
		INTO cant_aprobadoExamen
		FROM aprueba
		WHERE 
			:NEW.nro_examen = nro_examen
		AND 
			:NEW.nro_estudiante = nro_estudiante;

		IF cant_aprobadoExamen > 0 THEN
			RAISE_APPLICATION_ERROR(-20001,'El estudiante ya tiene aprobado el examen '|| :NEW.nro_examen ||'.');
		END IF;
	END;



--Control de numero de silla valido
	BEGIN
		SELECT s.nro_silla_max, s.nro_silla_min 
		INTO salon_nro_silla_max, salon_nro_silla_min
			FROM salon s, instancia_ex ix, inscribe ib
	 		WHERE ix.nombre_institucion = s.nombre_institucion
		AND ix.nombre_institucion = :NEW.nombre_institucion
		AND s.nro_salon = :NEW.nro_salon
		AND ix.nro_examen = ib.nro_examen
		AND ix.nro_examen = :NEW.nro_examen
		AND ib.nro_estudiante = :NEW.nro_estudiante;
		   
	  	IF (:NEW.nro_silla_asignado < salon_nro_silla_min) OR (:NEW.nro_silla_asignado > salon_nro_silla_max) THEN
			RAISE_APPLICATION_ERROR(-20001, 'El numero de silla no es valido, debe estar dentro del rango maximo y minimo del salon.');
		END IF;
	END;
  
--Control de qu ela silla no este ocupada
	BEGIN
		dbms_output.put_line(':NEW.nro_SAlo ='||:NEW.nro_SAlon);
		dbms_output.put_line(':NEW.nro_silla_asignado ='||:NEW.nro_silla_asignado);
		dbms_output.put_line('----'); 
		dbms_output.put_line(':NEW.nombre_institucion ='||:NEW.nombre_institucion);
		dbms_output.put_line(':NEW.fecha ='||:NEW.fecha);

		---Obtiene en controlSilla si el nro_silla ya esta ocupado.
		BEGIN
			SELECT count(*) 
			INTO controlSilla
	    		FROM rinde r  
			WHERE r.nro_SAlon = :NEW.nro_SAlon
			AND   r.nombre_institucion = :NEW.nombre_institucion
			AND   r.fecha = :NEW.fecha
			AND   r.nro_silla_asignado = :NEW.nro_silla_asignado;
		END;

		IF controlSilla = 0 THEN

			IF INSERTING THEN
					INSERT 	INTO rinde_data 
						VALUES (:NEW.nro_examen, :NEW.nro_estudiante, :NEW.nombre_institucion,
							:NEW.nro_salon, :NEW.fecha, :NEW.nro_silla_asignado);
				  
				ELSIF UPDATING THEN
			
				    UPDATE rinde_data 
				    SET   nro_silla_asignado = :NEW.nro_silla_asignado,
					  nro_salon = :NEW.nro_salon,
					  nro_examen = :NEW.nro_examen,
					  nro_estudiante = :NEW.nro_estudiante,
					  nombre_institucion = :NEW.nombre_institucion,
					  fecha = :NEW.fecha
            
				    WHERE nro_examen = :OLD.nro_examen
				      AND nro_estudiante = :OLD.nro_estudiante
				      AND nombre_institucion = :OLD.nombre_institucion
				      AND nro_salon = :OLD.nro_salon
              			      AND nro_silla_asignado = :OLD.nro_silla_asignado
				      AND fecha = :OLD.fecha;
				      
				
				      
				END IF;

		     -- RAISE_APPLICATION_ERROR(-20001,'SILLA en salon original disponible:  Tu nuevo salon es '||:NEW.nro_SAlon || ' y tu silla es: '|| :NEW.nro_silla_asignado);

		ELSE
			-- el numero de silla ya esta ocupado, entonces busco si el numero de silla esta libre en los otros salones.
			BEGIN 
				encontre := 0;
				open cursor_salonesDeInstitucion(:NEW.nombre_institucion);
				loop
					fetch cursor_salonesDeInstitucion into salonTupla;
		    			exit when cursor_salonesDeInstitucion%NOTFOUND OR encontre =1;
	
					-- busco si el salon salonTupla tiene sillas libres
					BEGIN
						SELECT count(*) 
						into controlSilla
						from rinde r  
						where r.nro_SAlon = salonTupla.nro_SAlon
						and   r.nombre_institucion = :NEW.nombre_institucion
						and   r.fecha = :NEW.fecha
						and   r.nro_silla_asignado = :NEW.nro_silla_asignado;
					END;
					--si no esta en uso me la quedo
					IF controlSilla = 0 THEN
						encontre := 1;
						nro_salonFinal := salonTupla.nro_SAlon;
						nro_sillaFinal := :NEW.nro_silla_asignado;
						--INSERT(new...);
					END IF;
				end loop;
				close cursor_salonesDeInstitucion;

				if(encontre = 1) THEN
					--- CAMBIAR POR INSERT OR ALGO, pues se enontro un nuevo salon con el mismo numero de silla
					RAISE_APPLICATION_ERROR(-20001,'NUEVO SALON MISMA SILLA Tu nuevo salon es'||nro_salonFinal || ' y tu silla es: '|| nro_sillaFinal);
				ELSE
					-- NO SE ENCONTRO otro salon con el numero de silla disponible.
					-- sillaLibre = busco la primer silla libre en mi salon

					BEGIN
						SELECT nro_silla_max , nro_silla_min 
						INTO nro_silla_maxTMP , nro_silla_minTMP 
						FROM salon 
						WHERE 	nombre_institucion = :NEW.nombre_institucion
						AND 	nro_salon = :NEW.nro_salon;
					EXCEPTION
						WHEN NO_DATA_FOUND
						THEN RAISE_APPLICATION_ERROR(-20001,'EL SALON '|| :NEW.nro_salon ||' NO EXISTE en '||:NEW.nombre_institucion);
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
									WHERE r.nro_salon = :NEW.nro_salon
									AND   r.nombre_institucion = :NEW.nombre_institucion
									AND   r.fecha = :NEW.fecha
								);
					EXCEPTION --pero si lo de arriba no da resultados, entocnes hay un error 
						  --y ponemos numero de silla en - para poder detectarlo. quiere decir:
						-- que no hay sillas disponibles en el salon
						WHEN NO_DATA_FOUND
						THEN 
							numeroDeSillaNueva := -1;
					END;

					IF numeroDeSillaNueva >0 THEN
						nro_salonFinal := :NEW.nro_salon;
						nro_sillaFinal := numeroDeSillaNueva;
						-- se encontro otra silla en el salon original
						--- CAMBIAR POR INSERT OR ALGO, pues se enontro NUEVA SILLA EN EL MISMO SALON
						RAISE_APPLICATION_ERROR(-20001,'MISMO SALON NUEVA SILLA - Tu nuevo salon es '||nro_salonFinal || ' y tu silla es: '|| nro_sillaFinal);
			
					ELSE
						-- no hay silla libre en el salon :NEW.nro_salon
						--entonces tengo que buscar una silla en el primero que encuentre

						BEGIN
							encontre := 0;
							open cursor_salonesDeInstitucion(:NEW.nombre_institucion);
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
												AND   r.fecha = :NEW.fecha
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
									-- se encontro otra silla en el salon original
									--- CAMBIAR POR INSERT OR ALGO, pues se enontro un nuevo salon nuevo numero de silla
									close cursor_salonesDeInstitucion;
									RAISE_APPLICATION_ERROR(-20001,'CUALQUIER SALON, CUALQUIER SILLA Tu nuevo salon es'||
									nro_salonFinal || ' y tu silla es: '|| nro_sillaFinal);
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
		  raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	END;
exception
  when NO_DATA_FOUND then
    RAISE_APPLICATION_ERROR(-20001, 'No se encontraron datos para los campos:: nro_salon y/o nro_examen y/o nombre_institucion y/o nro_estudiante');

END;


