/* FUNCIONARIO: */

CREATE TABLE Funcionario (
    Cpf CHAR(14) PRIMARY KEY,
    Nome CHAR(100),
    Salario DECIMAL(10,2),
    DataNasc DATE,
    CEP VARCHAR(9),
    Rua VARCHAR(256),
    Numero INT,
    Complemento VARCHAR(255)
);

/* FUNCIONARIO-DEPARTAMENTO: */

CREATE TABLE Funcionario (
    Cpf CHAR(14) PRIMARY KEY,
    Nome VARCHAR(100),
    Salario DECIMAL(10,2),
    DataNasc DATE,
    CEP CHAR(9),
    Rua VARCHAR(100),
    Numero INT,
    Complemento VARCHAR(255),
    fk_Departamento_ID INT
);

CREATE TABLE Departamento (
    ID INT PRIMARY KEY,
    Nome VARCHAR(100)
);
 
ALTER TABLE Funcionario ADD CONSTRAINT FK_Funcionario_2
    FOREIGN KEY (fk_Departamento_ID)
    REFERENCES Departamento (ID)
    ON DELETE CASCADE;

/* PROJETO-FUNCIONARIO-DEPARTAMENTO: */

CREATE TABLE Funcionario (
    Cpf CHAR(14) PRIMARY KEY,
    Nome VARVARCHAR(100),
    Salario DECIMAL(10,2),
    DataNasc DATE,
    CEP CHAR(9),
    Rua VARCHAR(255),
    Numero INT,
    Complemento VARCHAR(255),
    fk_Departamento_ID INT
);

CREATE TABLE Departamento (
    ID INT PRIMARY KEY,
    Nome VARCHAR(100),
    fk_Funcionario_Cpf CHAR(14),
    DataInicioGerencia DATE
);

CREATE TABLE Projeto (
    ID INT PRIMARY KEY,
    Nome VARCHAR(100),
    Local VARCHAR(100)
);

CREATE TABLE Funcionario_Projeto_Trabalha (
    fk_Funcionario_Cpf CHAR(14),
    fk_Projeto_ID INT,
    QtdHoras DECIMAL(3,1)
);
 
ALTER TABLE Funcionario ADD CONSTRAINT FK_Funcionario_2
    FOREIGN KEY (fk_Departamento_ID)
    REFERENCES Departamento (ID)
    ON DELETE CASCADE;
 
ALTER TABLE Departamento ADD CONSTRAINT FK_Departamento_2
    FOREIGN KEY (fk_Funcionario_Cpf)
    REFERENCES Funcionario (Cpf)
    ON DELETE CASCADE;
 
ALTER TABLE Funcionario_Projeto_Trabalha ADD CONSTRAINT FK_Funcionario_Projeto_Trabalha_1
    FOREIGN KEY (fk_Funcionario_Cpf)
    REFERENCES Funcionario (Cpf);
 
ALTER TABLE Funcionario_Projeto_Trabalha ADD CONSTRAINT FK_Funcionario_Projeto_Trabalha_2
    FOREIGN KEY (fk_Projeto_ID)
    REFERENCES Projeto (ID);