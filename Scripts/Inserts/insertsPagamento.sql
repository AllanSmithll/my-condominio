call inserirPagamentoMorador('12345678900', 500.00, '2023-07-08', 'Aluguel');
call inserirPagamentoMorador('98765432100', 300.00, '2023-07-10', 'Condomínio');
call inserirPagamentoMorador('12345678900', 100.00, '2023-07-10', 'Água');

select * from pagamento;
