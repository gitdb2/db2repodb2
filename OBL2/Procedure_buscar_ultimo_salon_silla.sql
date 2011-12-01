CREATE OR REPLACE
PROCEDURE BUSCAR_ULTIMO_SALON_SILLA(
  p_NRO_EXAMEN IN NUMBER
, p_NRO_ESTUDIANTE IN NUMBER  
, p_FECHA IN DATE  
, p_NOMBRE_INSTITUCION IN OUT VARCHAR2  
, p_NRO_SALON OUT NUMBER  
, p_NRO_SILLA OUT NUMBER
, p_STATUS OUT NUMBER
) AS 
-- si no se pasa la institucion y nunca rindio el examen, da error 
-- si no se pasa o si se pasa   y ya    rindio el examen, se retorna la ultima institucion en la que se rindio, la silla y el salon en que rindio.
-- si    se pasa la institucion y nunca rindio el examen, retorna la institucion pasada, el primer salon y la primer silla de dicha institucion, para que luego se busque una libre, 

institucion VARCHAR2(50);
cantInstancias NUMBER;

BEGIN
  p_STATUS    := -1;
  p_NRO_SALON := -1;
  p_NRO_SILLA := -1;

  BEGIN --CHEQUEO que exista una instancia de examen para esa fecha, para no seguir trabajando sin necesidad
  IF p_NOMBRE_INSTITUCION IS NOT NULL THEN
    SELECT count(*) 
    INTO cantInstancias
    FROM instancia_ex iex
    		WHERE 	iex.fecha = p_FECHA
					AND 	iex.nro_examen = p_NRO_EXAMEN
					AND 	iex.nombre_institucion = p_NOMBRE_INSTITUCION;
    IF cantInstancias = 0 THEN 
      RAISE_APPLICATION_ERROR(-20001,'LA INSTANCIA DE EXAMEN NO EXISTE=> ERROR.');
    END IF;
  END IF;
  END;


  BEGIN
    --en rinde nro_est, fecha son unique por lo que al fijar una fecha y un estudiante se obtiene ninguno o solo un registro
    SELECT r.nombre_institucion, r.nro_salon, r.nro_silla_asignado
    INTO institucion, p_NRO_SALON, p_NRO_SILLA
    FROM rinde r
    WHERE r.nro_examen = p_NRO_EXAMEN
    AND   r.nro_estudiante = p_NRO_ESTUDIANTE
    AND   r.fecha IN 
                    (--busco la ultima fecha en que el estudinte dio el examen
                      SELECT MAX(fecha)
                      FROM rinde 
                      WHERE fecha < p_FECHA
		      AND nro_estudiante = p_NRO_ESTUDIANTE 
                      AND nro_examen = p_NRO_EXAMEN
                    );
  
  EXCEPTION
	WHEN NO_DATA_FOUND  THEN-- NUNCA RINDIO EL EXAMEN
			dbms_output.put_line('CODIGO MANEJO EXCEPCION');
			IF p_NOMBRE_INSTITUCION IS NULL THEN
				RAISE_APPLICATION_ERROR(-20001,'NO SE RINDIO EXAMEN ANTES Y NO SE PASA LA INSTITUCION => ERROR.');
			ELSE
				BEGIN
				--en caso que se pase la institucion me quedo con el primer salon que aparezca (rownum < 2) y obtengo la silla minima
					SELECT s.nombre_institucion, s.nro_salon, s.nro_silla_min
					INTO institucion, p_NRO_SALON, p_NRO_SILLA
					FROM instancia_ex iex, salon s
					WHERE 	iex.fecha = p_FECHA
					AND 	iex.nro_examen = p_NRO_EXAMEN
					AND 	iex.nombre_institucion = p_NOMBRE_INSTITUCION
					AND 	iex.nombre_institucion = s.nombre_institucion
					AND     rownum < 2;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN -- NO hay salones en la institucion

						RAISE_APPLICATION_ERROR(-20001,'NO HAY SALONES EN LA INSTITUCION o es una instancia invalida de examen=> ERROR.');
				END;
			END IF;
			
  END;

  p_NOMBRE_INSTITUCION := institucion;
  p_STATUS:= 0;

END;
