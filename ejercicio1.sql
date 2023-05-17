USE BDempleDepart;

DELIMITER $$

DROP PROCEDURE IF EXISTS ejercicio1 $$

CREATE PROCEDURE ejercicio1 (num INT, ofi VARCHAR(10))
BEGIN

  DECLARE done INT DEFAULT 0;
  DECLARE emp_apellido VARCHAR(20);
  DECLARE emp_salario INT(7);
  
  DECLARE cur CURSOR FOR
    SELECT APELLIDO, SALARIO
    FROM EMPLE
    WHERE OFICIO = ofi
    ORDER BY SALARIO DESC
    LIMIT num;
    
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  
  DROP TABLE IF EXISTS mayores_salarios;
  CREATE TABLE mayores_salarios (
    apellido VARCHAR(20),
    salario INT(7)
  );
  
  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO emp_apellido, emp_salario;
    IF done = 1 THEN
      LEAVE read_loop;
    END IF;
    INSERT INTO mayores_salarios (apellido, salario) VALUES (emp_apellido, emp_salario);
  END LOOP;

  CLOSE cur;

  SELECT * FROM mayores_salarios;
END $$

DELIMITER ;

-- Llamada 1
CALL ejercicio1(3, 'VENDEDOR');

-- Llamada 2
CALL ejercicio1(2, 'ANALISTA');

-- Llamada 3
CALL ejercicio1(1, 'DIRECTOR');
