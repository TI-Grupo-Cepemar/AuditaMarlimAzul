
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DE EDIÇÃO DE CAUSAS

    1. REQUERIMENTOS:
        1.1. id_causa
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','30')) AS properties; -- Permissão 8) Visualizar causas

-- VERIFICA SE O USUÁRIO INFORMOU OS DADOS NECESSÁRIO PARA ENCONTRAR A CAUSA NO BANCO DE DADOS, CASO O REQUISITANTE NÃO TENHA INFORMADO, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_causa IS NULL;

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA EXECUTAR A ROTA
SET causa = (
    SELECT c.nome
	FROM causas c
    WHERE c.id = $id_causa::INTEGER
    LIMIT 1
);

-- VERIFICA SE A CAUSA SOLICITADA PARA EDIÇÃO É UMA CAUSA VÁLIDA CADASTRADA NO BANCO DE DADOS, CASO NÃO SEJA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $causa IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\causas\crud_handles\edit?id_causa='||$id_causa AS action,
'' AS validate;
SELECT
'text' AS type,
'Causa' AS label,
'causa' AS name,
$causa AS value,
TRUE AS required;

SELECT
'submit' AS type,
'Salvar alterações' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
