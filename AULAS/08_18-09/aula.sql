CREATE OR ALTER PROCEDURE sp_inserir_funcionario
(
	@nome VARCHAR(50),
	@minicial CHAR(1),
	@unome VARCHAR(50),
	@CPF CHAR(11)
)
AS
BEGIN
	IF EXISTS ((SELECT 1
			   FROM FUNCIONARIO
			   WHERE Pnome = @nome))
		BEGIN
			PRINT 'O nome ' + @nome + 'já existe no banco de dados!';
			RETURN;
		END;

	ELSE IF EXISTS ((SELECT 1
			   FROM FUNCIONARIO
			   WHERE Unome = @unome))
		BEGIN
			PRINT 'O sobrenome ' + @unome + 'já existe no banco de dados!';
			RETURN;
		END;

	ELSE IF EXISTS ((SELECT 1
			   FROM FUNCIONARIO
			   WHERE Cpf = @CPF))
		BEGIN
			PRINT 'O CPF ' + @CPF + 'já existe no banco de dados!';
			RETURN;
		END;

	ELSE 
		BEGIN
			INSERT INTO FUNCIONARIO(
				Pnome, Unome, Cpf
			)

			VALUES(
				@nome, @unome, @CPF
			);
		END;
END;


EXEC sp_inserir_funcionario 'Gabriel', 'M', 'Braganholo', 03552632345;

SELECT * 
FROM FUNCIONARIO
WHERE Pnome = 'Gabriel';
