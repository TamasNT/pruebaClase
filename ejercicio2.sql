USE BDempleDepart;

DELIMITER $$

DROP PROCEDURE IF EXISTS ejercicio2 $$

CREATE PROCEDURE ejercicio2()
BEGIN

  DECLARE done INT DEFAULT 0;
  DECLARE oficio_var VARCHAR(10);
  DECLARE salario_min INT(7);
  DECLARE salario_max INT(7);

  DECLARE cur CURSOR FOR
    SELECT DISTINCT OFICIO
    FROM EMPLE;
    
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  
  DROP TABLE IF EXISTS resumen_salarios;
  CREATE TABLE resumen_salarios (
    oficio VARCHAR(10),
    salario_minimo INT(7),
    salario_maximo INT(7)
  );
  
  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO oficio_var;
    IF done = 1 THEN
      LEAVE read_loop;
    END IF;
    SELECT MIN(SALARIO), MAX(SALARIO) INTO salario_min, salario_max FROM EMPLE WHERE OFICIO = oficio_var;
    INSERT INTO resumen_salarios (oficio, salario_minimo, salario_maximo) VALUES (oficio_var, salario_min, salario_max);
  END LOOP;

  CLOSE cur;

  SELECT * FROM resumen_salarios;
END $$

DELIMITER ;

CALL ejercicio2();