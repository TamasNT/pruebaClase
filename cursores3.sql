-- 1
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cursor_1`()
begin 
declare vnombre varchar(200);
declare vnum smallint;
declare fin bool;
declare cur2 CURSOR FOR SELECT nombre,num FROM club ORDER BY num;
declare continue handler for not found set fin=1;
set fin=0;
open cur2;
while(fin=0)DO
FETCH cur2 INTO vnombre,vnum;
if(fin=0) THEN
SELECT vnombre,vnum;
end if;
end while;
close cur2;
END$$
DELIMITER ;

-- 2
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cursor_2`()
BEGIN
    declare vnombre varchar(200);
    declare vfecha datetime;
    declare fin bool;
    declare cur2 CURSOR FOR SELECT nombre,fecha from disco WHERE cod_gru IN(SELECT cod from grupo where cod IN(SELECT cod from pertenece where dni in(select dni from artista where nombre like 'A%' )));
    declare continue HANDLER for not found set fin=1;
    set fin=0;
    open cur2;
    while(fin=0)DO
        FETCH cur2 into vnombre,vfecha;
        if(fin=0) THEN 
        	SELECT vnombre,vfecha;
        end IF;
    end while;
    close cur2;
END$$
DELIMITER ;