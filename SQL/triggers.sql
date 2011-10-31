
--t1_inscribe
--Cuando un estudiante se inscribe a un examen, el examen debe estar disponible.

CREATE OR REPLACE TRIGGER t1_inscribe
BEFORE INSERT OR UPDATE OF nro_examen ON inscribe
FOR EACH ROW
DECLARE
  	esta_disponible CHAR(1);
BEGIN

	SELECT disponible INTO esta_disponible
	FROM examen
 	WHERE :NEW.nro_examen = nro_examen;
		    		
  IF esta_disponible = 'N' THEN
		RAISE_APPLICATION_ERROR(-20001,'El examen debe estar disponible para poder inscribirse a el.');
	END IF;
  
END;

--prueba para t1_inscribe
INSERT INTO estudiante VALUES (1, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO examen VALUES (1, 'test de cooper', 'S');
INSERT INTO examen VALUES (2, 'tiro al arco', 'N');
INSERT INTO inscribe VALUES (1, 1);

--aca se rompe
INSERT INTO inscribe VALUES (1, 2);

