
/*
    COMPONENTE RESPONSÁVEL PELA CONFIRMAÇÃO DE REMOÇÃO DE UM GESTOR

    1. REQUERIMENTOS
        1.1. id_base (GET)
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','12')) AS properties; -- Permissão 12) Visualizar bases

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_base_nao_encontrada_no_banco_de_dados = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Base não encontrada na base de dados'
);
SET id_base_encontrada_no_banco_de_dados = (
    SELECT b.id
    FROM bases b
    WHERE b.id = $id_base::INTEGER
    LIMIT 1
);
SET sigla_base = (
    SELECT b.sigla
    FROM bases b
    WHERE b.id = $id_base::INTEGER
    LIMIT 1
);
SET parametros_get_remover_gestor = (
    '?id_base='||$id_base
);

-- VERIFICA SE O USUÁRIO INFORMOU OS ARGUMENTOS NECESSÁRIO PARA A ROTA
SELECT
'redirect' AS component,
'\entidades\bases\'||$mensagem_argumentos_incorretos AS link
WHERE $id_base IS NULL;

-- VERIFICA SE O ID_BASE INFORMADO PERTENCE REALMENTE A UMA BASE VÁLIDA CADASTRADA NO BANCO DE DADOS, E CASO CONTRÁRIO, REDIRECIONA O REQUERENTE PARA O \BASES\
SELECT
'redirect' AS component,
'\entidades\bases\'||$mensagem_base_nao_encontrada_no_banco_de_dados AS link
WHERE $id_base_encontrada_no_banco_de_dados IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'text' AS component,
'Confirma a remoção da base "'||$sigla_base||'"?' AS contents;

SELECT
'button' AS component,
'end' As justify;
--SELECT
--'Cancelar' AS 'title';
SELECT
'Confirmar' AS title,
'red' AS color,
'\entidades\bases\crud_handles\delete'||$parametros_get_remover_gestor AS link;
