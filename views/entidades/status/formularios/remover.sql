
/*
    COMPONENTE RESPONSÁVEL PELA CONFIRMAÇÃO DE REMOÇÃO DE UM STATUS

    1. REQUERIMENTOS
        1.1. id_status (GET)
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','38')) AS properties; -- Permissão 38) Visualizar status

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_status_nao_encontrado_no_banco_de_dados = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Status não encontrado na base de dados'
);
SET id_status_encontrado_no_banco_de_dados = (
    SELECT id
    FROM status
    WHERE id = $id_status::INTEGER
    LIMIT 1
);
SET nome_status = (
    SELECT nome
    FROM status
    WHERE id = $id_status::INTEGER
    LIMIT 1
);
SET parametros_get_remover_status = (
    '?id_status='||$id_status
);

-- VERIFICA SE O USUÁRIO INFORMOU OS ARGUMENTOS NECESSÁRIO PARA A ROTA
SELECT
'redirect' AS component,
'\entidades\status\'||$mensagem_argumentos_incorretos AS link
WHERE $id_status IS NULL;

-- VERIFICA SE O ID_STATUS INFORMADO PERTENCE REALMENTE A UM STATUS VÁLIDO CADASTRADO NO BANCO DE DADOS, E CASO CONTRÁRIO, REDIRECIONA O REQUERENTE PARA O \STATUS\
SELECT
'redirect' AS component,
'\entidades\status\'||$mensagem_status_nao_encontrado_no_banco_de_dados AS link
WHERE $id_status_encontrado_no_banco_de_dados IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'text' AS component,
'Confirma a remoção do status(a) "'||$nome_status||'"?' AS contents;

SELECT
'button' AS component,
'end' As justify;
SELECT
'Confirmar' AS title,
'red' AS color,
'\entidades\status\crud_handles\delete'||$parametros_get_remover_status AS link;
