/*BULK INSERT - IMPORTAÇÃO DE ARQUIVOS*/

CREATE TABLE lancamento_contabil(
	conta INT,
	valor INT,
	DEB_CRED CHAR(1)
	)
	GO


SELECT * FROM lancamento_contabil
GO

BULK INSERT lancamento_contabil
FROM 'C:\Users\----\Downloads\CONTAS.txt'
with
(
		FIRSTROW = 2,
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		ROWTERMINATOR = '\n'
)

SELECT * FROM lancamento_contabil
GO

/* QUERY COM O NÚMERO DA CONTA E O SALDO DELA" */

SELECT conta, valor,
CHARINDEX('D', DEB_CRED) AS DEBITO,
CHARINDEX('C', DEB_CRED) AS CREDITO,
CHARINDEX('C', DEB_CRED) * 2 - 1 AS MULTIPLICADOR
FROM lancamento_contabil;


SELECT conta, SUM(valor * CHARINDEX('C', DEB_CRED) * 2 - 1) AS SALDO
FROM lancamento_contabil
GROUP BY conta;