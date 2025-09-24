
/*
    COMPONENTE RESPONSÁVEL POR RENDERIZAR DINÂMICAMENTE O COMPONENTE MODAL
*/

-- CASO O USUÁRIO NÃO POSSUA PERMISSÃO PARA ACESSAR A ROTA, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','0')) AS properties;

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA A EXECUÇÃO DA ROTA
SET parametros_informados = (
    CASE WHEN ($id_modal IS NOT NULL AND $titulo_modal IS NOT NULL AND $url_iframe IS NOT NULL) THEN 'true' ELSE NULL END
);

-- VERIFICA SE O REQUISITANTE INFORMOU OS PARÂMETROS NECESSÁRIOS PARA ACESSAR A ROTA
SELECT
'redirect' AS component,
'\c\login\' As link
WHERE $parametros_informados IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'modal' AS component,
$id_modal AS id,
$titulo_modal AS title,
$url_iframe AS embed;
