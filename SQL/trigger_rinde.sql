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
		AND ib.nro_estudiante = :NEW.nro_estudiante
		AND ix.fecha = :NEW.fecha;
		   
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

		nro_salonFinal := :NEW.nro_SAlon;
    nro_sillaFinal := :NEW.nro_silla_asignado;

		BUSCAR_SALON_SILLA(
			   :NEW.nombre_institucion,
			   :NEW.fecha,
			   nro_salonFinal,
			   nro_sillaFinal
			  );

		IF nro_salonFinal = :NEW.nro_SAlon THEN
			IF nro_sillaFinal = :NEW.nro_silla_asignado THEN
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
			ELSE
				raise_application_error(-20001, 'MISMO SALON DISTINTA SILLA');
			END IF;
		ELSE
			IF nro_sillaFinal = :NEW.nro_silla_asignado THEN
				raise_application_error(-20001, 'DISTINTO SALON MISMA SILLA');
			ELSE
				raise_application_error(-20001, 'DISTINTO SALON DISTINTA SILLA');
			END IF;
		END IF;
	EXCEPTION
		 WHEN OTHERS THEN
			raise_application_error(-20001, SQLERRM);
	END;
EXCEPTION
  when NO_DATA_FOUND then
    RAISE_APPLICATION_ERROR(-20001, 'No se encontraron datos para los campos:: nro_salon y/o nro_examen y/o nombre_institucion y/o nro_estudiante');

END;
