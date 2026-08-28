-- DECLARE
DECLARE @nome VARCHAR(100),
		@idade INT,
		@salario DECIMAL(10,2),
		@data DATE;
SET @nome = 'Gabriel Morais Braganholo';
SET @idade = 20;
SET @salario = 5000.00;
SET @data = GETDATE();

PRINT 'Nome: ' + @nome + 'Idade: ' + CAST(@idade AS VARCHAR(10))

SELECT
	@nome AS 'NOME',
	@idade AS 'IDADE',
	@salario AS 'SALÁRIO',
	@data 'DATA DE HOJE';

GO -- FECHA O BLOCO

-- SETAR VARIAVEL COM SELECT
DECLARE @nome_dpt VARCHAR(50);
		
SELECT @nome_dpt = D.Dnome
FROM DEPARTAMENTO AS D
WHERE D.Dnumero = 4

PRINT 'Departamento: ' + @nome_dpt
GO

-- calcular salario
DECLARE @salario DECIMAL(10,2),
		@novo_salario DECIMAL(10,2),
		@nome VARCHAR(100);

SET @nome = 'Jennifer';

SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome

SET @novo_salario = @salario * 1.1;

PRINT 'Salário: ' + CAST(@salario AS VARCHAR(10));
PRINT 'Novo Salário: ' + CAST(@novo_salario AS VARCHAR(10));
GO

-- calculando idade de acordo com a date de nascimento
DECLARE @data_nasc DATE,
        @idade INT;

SELECT @data_nasc = F.Datanasc
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Jennifer';

SET @idade = YEAR(GETDATE()) - YEAR(@data_nasc);

PRINT 'A Jennifer tem ' + CAST(@idade AS VARCHAR(5)) + ' anos'