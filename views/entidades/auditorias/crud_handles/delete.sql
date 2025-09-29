/*
    COMPONENTE RESPONSÁVEL PELA REMOÇÃO DE AUDITORIAS

    1. REQUERIMENTOS:
        1.1. id_auditoria
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','20')) AS properties; -- Permissão 20) Remover auditorias

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro ao remover a auditoria&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_auditoria_nao_encontrada = (
    '?tipo=erro&titulo=Erro ao remover a auditoria&mensagem=Não foi possível encontrar a auditoria solicitada para remoção'
);
SET mensagem_auditoria_removida_com_sucesso = (
    '?tipo=sucesso&titulo=Remoção realizada com sucesso&mensagem=Auditoria removida com sucesso'
);
SET id_auditoria_validada_no_banco_de_dados = (
    SELECT a.id
    FROM auditorias a
    WHERE a.id = $id_auditoria::INTEGER
    LIMIT 1
);

-- VERIFICA SE O REQUERENTE INFORMOU OS ARGUMENTOS NECESSÁRIOS PARA A EXECUÇÃO DA ROTA
SELECT
'redirect' AS component,
'\entidades\auditorias\'||$mensagem_argumentos_incorretos AS link
WHERE $id_auditoria IS NULL;

-- VERIFICA SE O ID_AUDITORIA REALMENTE PERTENCE A UMA AUDITORIA CADASTRADA NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\auditorias\'||$mensagem_auditoria_nao_encontrada AS link
WHERE $id_auditoria_validada_no_banco_de_dados IS NULL;

DELETE FROM auditorias
WHERE id = $id_auditoria::INTEGER
RETURNING
'redirect' AS component,
'\entidades\auditorias\'||$mensagem_auditoria_removida_com_sucesso AS link;
