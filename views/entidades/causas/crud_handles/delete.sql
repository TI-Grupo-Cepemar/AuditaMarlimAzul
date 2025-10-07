/*
    COMPONENTE RESPONSÁVEL PELA REMOÇÃO DE CAUSAS

    1. REQUERIMENTOS:
        1.1. id_causa (GET)
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','33')) AS properties; -- Permissão 33) Remover causa

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro ao remover a causa&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_causa_nao_encontrada = (
    '?tipo=erro&titulo=Erro ao remover a causa&mensagem=Não foi possível encontrar a causa solicitada para remoção'
);
SET mensagem_causa_removida_com_sucesso = (
    '?tipo=sucesso&titulo=Remoção realizada com sucesso&mensagem=Causa removida com sucesso'
);
SET id_causa_validada_no_banco_de_dados = (
    SELECT c.id
    FROM causas c
    WHERE c.id = $id_causa::INTEGER
    LIMIT 1
);

-- VERIFICA SE O REQUERENTE INFORMOU OS ARGUMENTOS NECESSÁRIOS PARA A EXECUÇÃO DA ROTA
SELECT
'redirect' AS component,
'\entidades\causas\'||$mensagem_argumentos_incorretos AS link
WHERE $id_causa IS NULL;

-- VERIFICA SE O ID_CAUSA REALMENTE PERTENCE A UMA CAUSA CADASTRADA NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\causas\'||$mensagem_causa_nao_encontrada AS link
WHERE $id_causa_validada_no_banco_de_dados IS NULL;

-- REMOVE A CAUSA SOLICITADA DO BANCO DE DADOS
DELETE FROM causas
WHERE id = $id_causa::INTEGER
RETURNING
'redirect' AS component,
'\entidades\causas\'||$mensagem_causa_removida_com_sucesso AS link;
