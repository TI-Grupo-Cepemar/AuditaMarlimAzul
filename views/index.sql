
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','0')) AS properties;

SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\shell.sql') AS properties;
