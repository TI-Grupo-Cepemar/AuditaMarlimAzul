SELECT
'table' AS component,
TRUE AS search,
TRUE AS sort,
'Pesquisar...' As search_placeholder,
'Não há registros cadastrados' AS empty_description;
SELECT 
-- id, id_auditoria, id_classificacao, id_status, descricao, id_grupo_responsavel, id_area_atuacao, id_questionamento
t.id AS "ID"
FROM topicos t
INNER JOIN auditorias a ON (a.id = t.id_auditoria)