/*
    COMPONENTE RESPONSÁVEL PELA REMOÇÃO DE CAUSAS

    1. REQUERIMENTOS:
        1.1. id_classificacao (GET)
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','37')) AS properties; -- Permissão 37) Remover classificações

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro ao remover a classificação&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_classificacao_nao_encontrada = (
    '?tipo=erro&titulo=Erro ao remover a classificação&mensagem=Não foi possível encontrar a classificação solicitada para remoção'
);
SET mensagem_classificacao_removida_com_sucesso = (
    '?tipo=sucesso&titulo=Remoção realizada com sucesso&mensagem=Classificação removida com sucesso'
);
SET id_classificacao_validada_no_banco_de_dados = (
    SELECT c.id
    FROM classificacoes c
    WHERE c.id = $id_classificacao::INTEGER
    LIMIT 1
);

-- VERIFICA SE O REQUERENTE INFORMOU OS ARGUMENTOS NECESSÁRIOS PARA A EXECUÇÃO DA ROTA
SELECT
'redirect' AS component,
'\entidades\classificacoes\'||$mensagem_argumentos_incorretos AS link
WHERE $id_classificacao IS NULL;

-- VERIFICA SE O ID_CLASSIFICACAO REALMENTE PERTENCE A UMA CLASSIFICAÇÃO CADASTRADA NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\classificacoes\'||$mensagem_classificacao_nao_encontrada AS link
WHERE $id_classificacao_validada_no_banco_de_dados IS NULL;

-- REMOVE A CLASSIFICACAO SOLICITADA DO BANCO DE DADOS
DELETE FROM classificacoes
WHERE id = $id_classificacao::INTEGER
RETURNING
'redirect' AS component,
'\entidades\classificacoes\'||$mensagem_classificacao_removida_com_sucesso AS link;
