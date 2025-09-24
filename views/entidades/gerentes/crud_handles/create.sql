
/*
    COMPONENTE RESPONSÁVEL PELA AÇÃO "CREATE" DE GESTORES
*/

-- VERIFICA SE O REQUISITANTE POSSUI PERMISSÃO PARA ACESSAR ESSA ROTA, CASO NÃO TENHA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','3')) AS properties;

-- DEFINE AS VARIÁVEIS UTILIZADAS PELA ROTA
SET variaveis_informadas_corretamente = (
    CASE WHEN ((:nome IS NOT NULL AND :tipo IS NOT NULL) AND (:tipo = 'local' OR :tipo = 'regional')) THEN 'true' ELSE NULL END
);
SET id_gerente_encontrado_pelo_nome = (
    SELECT id_gestor
    FROM gestores
    WHERE nome = :nome
    LIMIT 1
);
SET parametros_get_gestor_ja_cadastrado = (
    '?tipo=erro&titulo=Gerente já cadastrado&mensagem=Não foi possível cadastrar o gestor devido o cadastro já ter sido realizado.'
);
SET parametros_get_gestor_cadastrado_com_sucesso = (
    '?tipo=sucesso&titulo=Gerente cadastrado&mensagem=Cadastro realizado com sucesso.'
);
SET gerente_regional_informado = (
    CASE WHEN (:tipo = 'regional') THEN 'true' ELSE NULL END
);

-- VERIFICA SE O REQUISITANTE FORNECEU OS PARÂMETROS nome E tipo, E CASO NÃO TENHA FORNECIDO, REDIRECIONA O USUÁRIO PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $variaveis_informadas_corretamente IS NULL;

-- VERIFICA SE JÁ HÁ UM GERENTE CADASTRADO COM O NOME INFORMADO, E CASO HAJA, REDIRECINA PARA A ROTA /GERENTES/
SELECT
'redirect' AS component,
'\entidades\gerentes\'||$parametros_get_gestor_ja_cadastrado AS link
WHERE $id_gerente_encontrado_pelo_nome IS NOT NULL;

-- CASO OS DADOS TENHAM SIDO PASSADOS CORRETAMENTE, E O GESTOR NÃO JÁ ESTEJA PREVIAMENTE CADASTRADO NO SISTEMA, O CADASTRO É REALIZADO
INSERT INTO gestores (nome, e_gerente_regional)
VALUES(:nome, ($gerente_regional_informado IS NOT NULL))
RETURNING 
'redirect' AS component,
'\entidades\gerentes\'||$parametros_get_gestor_cadastrado_com_sucesso AS link;
