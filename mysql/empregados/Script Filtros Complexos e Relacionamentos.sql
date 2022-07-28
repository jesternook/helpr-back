use empregados_db; 

/*FILTRO COM RELACIONAMENTO DE CHAVES*/
SELECT * FROM empregado e, departamento d WHERE d.cod_depto = e.cod_depto;
SELECT * FROM dependente d, empregado e WHERE e.cod_empregado = d.cod_empregado;

/*FILTROS COM RELACIONAMENTOS COMPLEXOS (SUBQUERY)*/
SELECT d.nome AS Dependente, e.nome AS Empregado, e.salario AS Renda FROM dependente d, empregado e WHERE d.cod_empregado IN (
	SELECT cod_empregado FROM empregado WHERE salario BETWEEN 2500 AND 5000
) AND d.cod_empregado = e.cod_empregado; 

/*Ordenação de atributo*/

SELECT * FROM empregado WHERE salario > 30
ORDER BY nome;
SELECT * FROM empregado WHERE 
salario > 3000
AND 
FLOOR(DATEDIFF(NOW(), dt_admissao)/365) > 10 
ORDER BY 
FLOOR(DATEDIFF(NOW(), dt_nascimento)/365);

/*Agrupamento por relacionamento*/

SELECT depto.nome, COUNT(emp.cod_empregado) AS n_empregados
FROM departamento depto, empregado emp 
WHERE 
depto.cod_depto = emp.cod_depto 
GROUP BY depto.nome;

/*Agrupamento por relacionamento ordenado*/
SELECT depto.nome, COUNT(emp.cod_empregado) AS n_empregados
FROM departamento depto, empregado emp 
WHERE 
depto.cod_depto = emp.cod_depto 
GROUP BY depto.nome
ORDER BY n_empregados DESC;

SELECT e.nome AS empregado, e.salario, FLOOR((DATEDIFF(now(), e.dt_nascimento)/365)) AS idade, COUNT(d.cod_dep) AS N_DEPENDENTES,
FORMAT(e.salario / (COUNT(d.cod_dep)+1), 2) AS media_renda
FROM dependente d, empregado e
WHERE e.cod_empregado = d.cod_empregado
GROUP BY e.nome
ORDER BY N_DEPENDENTES DESC;

/*Uma pesquisa que execute uma contagem agrupada por dependentes contando o numero de dependentes 
por empregado e traga o nome do empregado, o numero de dependentes e seu salário e idade.*/
