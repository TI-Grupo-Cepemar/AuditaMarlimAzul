
/*
    ARQUIVO RESPONSÁVEL POR CONTROLAR E PERMITIR SE O USUÁRIO TEM PERMISSÕES SUFICIENTES PARA ACESSAR A PÁGINA

    Requerimentos:
        1.  Passar a função mínima de acesso a rotina. Um parâmetro de nome "funcao" que recebe 
            um inteiro como valor, representando o menor nível de acesso requerido para acessar
            a rota.
*/

-- VERIFICA SE O USUÁRIO AO MENOS POSSUI UM COOKIE DE SESSÃO GRAVADO NO NAVEGADOR
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE sqlpage.cookie('CODIGO_SESSAO') IS NULL;

-- DEFINE AS VARIÁVEIS NECESSÁRIAS NA ROTA
SET id_usuario = (
    SELECT id_usuario 
    FROM sessoes s 
    WHERE s.codigo_sessao = sqlpage.cookie('CODIGO_SESSAO')
);
SET maxima_permissao_usuario = (
    SELECT MAX(fp.id_permissoes) AS "permissao_maxima"
    FROM usuarios u
    INNER JOIN funcao_permissoes fp ON (fp.id_funcao = u.id_funcao)
    WHERE u.id_usuario = $id_usuario::INTEGER
);

-- VERIFICA SE O USUÁRIO POSSUI UMA SESSÃO ATIVA, E CASO NÃO TENHA, REDIRECIONA O USUÁRIO PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_usuario IS NULL;

/*
    VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA SOLICITADA,
    CASO NÃO TENHA, OU A PERMISSÃO SOLICITADA PELA ROTINA NÃO SEJA INFORMADA, 
    DIRECIONA O USUÁRIO PARA O /LOGIN, PARA PROSSEGUIR O USUÁRIO PRECISA 
    TER UMA PERMISSÃO DE ID MAIOR QUE O ID MÍNIMO DA ROTA
*/
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $funcao IS NULL OR ($funcao::INTEGER > $maxima_permissao_usuario::INTEGER);
