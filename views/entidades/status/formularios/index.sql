
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DE CADASTRO DE STATUS
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','38')) AS properties; -- Permissão 38) Visualizar status

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\status\crud_handles\create' AS action,
'' AS validate;
SELECT
'text' AS type,
'Status' AS label,
'status' AS name,
TRUE AS required,
9 AS width;

SELECT
'color' AS type,
'Cor' AS label,
'cor' AS name,
3 AS width,
TRUE AS required;

SELECT
'submit' AS type,
'Salvar' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
