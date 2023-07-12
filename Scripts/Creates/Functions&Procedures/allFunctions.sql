/* Função para calcular o tamanho do bloco a partir da quantidade de metros
quadrados das unidades habitacionais */
create or replace function areaTotalBloco(blocounidade unidade_habitacional.bloco%type)
returns numeric as $$
declare
	total_metros_bloco numeric = 0.0;
	valor_area numeric = 0.0;
	c_area CURSOR for
		select area from unidade_habitacional where bloco = blocounidade;
begin
	for area_record in c_area loop
		valor_area := area_record.area;
		total_metros_bloco := total_metros_bloco + valor_area;
	end loop;
	return total_metros_bloco;
end $$ language 'plpgsql';

-- Valor total arrecado pelo condomínio no ano passado para a função
create or replace function valorTotalAnualArrecadado(ano integer)
returns numeric as $$
declare
	totalArrecadado numeric = 0.0;
	c_valores CURSOR for
		select valor from pagamento where extract(year from data) = ano;
begin
	for val in c_valores loop
		totalArrecadado := totalArrecadado + val.valor;
	end loop;
	return totalArrecadado;
end $$ language 'plpgsql';
