
-- VERIFICA SE O USUÁRIO POSSUI A PERMISSÃO DE ID 17 (VISUALIZAR AUDITORIAS), E CASO NÃO TENHA, REDIRECIONA PARA A ROTA \LOGIN\
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','17')) AS properties; -- PERMISSÃO DE VISUALIZAR AUDITORIAS

-- RENDERIZA O SHELL GENÉRICO DA PÁGINA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\shell.sql') AS properties;
