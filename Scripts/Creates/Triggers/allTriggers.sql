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

/*verifica se a antiga unidade habitacional (OLD.numeroUnidade) existe e, se existir, decrementa o número de moradores na tabela UNIDADE_HABITACIONAL em 1 para aquela unidade habitacional. */
CREATE OR REPLACE FUNCTION decrementar_numero_moradores() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.numeroUnidade IS NOT NULL THEN
        UPDATE UNIDADE_HABITACIONAL
        SET numero_moradores = numero_moradores - 1
        WHERE numero = OLD.numeroUnidade;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER decrementar_numero_moradores_trigger
AFTER DELETE OR UPDATE OF numeroUnidade ON MORADOR
FOR EACH ROW
EXECUTE FUNCTION decrementar_numero_moradores();

-- Para garantir que a tabela Síndico só tenha um síndico regisrado
CREATE OR REPLACE FUNCTION checkSindicoUnico() RETURNS TRIGGER AS $$
DECLARE
    v_existing_sindico SINDICO%ROWTYPE;
BEGIN
    SELECT * INTO v_existing_sindico
    FROM SINDICO
    WHERE ativo = true;
    IF FOUND THEN
        IF NEW.ativo = true THEN
            RAISE EXCEPTION 'A tabela SINDICO já contém um síndico em atividade.';
        ELSE
            DELETE FROM SINDICO;
            call inserirSindico(NEW.cpf, NEW.ativo, NEW.data_inicio, NEW.data_termino,new.codigo,new.data_inicial,new.data_termino,new.observacoes);
        END IF;
    ELSE
        call inserirSindico(NEW.cpf, NEW.ativo, NEW.data_inicio, NEW.data_termino,new.codigo,new.data_inicial,new.data_termino,new.observacoes);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_single_row_sindico
BEFORE INSERT ON SINDICO
FOR EACH ROW
EXECUTE FUNCTION checkSindicoUnico();