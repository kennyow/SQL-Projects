/*Our client requested a table to store the books sold by the company. The request is only for books, 
and there is no need to search in other tables. Currently, a sales employee maintains an Excel 
sheet to store these records, but searches are becoming complex. It was decided to create a separate database for this employee.

After creating the table, we need to provide some ready-made queries to be sent to the programmer. The queries are as follows:*/

/*
1 - Retrieve all data.
2- Retrieve the book name and the publisher's name.
3- Retrieve the book name and the state (UF) of books published by male authors.
4- Retrieve the book name and the number of pages for books published by female authors.
5- Retrieve the values of the books from publishers in California.
6- Retrieve the data of male authors who had books published in São Paulo or Rio de Janeiro.*/

CREATE DATABASE livraria;

USE livraria;

CREATE TABLE livros(
	nome_livro VARCHAR(60) NOT NULL,
    nome_autor VARCHAR(30) NOT NULL,
    sexo CHAR(1) NOT NULL,
    paginas INT NOT NULL,
    nome_editora VARCHAR(20) NOT NULL,
    valor DECIMAL(8,2) NOT NULL,
    estado CHAR(2) NOT NULL,
    ano CHAR(4) NOT NULL);

ALTER TABLE livros
MODIFY COLUMN paginas INT NOT NULL;

INSERT INTO livros VALUES
    ('Aventuras Incríveis', 'Woody', 'M', 250, 'Pixar Books', 29.99, 'CA', '2022'),
    ('Em Busca do Amor', 'Dory', 'F', 180, 'Ocean Press', 19.99, 'FL', '2021'),
    ('Monstros no Armário', 'Sully', 'M', 320, 'Scare Publications', 34.99, 'NY', '2023'),
    ('Viagem ao Espaço', 'Buzz Lightyear', 'M', 200, 'Galactic Press', 25.99, 'TX', '2020'),
    ('Amizade Verdadeira', 'Mike Wazowski', 'M', 150, 'Laugh Factory', 15.99, 'CA', '2022'),
    ('O Poder da Amizade', 'Merida', 'F', 280, 'Brave Books', 27.50, 'CA', '2021'),
    ('Emoções em Ebulição', 'Joy', 'F', 210, 'Feelings Publishing', 22.99, 'CA', '2020'),
    ('A Jornada do Herói', 'Mr. Incredible', 'M', 300, 'Superhero Press', 31.75, 'NY', '2023'),
    ('O Mundo das Formigas', 'Flik', 'M', 180, 'Tiny Publications', 19.99, 'CA', '2022'),
    ('Além da Zona de Conforto', 'Remy', 'M', 240, 'Gourmet Editions', 28.50, 'CA', '2021'),
    ('Aventuras Subaquáticas', 'Nemo', 'M', 160, 'Ocean Explorer', 17.99, 'FL', '2020');
    


    
-- 1 - Retrieve all data.
SELECT * FROM livros;

-- 2- Retrieve the book name and the publisher's name.
SELECT nome_livro, nome_editora FROM livros;

-- 3- Retrieve the book name and the state (UF) of books published by male authors.
SELECT nome_livro, estado 
FROM livros
WHERE sexo = 'M';

-- 4- Retrieve the book name and the number of pages for books published by female authors.
SELECT nome_livro, paginas
FROM livros
WHERE sexo = 'F';

-- 5- Retrieve the values of the books from publishers in California.
SELECT nome_livro, valor
FROM livros
WHERE estado = 'CA';


-- 6- Retrieve the data of male authors who had books published in California or New York.*/
SELECT *
FROM livros
WHERE (sexo = 'M')
AND (estado = 'CA') OR (estado = 'NY');
