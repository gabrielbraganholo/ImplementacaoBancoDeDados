-- CAST
DECLARE @Pnome VARCHAR(50),
		@Salario DECIMAL(10,2);

SELECT @Pnome = F.Pnome, @Salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Jennifer';

PRINT 'Salário de ' + @Pnome + ': ' + CAST(@Salario AS VARCHAR(10));

GO;

-- CONVERT
SELECT Pnome, Unome, CONVERT(VARCHAR(10), Datanasc, 103) AS Data_Nascimento
FROM FUNCIONARIO
WHERE Pnome = 'Jennifer';

-- IF / ELSE
DECLARE @media_sal DECIMAL(10, 2),
        @salario DECIMAL(10, 2),
        @Pnome VARCHAR(50);

SET @Pnome = 'Jennifer';

SELECT @media_sal = AVG(F.Salario)
FROM FUNCIONARIO AS F;

SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE @Pnome = F.Pnome;

IF (@salario < @media_sal) 
    PRINT 'O funcionário(a) ' + @Pnome + ' ganha abaixo da média salarial.';
ELSE
    PRINT 'O funcionário(a) ' + @Pnome + ' ganha acima da média salarial.';

GO;


DECLARE @nome VARCHAR(50),
        @idade INT;

SET @nome = 'Jennifer';

SELECT @idade = DATEDIFF(YEAR, F.Datanasc, GETDATE())
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

PRINT CAST(@idade AS VARCHAR(10));

IF (@idade < 55)
    PRINT 'O funcionário(a) ' + @nome + ' não está perto de se aposentar.';
ELSE IF (@idade > 55 AND @idade < 60)
    PRINT 'O funcionário(a) ' + @nome + ' está perto de se aposentar.';
ELSE 
    PRINT 'O funcionário(a) ' + @nome + ' já pode se aposentar.';

GO;


DECLARE @data_nasc DATE,
        @nome VARCHAR(50),
        @idade INT;

SET @nome = 'Fernando';

SELECT @data_nasc = Datanasc
FROM FUNCIONARIO
WHERE Pnome = @nome;

IF (MONTH(GETDATE()) < MONTH(@data_nasc))
    SET @idade = DATEDIFF(YEAR, @data_nasc, GETDATE())-1;

ELSE IF (MONTH(GETDATE()) = MONTH(@data_nasc) AND DAY(GETDATE()) < DAY(@data_nasc))
    SET @idade = DATEDIFF(YEAR, @data_nasc, GETDATE())-1;

ELSE
    SET @idade = DATEDIFF(YEAR, @data_nasc, GETDATE());

PRINT @data_nasc;
PRINT @idade;

GO;

-- WHILE
DECLARE @salario DECIMAL(10, 2),
        @nome VARCHAR(50);

SET @nome = 'Joice';

SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

WHILE @salario < 30000.00
    BEGIN
        SET @salario = @salario + @salario * 0.05;
    END;

PRINT @salario;

GO;

-- CURSORES
DECLARE @nome VARCHAR(50);

DECLARE cursorFuncionario CURSOR FOR
SELECT Pnome 
FROM FUNCIONARIO;

OPEN cursorFuncionario;

FETCH NEXT FROM cursorFuncionario INTO @nome;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @nome;
    FETCH NEXT FROM cursorFuncionario INTO @nome
END

CLOSE cursorfuncionario;
DEALLOCATE cursorFuncionario;
GO;