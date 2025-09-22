
/*
    ARQUIVO RESPONSÁVEL POR RENDERIZAR LAYOUT GENÉRICO DA PÁGINA
*/

SELECT
'shell' AS component,
sqlpage.cookie('TEMA') AS theme,
'\c\css\custom_style.css' AS css,
'' AS footer,
'fluid' AS layout,
'Teste' AS title;
