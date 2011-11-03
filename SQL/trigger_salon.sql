CREATE OR REPLACE
TRIGGER t1_salon_control_rango_sillas
BEFORE UPDATE ON salon
FOR EACH ROW
DECLARE
	cantSillasFueraRango NUMBER;
BEGIN

	SELECT COUNT(*) AS uno
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

