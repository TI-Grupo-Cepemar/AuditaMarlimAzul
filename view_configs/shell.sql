
/*
    ROTA RESPONSÁVEL POR RENDERIZAR LAYOUT GENÉRICO DA PÁGINA
*/

-- DEFINE AS VARIÁVEIS UTILIZADAS NA ROTA
SET tema = (
    sqlpage.cookie('TEMA')
);
SET json_mudar_tema = (
    '{
        "title": "Inverter tema",
        "icon": "'||CASE WHEN $tema = 'light' THEN 'moon' ELSE 'sun' END||'",
        "link": "\\c\\inverter_tema"
    }'
);

SELECT -- COMPONENTE RESPONSÁVEL PELO ESTILO GENÉRICO DA ROTA (A ROTA LOGIN EM ESPECIAL POSSUI UM SHELL PRÓPRIO, TODAS AS OUTRAS ROTAS UTILIZAM O SHELL EM VIEW_CONFIGS)
'shell' AS component,
'AuditaMarlimAzul' AS title,
'' AS navbar_title,
$tema AS theme,
'' as footer,
'fluid' AS layout,
'\c\css\custom_style.css' AS css,
'\c\imagens\logo_marlim.png' AS image,
'\c\imagens\logo_marlim_favicon.png' AS favicon,
JSON($json_mudar_tema) AS menu_item;
