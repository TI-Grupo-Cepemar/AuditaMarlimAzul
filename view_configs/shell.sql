
/*
    ROTA RESPONSÁVEL POR RENDERIZAR LAYOUT GENÉRICO DA PÁGINA
*/

-- DEFINE AS VARIÁVEIS UTILIZADAS NA ROTA
SET tema = (
    sqlpage.cookie('TEMA')
);
SET nome_usuario = (
    SELECT u.nome
    FROM sessoes s
    INNER JOIN usuarios u ON (s.id_usuario = u.id)
    WHERE s.codigo = sqlpage.cookie('CODIGO_SESSAO')
    LIMIT 1
);
SET json_informacoes_usuario = (
    '{
        "title": "'||$nome_usuario||'",
        "icon": "user",
        "submenu": [
            {"title":"Inverter tema", "icon": "'||CASE WHEN $tema = 'light' THEN 'moon' ELSE 'sun' END||'", "link": "\\c\\inverter_tema"}
        ]
    }'
);
SET json_entidades = (
    '{
        "title": "Entidades",
        "icon": "list-details",
        "submenu": [
            {"title": "Gerentes", "icon": "users", "link": "\\entidades\\gerentes\\"},
            {"title": "Bases", "icon": "building-airport", "link": "\\entidades\\bases\\"}
        ]
    }'
);
SET renderiza_alerta = (
    CASE WHEN (($tipo IS NOT NULL AND $titulo IS NOT NULL AND $mensagem IS NOT NULL) AND ($tipo = 'erro' OR $tipo = 'alerta' OR $tipo = 'sucesso')) THEN 'true' ELSE NULL END
);
SET alert_color = (
    CASE WHEN $tipo = 'erro' THEN 'red' WHEN $tipo = 'alerta' THEN 'yellow' WHEN $tipo = 'sucesso' THEN 'green' ELSE 'black' END
);

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT -- COMPONENTE RESPONSÁVEL PELO ESTILO GENÉRICO DA ROTA (A ROTA \LOGIN EM ESPECIAL POSSUI UM SHELL PRÓPRIO, TODAS AS OUTRAS ROTAS UTILIZAM O SHELL EM VIEW_CONFIGS)
'shell' AS component,
'AuditaMarlimAzul' AS title,
'' AS navbar_title,
$tema AS theme,
'' as footer,
'fluid' AS layout,
'\c\css\custom_style.css' AS css,
'\c\imagens\logo_marlim.png' AS image,
'\c\imagens\logo_marlim_favicon.png' AS favicon,
JSON($json_entidades) AS menu_item,
JSON($json_informacoes_usuario) AS menu_item;

-- RENDERIZA O ALERTA DA ROTA CASO OS ARGUMENTOS tipo, titulo, E mensagem FOREM INFORMADOS PELO REQUERENTE
SELECT
'alert' AS component,
$alert_color AS color,
$titulo AS title,
$mensagem AS description,
TRUE AS dismissible,
TRUE AS important,
'position-fixed end-0 bottom-0 me-5' AS class
WHERE $renderiza_alerta IS NOT NULL;
