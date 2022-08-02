use empregados_db;

CREATE TABLE log_empregado (
cod_log INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
cod_empregado INT NOT NULL,
dt_alteracao DATETIME,
valor_antigo DECIMAL(10,2),
valor_novo DECIMAL(10,2),
correcao_legal VARCHAR(100), 
cod_correcao INT
);

ALTER TABLE log_empregado
ADD depto_novo INT;
ALTER TABLE log_empregado
ADD depto_antigo INT;

DELIMITER //
CREATE TRIGGER tg_log_empregado_salario BEFORE UPDATE ON empregado
FOR EACH ROW
	BEGIN
    IF(NEW.salario < OLD.salario) THEN
		INSERT INTO log_empregado(cod_empregado, dt_alteracao, valor_antigo, valor_novo, correcao_legal, cod_correcao, depto_novo, depto_antigo)
        VALUES(OLD.cod_empregado, now(), OLD.salario, NEW.salario, "Ilegal", 0, NULL, NULL);
        END IF;
	 IF(NEW.salario > OLD.salario) THEN
		INSERT INTO log_empregado(cod_empregado, dt_alteracao, valor_antigo, valor_novo, correcao_legal, cod_correcao, depto_novo, depto_antigo)
        VALUES(OLD.cod_empregado, now(), OLD.salario, NEW.salario, "Legal", 0, NULL, NULL);
        END IF;
    END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_log_empregado_depto BEFORE UPDATE ON empregado
FOR EACH ROW
	BEGIN 
		IF(NEW.cod_depto <> OLD.cod_depto) THEN
			INSERT INTO log_empregado(cod_empregado, dt_alteracao, valor_antigo, valor_novo, correcao_legal, cod_correcao, depto_novo, depto_antigo)
			VALUES(OLD.cod_empregado, now(), OLD.salario, NULL, NULL, NULL, NEW.cod_depto, OLD.cod_depto);
			END IF;
	END //
DELIMITER ;


DROP TRIGGER tg_log_empregado;
DELETE FROM log_empregado WHERE cod_log > 0;
/*
1. Dropar o gatilho (DROP TRIGGER tg_log_empregado) e modificar a inserção do campo
correcao_legal.
2. Na regra vamos observar se o slario novo é maior que o salario antigo,
caso sim insert o texto LEGAL caso não o texto ILEGAL.
3. Ao final vamos limpar os registros de log_empregados com DELETE e START TRANSACTION e 
refazer o UPLOAD checar os reguistros e ao fim commitar.
*/

SELECT * , (FLOOR(DATEDIFF(NOW(), dt_admissao)/365)) AS tempo_empresa FROM empregado;
SELECT * FROM log_empregado;

START TRANSACTION;
UPDATE empregado SET salario = (salario * 1.15) WHERE cod_empregado IN (6, 12, 14);
START TRANSACTION;
UPDATE empregado SET cod_depto = 8, salario = (salario * 1.47) WHERE cod_empregado IN (1, 4);
ROLLBACK;
COMMIT;


/*
1. Modificar o gatilho de salario para tg_log_empregado_salario e adicionar a 
existência de depto_novo e depto_antigo.
2. Organizar um novo gatilho para registrar as mudanças de departamento de um emrpegado
registrando NULL nas informações de salario.
3. Testar se as execuções estão certas mudando o demartamento dos registros de 
Marcos Aparecido e Ana Júlia Marcelino para a Gestão. e danto aumento para amnbos de 0,47.
*/