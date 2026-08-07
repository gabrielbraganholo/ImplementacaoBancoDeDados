-- Criando meu banco
CREATE DATABASE biblioteca;

-- Colocando o banco criado em uso
USE biblioteca;

-- Criando tabelas
CREATE TABLE autor
(
    id INT PRIMARY KEY auto_increment,
    nome VARCHAR(50) NOT NULL,
    nacionalidade VARCHAR(50) NOT NULL
);

CREATE TABLE livro
(
    id INT PRIMARY KEY auto_increment,
    titulo TEXT NOT NULL,
    ano_publicacao INT,
    fk_id_autor INT,
    FOREIGN KEY (fk_id_autor) REFERENCES autor(id)
);

CREATE TABLE Editora
(
	id INT PRIMARY KEY auto_increment,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(50),
    site VARCHAR(50),
    fundacao INT
);

-- Adicionando fk via alteração da tabela
ALTER TABLE livro
ADD COLUMN fk_id_editora INT,
ADD CONSTRAINT fk_livro_editora
FOREIGN KEY (fk_id_editora) REFERENCES Editora(id)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE livro
ADD CONSTRAINT fk_autor -- nome da restrição
FOREIGN KEY (fk_id_autor) REFERENCES autor (id);


-- Apagando uma tabela
DROP TABLE IF EXISTS livro;
DROP TABLE IF EXISTS autor;
DROP TABLE IF EXISTS editora;

-- Removendo uma coluna 
ALTER TABLE livro
DROP COLUMN titulo;

-- Populando o banco com inserts
INSERT INTO autor (nome, nacionalidade)
VALUES
('Machado de Assis', 'Brasileira'),
('J.K. Rowling', 'Britânica'),
('Gabriel García Márquez', 'Colombiana'),
('George Orwell', 'Britânica');

INSERT INTO Editora (nome, cidade, site, fundacao)
VALUES
('Companhia das Letras', 'São Paulo', 'www.companhiadasletras.com.br', 1986),
('Rocco', 'Rio de Janeiro', 'www.rocco.com.br', 1975),
('Record', 'Rio de Janeiro', 'www.record.com.br', 1942);

INSERT INTO livro (titulo, ano_publicacao, fk_id_autor, fk_id_editora)
VALUES
('Dom Casmurro', 1899, 1, 1),
('Harry Potter e a Pedra Filosofal', 1997, 2, 2),
('Cem Anos de Solidão', 1967, 3, 3),
('1984', 1949, 4, 1),
('Memórias Póstumas de Brás Cubas', 1881, 1, 1);

-- Selects para ver tudo que tem em uma tabela
SELECT * FROM autor;

SELECT * FROM Editora;

SELECT * FROM livro;

-- Fazendo pesquisas específicas
SELECT l.titulo, l.ano_publicacao
FROM livro AS l
WHERE l.titulo LIKE "Dom%";

SELECT 
    l.titulo AS "Título",
    l.ano_publicacao AS "Ano",
    a.nome AS "Autor",
    a.nacionalidade AS "Nacionalidade",
    e.nome AS "Editora"
FROM livro AS l
JOIN autor AS a ON l.fk_id_autor = a.id
JOIN editora AS e ON l.fk_id_editora = e.id;
