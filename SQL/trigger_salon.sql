create or replace
TRIGGER t1_salon_control_rango_sillas
BEFORE UPDATE ON salon
FOR EACH ROW
DECLARE
	cantSillasFueraRango NUMBER;
BEGIN
	SELECT count(*) as uno
	INTO 	cantSillasFueraRango
	FROM 	rinde r
 	WHERE 
        	:NEW.nro_salon = r.nro_salon
	AND 	
		:NEW.nombre_institucion = r.nombre_institucion
	AND 	
		(r.nro_silla_asignado < :NEW.nro_silla_min OR r.nro_silla_asignado > :NEW.nro_silla_max);
			
	IF cantSillasFueraRango >0 THEN
		RAISE_APPLICATION_ERROR(-20001,'NO SE PUEDE MODIFICAR EL RANGO DE SILLAS DEL SALON PUES YA HAY SILLAS ASIGNADAS EN LA RELACION RINDE');
	END IF;
																  
END;

--prueba para t1_salon_control_rango_sillas
INSERT INTO estudiante VALUES (1, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO institucion VALUES ('inst1', 'paraguay', 'asuncion', 'chilavert road 1354');
INSERT INTO salon VALUES ('inst1', 1, 30, 1);
INSERT INTO institucion VALUES ('inst2', 'ARGENTINA', 'BS', 'Kichener');
INSERT INTO salon VALUES ('inst2', 1, 5, 1);
INSERT INTO examen VALUES (1, 'test de cooper', 'S');
INSERT INTO inscribe VALUES (1, 1);
INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'));
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 5);

--NO debe ROMPER
UPDATE salon
set nro_silla_min = 10, nro_silla_max = 17
where nombre_institucion = 'inst2';

--ROMPE
UPDATE salon
set nro_silla_min = 10
where nombre_institucion = 'inst1';

--ROMPE 2
UPDATE salon
set nro_silla_max = 2
where nombre_institucion = 'inst1';

