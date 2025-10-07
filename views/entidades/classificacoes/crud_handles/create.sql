
/*
    COMPONENTE RESPONSÁVEL PELA AÇÃO "CREATE" DE CLASSIFICAÇÕES

    1. REQUERIMENTOS
        1.1. classificacao (POST)
*/

-- VERIFICA SE O REQUISITANTE POSSUI PERMISSÃO PARA ACESSAR ESSA ROTA, CASO NÃO TENHA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN\
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','35')) AS properties; -- Permissão 35) Cadastrar classificações

-- DEFINE AS VARIÁVEIS UTILIZADAS PELA ROTA
SET variaveis_informadas_corretamente = (
    CASE WHEN (:classificacao IS NOT NULL) THEN 'true' ELSE NULL END
);
SET id_classificacao_encontrada_pelo_nome = (
    SELECT c.id
    FROM classificacoes c
    WHERE c.nome = :classificacao
    LIMIT 1
);
SET parametros_get_classificacao_ja_cadastrada = (
    '?tipo=erro&titulo=Classificação já cadastrada&mensagem=Não foi possível cadastrar a classificação devido o cadastro já ter sido realizado.'
);
SET parametros_get_classificacao_cadastrada_com_sucesso = (
    '?tipo=sucesso&titulo=Classificação cadastrada&mensagem=Cadastro realizado com sucesso.'
);

-- VERIFICA SE O REQUISITANTE FORNECEU O PARÂMETRO classificacao, E CASO NÃO TENHA FORNECIDO, REDIRECIONA O USUÁRIO PARA A ROTA \LOGIN\
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $variaveis_informadas_corretamente IS NULL;

-- VERIFICA SE JÁ HÁ UMA CLASSIFICAÇÃO CADASTRADA COM O NOME INFORMADO, E CASO HAJA, REDIRECINA PARA A ROTA /CLASSIFICACOES/
SELECT
'redirect' AS component,
'\entidades\classificacoes\'||$parametros_get_classificacao_ja_cadastrada AS link
WHERE $id_classificacao_encontrada_pelo_nome IS NOT NULL;

-- CASO OS DADOS TENHAM SIDO PASSADOS CORRETAMENTE, E A CLASSIFICAÇÃO NÃO JÁ ESTEJA PREVIAMENTE CADASTRADO NO SISTEMA, O CADASTRO É REALIZADO
INSERT INTO classificacoes(nome)
VALUES (:classificacao)
RETURNING 
'redirect' AS component,
'\entidades\classificacoes\'||$parametros_get_classificacao_cadastrada_com_sucesso AS link;
