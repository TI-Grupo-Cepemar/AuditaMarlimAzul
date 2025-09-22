
-- ARMAZENA O VALOR ATUAL DO COOKIE
SET novo_valor_cookie = (
    CASE WHEN sqlpage.cookie('TEMA') = 'light' THEN 'dark' ELSE 'light' END
);

-- APAGA O COOKIE ANTERIORMENTE UTILIZADO
SELECT
'cookie' AS component,
'TEMA' AS name,
TRUE AS remove;

-- RECRIA O COOKIE QUE ARMAZENA O TEMA
SELECT
'cookie' AS component,
'TEMA' AS name,
$novo_valor_cookie AS value,
21600 AS max_age,
FALSE AS secure;

-- DIRECIONA O USUÁRIO PARA A ÚLTIMA PÁGINA ACESSADA
SELECT
'go-to-last-page' AS component;
