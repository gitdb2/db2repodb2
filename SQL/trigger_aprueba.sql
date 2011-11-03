
CREATE OR REPLACE TRIGGER t1_aprueba
BEFORE INSERT OR UPDATE OF nro_estudiante, nro_examen, fecha ON APRUEBA
FOR EACH ROW
DECLARE
  	fecha_instancia_examen DATE;
BEGIN
	SELECT ie.fecha INTO fecha_instancia_examen
	FROM instancia_ex ie, rinde r
 	WHERE 
			:NEW.nro_estudiante = r.nro_estudiante
		AND :NEW.nro_examen = r.nro_examen
		AND ie.nro_examen = r.nro_examen
    AND ie.nombre_institucion = r.nombre_institucion;
		
  IF :NEW.fecha <= (fecha_instancia_examen + 7) THEN
		RAISE_APPLICATION_ERROR(-20001,'La fecha de aprobacion de un examen debe ser al menos siete dias posterior a la fecha del mismo.');
	END IF;
  
END;
