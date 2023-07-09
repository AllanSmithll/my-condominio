-- Funções do My Codominio de Inserções

-- Unidade Habitacional
CREATE OR REPLACE FUNCTION inserir_unidade_habitacional(
    p_bloco CHAR(1),
    p_area DECIMAL
) RETURNS VOID AS $$
DECLARE
    v_proximo_id INT;
BEGIN
    SELECT COALESCE(MAX(numero::INT) + 1, 1) INTO v_proximo_id
    FROM UNIDADE_HABITACIONAL;

    v_proximo_id := LPAD(v_proximo_id::TEXT, 4, '0');

    INSERT INTO UNIDADE_HABITACIONAL (numero, bloco, area, proprietario)
    VALUES (v_proximo_id, p_bloco, p_area, p_proprietario);
END;
$$ LANGUAGE plpgsql;

-- Morador
CREATE OR REPLACE FUNCTION inserir_morador(
    p_cpf CHAR(11),
    p_nome VARCHAR(100),
    p_email VARCHAR(50),
    p_numero_unidade integer
) RETURNS VOID AS $$
DECLARE
	v_numero_moradores integer;
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
END;
$$ LANGUAGE plpgsql;
