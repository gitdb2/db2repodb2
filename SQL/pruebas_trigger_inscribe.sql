
--prueba para t1_inscribe
INSERT INTO estudiante VALUES (1, 2, 'paraguay', 'est1', 'apellido', 'asuncion');
INSERT INTO examen VALUES (1, 'test de cooper', 'S');
INSERT INTO examen VALUES (2, 'tiro al arco', 'N');

--Inscribo un Estudiante en un Examen que está disponible.
INSERT INTO inscribe VALUES (1, 1);

--Inscribo un Estudiante en un Examen que no está disponible.
INSERT INTO inscribe VALUES (1, 2);
