SET SERVEROUTPUT ON;
DECLARE
  NEW_NRO_SALON NUMBER;
  NEW_NOMBRE_INSTITUCION VARCHAR2(200);
  NEW_FECHA DATE;
  NEW_NRO_SILLA_ASIGNADO NUMBER;
BEGIN
  NEW_NOMBRE_INSTITUCION := 'inst1';
  NEW_FECHA := to_date('2011/01/01', 'yyyy/MM/dd');
  NEW_NRO_SALON := 2;
  NEW_NRO_SILLA_ASIGNADO := 1;

  BUSCAR_SALON_SILLA(
    NEW_NOMBRE_INSTITUCION,
    NEW_FECHA ,
    NEW_NRO_SALON ,
    NEW_NRO_SILLA_ASIGNADO
  
  );
  dbms_output.put_line('---------------------------------------');
  dbms_output.put_line('RETURNED_NRO_SALON = '||NEW_NRO_SALON);
  dbms_output.put_line('RETURNED_NRO_SILLA = '||NEW_NRO_SILLA_ASIGNADO);
  
END;



--------------------------------------------------------------------------
SET SERVEROUTPUT ON;
DECLARE
  NEW_NRO_SALON NUMBER;
  NEW_NOMBRE_INSTITUCION VARCHAR2(200);
  NEW_FECHA DATE;
  NEW_NRO_SILLA_ASIGNADO NUMBER;
BEGIN
  NEW_NOMBRE_INSTITUCION := 'inst1';
  NEW_FECHA :=  TO_DATE('03/03/11', 'DD/MM/RR');
  NEW_NRO_SALON := 2;
  NEW_NRO_SILLA_ASIGNADO := 4;

  BUSCAR_SALON_SILLA(
    NEW_NOMBRE_INSTITUCION,
    NEW_FECHA ,
    NEW_NRO_SALON ,
    NEW_NRO_SILLA_ASIGNADO
  
  );
  dbms_output.put_line('---------------------------------------');
  dbms_output.put_line('RETURNED_NRO_SALON = '||NEW_NRO_SALON);
  dbms_output.put_line('RETURNED_NRO_SILLA = '||NEW_NRO_SILLA_ASIGNADO);
  
END;
