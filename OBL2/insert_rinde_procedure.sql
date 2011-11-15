create or replace
PROCEDURE INSERT_RINDE 
(
  NRO_EXAMEN IN NUMBER  ,
  NRO_ESTUDIANTE IN NUMBER  
, NOMBRE_INSTITUCION IN VARCHAR2  
, FECHA IN DATE  
, NRO_SALON IN NUMBER  
, NRO_SILLA IN NUMBER  
) AS 

nro_salonFinal NUMBER;
nro_sillaFinal NUMBER;

lockname VARCHAR2(30) := 'INSERT_RINDE';
lockhandle VARCHAR2(128);
lockid  INTEGER := 99999;--se puede usar el lockid solo sin     DBMS_LOCK.ALLOCATE_UNIQUE(lockname, lockhandle);, haciendo solo request y release del lockid
call_status  INTEGER;

BEGIN
    DBMS_LOCK.ALLOCATE_UNIQUE(lockname, lockhandle);
    call_status := DBMS_LOCK.REQUEST(lockhandle);
      

  	nro_salonFinal := NRO_SALON;
    	nro_sillaFinal := NRO_SILLA;

		BUSCAR_SALON_SILLA(
			   NOMBRE_INSTITUCION,
			   FECHA,
			   nro_salonFinal,
			   nro_sillaFinal
			  );
       
   INSERT INTO rinde VALUES (NRO_EXAMEN, NRO_ESTUDIANTE, NOMBRE_INSTITUCION, nro_salonFinal,FECHA, nro_sillaFinal); 
   call_status := DBMS_LOCK.RELEASE(lockhandle);
EXCEPTION
    WHEN OTHERS THEN
    	  call_status := DBMS_LOCK.RELEASE(lockhandle);
	  raise_application_error(-20001, SQLERRM);
  
END INSERT_RINDE;
