create or replace
TRIGGER t1_aprueba
BEFORE INSERT OR UPDATE OF nro_estudiante, nro_examen, fecha ON APRUEBA
FOR EACH ROW
DECLARE
  	fecha_instancia_examen DATE;
BEGIN
	SELECT MAX(ie.fecha) 
  INTO fecha_instancia_examen
	FROM instancia_ex ie, rinde r
 	WHERE 
			:NEW.nro_estudiante = r.nro_estudiante
		AND :NEW.nro_examen = r.nro_examen
		AND ie.nro_examen = r.nro_examen
    AND ie.nombre_institucion = r.nombre_institucion;
    
    --SI NO HAY INSTANCIA DE EXAMEN O SI NO HAY ALGUN RINDE LA FECHA QUEDA EN NULL
   if fecha_instancia_examen is null THEN
      RAISE_APPLICATION_ERROR(-20001,'NO SE RINDIO NINGUN EXAMEN, NO SE PUEDE APROBAR');
   END IF; 
   
  IF :NEW.fecha <= (fecha_instancia_examen + 7) THEN
		RAISE_APPLICATION_ERROR(-20001,'La fecha de aprobacion de un examen debe ser al '||
                'menos siete dias posterior a la fecha del mismo.(faltan '||((fecha_instancia_examen + 7) - :NEW.fecha +1)||' dias)');
	END IF;
	
END;
