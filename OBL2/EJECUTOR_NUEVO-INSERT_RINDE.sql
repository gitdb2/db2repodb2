SET SERVEROUTPUT ON;
DECLARE
  P_NRO_EXAMEN NUMBER;
  P_NRO_ESTUDIANTE NUMBER;
  P_NOMBRE_INSTITUCION VARCHAR2(200);
  P_FECHA DATE;
  P_NRO_SALON NUMBER;
  P_NRO_SILLA NUMBER;
  P_STATUS NUMBER;
BEGIN
  P_NRO_EXAMEN := 1;
  P_NRO_ESTUDIANTE := 1;
  P_NOMBRE_INSTITUCION := 'inst1';
  P_FECHA := TO_DATE('03/03/11', 'DD/MM/RR');

  INSERT_RINDE(
   P_NRO_EXAMEN,
   P_NRO_ESTUDIANTE,
   P_NOMBRE_INSTITUCION,
   P_FECHA,
   P_NRO_SALON,
   P_NRO_SILLA,
   P_STATUS
  );

DBMS_OUTPUT.PUT_LINE('P_NRO_SALON = ' || P_NRO_SALON);
DBMS_OUTPUT.PUT_LINE('P_NRO_SILLA = ' || P_NRO_SILLA);
DBMS_OUTPUT.PUT_LINE('P_STATUS = ' || P_STATUS);

END;

