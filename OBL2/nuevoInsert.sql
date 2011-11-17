create or replace
PROCEDURE INSERT_RINDE 
(
  NRO_EXAMEN IN NUMBER
, NRO_ESTUDIANTE IN NUMBER  
, NOMBRE_INSTITUCION IN VARCHAR2  
, FECHA IN DATE  
, NRO_SALON OUT NUMBER  
, NRO_SILLA OUT NUMBER
, STATUS OUT NUMBER
) AS 

nom_inst VARCHAR2;
nro_salonFinal NUMBER;
nro_sillaFinal NUMBER;

lockname VARCHAR2(30) := 'INSERT_RINDE';
lockhandle VARCHAR2(128);
lockid  INTEGER := 99999;--se puede usar el lockid solo sin     DBMS_LOCK.ALLOCATE_UNIQUE(lockname, lockhandle);, haciendo solo request y release del lockid
call_status  INTEGER;
estado_interno NUMBER;

BEGIN
  --  DBMS_LOCK.ALLOCATE_UNIQUE(lockname, lockhandle);
  --  call_status := DBMS_LOCK.REQUEST(lockhandle);
    STATUS    := 1;
    nom_inst  := NOMBRE_INSTITUCION;
    
    -- si no se pasa la institucion y nunca rindio el examen, da error 
    -- si no se pasa o si se pasa   y ya    rindio el examen, se retorna la ultima institucion en la que se rindio, la silla y el salon en que rindio.
    -- si    se pasa la institucion y nunca rindio el examen, retorna la institucion pasada, el primer salon y la primer silla de dicha institucion, para que luego se busque una libre, 
    BUSCAR_ULTIMO_SALON_SILLA(NRO_EXAMEN, NRO_ESTUDIANTE, FECHA, nom_inst, nro_salonFinal, nro_sillaFinal, estado_interno);
    
   
		BUSCAR_SALON_SILLA(
			   NOMBRE_INSTITUCION,
			   FECHA,
			   nro_salonFinal,
			   nro_sillaFinal
			  );
       
   INSERT INTO rinde VALUES (NRO_EXAMEN, NRO_ESTUDIANTE, NOMBRE_INSTITUCION, nro_salonFinal,FECHA, nro_sillaFinal); 
   
   	NRO_SALON := nro_salonFinal;
    NRO_SILLA := nro_sillaFinal;
    STATUS    := 0;

   
  -- call_status := DBMS_LOCK.RELEASE(lockhandle);
EXCEPTION
    WHEN OTHERS THEN
    --	  call_status := DBMS_LOCK.RELEASE(lockhandle);
    STATUS:=1;
	  raise_application_error(-20001, SQLERRM);
  
END INSERT_RINDE;