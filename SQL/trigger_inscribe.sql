
--t1_inscribe
--Cuando un estudiante se inscribe a un examen, el examen debe estar disponible.

CREATE OR REPLACE TRIGGER t1_inscribe
BEFORE INSERT OR UPDATE OF nro_examen ON inscribe
FOR EACH ROW
DECLARE
  	esta_disponible CHAR(1);
	cant_aprobadoExamen NUMBER;
BEGIN

	--control de inscripcion a examen solo si esta disponible
	SELECT disponible INTO esta_disponible
	FROM examen
 	WHERE :NEW.nro_examen = nro_examen;
		    		
  	IF esta_disponible = 'N' THEN
		RAISE_APPLICATION_ERROR(-20001,'El examen debe estar disponible para poder inscribirse a el.');
	END IF;
	
END;


