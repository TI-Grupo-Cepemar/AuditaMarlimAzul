
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DO GERENTE
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','2')) AS properties;

SELECT
'form' AS component,
'' AS action,
'' AS validate;
SELECT
'text' AS type,
'Nome' AS label,
'nome' AS name,
TRUE AS required;

SELECT
'select' AS type,
'Tipo' AS label,
'tipo' AS name,
TRUE AS required;

/*
id_gestor, 
nome, 
e_gerente_regional
*/