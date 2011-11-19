
select * from rinde
where nro_estudiante = 8945
and nro_examen = 142
and fecha < ( 
 SELECT max(r.fecha) from aprueba a, rinde r
  where r.nro_estudiante = a.nro_estudiante
  and r.nro_examen = a.nro_examen
  and a.fecha > r.fecha + 7 
  and r.nro_estudiante = 8945
  and r.nro_examen = 142
);

