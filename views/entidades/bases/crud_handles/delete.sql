/*
    COMPONENTE RESPONSÁVEL PELA REMOÇÃO DE GERENTES

    1. REQUERIMENTOS:
        1.1. id_base
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','15')) AS properties; -- Permissão 15) Remover base

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro ao remover a base&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_base_nao_encontrada = (
    '?tipo=erro&titulo=Erro ao remover o gerente&mensagem=Não foi possível encontrar o gerente solicitado para remoção'
);
SET mensagem_base_removida_com_sucesso = (
    '?tipo=sucesso&titulo=Remoção realizada com sucesso&mensagem=Base removida com sucesso'
);
SET id_base_validada_no_banco_de_dados = (
    SELECT b.id
    FROM bases b
    WHERE b.id = $id_base::INTEGER
    LIMIT 1
);

-- VERIFICA SE O REQUERENTE INFORMOU OS ARGUMENTOS NECESSÁRIOS PARA A EXECUÇÃO DA ROTA
SELECT
'redirect' AS component,
'\entidades\bases\'||$mensagem_argumentos_incorretos AS link
WHERE $id_base IS NULL;

-- VERIFICA SE O ID_BASE REALMENTE PERTENCE A UMA BASE CADASTRADA NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\bases\'||$mensagem_base_nao_encontrada AS link
WHERE $id_base_validada_no_banco_de_dados IS NULL;

DELETE FROM bases
WHERE id = $id_base::INTEGER
RETURNING
'redirect' AS component,
'\entidades\bases\'||$mensagem_base_removida_com_sucesso AS link;
