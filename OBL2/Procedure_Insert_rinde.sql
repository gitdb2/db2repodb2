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

nom_inst VARCHAR2(50);
nro_salonFinal NUMBER;
nro_sillaFinal NUMBER;

estado_interno NUMBER;
tmp NUMBER;

BEGIN
    p_STATUS    := 1;
    nom_inst  := p_NOMBRE_INSTITUCION;
    
    dbms_output.put_line('nom_inst='||nom_inst);
    
    -- si no se pasa la institucion y nunca rindio el examen, da error 
    -- si no se pasa o si se pasa   y ya    rindio el examen, se retorna la ultima institucion en la que se rindio, la silla y el salon en que rindio.
    -- si    se pasa la institucion y nunca rindio el examen, retorna la institucion pasada, el primer salon y la primer silla de dicha institucion, para que luego se busque una libre, 
    BUSCAR_ULTIMO_SALON_SILLA(p_NRO_EXAMEN, p_NRO_ESTUDIANTE, p_FECHA, nom_inst, nro_salonFinal, nro_sillaFinal, estado_interno);
    
   --BLOQUEO los rinde para la institucion seleccionada, para que nadie pueda leer ni escibir datos en rinde y relacionados con la institucion
     dbms_output.put_line('BLOQUEO FOR UPDATE instancia examen(int, ex, fecha) ='
          ||nom_inst||', '||p_NRO_EXAMEN||', '||p_FECHA);
   
 --- Seccion critica para la instancia de examen, para evitar que me 
--llamen al procedimientos mientras estoy buscando un lugar vacio para insertar
-- Se bloquean todas las instancia de examen para una fecha y una institucion dada, pues tenemos un supuesto que 
-- en un salon puede haber varios examenes distintos
   SELECT 1
    INTO tmp
   FROM	instancia_ex iex
   WHERE 
      iex.nombre_institucion = nom_inst
   --AND	iex.nro_examen = p_NRO_EXAMEN
   AND iex.fecha    = p_FECHA
   FOR UPDATE;
   
	BEGIN
        dbms_output.put_line('BUSCAR_SALON_SILLA('|| p_NOMBRE_INSTITUCION ||','||
                   p_FECHA||','||
                   nro_salonFinal||','||
                   nro_sillaFinal||')');
                   
			BUSCAR_SALON_SILLA(
				   p_NOMBRE_INSTITUCION,
				   p_FECHA,
				   nro_salonFinal,
				   nro_sillaFinal
				  );
	       
	   INSERT INTO rinde VALUES (p_NRO_EXAMEN, p_NRO_ESTUDIANTE, nom_inst, nro_salonFinal, p_FECHA, nro_sillaFinal); 
   
	   COMMIT;
    	  dbms_output.put_line('hizo commit');
	END;
   p_NRO_SALON := nro_salonFinal;
   p_NRO_SILLA := nro_sillaFinal;
   p_STATUS    := 0;

EXCEPTION
    WHEN OTHERS THEN
    
    dbms_output.put_line(  'CODE - '||SQLCODE||' -ERROR- '||SQLERRM);
    ROLLBACK;
    p_STATUS:=1;
  
END INSERT_RINDE;
