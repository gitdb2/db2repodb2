
--Controla que cuando se inserta un registro, el nroSilla este dentro del rango de nroSillas valido

CREATE OR REPLACE TRIGGER t1_rinde_insteadof
INSTEAD OF INSERT OR UPDATE ON rinde
FOR EACH ROW
DECLARE
  	salon_nro_silla_max NUMBER;
    salon_nro_silla_min NUMBER;
    cantidad NUMBER;
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
  
  SELECT COUNT(*) 
  INTO cantidad
	FROM rinde_data r
 	WHERE r.nro_examen = :NEW.nro_examen
    AND r.nombre_institucion = :NEW.nombre_institucion
    AND r.nro_salon = :NEW.nro_salon
    AND r.fecha = :NEW.fecha
    AND r.nro_silla_asignado = :NEW.nro_silla_asignado;

  IF (cantidad > 0) THEN
		RAISE_APPLICATION_ERROR(-20001, 'El numero de silla no es valido, esta ocupado.');
	END IF;

  IF INSERTING THEN
  
    INSERT INTO rinde_data VALUES (:NEW.nro_examen, :NEW.nro_estudiante, :NEW.nombre_institucion, :NEW.nro_salon, :NEW.fecha, :NEW.nro_silla_asignado);
  
  ELSIF UPDATING THEN

    UPDATE rinde_data SET nro_silla_asignado = :NEW.nro_silla_asignado
    WHERE nro_examen = :NEW.nro_examen
      AND nro_estudiante = :NEW.nro_estudiante
      AND nombre_institucion = :NEW.nombre_institucion
      AND nro_salon = :NEW.nro_salon
      AND fecha = :NEW.fecha;
      
  END IF;

END;


--prueba para rinde

INSERT INTO estudiante VALUES (1, 1, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (2, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (3, 3, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO institucion VALUES ('inst1', 'paraguay', 'asuncion', 'chilavert road 1354');
INSERT INTO salon VALUES ('inst1', 1, 30, 1);
INSERT INTO examen VALUES (1, 'test de cooper', 'S');

INSERT INTO inscribe VALUES (1, 1);
INSERT INTO inscribe VALUES (2, 1);
INSERT INTO inscribe VALUES (3, 1);

INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'));
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 2);

--este insert activa el trigger por el nroSalon invalido
INSERT INTO rinde VALUES (1, 3, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 900);

--este update activa el trigger por el nroSalon invalido
UPDATE rinde SET nro_silla_asignado = 900 
WHERE nro_examen = 1
  AND nro_estudiante = 1
  AND nombre_institucion = 'inst1'
  AND nro_salon = 1
  AND fecha = to_date('2011/01/01', 'yyyy/mm/dd');


--este insert activa el trigger porque ya esta ocupado el nroSilla
INSERT INTO rinde VALUES (1, 3, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);


--este update activa el trigger porque ya esta ocupado el nroSilla
UPDATE rinde SET nro_silla_asignado = 2
WHERE nro_examen = 1
  AND nro_estudiante = 1
  AND nombre_institucion = 'inst1'
  AND nro_salon = 1
  AND fecha = to_date('2011/01/01', 'yyyy/mm/dd');






