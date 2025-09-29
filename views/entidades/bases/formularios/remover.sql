
/*
    COMPONENTE RESPONSÁVEL PELA CONFIRMAÇÃO DE REMOÇÃO DE UM GESTOR

    1. REQUERIMENTOS
        1.1. id_gerente (GET)
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','12')) AS properties; -- Permissão 12) Visualizar bases

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_gerente_nao_encontrado_no_banco_de_dados = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Gerente não encontrado na base de dados'
);
SET id_gerente_encontrado_no_banco_de_dados = (
    SELECT id
    FROM gerentes
    WHERE id = $id_gerente::INTEGER
    LIMIT 1
);
SET nome_gerente = (
    SELECT nome
    FROM gerentes
    WHERE id = $id_gerente::INTEGER
    LIMIT 1
);
SET parametros_get_remover_gestor = (
    '?id_gerente='||$id_gerente
);

-- VERIFICA SE O USUÁRIO INFORMOU OS ARGUMENTOS NECESSÁRIO PARA A ROTA
SELECT
'redirect' AS component,
'\entidades\gerentes\'||$mensagem_argumentos_incorretos AS link
WHERE $id_gerente IS NULL;

-- VERIFICA SE O ID_GERENTE INFORMADO PERTENCE REALMENTE A UM GERENTE VÁLIDO CADASTRADO NO BANCO DE DADOS, E CASO CONTRÁRIO, REDIRECIONA O REQUERENTE PARA O \GERENTES\
SELECT
'redirect' AS component,
'\entidades\gerentes\'||$mensagem_gerente_nao_encontrado_no_banco_de_dados AS link
WHERE $id_gerente_encontrado_no_banco_de_dados IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'text' AS component,
'Confirma a remoção do gestor(a) "'||$nome_gerente||'"?' AS contents;

SELECT
'button' AS component,
'end' As justify;
--SELECT
--'Cancelar' AS 'title';
SELECT
'Confirmar' AS title,
'red' AS color,
'\entidades\gerentes\crud_handles\delete'||$parametros_get_remover_gestor AS link;
