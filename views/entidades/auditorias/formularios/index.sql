
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DO GERENTE
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','17')) AS properties; -- Permissão 17) Visualizar auditorias

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\auditorias\crud_handles\create' AS action,
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
' ' AS empty_option
FROM bases b
INNER JOIN municipios m ON (m.id = b.id_municipio)
INNER JOIN estados e ON (e.id = m.id_estado);

SELECT
'date' AS type,
'Data Inicial' AS label,
'data_inicial' AS name,
TRUE AS required;

SELECT
'date' AS type,
'Data Final' AS label,
'data_final' AS name,
TRUE AS required;

SELECT
'select' AS type,
'Evento' AS label,
'evento' AS name,
TRUE AS required,
json_object('label':'Auditoria', 'value': 'auditoria') AS options,
json_object('label':'Pré-auditoria', 'value': 'pre-auditoria') AS options,
' ' AS empty_option;

SELECT
'submit' AS type,
'Salvar' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
