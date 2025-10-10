/*
    COMPONENTE RESPONSÁVEL PELA REMOÇÃO DE STATUS

    1. REQUERIMENTOS:
        1.1. id_status
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','41')) AS properties; -- Permissão 41) Remover status

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro ao remover o status&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_status_nao_encontrado = (
    '?tipo=erro&titulo=Erro ao remover o status&mensagem=Não foi possível encontrar o status solicitado para remoção'
);
SET mensagem_status_removido_com_sucesso = (
    '?tipo=sucesso&titulo=Remoção realizada com sucesso&mensagem=Status removido com sucesso'
);
SET id_status_validado_no_banco_de_dados = (
    SELECT id
    FROM status
    WHERE id = $id_status::INTEGER
    LIMIT 1
);

-- VERIFICA SE O REQUERENTE INFORMOU OS ARGUMENTOS NECESSÁRIOS PARA A EXECUÇÃO DA ROTA
SELECT
'redirect' AS component,
'\entidades\status\'||$mensagem_argumentos_incorretos AS link
WHERE $id_status IS NULL;

-- VERIFICA SE O ID_STATUS REALMENTE PERTENCE A UM STATUS CADASTRADO NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\status\'||$mensagem_status_nao_encontrado AS link
WHERE $id_status_validado_no_banco_de_dados IS NULL;

-- REALIZA A REMOÇÃO DO STATUS NA BASE DE DADOS 
DELETE FROM status
WHERE id = $id_status::INTEGER
RETURNING
'redirect' AS component,
'\entidades\status\'||$mensagem_status_removido_com_sucesso AS link;
