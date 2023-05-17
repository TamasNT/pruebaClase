USE BDempleDepart;

DELIMITER $$

DROP PROCEDURE IF EXISTS ejercicio3 $$

CREATE PROCEDURE ejercicio3(p_sal INT)
BEGIN
  -- Declarar variables
  DECLARE done INT DEFAULT 0;
  DECLARE emp_apellido VARCHAR(20);
  DECLARE emp_oficio VARCHAR(10);
  DECLARE emp_salario INT(7);
  DECLARE emp_texto VARCHAR(50);

  -- Crear cursor
  DECLARE cur CURSOR FOR
    SELECT APELLIDO, OFICIO, SALARIO
    FROM EMPLE
    ORDER BY APELLIDO;
    
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  
  -- Paso 1: Borrar y crear la tabla comparativa_salarios
  DROP TABLE IF EXISTS comparativa_salarios;
  CREATE TABLE comparativa_salarios (
    apellido VARCHAR(20),
    oficio VARCHAR(10),
    salario INT(7),
    texto VARCHAR(50)
  );
  
  -- Abrir cursor
  OPEN cur;

  -- Usar cursor para agregar empleados y comparar salarios
  read_loop: LOOP
    FETCH cur INTO emp_apellido, emp_oficio, emp_salario;
    IF done = 1 THEN
      LEAVE read_loop;
    END IF;
    IF emp_salario < p_sal THEN
      SET emp_texto = 'El salario es menor que ' + p_sal;
    ELSEIF emp_salario = p_sal THEN
      SET emp_texto = 'El salario es igual a ' + p_sal;
    ELSE
      SET emp_texto = 'El salario es mayor que ' + p_sal;
    END IF;
    INSERT INTO comparativa_salarios (apellido, oficio, salario, texto) VALUES (emp_apellido, emp_oficio, emp_salario, emp_texto);
  END LOOP;

  -- Cerrar cursor
  CLOSE cur;

  -- Paso 4: Mostrar las tuplas añadidas a la tabla comparativa_salarios
  SELECT * FROM comparativa_salarios;
END $$

DELIMITER ;

-- Llamada 1
CALL ejercicio3(1500);

-- Llamada 2
CALL ejercicio3(2000);

-- Llamada 3
CALL ejercicio3(2500);