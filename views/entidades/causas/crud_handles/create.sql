
/*
    COMPONENTE RESPONSÁVEL PELA AÇÃO "CREATE" DE GESTORES
*/

-- VERIFICA SE O REQUISITANTE POSSUI PERMISSÃO PARA ACESSAR ESSA ROTA, CASO NÃO TENHA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN\
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','31')) AS properties; -- Permissão 31) Cadastrar causas

-- DEFINE AS VARIÁVEIS UTILIZADAS PELA ROTA
SET variaveis_informadas_corretamente = (
    CASE WHEN (:causa IS NOT NULL) THEN 'true' ELSE NULL END
);
SET id_causa_encontrada_pelo_nome = (
    SELECT c.id
    FROM causas c
    WHERE c.nome = :causa
    LIMIT 1
);
SET parametros_get_causa_ja_cadastrada = (
    '?tipo=erro&titulo=Causa já cadastrada&mensagem=Não foi possível cadastrar a causa devido o cadastro já ter sido realizado.'
);
SET parametros_get_causa_cadastrada_com_sucesso = (
    '?tipo=sucesso&titulo=Causa cadastrada&mensagem=Cadastro realizado com sucesso.'
);

-- VERIFICA SE O REQUISITANTE FORNECEU O PARÂMETRO causa, E CASO NÃO TENHA FORNECIDO, REDIRECIONA O USUÁRIO PARA A ROTA \LOGIN\
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $variaveis_informadas_corretamente IS NULL;

-- VERIFICA SE JÁ HÁ UMA CAUSA CADASTRADA COM O NOME INFORMADO, E CASO HAJA, REDIRECINA PARA A ROTA /CAUSAS/
SELECT
'redirect' AS component,
'\entidades\causas\'||$parametros_get_causa_ja_cadastrada AS link
WHERE $id_causa_encontrada_pelo_nome IS NOT NULL;

-- CASO OS DADOS TENHAM SIDO PASSADOS CORRETAMENTE, E O GESTOR NÃO JÁ ESTEJA PREVIAMENTE CADASTRADO NO SISTEMA, O CADASTRO É REALIZADO
INSERT INTO causas(nome)
VALUES (:causa)
RETURNING 
'redirect' AS component,
'\entidades\causas\'||$parametros_get_causa_cadastrada_com_sucesso AS link;
