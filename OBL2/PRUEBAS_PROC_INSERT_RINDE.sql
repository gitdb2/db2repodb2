DELETE FROM aprueba WHERE 1=1;
DELETE FROM rinde WHERE 1=1;
DELETE FROM instancia_ex WHERE 1=1;
DELETE FROM inscribe WHERE 1=1;
DELETE FROM salon WHERE 1=1;
DELETE FROM institucion WHERE 1=1;
DELETE FROM estudiante WHERE 1=1;
DELETE FROM examen WHERE 1=1;

INSERT INTO estudiante VALUES (1, 1, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (2, 2, 'paraguay', 'est2', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (3, 3, 'paraguay', 'est3', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (4, 4, 'paraguay', 'est4', 'apellido', 'asuncion');
INSERT INTO estudiante VALUES (5, 5, 'paraguay', 'est5', 'apellido', 'asuncion');
INSERT INTO institucion VALUES ('inst1', 'paraguay', 'asuncion', 'chilavert road 1354', '-04:00');
INSERT INTO salon VALUES ('inst1', 1, 2, 1);
INSERT INTO salon VALUES ('inst1', 2, 2, 1);
INSERT INTO examen VALUES (1, 'test de cooper', 'S');

INSERT INTO inscribe VALUES (1, 1);
INSERT INTO inscribe VALUES (2, 1);
INSERT INTO inscribe VALUES (3, 1);
INSERT INTO inscribe VALUES (4, 1);
INSERT INTO inscribe VALUES (5, 1);

INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/01/01', 'yyyy/mm/dd'), to_date('2011/01/01 16:00', 'yyyy/mm/dd HH24:MI'));
INSERT INTO rinde VALUES (1, 1, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 1);
INSERT INTO rinde VALUES (1, 2, 'inst1', 1, to_date('2011/01/01', 'yyyy/mm/dd'), 2);


---PRUEBAS
INSERT INTO instancia_ex VALUES (1, 'inst1', to_date('2011/02/01', 'yyyy/mm/dd'), to_date('2011/02/01 16:00', 'yyyy/mm/dd HH24:MI'));
--------------


--- DEBE RETORNAR STATUS = 0,salon =1,  SILLA = 1 (OK)
SET SERVEROUTPUT ON;
declare
P_NRO_SILLA NUMBER;
P_NRO_SALON NUMBER;
P_STATUS NUMBER;
BEGIN


INSERT_RINDE(1, 1, NULL, to_date('2011/02/01', 'yyyy/mm/dd'), P_NRO_SALON, P_NRO_SILLA, P_STATUS);
DBMS_OUTPUT.PUT_LINE('P_NRO_SALON = ' || P_NRO_SALON);
DBMS_OUTPUT.PUT_LINE('P_NRO_SILLA = ' || P_NRO_SILLA);
DBMS_OUTPUT.PUT_LINE('P_STATUS = ' || P_STATUS);
END;

--- EJECUTAR DE NUEVO EL MISMO PROC Y MISMO PARAMS DEBE RETORNAR status = 1 (ERROR)

--- --- DEBE RETORNAR STATUS = 0, salon =1,  SILLA = 2  (tanto con instiitucion null como ints1)  (OK)
INSERT_RINDE(1, 2, NULL, to_date('2011/02/01', 'yyyy/mm/dd'), P_NRO_SALON, P_NRO_SILLA, P_STATUS);

--- --- DEBE RETORNAR STATUS = 1, NUNCA RINDIO EL EXAMEN (ERROR)
INSERT_RINDE(1, 3, NULL, to_date('2011/02/01', 'yyyy/mm/dd'), P_NRO_SALON, P_NRO_SILLA, P_STATUS);

--- --- DEBE RETORNAR STATUS = 0, salon =2,  SILLA = 1    (OK)
INSERT_RINDE(1, 3, 'inst1', to_date('2011/02/01', 'yyyy/mm/dd'), P_NRO_SALON, P_NRO_SILLA, P_STATUS);

--- --- DEBE RETORNAR STATUS = 0, salon =2,  SILLA = 2    (OK)
INSERT_RINDE(1, 4, 'inst1', to_date('2011/02/01', 'yyyy/mm/dd'), P_NRO_SALON, P_NRO_SILLA, P_STATUS);

--- --- DEBE RETORNAR STATUS = 1, NO HAY LUGAR (ERROR)
INSERT_RINDE(1, 5, 'inst1', to_date('2011/02/01', 'yyyy/mm/dd'), P_NRO_SALON, P_NRO_SILLA, P_STATUS);

--inserta en el primer lugar libre (porque nunca dio)
delete from rinde where fecha = to_date('2011/02/01', 'yyyy/mm/dd');

-- T = Status
-- A = Salon
-- I = Silla
-- R = Resultado

-- T A I R
-- 0 1 1 OK
INSERT_RINDE(1, 5, 'inst1', to_date('2011/02/01', 'yyyy/mm/dd'), P_NRO_SALON, P_NRO_SILLA, P_STATUS);
-- T A I R
-- 0 2 1 OK
INSERT_RINDE(1, 1, 'inst1', to_date('2011/02/01', 'yyyy/mm/dd'), P_NRO_SALON, P_NRO_SILLA, P_STATUS);

-- T A I R
-- 0 1 2 OK
INSERT_RINDE(1, 2, null, to_date('2011/02/01', 'yyyy/mm/dd'), P_NRO_SALON, P_NRO_SILLA, P_STATUS);

-- T A I R
-- 0 2 2 OK
INSERT_RINDE(1, 3, 'inst1', to_date('2011/02/01', 'yyyy/mm/dd'), P_NRO_SALON, P_NRO_SILLA, P_STATUS);



