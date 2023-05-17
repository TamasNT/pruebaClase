DROP DATABASE if EXISTS videoteca_tamas;
-- 1. Crea una base de datos llamada videoteca_tu_nombre
CREATE DATABASE videoteca_tamas;
USE videoteca_tamas;

-- 2. Crea una tabla llamada actores con el siguiente script:
CREATE TABLE actores (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(64) NOT NULL,
  apellidos VARCHAR(64) NOT NULL,
  imdb VARCHAR(32) NOT NULL DEFAULT '',
  PRIMARY KEY(id)
);

-- 3. Inserta un total de 5 registros con un formato similar a los siguientes:
INSERT INTO actores(nombre, apellidos, imdb) VALUES
('Denzel', 'Washington', 'nm0000243'),
('Meryl', 'Streep', 'nm0000658'),
('Robert', 'De Niro', 'nm0000134'),
('Tom', 'Cruise', 'nm0000129'),
('Angelina', 'Jolie', 'nm0001401');


-- 4. Crea un procedimiento almacenado llamado ACTORES_LISTA que no reciba ningún parámetro y devuelva un listado con todos los registros de la tabla actores
DELIMITER $$
CREATE PROCEDURE ACTORES_LISTA()
BEGIN
	SELECT * FROM actores;
END;

-- 5. Llama al procedimiento y comprueba que funciona correctamente
CALL ACTORES_LISTA;

-- 6. Crea una función llamada CONTAR_ACTORES que no reciba ningún parámetro y devuelva el total de actores existentes.
DELIMITER $$
CREATE FUNCTION CONTAR_ACTORES() RETURNS INT
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM actores;
  RETURN total;
END $$
DELIMITER ;

-- 7. Prueba que funciona correctamente CONTAR_ACTORES
SELECT CONTAR_ACTORES();

-- 8. Crea un procedimiento llamado BUSCAR_ACTOR que reciba como parámetro un id de un actor y devuelva el nombre completo del actor (nombre y apellido)
DELIMITER $$
CREATE PROCEDURE BUSCAR_ACTOR(IN actor_imdb VARCHAR(32))
BEGIN
  SELECT CONCAT(nombre, ' ', apellidos) AS nombre_completo FROM actores WHERE imdb = actor_imdb;
END $$
DELIMITER ;

-- 9. Prueba que funciona BUSCAR_ACTOR
CALL BUSCAR_ACTOR('nm0000243');


DROP PROCEDURE BUSCAR_ACTOR;
-- 10. Modifica BUSCAR_ACTOR para que almacene el resultado en una variable llamada actor.
DELIMITER $$
CREATE PROCEDURE BUSCAR_ACTOR(IN actor_imdb VARCHAR(32), OUT actor VARCHAR(128))
BEGIN
  SELECT CONCAT(nombre, ' ', apellidos) INTO actor FROM actores WHERE imdb = actor_imdb;
END $$
DELIMITER ;

-- 11. Ejecuta el procedimiento y visualiza el valor de la variable actor ejecutando SELECT @actor;
CALL BUSCAR_ACTOR('nm0001401', @actor);
SELECT @actor;

-- 12. Crea una función llamada ACTOR_APELLIDO1 que devuelva el id del actor cuyo apellido sea el primero por orden alfabético.
DELIMITER $$
CREATE FUNCTION ACTOR_APELLIDO1()
RETURNS VARCHAR(32)
BEGIN
  DECLARE actor_imdb VARCHAR(32);
  SELECT imdb INTO actor_imdb FROM actores ORDER BY apellidos ASC LIMIT 1;
  RETURN actor_imdb;
END $$
DELIMITER ;

-- 13. Ahora utiliza esta función como parámetro de BUSCAR_ACTOR y visualiza el valor de la variable actor.
CALL BUSCAR_ACTOR(ACTOR_APELLIDO1(), @actor);
SELECT @actor;

-- 14. Crea una función llamada ACTOR_NOMBRE1 que devuelva el id del actor cuyo nombre sea el primero por orden alfabético. En caso de nombres iguales, que ordene por apellido.
DELIMITER $$
CREATE FUNCTION ACTOR_NOMBRE1()
RETURNS VARCHAR(32)
BEGIN
  DECLARE actor_imdb VARCHAR(32);
  SELECT imdb INTO actor_imdb FROM actores ORDER BY nombre ASC, apellidos ASC LIMIT 1;
  RETURN actor_imdb;
END $$
DELIMITER ;

-- 15. Utiliza esta función como parámetro de BUSCAR_ACTOR y visualiza el valor de la variable actor
CALL BUSCAR_ACTOR(ACTOR_NOMBRE1(), @actor);
SELECT @actor;