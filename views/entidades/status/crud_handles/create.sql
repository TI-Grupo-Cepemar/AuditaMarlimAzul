
/*
    COMPONENTE RESPONSÁVEL PELA AÇÃO "CREATE" DE STATUS

    1. REQUERIMENTOS
        1.1. status (POST)
        1.2. cor (POST)
*/

-- VERIFICA SE O REQUISITANTE POSSUI PERMISSÃO PARA ACESSAR ESSA ROTA, CASO NÃO TENHA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN\
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','39')) AS properties; -- Permissão 39) Cadastrar status

-- DEFINE AS VARIÁVEIS UTILIZADAS PELA ROTA
SET variaveis_informadas_corretamente = (
    CASE WHEN ((:status IS NOT NULL AND :cor IS NOT NULL) AND (:cor ~ '^#[\dA-Fa-f]{6}$')) THEN 'true' ELSE NULL END
);
SET id_status_encontrado_pelo_nome = (
    SELECT id
    FROM status
    WHERE nome = :status or coloracao = :cor
    LIMIT 1
);
SET parametros_get_status_ja_cadastrado = (
    '?tipo=erro&titulo=Status já cadastrado&mensagem=Não foi possível cadastrar o status devido o cadastro já ter sido realizado.'
);
SET parametros_get_status_cadastrado_com_sucesso = (
    '?tipo=sucesso&titulo=Status cadastrado&mensagem=Cadastro realizado com sucesso.'
);

-- VERIFICA SE O REQUISITANTE FORNECEU OS PARÂMETROS status, E cor, E CASO NÃO TENHA FORNECIDO, REDIRECIONA O USUÁRIO PARA A ROTA \LOGIN\
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $variaveis_informadas_corretamente IS NULL;

-- VERIFICA SE JÁ HÁ UM STATUS CADASTRADO COM O NOME INFORMADO, E CASO HAJA, REDIRECINA PARA A ROTA /STATUS/
SELECT
'redirect' AS component,
'\entidades\status\'||$parametros_get_status_ja_cadastrado AS link
WHERE $id_status_encontrado_pelo_nome IS NOT NULL;

-- CASO OS DADOS TENHAM SIDO PASSADOS CORRETAMENTE, E O STATUS NÃO JÁ ESTEJA PREVIAMENTE CADASTRADO NO SISTEMA, O CADASTRO É REALIZADO
INSERT INTO status (nome, coloracao)
VALUES(:status, :cor)
RETURNING 
'redirect' AS component,
'\entidades\status\'||$parametros_get_status_cadastrado_com_sucesso AS link;
