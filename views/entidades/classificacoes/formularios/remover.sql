
/*
    COMPONENTE RESPONSÁVEL PELA CONFIRMAÇÃO DE REMOÇÃO DE UMA classificação

    1. REQUERIMENTOS
        1.1. id_classificacao (GET)
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','34')) AS properties; -- Permissão 34) Visualizar classificações

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_classificacao_nao_encontrada_no_banco_de_dados = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Classificação não encontrada na base de dados'
);
SET id_classificacao_encontrada_no_banco_de_dados = (
    SELECT c.id
    FROM classificacoes c
    WHERE c.id = $id_classificacao::INTEGER
    LIMIT 1
);
SET nome_classificacao = (
    SELECT c.nome
    FROM classificacoes c
    WHERE c.id = $id_classificacao::INTEGER
    LIMIT 1
);
SET parametros_get_remover_classificacao = (
    '?id_classificacao='||$id_classificacao
);

-- VERIFICA SE O USUÁRIO INFORMOU OS ARGUMENTOS NECESSÁRIO PARA A ROTA
SELECT
'redirect' AS component,
'\entidades\classificacoes\'||$mensagem_argumentos_incorretos AS link
WHERE $id_classificacao IS NULL;

-- VERIFICA SE O ID_CLASSIFICACAO INFORMADO PERTENCE REALMENTE A UMA CLASSIFICACAO VÁLIDA CADASTRADA NO BANCO DE DADOS, E CASO CONTRÁRIO, REDIRECIONA O REQUERENTE PARA O \CLASSIFICACOES\
SELECT
'redirect' AS component,
'\entidades\classificacoes\'||$mensagem_classificacao_nao_encontrada_no_banco_de_dados AS link
WHERE $id_classificacao_encontrada_no_banco_de_dados IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'text' AS component,
'Confirma a remoção da classificação "'||$nome_classificacao||'"?' AS contents;

SELECT
'button' AS component,
'end' As justify;
SELECT
'Confirmar' AS title,
'red' AS color,
'\entidades\classificacoes\crud_handles\delete'||$parametros_get_remover_classificacao AS link;
