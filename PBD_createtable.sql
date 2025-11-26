CREATE TABLE Cidade (
    id_cidade INT PRIMARY KEY,
    nome VARCHAR(100),
    estado CHAR(2)
);

CREATE TABLE Loja (
    id_loja INT PRIMARY KEY,
    nome VARCHAR(100),
    endereco VARCHAR(200),
    id_cidade INT,
    FOREIGN KEY (id_cidade) REFERENCES Cidade(id_cidade)
);

CREATE TABLE CategoriaVeiculo (
    id_categoria INT PRIMARY KEY,
    nome VARCHAR(50),
    diaria DECIMAL(10,2)
);

CREATE TABLE Veiculo (
    id_veiculo INT PRIMARY KEY,
    placa VARCHAR(15) UNIQUE,
    modelo VARCHAR(100),
    ano INT,
    status VARCHAR(20),
    id_loja_atual INT,
    id_categoria INT,
    FOREIGN KEY (id_loja_atual) REFERENCES Loja(id_loja),
    FOREIGN KEY (id_categoria) REFERENCES CategoriaVeiculo(id_categoria)
);

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100),
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Reserva (
    id_reserva INT PRIMARY KEY,
    id_cliente INT,
    id_loja_retirada INT,
    id_loja_retorno INT,
    data_reserva DATE,
    periodo INT CHECK (periodo IN (7,15,30)),
    inclui_motorista BOOLEAN,
    status VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_loja_retirada) REFERENCES Loja(id_loja),
    FOREIGN KEY (id_loja_retorno) REFERENCES Loja(id_loja)
);

CREATE TABLE Locacao (
    id_locacao INT PRIMARY KEY,
    id_reserva INT UNIQUE,
    id_veiculo INT,
    data_inicio DATE,
    data_fim DATE,
    valor_pago DECIMAL(10,2),
    pagamento_confirmado BOOLEAN,
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo)
);

CREATE TABLE Motorista (
    id_motorista INT PRIMARY KEY,
    nome VARCHAR(100),
    cnh VARCHAR(20) UNIQUE,
    telefone VARCHAR(20),
    diaria DECIMAL(10,2)
);

CREATE TABLE LocacaoMotorista (
    id_locacao INT,
    id_motorista INT,
    PRIMARY KEY(id_locacao, id_motorista),
    FOREIGN KEY (id_locacao) REFERENCES Locacao(id_locacao),
    FOREIGN KEY (id_motorista) REFERENCES Motorista(id_motorista)
);

CREATE TABLE Manutencao (
    id_manutencao INT PRIMARY KEY,
    id_veiculo INT NOT NULL,
    id_locacao INT NULL,
    data_manutencao DATE NOT NULL,
    data_ultima_vistoria DATE NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    descricao TEXT,
    custo DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) 
        CHECK (status IN ('AGENDADA', 'EM_EXECUCAO', 'CONCLUIDA', 'CANCELADA')),
    
    FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo),
    FOREIGN KEY (id_locacao) REFERENCES Locacao(id_locacao)
);
