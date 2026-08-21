-- IN
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Salario in (25000, 30000);

SELECT *
FROM TRABALHA_EM AS T, FUNCIONARIO AS F
WHERE 
    F.Cpf = T.Fcpf
    AND T.Pnr IN (SELECT Pnr 
                  FROM TRABALHA_EM 
                  WHERE FCpf = (SELECT Cpf
                                FROM FUNCIONARIO
                                WHERE Pnome = 'Fernando'))
    AND F.Pnome <> 'Fernando'
ORDER BY T.Pnr ASC, F.Pnome ASC;

-- BETWEEN 
SELECT *
FROM FUNCIONARIO AS F, DEPARTAMENTO AS D
WHERE D.Dnumero = 5
      AND F.Salario BETWEEN 30000 AND 40000;

-- JOIN
SELECT F.Pnome AS Nome, F.Unome AS Sobrenome,  F.Endereco 
FROM FUNCIONARIO AS F
INNER JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
WHERE D.Dnumero = (SELECT D.Dnumero
                FROM DEPARTAMENTO AS D
                WHERE D.Dnome = 'Pesquisa')
ORDER BY F.Pnome ASC;

SELECT F.Pnome
FROM FUNCIONARIO AS F
INNER JOIN TRABALHA_EM AS T
    ON F.Cpf = T.Fcpf
INNER JOIN PROJETO AS P
    ON T.Pnr = P.Projnumero
WHERE P.Projnome = 'ProdutoX'
ORDER BY F.Pnome ASC;


SELECT D.Dnome AS Nome, P.Projnome AS 'Nome do Projeto', P.Projlocal 'Local do Projeto', D.Cpf_gerente 'CPF do gerente', F.Unome Sobrenome, F.Endereco AS Endereço
FROM DEPARTAMENTO AS D
JOIN PROJETO AS P
    ON P.Dnum = D.Dnumero
JOIN FUNCIONARIO AS F
    ON F.Cpf = D.Cpf_gerente
WHERE P.Projlocal = 'Mauá';

-- LEFT JOIN
SELECT *   
FROM FUNCIONARIO AS F
LEFT JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero;

-- LEFT - INNER JOIN
SELECT *
FROM DEPARTAMENTO AS D
LEFT JOIN FUNCIONARIO AS F
    ON D.Dnumero = F.Dnr
WHERE D.Dnome NOT IN (SELECT D.Dnome
                      FROM DEPARTAMENTO AS D
                      INNER JOIN FUNCIONARIO AS F
                        ON D.Dnumero = F.Dnr);

-- CROSS - INNER JOIN
SELECT *
FROM FUNCIONARIO AS F
FULL JOIN DEPARTAMENTO AS D
 ON D.Dnumero = F.Dnr
WHERE 
    D.Dnumero IS NULL
    OR F.Cpf IS NULL;

-- SELF JOIN
SELECT F.Pnome AS Funcionário, S.Unome AS Supervisor
FROM FUNCIONARIO AS F
JOIN FUNCIONARIO AS S
    ON F.Cpf_supervisor = S.Cpf
ORDER BY S.Unome;

-- UNION/INTERSECT/EXCEPT
SELECT 
    F.Pnome AS 'Nome', 
    F.Sexo AS 'Sexo', 
    F.Datanasc AS 'Data'
FROM FUNCIONARIO AS F

UNION

SELECT 
    D.Nome_dependente AS 'Nome',
    D.Sexo AS 'Sexo',
    D.Datanasc AS 'Data'
FROM DEPENDENTE AS D;