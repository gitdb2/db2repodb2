create or replace
PROCEDURE incrementar_si_aprueba
(
 par_nro_examen IN NUMBER, 
 par_nro_estudiante IN NUMBER, 
 par_posible_fecha_aprobacion IN DATE,
 par_contador IN OUT NUMBER
) AS

 var_fecha DATE;

BEGIN
 
 SELECT MAX(r.fecha)
 INTO var_fecha
 FROM rinde r, aprueba a
 WHERE r.nro_estudiante = par_nro_estudiante
   AND r.nro_examen = par_nro_examen
   AND r.nro_estudiante = a.nro_estudiante
   AND r.nro_examen = a.nro_examen;
   
 IF (var_fecha = par_posible_fecha_aprobacion) THEN
   par_contador := par_contador + 1;
 END IF;
 
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
   --dummy
   par_contador := par_contador;

END incrementar_si_aprueba;
