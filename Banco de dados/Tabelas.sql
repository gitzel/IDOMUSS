CREATE TABLE Cliente (
	idCliente INT IDENTITY(1,1) PRIMARY KEY,
	rg CHAR(9) NOT NULL,
	cpf CHAR(11) NOT NULL,
  	nome VARCHAR(50) NOT NULL, 
  	email VARCHAR(60) NOT NULL,
  	numeroCelular CHAR(15) NOT NULL,
  	dataNascimento DATE NOT NULL,
	genero VARCHAR(20) NOT NULL,
  	querGenero BIT NOT NULL,
  	senha VARBINARY NOT NULL, 
  	descricao NTEXT NOT NULL,
  	foto NTEXT NOT NULL
)



CREATE TABLE Servico (
	idServico int IDENTITY(1,1) PRIMARY KEY,
  	nome VARCHAR(50) NOT NULL, 
  	ocupacao VARCHAR(40) NOT NULL,
	foto NTEXT NOT NULL
)

CREATE TABLE Profissional (
	idProfissional INT IDENTITY(1,1) PRIMARY KEY,
	rg CHAR(9) NOT NULL,
	cpf CHAR(11) NOT NULL,
	cnpj CHAR(14) NOT NULL,
  	nome VARCHAR(50) NOT NULL, 
  	email VARCHAR(60) NOT NULL,
  	cep CHAR(8) NOT NULL,
  	numeroCelular CHAR(15) NOT NULL,
  	dataNascimento DATE NOT NULL,
	genero VARCHAR(20) NOt NULL,
  	querGenero BIT NOT NULL,
  	senha VARBINARY NOT NULL, 
  	descricao NTEXT NOT NULL,
  	foto NTEXT NOT NULL,
 	idServico INT NOT NULL,
  	CONSTRAINT FK_ProfissionalServico FOREIGN KEY(idServico) REFERENCES Servico(idServico)
)

CREATE TABLE HistoricoDeAcessoProfissional (
	idLogin INT IDENTITY(1,1) PRIMARY KEY,
  	dataAcesso DATETIME NOT NULL,
  	idProfissional INT NOT NULL,
  	CONSTRAINT FK_LoginProfissional FOREIGN KEY(idProfissional) REFERENCES Profissional(idProfissional)
)

CREATE TABLE HistoricoDeAcessoCliente (
	idLogin int IDENTITY(1,1) PRIMARY KEY,
  	dataAcesso DATETIME NOT NULL,
  	idCliente INT NOT NULL,
  	CONSTRAINT FK_LoginCliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
)

CREATE TABLE ProfissionalVIP (
	idProfissionalVIP INT IDENTITY(1,1) PRIMARY KEY,
  	dataInicio DATETIME NOT NULL,
  	idProfissional int NOT NULL,
  	CONSTRAINT FK_ProfissionalVIP FOREIGN KEY(idProfissional) REFERENCES Profissional(idProfissional)
)

CREATE TABLE Cartao  (
	idCartao INT IDENTITY(1,1) PRIMARY KEY,
  	dataValidade DATE NOT NULL,
  	ccv CHAR(3) NOT NULL,
  	numero CHAR(16) NOT NULL, 
  	idCliente INT NOT NULL,
  	CONSTRAINT FK_CartaoCliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
)

CREATE TABLE Endereco  (
	idEndereco INT IDENTITY(1,1) PRIMARY KEY,
  	cep char(8) NOT NULL,
  	numero char(5) NOT NULL,
  	complemento VARCHAR(30) NOT NULL, 
  	idCliente int NOT NULL,
  	CONSTRAINT FK_EnderecoCliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
)

CREATE TABLE ServicoContratado(
	idServicoContratado INT IDENTITY(1,1) PRIMARY KEY,
	situacao VARCHAR(25) NOT NULL CHECK (situacao IN ('Aguardando','Aceito','Em Análise','Profissional a Caminho', 'Chegou', 'Andamento', 'Finalizado')),
  	dataServico DATETIME NOT NULL,
  	preco MONEY NOT NULL,
  	descricao NTEXT NOT NULL,
  	idProfissional INT NOT NULL,
  	idCliente INT NoT NULL,
  	idServico INT NOT NULL,
  	CONSTRAINT FK_ContratadoProfissional FOREIGN KEY(idProfissional) REFERENCES Profissional(idProfissional),
  	CONSTRAINT FK_ContratadoCliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente),
 	CONSTRAINT FK_ContratadoServico FOREIGN KEY(idServico) REFERENCES Servico(idServico)
)

CREATE TABLE Avaliacao(
	idAvaliacao INT IDENTITY(1,1) PRIMARY KEY,
  	dataAvaliacao DATETIME NOT NULL,
  	nota FLOAT NOT NULL,
  	comentario NTEXT NOT NULL,
  	idProfissional INT NOT NULL,
  	idCliente INT NOT NULL,
  	CONSTRAINT FK_AvaliacaoProfissional FOREIGN KEY(idProfissional) REFERENCES Profissional(idProfissional),
  	CONSTRAINT FK_AvaliacaoCliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
)

CREATE TABLE Resposta(
	idResposta INT IDENTITY(1,1) PRIMARY KEY,
  	dataResposta DATETIME NOT NULL,
  	comentario NTEXT NOT NULL,
  	idProfissional INT NOT NULL,
  	idCliente INT NOT NULL,
    idAvaliacao INT NOT NULL,
  	CONSTRAINT FK_RespostaAvaliacao FOREIGN KEY(idAvaliacao) REFERENCES Avaliacao(idAvaliacao),
  	CONSTRAINT FK_RespostaProfissional FOREIGN KEY(idProfissional) REFERENCES Profissional(idProfissional),
  	CONSTRAINT FK_RespostaCliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
)


CREATE TABLE Ranking(
	idRanking INT IDENTITY(1,1) PRIMARY KEY,
  	potuacao FLOAT NOT NULL,
  	idProfissional INT NOT NULL,
  	idServico INT NOT NULL,
  	CONSTRAINT FK_RankingProfissional FOREIGN KEY(idProfissional) REFERENCES Profissional(idProfissional),
  	CONSTRAINT FK_RankingServico FOREIGN KEY(idServico) REFERENCES Servico(idServico)
)

CREATE TABLE Favorito(
	idFavorito INT IDENTITY(1,1) PRIMARY KEY,
  	idProfissional INT NOT NULL,
  	idCliente INT NOT NULL,
  	CONSTRAINT FK_FavoritoProfissional FOREIGN KEY(idProfissional) REFERENCES Profissional(idProfissional),
  	CONSTRAINT FK_FavoritoCliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
)