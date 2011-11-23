
CREATE OR REPLACE 
TRIGGER t1_instancia_ex_insteadof
INSTEAD OF INSERT OR UPDATE ON instancia_ex
FOR EACH ROW
DECLARE

  var_cantidad NUMBER;
  
BEGIN

  BEGIN
    
    SELECT COUNT(*)
    INTO var_cantidad
    FROM instancia_ex
    WHERE nro_examen = :NEW.nro_examen
      AND fecha = :NEW.fecha
      AND to_char(hora, 'HH24:MI') <> to_char(:NEW.hora, 'HH24:MI');

  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN var_cantidad := 0;
    
  END;
  
  IF (var_cantidad > 0) THEN
    RAISE_APPLICATION_ERROR(-20001,'UN EXAMEN DEBE TOMARSE EN EL MISMO MOMENTO EN TODO EL MUNDO');
  END IF;
  
  IF INSERTING THEN
  
    INSERT INTO instancia_ex_data VALUES (:NEW.nro_examen, :NEW.nombre_institucion, :NEW.fecha, :NEW.hora);
  
  ELSIF UPDATING THEN
  
    UPDATE instancia_ex_data 
    SET nro_examen = :NEW.nro_examen, 
        nombre_institucion = :NEW.nombre_institucion,
        fecha = :NEW.fecha, 
        hora = :NEW.hora
    WHERE nro_examen = :OLD.nro_examen
      AND nombre_institucion = :OLD.nombre_institucion
      AND fecha = :OLD.fecha
      AND hora = :OLD.hora;
                          
  END IF;

END;