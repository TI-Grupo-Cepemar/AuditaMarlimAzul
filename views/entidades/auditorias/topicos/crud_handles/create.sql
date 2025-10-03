
/*
    COMPONENTE RESPONSÁVEL PELA AÇÃO "CREATE" DE BASES
*/

-- VERIFICA SE O REQUISITANTE POSSUI PERMISSÃO PARA ACESSAR ESSA ROTA, CASO NÃO TENHA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN\
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','13')) AS properties; -- Permissão 13) Cadastrar bases

-- DEFINE AS VARIÁVEIS UTILIZADAS PELA ROTA
SET variaveis_informadas_corretamente = (
    CASE WHEN ((:sigla IS NOT NULL AND :gerente_local IS NOT NULL AND :gerente_regional IS NOT NULL AND :municipio IS NOT NULL) AND (:sigla ~ '^[A-Z]{3,}$')) THEN 'true' ELSE NULL END
);
SET gerente_local_encontrado = (
    SELECT g.id
    FROM gerentes g
    WHERE g.id = :gerente_local::INTEGER
    LIMIT 1
);
SET gerente_regional_encontrado = (
    SELECT g.id
    FROM gerentes g
    WHERE g.id = :gerente_regional::INTEGER
    LIMIT 1
);
SET municipio_encontrado = (
    SELECT m.id
    FROM municipios m
    WHERE m.id = :municipio::INTEGER
    LIMIT 1
);
SET base_ja_cadastrada = (
    SELECT b.id
    FROM bases b
    WHERE b.sigla = :sigla
    LIMIT 1
);
SET parametros_get_base_ja_cadastrada = (
    '?tipo=erro&titulo=Base já cadastrada&mensagem=Não foi possível cadastrar a base devido o cadastro já ter sido realizado.'
);
SET parametros_get_base_cadastrada_com_sucesso = (
    '?tipo=sucesso&titulo=Base cadastrada&mensagem=Cadastro realizado com sucesso.'
);

-- VERIFICA SE O REQUISITANTE FORNECEU OS PARÂMETROS sigla, gerente_loca, gerente_regional, E municipio, E CASO NÃO TENHA FORNECIDO, REDIRECIONA O USUÁRIO PARA A ROTA \LOGIN\
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $variaveis_informadas_corretamente IS NULL;

-- VERIFICA SE O PARÂMETROS INFORMADOS PELO USUÁRIO (CHAVES PRIMÁRIAS) REALMENTE EXISTEM NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $gerente_local_encontrado IS NULL OR $gerente_regional_encontrado IS NULL OR $municipio_encontrado IS NULL

-- VERIFICA SE JÁ HÁ UMA BASE CADASTRADA COM A SIGLA (CÓDIGO IATA) INFORMADA, E CASO HAJA, REDIRECINA PARA A ROTA /BASES/
SELECT
'redirect' AS component,
'\entidades\bases\'||$parametros_get_base_ja_cadastrada AS link
WHERE $base_ja_cadastrada IS NOT NULL;

-- CASO OS DADOS TENHAM SIDO PASSADOS CORRETAMENTE, E A BASE NÃO JÁ ESTEJA PREVIAMENTE CADASTRADO NO SISTEMA, O CADASTRO É REALIZADO
INSERT INTO bases (sigla, id_gerente, id_gerente_regional, id_municipio)
VALUES(:sigla, :gerente_local::INTEGER, :gerente_regional::INTEGER, :municipio::INTEGER)
RETURNING 
'redirect' AS component,
'\entidades\bases\'||$parametros_get_base_cadastrada_com_sucesso AS link;
