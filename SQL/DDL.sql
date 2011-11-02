
DROP TABLE aprueba CASCADE CONSTRAINTS;
DROP TABLE estudiante CASCADE CONSTRAINTS;
DROP TABLE examen CASCADE CONSTRAINTS;
DROP TABLE inscribe CASCADE CONSTRAINTS;
DROP TABLE instancia_ex CASCADE CONSTRAINTS;
DROP TABLE institucion CASCADE CONSTRAINTS;
DROP TABLE salon CASCADE CONSTRAINTS;
DROP TABLE rinde_data CASCADE CONSTRAINTS;
DROP VIEW rinde CASCADE CONSTRAINTS;


CREATE TABLE estudiante (
  nro_estudiante NUMBER CHECK(nro_estudiante >=0),
  nro_pasaporte NUMBER NOT NULL CHECK(nro_pasaporte >=0),
  pais VARCHAR2(30) NOT NULL,
  nombre VARCHAR2(50) NOT NULL,
  apellido VARCHAR2(50) NOT NULL,
  ciudad_residencia VARCHAR2(50),
  CONSTRAINT estudiante_pk PRIMARY KEY (nro_estudiante),
  CONSTRAINT estudiante_ak UNIQUE (nro_pasaporte, pais)
);


CREATE TABLE examen (
  nro_examen NUMBER CHECK(nro_examen >=0),
  descripcion VARCHAR2(200),
  disponible CHAR(1) CHECK (disponible IN ('S', 'N')) NOT NULL,
  CONSTRAINT examen_pk PRIMARY KEY (nro_examen)
);


CREATE TABLE institucion (
  nombre VARCHAR2(50),
  pais VARCHAR2(30) NOT NULL,
  ciudad VARCHAR2(50) NOT NULL,
  direccion VARCHAR2 (100) NOT NULL,
  CONSTRAINT institucion_pk PRIMARY KEY (nombre)
);


CREATE TABLE salon (
  nombre_institucion VARCHAR2(50),
  nro_salon NUMBER CHECK(nro_salon >=0),
  nro_silla_max NUMBER NOT NULL CHECK (nro_silla_max >= 0),
  nro_silla_min NUMBER NOT NULL CHECK (nro_silla_min >= 0),
  CONSTRAINT salon_pk PRIMARY KEY (nombre_institucion, nro_salon),
  CONSTRAINT salon_fk FOREIGN KEY (nombre_institucion) REFERENCES institucion (nombre),
  CONSTRAINT check_nroSillaMax CHECK (nro_silla_max >= nro_silla_min)
);


CREATE TABLE inscribe (
  nro_estudiante NUMBER CHECK(nro_estudiante >=0),
  nro_examen NUMBER CHECK(nro_examen >=0),
  CONSTRAINT inscribe_pk PRIMARY KEY (nro_estudiante, nro_examen),
  CONSTRAINT inscribe_fk_nro_est FOREIGN KEY (nro_estudiante) REFERENCES estudiante (nro_estudiante),
  CONSTRAINT inscribe_fk_nro_ex FOREIGN KEY (nro_examen) REFERENCES examen (nro_examen)
);


CREATE TABLE aprueba (
  nro_estudiante NUMBER CHECK(nro_estudiante >=0),
  nro_examen NUMBER CHECK(nro_examen >=0),
  fecha DATE NOT NULL,
  calificacion NUMBER (3) NOT NULL CHECK(calificacion BETWEEN 70  and 100),
  CONSTRAINT aprueba_pk PRIMARY KEY (nro_estudiante, nro_examen),
  CONSTRAINT aprueba_fk_nro_est FOREIGN KEY (nro_estudiante) REFERENCES examen (nro_examen),
  CONSTRAINT aprueba_fk_nro_ex FOREIGN KEY (nro_examen) REFERENCES examen (nro_examen)
);


CREATE TABLE instancia_ex (
  nro_examen NUMBER CHECK(nro_examen >=0),
  nombre_institucion VARCHAR2(50),
  fecha DATE,
  CONSTRAINT instancia_ex_pk PRIMARY KEY (nro_examen, nombre_institucion, fecha),
  CONSTRAINT instancia_ex_fk_nro_ex FOREIGN KEY (nro_examen) REFERENCES examen (nro_examen),
  CONSTRAINT instancia_ex_fk_nombre FOREIGN KEY (nombre_institucion) REFERENCES institucion (nombre)
);


CREATE TABLE rinde_data (
  nro_examen NUMBER CHECK(nro_examen >=0),
  nro_estudiante NUMBER check(nro_estudiante >=0),
  nombre_institucion VARCHAR2(50),
  nro_salon NUMBER check(nro_salon >=0),
  fecha DATE,
  nro_silla_asignado NUMBER check(nro_silla_asignado >=0) NOT NULL,
  CONSTRAINT rinde_pk PRIMARY KEY (nro_examen, nro_estudiante, nombre_institucion, nro_salon, fecha),
  CONSTRAINT rinde_fk_inscribe FOREIGN KEY (nro_examen, nro_estudiante) REFERENCES inscribe (nro_examen, nro_estudiante),
  CONSTRAINT rinde_fk_instancia_ex FOREIGN KEY (nro_examen, nombre_institucion, fecha) REFERENCES instancia_ex (nro_examen, nombre_institucion, fecha),
  CONSTRAINT rinde_fk_salon FOREIGN KEY (nombre_institucion, nro_salon) REFERENCES salon (nombre_institucion, nro_salon)
);

CREATE VIEW rinde AS SELECT * FROM rinde_data;

