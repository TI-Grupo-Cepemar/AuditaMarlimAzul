/*
    COMPONENTE RESPONSÁVEL PELA REMOÇÃO DE GESTORES

    1. REQUERIMENTOS:
        1.1. id_gerente
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','3')) AS properties;

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro ao remover o gerente&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_gestor_nao_encontrado = (
    '?tipo=erro&titulo=Erro ao remover o gerente&mensagem=Não foi possível encontrar o gerente solicitado para remoção'
);
SET mensagem_gestor_removido_com_sucesso = (
    '?tipo=sucesso&titulo=Remoção realizada com sucesso&mensagem=Gestor removido com sucesso'
);
SET id_gerente_validado_no_banco_de_dados = (
    SELECT id_gestor
    FROM gestores
    WHERE id_gestor = $id_gerente::INTEGER
    LIMIT 1
);

-- VERIFICA SE O REQUERENTE INFORMOU OS ARGUMENTOS NECESSÁRIOS PARA A EXECUÇÃO DA ROTA
SELECT
'redirect' AS component,
'\entidades\gerentes\'||$mensagem_argumentos_incorretos AS link
WHERE $id_gerente IS NULL;

-- VERIFICA SE O ID_GERENTE REALMENTE PERTENCE A UM GESTOR CADASTRADO NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\gerentes\'||$mensagem_gestor_nao_encontrado AS link
WHERE $id_gerente_validado_no_banco_de_dados IS NULL;

DELETE FROM gestores
WHERE id_gestor = $id_gerente::INTEGER
RETURNING
'redirect' AS component,
'\entidades\gerentes\'||$mensagem_gestor_removido_com_sucesso AS link;
