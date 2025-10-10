
/*
    COMPONENTE RESPONSÁVEL PELA CONFIRMAÇÃO DE REMOÇÃO DE UMA CAUSA

    1. REQUERIMENTOS
        1.1. id_causa (GET)
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','30')) AS properties; -- Permissão 8) Visualizar causas

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_causa_nao_encontrada_no_banco_de_dados = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Causa não encontrada na base de dados'
);
SET id_causa_encontrada_no_banco_de_dados = (
    SELECT c.id
    FROM causas c
    WHERE c.id = $id_causa::INTEGER
    LIMIT 1
);
SET nome_causa = (
    SELECT c.nome
    FROM causas c
    WHERE c.id = $id_causa::INTEGER
    LIMIT 1
);
SET parametros_get_remover_causa = (
    '?id_causa='||$id_causa
);

-- VERIFICA SE O USUÁRIO INFORMOU OS ARGUMENTOS NECESSÁRIO PARA A ROTA
SELECT
'redirect' AS component,
'\entidades\causas\'||$mensagem_argumentos_incorretos AS link
WHERE $id_causa IS NULL;

-- VERIFICA SE O ID_CAUSA INFORMADO PERTENCE REALMENTE A UMA CAUSA VÁLIDA CADASTRADA NO BANCO DE DADOS, E CASO CONTRÁRIO, REDIRECIONA O REQUERENTE PARA O \CAUSAS\
SELECT
'redirect' AS component,
'\entidades\causas\'||$mensagem_causa_nao_encontrada_no_banco_de_dados AS link
WHERE $id_causa_encontrada_no_banco_de_dados IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'text' AS component,
'Confirma a remoção da causa "'||$nome_causa||'"?' AS contents;

SELECT
'button' AS component,
'end' As justify;
SELECT
'Confirmar' AS title,
'red' AS color,
'\entidades\causas\crud_handles\delete'||$parametros_get_remover_causa AS link;
