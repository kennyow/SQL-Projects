/*PROCEDURES*/


-- SP_STORAGE PROCEDURE
USE tabela;

CREATE TABLE pessoa(
	idpessoa INT PRIMARY KEY IDENTITY,
	nome VARCHAR(30) NOT NULL,
	sexo CHAR(1) NOT NULL CHECK (SEXO in('M', 'F')),
	nascimento DATE NOT NULL
);
GO

CREATE TABLE telefone(
	idtelefone INT NOT NULL IDENTITY,
	tipo CHAR(3) NOT NULL CHECK (tipo IN ('CEL', 'COM')),
	numero CHAR(10) NOT NULL,
	id_pessoa INT
);
GO

ALTER TABLE telefone ADD CONSTRAINT fk_telefone_pessoa
FOREIGN KEY(id_pessoa) REFERENCES pessoa(idpessoa)
ON DELETE CASCADE
GO

select * from telefone;


INSERT INTO pessoa VALUES ('ANTONIO', 'M', '1981-02-13');
INSERT INTO pessoa VALUES ('DANIEL', 'M', '1985-03-18');
INSERT INTO pessoa VALUES ('CLEIDE', 'F', '1979-10-13');

INSERT INTO telefone VALUES('CEL', '9879008',1)
INSERT INTO telefone VALUES('COM', '8757909',1)
INSERT INTO telefone VALUES('CEL', '9858900',2)
INSERT INTO telefone VALUES('CEL', '98790234',2)
INSERT INTO telefone VALUES('COM', '9879432',3)
INSERT INTO telefone VALUES('COM', '9879123',2)
INSERT INTO telefone VALUES('CEL', '9879321',3)


/*CRIANDO A PROCEDURE*/

CREATE PROC soma
AS
	SELECT 10+10 AS soma
GO

/*EXECUÇÃO DA PROCEDURE*/

SOMA
-- OU
EXEC SOMA
GO


/*DINÂMICAS - COM PARÂMETROS*/

CREATE PROC conta @num1 INT, @num2 INT
AS
	SELECT @num1 + @num2 AS RESULTADO
GO

/*EXECUTANDO*/

EXEC conta 90, 78
GO

/*APAGANDO A PROCEDURE*/

DROP PROC conta
GO

/* PROCEDURE EM TABELA */

SELECT * FROM pessoa
SELECT * FROM telefone
GO

SELECT nome, numero
FROM pessoa
INNER JOIN telefone
ON idpessoa  = id_pessoa
WHERE tipo = 'CEL'
GO

/*TRAZER OS TELEFONES DE ACORDO COM O TIPO PASSADO*/

CREATE PROC telefones @tipo CHAR(3)
AS
	SELECT nome, numero
	FROM pessoa
	INNER JOIN telefone
	ON idpessoa  = id_pessoa
	WHERE tipo = @tipo
GO

EXEC telefones 'CEL'
GO

EXEC telefones 'COM'
GO

/*PARÂMETRO DE OUTPUT*/

SELECT tipo, COUNT(*) AS	 Quantidade
FROM telefone
GROUP BY tipo
GO

CREATE PROC gettipo @tipo CHAR(3), @contador INT OUTPUT
AS
	SELECT @contador = COUNT(*)
	FROM telefone
	WHERE tipo = @tipo
GO

/*EXECUÇÃO DA PROC COM PARÂMETRO DE SAÍDA*/

gettipo 'CEL'
GO

/*T-SQL - TRANSACTION SQL*/
DECLARE @saida INT
EXEC gettipo @tipo = 'CEL', @contador = @saida OUTPUT
SELECT @saida
GO

/*PROCEDURE DE CADASTRO*/

CREATE PROC cadastro @nome VARCHAR(30), @sexo CHAR(1), @nascimento DATE,  @tipo CHAR(3), @numero VARCHAR(10)
AS
	DECLARE @fk INT 

	INSERT INTO pessoa VALUES (@nome, @sexo, @nascimento)

	SET @fk = (SELECT idpessoa FROM pessoa WHERE idpessoa = @@IDENTITY)

	INSERT INTO telefone VALUES (@tipo, @numero, @fk)

GO

cadastro 'JORGE', 'm', '1987-01-21', 'CEL', '97273822'
GO

SELECT pessoa.*, telefone.*
FROM pessoa
INNER JOIN TELEFONE
ON idpessoa = id_pessoa
GO