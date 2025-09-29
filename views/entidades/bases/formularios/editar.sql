
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DE EDIÇÃO DO GERENTE

    1. REQUERIMENTOS:
        1.1. id_base
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','12')) AS properties; -- Permissão 12) Visualizar bases

-- VERIFICA SE O USUÁRIO INFORMOU OS DADOS NECESSÁRIO PARA ENCONTRAR O GESTOR NO BANCO DE DADOS, CASO O REQUISITANTE NÃO TENHA INFORMADO, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_base IS NULL;

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA EXECUTAR A ROTA
SET id_base_verificado = (
    SELECT b.id
    FROM bases b
    WHERE b.id = $id_base::INTEGER
    LIMIT 1
);
SET sigla_base = (
    SELECT b.sigla
    FROM bases b
    WHERE b.id = $id_base::INTEGER
    LIMIT 1
);
SET gerente_local_base = (
    SELECT b.id_gerente
    FROM bases b
    WHERE b.id = $id_base::INTEGER
    LIMIT 1
);
SET gerente_regional_base = (
    SELECT b.id_gerente_regional
    FROM bases b
    WHERE b.id = $id_base::INTEGER
    LIMIT 1
);
SET municipio_base = (
    SELECT b.id_municipio
    FROM bases b
    WHERE b.id = $id_base::INTEGER
    LIMIT 1
);
SET estado_base = (
    SELECT e.id
    FROM bases b
    INNER JOIN municipios m ON (m.id = b.id_municipio)
    INNER JOIN estados e ON (e.id = m.id_estado)
    WHERE b.id = $id_base::INTEGER
    LIMIT 1
);
SET identificador_modal = (
    gen_random_uuid()
);

-- VERIFICA SE O GERENTE SOLICITADO PARA EDIÇÃO É UM GERENTE VÁLIDO CADASTRADO NO BANCO DE DADOS, CASO NÃO SEJA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_base_verificado IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\bases\crud_handles\edit?id_base='||$id_base AS action,
'' AS validate;
SELECT
'text' AS type,
'Código IATA' AS label,
'sigla' AS name,
'^[A-Z]{3,}$' AS pattern,
$sigla_base AS value,
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
' ' As empty_option,
$gerente_local_base::INTEGER AS value
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
' ' As empty_option,
$gerente_regional_base::INTEGER AS value
FROM gerentes g
WHERE g.regional;

SELECT
'select' AS type,
'select-relations' AS class,
'Estado' AS label,
'estado' AS name,
'estado_editar_'||$identificador_modal AS id, -- CRIA O ID DINÂMICAMENTE PARA QUE UM MODAL NÃO ALTERE AS INFORMAÇÕES (DADO SELECIONADO NO CAMPO) DE OUTRO MODAL
TRUE AS required,
json_agg(json_object(
    'label': e.nome,
    'value': e.id
)) AS options,
$estado_base::INTEGER AS value,
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
'estado_editar_'||$identificador_modal AS "data-sf-parent", -- FAZ REFERENCIA AO DROPDOWN DECLARADO ACIMA, ONDE O ESTADO SELECIONADO, DEFINE OS MUNÍCIPIOS DEFINIDOS PARA SELEÇÃO
$municipio_base::INTEGER AS value
FROM municipios m;

SELECT
'submit' AS type,
'Salvar' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
