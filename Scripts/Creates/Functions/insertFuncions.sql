-- Funções do My Codominio de Inserções

-- Unidade Habitacional
CREATE OR REPLACE Procedure inserirUnidadeHabitacional(
    p_bloco CHAR(1),
    p_area DECIMAL
) AS $$
DECLARE
    v_proximo_id INT;
BEGIN
    SELECT COALESCE(MAX(numero::INT) + 1, 1) INTO v_proximo_id
    FROM UNIDADE_HABITACIONAL;

    v_proximo_id := LPAD(v_proximo_id::TEXT, 4, '0');

    INSERT INTO UNIDADE_HABITACIONAL (numero, bloco, area)
    VALUES (v_proximo_id, p_bloco, p_area);
END;
$$ LANGUAGE plpgsql;

-- Morador e Telefone
CREATE OR REPLACE Procedure inserirMorador(
    p_cpf CHAR(11),
    p_nome VARCHAR(100),
    p_email VARCHAR(50),
    p_numero_unidade INT,
    p_numero_telefones text[] DEFAULT '{}'
)  AS $$
DECLARE
    v_numero_moradores INTEGER;
	v_telefone text;
BEGIN
    INSERT INTO MORADOR (cpf, nome, email, numeroUnidade)
    VALUES (p_cpf, p_nome, p_email, p_numero_unidade);

    SELECT numero_moradores INTO v_numero_moradores
    FROM UNIDADE_HABITACIONAL
    WHERE numero = p_numero_unidade;

    IF v_numero_moradores = 0 THEN
        UPDATE UNIDADE_HABITACIONAL
        SET proprietario = p_nome
        WHERE numero = p_numero_unidade;
    END IF;

    UPDATE UNIDADE_HABITACIONAL
    SET numero_moradores = numero_moradores + 1
    WHERE numero = p_numero_unidade;

    FOREACH v_telefone in Array p_numero_telefones LOOP
    	call inserirTelefoneMorador(v_telefone,p_cpf);
    end LOOP;
END;
$$ LANGUAGE plpgsql;

create or replace procedure inserirTelefoneMorador(
	Numero_telefone char(15),
    Cpf_morador char(11)
) as $$    
    Begin
        INSERT INTO telefone_morador VALUES (Numero_telefone,Cpf_morador);
    end;
$$LANGUAGE 'plpgsql';

-- Sindico e Mandato
CREATE OR REPLACE Procedure inserirSindico(
    p_cpf_sindico CHAR(11),
    p_ativo BOOLEAN,
    p_data_inicio DATE,
    p_data_termino DATE,
    p_codigo_mandato CHAR(8),
    p_data_inicial DATE,
    p_data_final DATE,
    p_observacoes TEXT default ''
) AS $$
DECLARE
    v_sindico_existente BOOLEAN;
    v_mandato_existente BOOLEAN;
BEGIN
-- Verificar se o CPF do síndico já existe na tabela MORADOR
    SELECT NOT EXISTS (
        SELECT 1
        FROM MORADOR
        WHERE cpf = p_cpf_sindico
    ) INTO v_sindico_existente;

    IF v_sindico_existente THEN
        RAISE EXCEPTION 'Não existe morador com o CPF especificado.';
    END IF;
	
    -- Verificar se o CPF do síndico já existe na tabela SINDICO
    SELECT EXISTS (
        SELECT 1
        FROM SINDICO
        WHERE cpf = p_cpf_sindico
    ) INTO v_sindico_existente;

    IF v_sindico_existente THEN
        RAISE EXCEPTION 'Já existe um síndico com o CPF especificado.';
    END IF;

    -- Verificar se o código do mandato já existe na tabela MANDATO
    SELECT EXISTS (
        SELECT 1
        FROM MANDATO
        WHERE codigo = p_codigo_mandato
    ) INTO v_mandato_existente;

    IF v_mandato_existente THEN
        RAISE EXCEPTION 'Já existe um mandato com o código especificado.';
    END IF;

    -- Inserir o novo síndico na tabela SINDICO
    INSERT INTO SINDICO (cpf, ativo, data_inicio, data_termino)
    VALUES (p_cpf_sindico, p_ativo, p_data_inicio, p_data_termino);

    -- Inserir o novo mandato na tabela MANDATO
    INSERT INTO MANDATO (codigo, cpfSindico, data_inicial, data_termino, observacoes)
    VALUES (p_codigo_mandato, p_cpf_sindico, p_data_inicial, p_data_final, p_observacoes);
END;
$$ LANGUAGE plpgsql;
