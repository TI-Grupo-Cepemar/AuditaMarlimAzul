
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DE EDIÇÃO DO GERENTE

    1. REQUERIMENTOS:
        1.1. id_auditoria
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','17')) AS properties; -- Permissão 17) Visualizar auditorias

-- VERIFICA SE O USUÁRIO INFORMOU OS DADOS NECESSÁRIO PARA ENCONTRAR A AUDITORIA NO BANCO DE DADOS, CASO O REQUISITANTE NÃO TENHA INFORMADO, REDIRECIONA PARA A ROTA \LOGIN\
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_auditoria IS NULL;

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA EXECUTAR A ROTA
SET id_auditoria_verificado = (
    SELECT a.id
    FROM auditorias a
    WHERE a.id = $id_auditoria::INTEGER
    LIMIT 1
);
-- SELECT id, id_base, data_inicial, data_final, pre_auditoria
-- FROM public.auditorias;
SET id_base_auditoria = (
    SELECT a.id_base
    FROM auditorias a
    WHERE a.id = $id_auditoria::INTEGER
    LIMIT 1
);
SET data_inicial_auditoria = (
    SELECT a.data_inicial
    FROM auditorias a
    WHERE a.id = $id_auditoria::INTEGER
    LIMIT 1
);
SET data_final_auditoria = (
    SELECT a.data_final
    FROM auditorias a
    WHERE a.id = $id_auditoria::INTEGER
    LIMIT 1
);
SET e_pre_auditoria = (
    SELECT (CASE WHEN a.pre_auditoria THEN 'pre-auditoria' ELSE 'auditoria' END)
    FROM auditorias a
    WHERE a.id = $id_auditoria::INTEGER
    LIMIT 1
);
SET identificador_modal = (
    gen_random_uuid()
);

-- VERIFICA SE A AUDITORIA SOLICITADA PARA EDIÇÃO É UMA AUDITORIA VÁLIDA CADASTRADA NO BANCO DE DADOS, CASO NÃO SEJA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN\
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_auditoria_verificado IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\auditorias\crud_handles\edit?id_auditoria='||$id_auditoria AS action,
'' AS validate;
SELECT
'select' AS type,
'Base' AS label,
'base' AS name,
TRUE AS required,
json_agg(json_object(
    'label': CONCAT(b.sigla,' - ',m.nome,' / ',e.nome),
    'value': b.id
)) AS options,
' ' AS empty_option,
$id_base_auditoria::INTEGER AS value
FROM bases b
INNER JOIN municipios m ON (m.id = b.id_municipio)
INNER JOIN estados e ON (e.id = m.id_estado);

SELECT
'date' AS type,
'Data Inicial' AS label,
'data_inicial' AS name,
$data_inicial_auditoria::DATE AS value,
TRUE AS required;

SELECT
'date' AS type,
'Data Final' AS label,
'data_final' AS name,
$data_final_auditoria::DATE AS value,
TRUE AS required;

SELECT
'select' AS type,
'Evento' AS label,
'evento' AS name,
TRUE AS required,
json_object('label':'Auditoria', 'value': 'auditoria') AS options,
json_object('label':'Pré-auditoria', 'value': 'pre-auditoria') AS options,
' ' AS empty_option,
$e_pre_auditoria AS value;

SELECT
'submit' AS type,
'Salvar' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
