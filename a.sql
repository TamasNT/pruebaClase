-- Utiliza la base de datos del script rutinas2.sql

USE rutinas2.sql;

-- Crea un procedimiento llamado CuentaOficios al que se le pase como parámetro el tipo de oficio (Vendedor, Empleado, Analista o Director) y muestre por pantalla el número de trabajadores con dicho oficio. 
-- Ejemplo de llamada: call CuentaOficios(“Analista”);
-- Ejemplo de salida: “El número de analistas es 2“
DELIMITER $$

CREATE PROCEDURE CuentaOficios (p_oficio VARCHAR(10))
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM EMPLE
    WHERE OFICIO = p_oficio;
    SELECT CONCAT('El número de ', p_oficio, ' es ', v_count) AS Resultado;
END$$

DELIMITER;

CALL CuentaOficios('Analista');


-- Crea una tabla llamada artículos e introduce los registros almacenados en el archivo rutinas2add.TXT.
DROP TABLE IF EXISTS articulos;
CREATE TABLE articulos (
    CODIGO  INT(3)    NOT NULL, 
  DENOM   VARCHAR(18)  NOT NULL, 
  EXIS    INT (5), 
  PVP     decimal(6,2), 
  PRIMARY KEY ( CODIGO ) );

INSERT INTO ARTICULOS VALUES(100,'NARANJAS',100,0.90);
INSERT INTO ARTICULOS VALUES(101,'PATATAS',200,0.50);
INSERT INTO ARTICULOS VALUES(102,'CEBOLLAS',50,0.92);
INSERT INTO ARTICULOS VALUES(103,'SANDIAS',200,2.20);
INSERT INTO ARTICULOS VALUES(104,'PERAS',50,1.70);
INSERT INTO ARTICULOS VALUES(105,'NUECES',300,3.90);
INSERT INTO ARTICULOS VALUES(106,'MANZANAS',55,1.50);
INSERT INTO ARTICULOS VALUES(107,'JUDÍAS VERDES',600,1.45);
INSERT INTO ARTICULOS VALUES(108,'GARBANZOS',300,3.70);
INSERT INTO ARTICULOS VALUES(109,'LENTEJAS',250,2.97);
INSERT INTO ARTICULOS VALUES(110,'JUDÍAS BLANCAS',178,1.92);


-- Crea un procedimiento llamado ActualizaPrecio que reciba como parámetro el código de un artículo y actualice su precio del siguiente modo:
-- Si su PVP actual es menor a 1€, su precio debe aumentar 5 céntimos
-- Si su PVP está entre 1 y 2€, su precio debe aumentar 10 céntimos
-- Si su PVP es mayor a 2€, su precio debe aumentar 12 céntimos
DELIMITER $$
CREATE PROCEDURE ActualizaPrecio (IN codigo INT)
BEGIN
    DECLARE pvp_actual DECIMAL(8,2);
    DECLARE nuevo_precio DECIMAL(8,2);
    
    SELECT pvp INTO pvp_actual FROM articulos WHERE codigo = codigo;
    
    IF (pvp_actual < 1.00) THEN
        SET nuevo_precio = pvp_actual + 0.05;
    ELSEIF (pvp_actual >= 1.00 AND pvp_actual <= 2.00) THEN
        SET nuevo_precio = pvp_actual + 0.10;
    ELSE
        SET nuevo_precio = pvp_actual + 0.12;
    END IF;
    
    UPDATE articulos SET precio = nuevo_precio WHERE codigo = codigo;
END $$
DELIMITER ;


-- Visualiza los PVP antes y después de actualizarse con ActualizaPrecio.

-- Crea un procedimiento llamado NuevoEmpleado para que inserte una fila en la tabla EMPLE con los siguientes datos:
-- (1111,'AMADOR','EMPLEADO',7902,'2010/03/02',X,NULL,Z);
-- Donde X es el salario medio de todos los salarios
-- Donde Z es el número de departamento que tiene mayor comisión.

-- Visualiza el contenido de la tabla EMPLE antes y después de la inserción con NuevoEmpleado.

-- Crea un procedimiento llamado BorraEmpleado que reciba su id como parámetro y lo elimine de la tabla EMPLE.

-- Visualiza el contenido de la tabla EMPLE antes y después del borrado con BorraEmpleado para el id 1111.
