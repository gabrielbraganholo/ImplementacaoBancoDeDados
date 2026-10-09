CREATE DATABASE CAIXA;

USE CAIXA;

-- Criação da nossa tabela
CREATE TABLE conta(
	id INT PRIMARY KEY,
	Nome VARCHAR(50),
	saldo MONEY
);

INSERT INTO conta
VALUES (10, 'Maria', 500),
	   (20, 'João', 1500),
	   (30, 'Paulo', 30000),
	   (40, 'Maria', 50000);

GO;

-- Primeira transação
BEGIN TRAN;

	DECLARE @erro INT = 0;
	INSERT INTO conta
	VALUES ('50', 'Pedro', 500);
	SET @erro = @erro + @@ERROR;

	INSERT INTO conta
	VALUES ('10', 'Judas', 666);
	SET @erro = @erro + @@ERROR;

	SELECT *
	FROM conta;

	IF @erro <> 0
	BEGIN 
		PRINT 'Transação revertida!'
		ROLLBACK TRAN;
	END;
	ELSE
	BEGIN
		PRINT 'Transação realizada com sucesso!'
		COMMIT TRAN;
	END;

SELECT *
FROM conta;

BEGIN TRAN;
	
	UPDATE conta
	SET saldo = 10000
	WHERE Nome = 'Maria';

	IF @@ROWCOUNT <> 1

	BEGIN
		SELECT *
		FROM conta;
		ROLLBACK TRAN;
	END;

SELECT *
FROM conta;

GO;

-- Transferir dinheiro de uma pessoa para a outra
CREATE PROCEDURE usp_trasnferencia
	@id_origem INT,
	@id_destino INT,
	@valor MONEY
AS
BEGIN
	BEGIN TRAN;

	-- Tirando dinheiro da conta de origem
	UPDATE conta
	SET saldo = saldo - @valor
	WHERE id = @id_origem;

	-- Depositando na conta destino
	UPDATE conta
	SET saldo = saldo + @valor
	WHERE ID = @id_destino

	-- Ver possível estado da tabela conta
	SELECT *
	FROM conta;

	-- Condição para rollback
	IF (SELECT saldo FROM conta WHERE id = @id_origem) < 0
	BEGIN
		PRINT 'Saldo insuficiente!'
		ROLLBACK TRAN;
	END;
	ELSE
	BEGIN
		PRINT 'Transferência realizada!'
		COMMIT;
	END;
END;

SELECT *
FROM conta;

EXEC usp_trasnferencia 40, 10, 500;

EXEC usp_trasnferencia 10, 20, 2000;

GO;

-- Save point
BEGIN TRAN;
	
	INSERT INTO conta
	VALUES (50, 'Pedro', 50);

	SAVE TRAN PedroOk
	INSERT INTO conta
	VALUES (10, 'Juca', -200);

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN PedroOk;
		COMMIT TRAN;
		PRINT 'Voltamos para o save point';
	END;
	ELSE
		COMMIT TRAN;

SELECT *
FROM conta;

GO;

-- TRY CATCH
BEGIN TRY
	PRINT 'Olá, Try Catch!';
	SELECT 1/0 -- erro;
	PRINT 'Não cheguei aqui!';
END TRY
BEGIN CATCH 
	PRINT 'Deu erro!';
	PRINT 'Número: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
	PRINT 'Mensagem de ERRO: ' + ERROR_MESSAGE();
END CATCH