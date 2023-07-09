-- Morador comum
call inserirMorador('12345678900', 'Maria Santos', 'maria.santos@example.com', 1, ['+55083982291213']);
call inserirMorador('45678976556', 'Allan Amancio', 'allanammancio04@example.com', 2, ['+55083982291235']);
select * from morador;
call inserirMorador('98765432100', 'João Silva', 'joao.silva@example.com', 1);

call inserirSindico('45678976556',true,'2023-01-01','2025-01-01','20232025','2023-01-01','2025-01-01','Primeiro mandato de Allan Amancio');
select * from sindico;
select * from mandato;