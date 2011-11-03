
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


--prueba para t1_aprueba
INSERT INTO estudiante VALUES (1, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO institucion VALUES ('inst1', 'paraguay', 'asuncion', 'chilavert road 1354');
INSERT INTO salon VALUES ('inst1', 1, 30, 1);
INSERT INTO examen VALUES (1, 'test de cooper', 'S');
INSERT INTO inscribe VALUES (1, 1);
INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011-12-02 16:00:', 'YYYY-MM-DD HH24:MI:'));
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 5);


--este insert no activa el trigger
INSERT INTO aprueba VALUES (1, 1, to_date('2011/01/15', 'yyyy/mm/dd'), 95);

--este insert activa el trigger
INSERT INTO aprueba VALUES (1, 1, to_date('2011/01/05', 'yyyy/mm/dd'), 95);

