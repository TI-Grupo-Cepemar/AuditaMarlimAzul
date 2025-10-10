
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DE EDIÇÃO DE STATUS

    1. REQUERIMENTOS:
        1.1. id_status
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','38')) AS properties; -- Permissão 38) Visualizar status

-- VERIFICA SE O USUÁRIO INFORMOU OS DADOS NECESSÁRIO PARA ENCONTRAR O STATUS NO BANCO DE DADOS, CASO O REQUISITANTE NÃO TENHA INFORMADO, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_status IS NULL;

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA EXECUTAR A ROTA
SET id_status_encontrado_na_base_de_dados = (
    SELECT id
    FROM status s
    WHERE id = $id_status::INTEGER
    LIMIT 1
);
SET nome_status = (
    SELECT nome
    FROM status s
    WHERE id = $id_status::INTEGER
    LIMIT 1
);
SET cor_status = (
    SELECT coloracao
    FROM status s
    WHERE id = $id_status::INTEGER
    LIMIT 1
);

-- VERIFICA SE O STATUS SOLICITADO PARA EDIÇÃO É UM STATUS VÁLIDO CADASTRADO NO BANCO DE DADOS, CASO NÃO SEJA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_status_encontrado_na_base_de_dados IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\status\crud_handles\edit?id_status='||$id_status AS action,
'' AS validate;
SELECT
'text' AS type,
'Status' AS label,
'status' AS name,
$nome_status AS value,
TRUE AS required;

SELECT
'color' AS type,
'Cor' AS label,
'cor' AS name,
$cor_status AS value,
TRUE AS required;

SELECT
'submit' AS type,
'Salvar alterações' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
