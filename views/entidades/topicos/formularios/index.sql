
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DO GERENTE
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','12')) AS properties; -- Permissão 12) Visualizar bases

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\bases\crud_handles\create' AS action,
'' AS validate;
SELECT
'text' AS type,
'Código IATA' AS label,
'sigla' AS name,
'^[A-Z]{3,}$' AS pattern,
TRUE AS required;

SELECT
'select' AS type,
'Gerente Local' AS label,
'gerente_local' AS name,
TRUE AS required,
json_agg(json_object(
    'label': g.nome,
    'value': g.id
)) AS options,
' ' As empty_option
FROM gerentes g
WHERE NOT g.regional;

SELECT
'select' AS type,
'Gerente Regional' AS label,
'gerente_regional' AS name,
TRUE AS required,
json_agg(json_object(
    'label': g.nome,
    'value': g.id
)) AS options,
' ' As empty_option
FROM gerentes g
WHERE g.regional;

SELECT
'select' AS type,
'select-relations' AS class,
'Estado' AS label,
'estado' AS name,
'estado' AS id,
TRUE AS required,
json_agg(json_object(
    'label': e.nome,
    'value': e.id
)) AS options,
' ' AS empty_option
FROM estados e;

SELECT
'select' AS type,
'select-relations' AS class,
'Município' AS label,
'municipio' AS name,
'municipio' AS id,
TRUE AS required,
json_agg(json_object(
    'label': m.nome,
    'value': m.id,
    'data-pr': m.id_estado -- DEFINE QUAL ESTADO DEVE ESTAR SELECIONADO PARA QUE O MUNICÍPIO SEJA VISÍVEL
)) AS options,
' ' AS empty_option,
'estado' AS "data-sf-parent" -- FAZ REFERENCIA AO DROPDOWN DECLARADO ACIMA, ONDE O ESTADO SELECIONADO, DEFINE OS MUNÍCIPIOS DEFINIDOS PARA SELEÇÃO
FROM municipios m;

SELECT
'submit' AS type,
'Salvar' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
