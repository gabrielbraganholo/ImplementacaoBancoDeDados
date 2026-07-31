### Modelo Conceitual

![alt text](image.png)

### Modelo Lógico

![alt text](image-1.png)

### Modelo Físico

```sql
/* Lógico_2: */

CREATE TABLE Livro (
    ID INT PRIMARY KEY,
    Titulo VARCHAR,
    AnoLancamento INT,
    fk_Editora_ID INT,
    fk_Categoria_Codigo INT
);

CREATE TABLE Editora (
    Nome VARCHAR,
    ID INT PRIMARY KEY
);

CREATE TABLE Autor (
    Nome VARCHAR,
    Cpf VARCHAR PRIMARY KEY,
    Nacionalidade VARCHAR
);

CREATE TABLE Livro_Autor_Escreve (
    fk_Livro_ID INT,
    fk_Autor_Cpf VARCHAR
);

CREATE TABLE Categoria (
    Codigo INT PRIMARY KEY,
    Descricao VARCHAR
);
 
ALTER TABLE Livro ADD CONSTRAINT FK_Livro_2
    FOREIGN KEY (fk_Editora_ID)
    REFERENCES Editora (ID)
    ON DELETE CASCADE;
 
ALTER TABLE Livro ADD CONSTRAINT FK_Livro_3
    FOREIGN KEY (fk_Categoria_Codigo)
    REFERENCES Categoria (Codigo)
    ON DELETE CASCADE;
 
ALTER TABLE Livro_Autor_Escreve ADD CONSTRAINT FK_Livro_Autor_Escreve_1
    FOREIGN KEY (fk_Livro_ID)
    REFERENCES Livro (ID);
 
ALTER TABLE Livro_Autor_Escreve ADD CONSTRAINT FK_Livro_Autor_Escreve_2
    FOREIGN KEY (fk_Autor_Cpf)
    REFERENCES Autor (Cpf);
```