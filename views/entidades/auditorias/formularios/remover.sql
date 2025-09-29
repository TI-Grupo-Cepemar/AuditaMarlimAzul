
/*
    COMPONENTE RESPONSÁVEL PELA CONFIRMAÇÃO DE REMOÇÃO DE UM GESTOR

    1. REQUERIMENTOS
        1.1. id_auditoria (GET)
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','17')) AS properties; -- Permissão 12) Visualizar auditorias

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Os argumentos informados estão incorretos'
);
SET mensagem_auditoria_nao_encontrada_no_banco_de_dados = (
    '?tipo=erro&titulo=Erro durante a remoção&mensagem=Auditoria não encontrada na base de dados'
);
SET id_auditoria_encontrada_no_banco_de_dados = (
    SELECT id
    FROM auditorias a
    WHERE a.id = $id_auditoria::INTEGER
    LIMIT 1
);
SET sigla_base_auditoria =(
    SELECT CONCAT(b.sigla,' (',TO_CHAR(a.data_inicial,'dd/MM/yyyy'),' à ',TO_CHAR(a.data_final,'dd/MM/yyyy'),')')
    FROM auditorias a
    INNER JOIN bases b ON (a.id_base = b.id)
    LIMIT 1
);
SET data_inicial_auditoria = (
    SELECT TO_CHAR(a.data_inicial,'dd/MM/yyyy')
    FROM auditorias a
    LIMIT 1
);
SET data_final_auditoria = (
    SELECT TO_CHAR(a.data_final,'dd/MM/yyyy')
    FROM auditorias a
    LIMIT 1
);
SET parametros_get_remover_gestor = (
    '?id_auditoria='||$id_auditoria
);

-- VERIFICA SE O USUÁRIO INFORMOU OS ARGUMENTOS NECESSÁRIO PARA A ROTA
SELECT
'redirect' AS component,
'\entidades\auditorias\'||$mensagem_argumentos_incorretos AS link
WHERE $id_auditoria IS NULL;

-- VERIFICA SE O ID_AUDITORIA INFORMADO PERTENCE REALMENTE A UMA AUDITORIA VÁLIDA CADASTRADA NO BANCO DE DADOS, E CASO CONTRÁRIO, REDIRECIONA O REQUERENTE PARA O \AUDITORIAS\
SELECT
'redirect' AS component,
'\entidades\auditorias\'||$mensagem_auditoria_nao_encontrada_no_banco_de_dados AS link
WHERE $id_auditoria_encontrada_no_banco_de_dados IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'text' AS component,
'Confirma a remoção da auditoria "'||$sigla_base_auditoria||'"?' AS contents;

SELECT
'button' AS component,
'end' As justify;
SELECT
'Confirmar' AS title,
'red' AS color,
'\entidades\auditorias\crud_handles\delete'||$parametros_get_remover_gestor AS link;
