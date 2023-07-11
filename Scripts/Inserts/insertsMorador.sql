-- Morador comum
call inserirMorador('12345678900', 'Maria Santos', 'maria.santos@example.com', 1, 'A', array['+55083982291213']);
call inserirMorador('45678976556', 'Allan Amancio', 'allanammancio04@example.com', 2, 'A', array['+55083982291235']);
call inserirMorador('98765432100', 'João Silva', 'joao.silva@example.com', 1, 'A', array['+55081954678907']);
select * from morador;

call inserirSindico('45678976556',true,'2023-01-01','2025-01-01','20232025','2023-01-01','2025-01-01','Primeiro mandato de Allan Amancio');
select * from sindico;
select * from mandato;