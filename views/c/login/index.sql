
-- CASO O USUÁRIO NÃO POSSUA COOKIE ARMAZENANDO O TEMA UTILIZADO, CRIA O COOKIE COM O TEMA BRANCO POR PADRÃO
SELECT
'cookie' AS component,
'TEMA' AS name,
'light' AS value,
21600 AS max_age,
FALSE AS secure
WHERE sqlpage.cookie('TEMA') IS NULL;

-- DEFINE AS VARIÁVEIS UTILIZADAS NA ROTA
SET id_usuario_recuperado_pela_sessao = ( -- id do usuário recuperado através do cookie de sessão armazenado no navegador
    SELECT s.id_usuario
    FROM sessoes s
    WHERE s.codigo_sessao = sqlpage.cookie('CODIGO_SESSAO')
);
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

-- CASO O USUÁRIO JÁ POSSUA MA SESSÃO VÁLIDA NO SISTEMA, DIRECIONA O USUÁRIO PARA O BARRA
SELECT
'redirect' AS component,
'/' AS link
WHERE $id_usuario_recuperado_pela_sessao IS NOT NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
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

SELECT
'title' AS component,
'AuditaMarlimAzul' AS contents,
1 AS level,
TRUE AS center;

SELECT
'form' AS component,
'mx-auto' AS class,
'\c\login\autenticador' AS action,
'' AS validate;

SELECT
'text' AS type,
TRUE AS required,
'Insira o usuário aqui' AS placeholder,
'Usuário' AS label,
'usuario' AS name;

SELECT
'password' AS type,
TRUE AS required,
'Insira a senha aqui' AS placeholder,
'Senha' AS label,
'senha' AS name;

SELECT
'submit' As type,
'Acessar' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
