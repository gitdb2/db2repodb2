create or replace
PROCEDURE INSERT_RINDE 
(
  p_NRO_EXAMEN IN NUMBER
, p_NRO_ESTUDIANTE IN NUMBER  
, p_NOMBRE_INSTITUCION IN VARCHAR2  
, p_FECHA IN DATE  
, p_NRO_SALON OUT NUMBER  
, p_NRO_SILLA OUT NUMBER
, p_STATUS OUT NUMBER
) AS 

nom_inst VARCHAR2;
nro_salonFinal NUMBER;
nro_sillaFinal NUMBER;

--lockname VARCHAR2(30) := 'INSERT_RINDE';
--lockhandle VARCHAR2(128);
--lockid  INTEGER := 99999;--se puede usar el lockid solo sin     DBMS_LOCK.ALLOCATE_UNIQUE(lockname, lockhandle);, haciendo solo request y release del lockid
--call_status  INTEGER;
estado_interno NUMBER;
tmp NUMBER;

BEGIN
  --  DBMS_LOCK.ALLOCATE_UNIQUE(lockname, lockhandle);
  --  call_status := DBMS_LOCK.REQUEST(lockhandle);
    p_STATUS    := 1;
    nom_inst  := p_NOMBRE_INSTITUCION;
    
    -- si no se pasa la institucion y nunca rindio el examen, da error 
    -- si no se pasa o si se pasa   y ya    rindio el examen, se retorna la ultima institucion en la que se rindio, la silla y el salon en que rindio.
    -- si    se pasa la institucion y nunca rindio el examen, retorna la institucion pasada, el primer salon y la primer silla de dicha institucion, para que luego se busque una libre, 
    BUSCAR_ULTIMO_SALON_SILLA(p_NRO_EXAMEN, p_NRO_ESTUDIANTE, p_FECHA, nom_inst, nro_salonFinal, nro_sillaFinal, estado_interno);
    
   --BLOQUEO los rinde para la institucion seleccionada, para que nadie pueda leer ni escibir datos en rinde y relacionados con la institucion
   SELECT count(*)
	INTO tmp
   FROM	rinde r
   WHERE 
	r.nombre_institucion = nom_inst
   AND	r.fecha = p_FECHA
   FOR UPDATE;

		BUSCAR_SALON_SILLA(
			   p_NOMBRE_INSTITUCION,
			   p_FECHA,
			   nro_salonFinal,
			   nro_sillaFinal
			  );
       
   INSERT INTO rinde VALUES (p_NRO_EXAMEN, p_NRO_ESTUDIANTE, nom_inst, nro_salonFinal,p_FECHA, nro_sillaFinal); 
   
   COMMIT;
   p_NRO_SALON := nro_salonFinal;
   p_NRO_SILLA := nro_sillaFinal;
   p_STATUS    := 0;

   
  -- call_status := DBMS_LOCK.RELEASE(lockhandle);
EXCEPTION
    WHEN OTHERS THEN
    --	  call_status := DBMS_LOCK.RELEASE(lockhandle);
    ROLLBACK;
    p_STATUS:=1;
	  raise_application_error(-20001, SQLERRM);
  
END INSERT_RINDE;
