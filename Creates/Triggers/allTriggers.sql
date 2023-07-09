-- Todos os triggers do My Condominio

-- Verificar se a unidade habitacional existe
CREATE OR REPLACE FUNCTION verifica_unidade_habitacional(p_numero_unidade integer) RETURNS BOOLEAN AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM UNIDADE_HABITACIONAL
    WHERE numero = p_numero_unidade;   
    RETURN v_count > 0;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION verifica_unidade_habitacional_trigger() RETURNS TRIGGER AS $$
BEGIN
    IF NOT verifica_unidade_habitacional(NEW.numeroUnidade) THEN
        RAISE EXCEPTION 'A unidade habitacional especificada não existe na tabela UNIDADE_HABITACIONAL.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificar_unidade_habitacional_trigger
BEFORE INSERT ON MORADOR
FOR EACH ROW
EXECUTE FUNCTION verifica_unidade_habitacional_trigger();