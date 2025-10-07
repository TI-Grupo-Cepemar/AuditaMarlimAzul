
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DE EDIÇÃO DE CLASSIFICAÇÕES

    1. REQUERIMENTOS:
        1.1. id_classificacao
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','34')) AS properties; -- Permissão 34) Visualizar classificações

-- VERIFICA SE O USUÁRIO INFORMOU OS DADOS NECESSÁRIOS PARA ENCONTRAR A CLASSIFICAÇÃO NO BANCO DE DADOS, CASO O REQUISITANTE NÃO TENHA INFORMADO, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_classificacao IS NULL;

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA EXECUTAR A ROTA
SET classificacao = (
    SELECT c.nome
	FROM classificacoes c
    WHERE c.id = $id_classificacao::INTEGER
    LIMIT 1
);

-- VERIFICA SE A CLASSIFICAÇÃO SOLICITADA PARA EDIÇÃO É UMA CLASSIFICAÇÃO VÁLIDA CADASTRADA NO BANCO DE DADOS, CASO NÃO SEJA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $classificacao IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\classificacoes\crud_handles\edit?id_classificacao='||$id_classificacao AS action,
'' AS validate;
SELECT
'text' AS type,
'Classificação' AS label,
'classificacao' AS name,
$classificacao AS value,
TRUE AS required;

SELECT
'submit' AS type,
'Salvar alterações' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
