-- Tabelas do condomínio - atualizado em 08/07/2023
-- Tabela UNIDADE_HABITACIONAL
create table UNIDADE_HABITACIONAL (
	numero serial not null primary key,
	bloco char(1) not null,
	area decimal not null default 20.00,
	proprietario varchar(100) default 'Do condomínio',
	numero_moradores int not null default 0
);

-- Tabela MORADOR
create table MORADOR (
    cpf char(11) not null primary key,
    nome varchar(100) not null,
    email varchar(50) not null,
	numeroUnidade int not null,
    foreign key (numeroUnidade) references UNIDADE_HABITACIONAL(numero) on delete cascade
);

-- Tabela TELEFONE_MORADOR
create table TELEFONE_MORADOR (
	numero_telefone char(15) not null,
	cpf_morador char(11) not null,
	primary key (numero_telefone, cpf_morador),
    foreign key (cpf_morador) references MORADOR (cpf)
);

-- Tabela AREA_COMUM
create table AREA_COMUM (
	codigo char(5) not null primary key,
	nome varchar(45) not null,
	disponibilidade varchar(15) not null,
	horario varchar(11) not null
);

-- Tabela PAGAMENTO
create table PAGAMENTO (
	id serial not null,
	cpfMorador char(11) not null,
	valor numeric not null,
	data date not null,
	tipo varchar(20),
	primary key (id, cpfMorador),
    foreign key (cpfMorador) references MORADOR (cpf) on delete cascade
);

-- Tabela SINDICO
create table SINDICO (
	cpf char(11) not null primary key,
	ativo boolean not null,
	data_inicio date not null,
	data_termino date
);

-- Tabela MANDATO
create table MANDATO (
	codigo char(8) not null,
	cpfSindico char(11) not null,
	data_inicial date not null,
	data_termino date,
	observacoes text,
	primary key (cpfSindico, codigo),
    foreign key (cpfSindico) references SINDICO (cpf)
);

ALTER TABLE PAGAMENTO ADD CONSTRAINT valor_positivo_check check (valor > 0);