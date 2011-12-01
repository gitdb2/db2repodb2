CREATE OR REPLACE PROCEDURE FORMATO_UTC_A_LOCAL 
(
  P_I_FECHA_HORA IN TIMESTAMP  
, P_I_TIME_ZONE IN VARCHAR2  
, P_O_FECHA_LOCAL OUT VARCHAR2  
, P_O_HORA_LOCAL OUT VARCHAR2  
) AS

temp_timestamp TIMESTAMP;
tmp_string varchar2(100);

BEGIN
--variables auxiliares intermedias
tmp_string := TO_CHAR (P_I_FECHA_HORA) || P_I_TIME_ZONE;
temp_timestamp := SYS_EXTRACT_UTC (tmp_string);

--variables de salida con el resultado de la conversion
P_O_FECHA_LOCAL := to_char(temp_timestamp, 'DD.MON.YYYY');
P_O_HORA_LOCAL  := LOWER(to_char(temp_timestamp, 'HH:MI PM')) ;

END FORMATO_UTC_A_LOCAL;

