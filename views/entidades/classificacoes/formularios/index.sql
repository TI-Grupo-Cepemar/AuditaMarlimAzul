
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DE CADASTRO DE CLASSIFICAÇÕES
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','34')) AS properties; -- Permissão 34) Visualizar classificações

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\classificacoes\crud_handles\create' AS action,
'' AS validate;
SELECT
'text' AS type,
'Classificação' AS label,
'classificacao' AS name,
TRUE AS required;

SELECT
'submit' AS type,
'Salvar' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
