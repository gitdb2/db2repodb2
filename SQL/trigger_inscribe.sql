
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

	--control de que un estudiante no se pueda volver a inscribir a un examen que ya lo tiene aprobado
	select count(*) 
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


---DATOS DE PRUEBA PARA LA PARTE DE CONTRO DE INSCRIPCION A EXAMEN NO DISPONIBLE
--prueba para t1_inscribe
INSERT INTO estudiante VALUES (1, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO examen VALUES (1, 'test de cooper', 'S');
INSERT INTO examen VALUES (2, 'tiro al arco', 'N');
INSERT INTO inscribe VALUES (1, 1);

--en este insert se activa el trigger
INSERT INTO inscribe VALUES (1, 2);




---DATOS DE PRUEBA PAR LA PARTE DE CONTROL DE INSCRIPCION SI YA ESTA APROBADO EL EXAMEN

INSERT INTO estudiante VALUES (3, 3, 'Argentina', 'est3', 'apellido', 'asuncion');
INSERT INTO examen VALUES (1, 'test de cooper', 'S');
INSERT INTO examen VALUES (3, 'tiro al arco 2', 'S');
INSERT INTO inscribe VALUES (3, 1);
INSERT INTO inscribe VALUES (3, 3);

-- nro_estudiante , nro_examen, fecha, calificacion 
INSERT INTO aprueba VALUES (3, 1, sysDate, 80);

--No debe permitirse:

INSERT INTO inscribe VALUES (3, 1);

