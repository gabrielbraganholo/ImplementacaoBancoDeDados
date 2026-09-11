CREATE OR ALTER FUNCTION fn_dobro(@numero DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
	RETURN (@numero * 2)
END
GO;


SELECT dbo.fn_dobro(10);


DECLARE @menor_salario AS DECIMAL(10, 2);
SELECT @menor_salario = MIN(Salario)
FROM FUNCIONARIO;

SELECT
    Pnome,
    Unome,
    F.Salario,
    dbo.fn_dobro(F.Salario) AS Dobro
FROM FUNCIONARIO AS F
WHERE F.Salario > dbo.fn_dobro(@menor_salario);

GO;



CREATE OR ALTER FUNCTION fn_calcularIdade(@data_nascimento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @idade INT;

    IF (MONTH(GETDATE()) < MONTH(@data_nascimento))
        SET @idade = DATEDIFF(YEAR, @data_nascimento, GETDATE())-1;

    ELSE IF (MONTH(GETDATE()) = MONTH(@data_nascimento) AND DAY(GETDATE()) < DAY(@data_nascimento))
        SET @idade = DATEDIFF(YEAR, @data_nascimento, GETDATE())-1;

    ELSE
        SET @idade = DATEDIFF(YEAR, @data_nascimento, GETDATE());

    RETURN @idade;
END;
GO;


SELECT 
    Pnome AS Nome,
    Salario AS Salário,
    CONVERT(VARCHAR, Datanasc, 103) AS "Data de Nascimento",
    dbo.fn_calcularIdade(Datanasc) AS Idade
FROM FUNCIONARIO;
GO;


CREATE OR ALTER FUNCTION fn_retornaFuncionario(@nome_departamento VARCHAR(30))
RETURNS TABLE
AS
    RETURN (
        SELECT
            F.Pnome AS Nome,
            F.Cpf AS CPF, 
            F.Salario AS Salário
        FROM FUNCIONARIO AS F
        JOIN DEPARTAMENTO AS D
            ON D.Dnumero = F.Dnr
        WHERE D.Dnome = @nome_departamento
        )
GO;

SELECT *
FROM dbo.fn_retornaFuncionario('Pesquisa')
GO;


CREATE FUNCTION fn_SalarioAnual()
RETURNS @Tabela TABLE
(
    NomeCompleto VARCHAR(50),
    SalarioAnual DECIMAL(12,2)
)
AS
BEGIN

    INSERT INTO @Tabela
    SELECT
        Pnome + ' ' + Unome,
        Salario * 13 + (Salario * 0.3)
    FROM FUNCIONARIO;

    RETURN;
END;
GO;

SELECT *
FROM dbo.fn_SalarioAnual();
GO;



CREATE FUNCTION fn_SalarioAnualBonus
(
    @Salario DECIMAL(10,2),
    @Bonus DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @SalarioAnual DECIMAL(12,2);

    SET @SalarioAnual = (@Salario * 12) + (@Salario * 12 * @Bonus / 100);

    RETURN @SalarioAnual;
END;
GO;


SELECT dbo.fn_SalarioAnualBonus(5000, 10) AS SalarioAnual;
GO;


CREATE OR ALTER PROCEDURE sp_aumento
(
@porcentagem DECIMAL(3,1),
@cpf CHAR(11)
)
AS
BEGIN
    UPDATE FUNCIONARIO
    SET Salario = Salario * (1 + (@porcentagem / 100))
    WHERE Cpf = @cpf
END;
GO;

EXEC dbo.sp_aumento @porcentagem = 5, @cpf = '98765432300';

SELECT F.Pnome AS Nome, F.Salario AS Salário
FROM FUNCIONARIO AS F
WHERE F.Cpf = '98765432300'

EXEC sp_help sp_aumento
GO;


CREATE PROCEDURE sp_funcionarios
WITH ENCRYPTION
AS
SELECT * FROM FUNCIONARIO;
GO;


CREATE OR ALTER PROCEDURE sp_novoDepartamento
(
    @nome VARCHAR(50),
    @numero INT,
    @local VARCHAR(70)
)
AS
BEGIN
    
    IF EXISTS (SELECT 1
               FROM DEPARTAMENTO
               WHERE Dnome = @nome 
               )
        BEGIN
            PRINT 'Departamento ' + @nome + ' já existe!';
            RETURN;
        END;

    ELSE IF EXISTS (SELECT 1
               FROM DEPARTAMENTO
               WHERE Dnumero = @numero
               )
        BEGIN
            PRINT 'Departamento com id ' + CAST(@numero AS VARCHAR(10)) + ' já existe!';
            RETURN;
        END

    ELSE
        BEGIN
            INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
            VALUES (@nome, @numero)

            INSERT INTO LOCALIZACAO_DEP (Dlocal, Dnumero)
            VALUES (@local, @numero)

            PRINT 'Departamento criado!';
        END;

END;
GO;

EXEC sp_novoDepartamento Contabilidade, 9, Goiania;

SELECT *
FROM DEPARTAMENTO;
GO;


CREATE PROCEDURE sp_listaFuncionarios
(
    @Dnome VARCHAR(30)
)
AS
BEGIN
    
    IF @Dnome IS NULL
        BEGIN
            SELECT F.Pnome + ' ' + F.Unome AS 'Nome Completo', D.Dnome AS Departamento
            FROM FUNCIONARIO AS F
            JOIN DEPARTAMENTO AS D
                ON F.Dnr = D.Dnumero
            ORDER BY D.Dnome ASC, F.Pnome ASC;
        END;

    ELSE 
        BEGIN
            SELECT F.Pnome + ' ' + F.Unome AS 'Nome Completo', D.Dnome AS Departamento
            FROM FUNCIONARIO AS F
            JOIN DEPARTAMENTO AS D
                ON F.Dnr = D.Dnumero
            WHERE D.Dnome = @Dnome
            ORDER BY D.Dnome ASC, F.Pnome ASC;
        END;
END;
GO;