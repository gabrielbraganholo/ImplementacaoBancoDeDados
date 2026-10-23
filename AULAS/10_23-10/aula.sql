-- TRIGGER AFTER INSERT

CREATE OR ALTER TRIGGER trg_after_insert_dpt
ON DEPARTAMENTO
AFTER INSERT
AS
BEGIN
	DECLARE @nome VARCHAR(40);
	
	SELECT @nome = I.Dnome
	FROM inserted AS I;

	PRINT 'Novo departamento inserido: ' + @nome;
END;

GO;

INSERT INTO DEPARTAMENTO (Dnumero, Dnome)
VALUES (88, 'Expedição');

SELECT *
FROM DEPARTAMENTO;

GO;

-- TRIGGER INSTEAD OF DELETE

CREATE TRIGGER trg_insteadof_delete_dpt
ON DEPARTAMENTO
INSTEAD OF DELETE
AS
BEGIN
	PRINT 'NÃO DELETEI O REGISTRO';
END;

GO;

DELETE
FROM DEPARTAMENTO
WHERE Dnumero = 87;

SELECT *
FROM DEPARTAMENTO;

-- ATIVAR E DESATIVAR UM TRIGGER (ENABLE/DISABLE)

ALTER TABLE DEPARTAMENTO
DISABLE TRIGGER trg_insteadof_delete_dpt;

-- PROCURAR TRIGGERS DE UMA ENTIDADE

EXEC sp_helptrigger DEPARTAMENTO;
GO;

-- NÃO PERMITIR INSERIR UM DEPARTAMENTO COM O MESMO NOME
CREATE OR ALTER TRIGGER trg_insteadof_insert_nome_repetido_dpt
ON dbo.DEPARTAMENTO
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @nome VARCHAR(40), @numero INT;

    SELECT @nome = I.Dnome
    FROM inserted AS I

    IF EXISTS (
        SELECT 1
        FROM DEPARTAMENTO
        WHERE Dnome = @nome
    )
    BEGIN
        RAISERROR('O departamento %s já existe!', 16, 1, @nome);
        ROLLBACK TRANSACTION;
    END;
    ELSE
    BEGIN
        INSERT INTO DEPARTAMENTO (Dnumero, Dnome, Cpf_gerente, Data_inicio_gerente)
        SELECT I.Dnumero, I.Dnome, I.Cpf_gerente, I.Data_inicio_gerente
        FROM inserted AS I
    END;
END;

GO;

CREATE OR ALTER TRIGGER trg_after_insert_nome_repetido_dpt
ON dbo.DEPARTAMENTO
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS I
        INNER JOIN dbo.DEPARTAMENTO AS D
            ON D.Dnome = I.Dnome
        GROUP BY I.Dnome
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('Um departamento com esse nome já existe!', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

GO;

INSERT INTO DEPARTAMENTO (Dnumero, Dnome)
VALUES (100, 'Vendas');

SELECT *
FROM DEPARTAMENTO;

GO;

-- TABLE PARA LOG

CREATE TABLE LOG_FUNCIONARIO
(
    log_id INT IDENTITY(100, 1) PRIMARY KEY,
    cpf CHAR(11),
    operacao VARCHAR(10),
    data_hora DATETIME DEFAULT GETDATE()
)

GO;

-- TRIGGERS PARA LOGS
CREATE TRIGGER trg_for_insert_funcionario
ON FUNCIONARIO
FOR INSERT
AS
BEGIN
    INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
    SELECT I.Cpf, 'INSERT'
    FROM inserted AS I
END;

GO;

CREATE TRIGGER trg_for_update_funcionario
ON FUNCIONARIO
FOR UPDATE
AS
BEGIN
    INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
    SELECT I.Cpf, 'UPDATE'
    FROM inserted AS I
END;

GO;

CREATE OR ALTER TRIGGER trg_for_delete_funcionario
ON FUNCIONARIO
FOR DELETE
AS
BEGIN
    INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
    SELECT D.Cpf, 'DELETE'
    FROM deleted AS D;
END;

GO;

INSERT INTO FUNCIONARIO (Pnome, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Bonus, Data_Admissao, Dnr)
VALUES ('Juca', 'da Silva', '456324', '2005-06-08', 'Rua Sete', 'M', 1100, 0, '2026-10-23', 8);

UPDATE FUNCIONARIO
SET Salario = 1500
WHERE Cpf = '45632400001';

DELETE FROM FUNCIONARIO
WHERE Cpf = '45632400001';

SELECT *
FROM FUNCIONARIO
ORDER BY Pnome;

SELECT *
FROM LOG_FUNCIONARIO;

GO;

-- VIEW
CREATE VIEW vw_rh_funcionario_dpt
AS
SELECT
    CONCAT(Pnome, ' ', Minicial, ' ', Unome) AS 'Nome',
    DATEDIFF(YEAR, Datanasc, GETDATE()) AS 'Idade',
    Endereco AS 'Endereço',
    Data_Admissao AS 'Admisão',
    D.Dnome AS 'Departamento'
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero;

GO;

SELECT *
FROM vw_rh_funcionario_dpt
ORDER BY 'Departamento';