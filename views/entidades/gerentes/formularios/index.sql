
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DO GERENTE
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','2')) AS properties;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\gerentes\crud_handles\create' AS action,
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
TRUE AS required,
json_object('label':'Local',     'value':'local') AS options,
json_object('label':'Regional',  'value':'regional') AS options;

SELECT
'submit' AS type,
'Salvar' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
