/*TRIGGERS - SQL SERVER*/

USE tabela;

/*PRODUTOS - PRODOTTI - PRODUCTS*/
CREATE TABLE produtos(
	idproduto INT IDENTITY PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	categoria VARCHAR(30) NOT NULL,
	preco NUMERIC(10,2) NOT NULL
	)
GO

/*HISTÓRICO - CRONOLOGIA - HISTORIC*/
CREATE TABLE historico(
	idoperacao INT IDENTITY PRIMARY KEY,
	produto VARCHAR(50) NOT NULL,
	categoria VARCHAR(30) NOT NULL,
	precoantigo NUMERIC(10,2) NOT NULL,
	preconovo NUMERIC(10,2) NOT NULL,
	datas DATETIME,
	usuario VARCHAR(30),
	mensagem VARCHAR(100)
	)
GO

/*INSERINDO VALORES - PRODUTOS - INSERIMENTO DEI VALORI - INSERTING VALUES*/
INSERT INTO produtos VALUES('LIVRO SQL SERVER', 'LIVROS', 98.00);
INSERT INTO produtos VALUES('LIVRO ORACLE', 'LIVROS', 50.00);
INSERT INTO produtos VALUES('LICENÇA POWERCENTER', 'SOFTWARES', 45000.00);
INSERT INTO produtos VALUES('NOTEBOOK I7', 'COMPUTADORES', 3150.00);
INSERT INTO produtos VALUES('LIVRO BUSINESS INTELLIGENCE', 'LIVROS', 90.00);

/*SELECT*/
SELECT * FROM produtos;
SELECT * FROM historico;


-- VERIFICANDO O USUÁRIO - VERIFICANDO L'UTENTE - VERIFYING THE USER

SELECT SUSER_NAME();

-- TRIGGERS  - DATA MANIPULATION LANGUAGE

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE
AS
			DECLARE @idproduto INT
			DECLARE @produto VARCHAR(30)
			DECLARE @categoria VARCHAR(10)
			DECLARE @preco NUMERIC(10,2)
			DECLARE @preconovo NUMERIC(10,2)
			DECLARE @datas DATETIME
			DECLARE @usuario VARCHAR(30)
			DECLARE @acao VARCHAR(100)

			SELECT @idproduto = idproduto FROM inserted
			SELECT @produto = nome FROM inserted
			SELECT @categoria = categoria FROM inserted
			SELECT @preco = preco FROM deleted --QUER O PREÇO ANTIGO - VUOLE IL VECCHIO PREZZO - WANT THE OLD VALUE
			SELECT @preconovo = preco FROM inserted

			SET @datas = GETDATE()
			SET @usuario = SUSER_NAME()
			SET @acao = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA PRECO'

			INSERT INTO historico
			(produto, categoria, precoantigo, preconovo, datas, usuario, mensagem)
			VALUES
			(@produto, @categoria, @preco, @preconovo, @datas, @usuario, @acao)

			PRINT 'TRIGGER EXECUTADA'

GO


/*EXECUTANDO UM UPDATE - ESEGUENDO UN AGGIORNAMENTO - EXECUTING UPDATE*/

UPDATE produtos set preco = 100.00
WHERE idproduto = 1
GO

SELECT * FROM produtos;
SELECT * FROM historico;
GO


UPDATE produtos 
SET nome = 'LIVRO C#'
WHERE idproduto = 1;

/*Atualização de nome não requerido no histórico  - Aggiornamento del nome non richiesto nella cronologia - Name update not required in the history*/
SELECT * FROM produtos;
SELECT * FROM historico;

/* PROGRAMANDO TRIGGER EM UMA COLUNA - PROGRAMMAZIONE DI UN TRIGGER SU UNA COLONNA - PROGRAMMING A TRIGGER ON A COLUMN*/

DROP TRIGGER TRG_ATUALIZA_PRECO;

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE AS
IF UPDATE(preco)
BEGIN
			DECLARE @idproduto INT
			DECLARE @produto VARCHAR(30)
			DECLARE @categoria VARCHAR(10)
			DECLARE @preco NUMERIC(10,2)
			DECLARE @preconovo NUMERIC(10,2)
			DECLARE @datas DATETIME
			DECLARE @usuario VARCHAR(30)
			DECLARE @acao VARCHAR(100)

			SELECT @idproduto = idproduto FROM inserted
			SELECT @produto = nome FROM inserted
			SELECT @categoria = categoria FROM inserted
			SELECT @preco = preco FROM deleted --QUER O PREÇO ANTIGO
			SELECT @preconovo = preco FROM inserted

			SET @datas = GETDATE()
			SET @usuario = SUSER_NAME()
			SET @acao = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA PRECO'

			INSERT INTO historico
			(produto, categoria, precoantigo, preconovo, datas, usuario, mensagem)
			VALUES
			(@produto, @categoria, @preco, @preconovo, @datas, @usuario, @acao)

			PRINT 'TRIGGER EXECUTADA'
END
GO

UPDATE produtos 
SET preco = 300.00
WHERE idproduto = 2
GO

SELECT * FROM produtos;
SELECT * FROM historico;

UPDATE produtos 
SET nome = 'LIVRO JAVA'
WHERE idproduto = 2;

SELECT * FROM produtos;
SELECT * FROM historico;

/*VARIÁVEIS COM SELECT*/

CREATE TABLE resultado(
	idresultado INT PRIMARY KEY IDENTITY, 
	resultado INT
	)
GO


/*ATRIBUINDO SELECTS A VARIÁVEIS*/
DECLARE
	@resultado INT
	SET @resultado = (SELECT 50 + 50)
	INSERT INTO resultado VALUES(@resultado)
	PRINT 'VALOR INSERIDO NA TABELA: ' + CAST(@resultado AS VARCHAR)
	GO

/*TRIGGER UPDATE*/
CREATE TABLE empregado(
	idemp INT PRIMARY KEY,
	nome VARCHAR(30),
	salario MONEY,
	idgerente INT
)
GO

ALTER TABLE empregado ADD CONSTRAINT fk_gerente
FOREIGN KEY(idgerente) REFERENCES empregado(idemp);
GO

INSERT INTO empregado VALUES(1, 'CLARA', 5000.00, NULL);
INSERT INTO empregado VALUES(2, 'CELIA', 4000.00, 1);
INSERT INTO empregado VALUES(3, 'JOÃO', 4000.00, 1);
GO

CREATE TABLE hist_salario(
	idempregado INT,
	antigosal MONEY,
	novosal MONEY,
	data DATETIME
	)
GO

CREATE TRIGGER tg_salario
ON dbo.empregado
FOR UPDATE AS
IF UPDATE(SALARIO)
BEGIN
		INSERT INTO hist_salario(idempregado, antigosal, novosal, data)
		SELECT d.idemp, d.salario, i.salario, GETDATE()
		FROM deleted d, inserted i
		WHERE d.idemp = i.idemp --EX: PARA NÃO APLICAR UMA ATUALIZAÇÃO DE SALÁRIO A TODOS OS FUNCIONÁRIOS
END
GO

SELECT * FROM empregado;

UPDATE empregado SET salario = salario *1.1
GO

SELECT * FROM empregado;
SELECT * FROM hist_salario;

CREATE TABLE salario_range(
	minsal MONEY,
	maxsal MONEY,
)
GO

INSERT INTO salario_range VALUES(3000.00, 6000.00)
GO

SELECT * FROM salario_range;

CREATE TRIGGER tr_range
ON dbo.empregado
FOR INSERT, UPDATE --PARA MAIS DE UMA CONDIÇÃO
AS
	DECLARE
		@minsal MONEY,
		@maxsal MONEY,
		@atualsal MONEY

		SELECT  @minsal = minsal, @maxsal = maxsal FROM salario_range

		SELECT @atualsal = i.salario
		FROM inserted i

		IF(@atualsal < @minsal)
		BEGIN
			RAISERROR('SALARIO MENOR QUE O PISO', 16,1)
			ROLLBACK TRANSACTION

		END

		IF (@atualsal > @maxsal)
		BEGIN
			RAISERROR('SALARIO MAIOR QUE O TETO',16,1)
			ROLLBACK TRANSACTION

		END
GO

UPDATE empregado SET salario  = 9000.00
WHERE idemp = 1
GO

