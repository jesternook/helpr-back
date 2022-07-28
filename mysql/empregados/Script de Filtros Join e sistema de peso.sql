use empregados_db;

SELECT * FROM empregado
INNER JOIN dependente 
ON empregado.cod_empregado = dependente.cod_empregado
WHERE dependente.nome LIKE "%Ana%";

/*Pesquisa com relacionamento Left Join*/
SELECT * FROM empregado e
LEFT JOIN  dependente d 
ON e.cod_empregado = d.cod_empregado
WHERE e.salario > 5000;

/*Pesquisa com Right Join*/
SELECT * FROM empregado e 
RIGHT JOIN dependente d
ON e.cod_empregado = d.cod_empregado;

/*Pesquia com CROSS JOIN*/
SELECT * FROM empregado e
CROSS JOIN dependente d 
ON e.cod_empregado = d.cod_empregado;

SELECT e.nome, IFNULL(dep.nome, "sem dependente") AS dependente,
IF(dep.dt_nascimento < "2005-01-01", "quase maior", "dependente menor") AS estatus
FROM empregado e
LEFT JOIN dependente dep
ON e.cod_empregado = dep.cod_empregado;

SELECT e.nome AS empregado, IFNULL(COUNT(d.cod_dep), 0) AS n_dependentes, 
IF(COUNT(d.cod_dep) <= 0,  "Sem Abatimento", "Com Abatimento") AS IRPF
FROM empregado e 
LEFT JOIN dependente d
ON e.cod_empregado = d.cod_empregado
GROUP BY e.nome;

/*Exercício JOINs*/
/*Monte um filtro que liste todos os empregados da empresa,
neste filtro deverá ter uma coluna onde mostre o numero de dependentes, os
empregados sem dependetes deve aparecer 0 e em um próxima coluna
deve aparecer o IRPF onde os empregdos com dependentes tem mensagem Com Abatimento e os
sem Sem Abatimento.
*/


