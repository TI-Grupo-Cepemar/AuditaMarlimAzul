
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

-- VERIFICA SE O REQUISITANTE INFORMOU A FUNÇÃO NECESSÁRIA PARA ACESSAR A ROTA, E CASO NÃO TENHA INFORMADO, REDIRECINA O USUÁRIO PARA A ROTA \LOGIN\
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE ($funcao IS NULL OR $funcao !~ '^[1-9][0-9]*$'); -- A ÚLTIMA VERIFICAÇÃO VERIFICA SE O ATRIBUTO "funcao" É UM NÚMERO

-- DEFINE AS VARIÁVEIS NECESSÁRIAS NA ROTA
SET id_usuario = (
    SELECT id_usuario 
    FROM sessoes s 
    WHERE s.codigo = sqlpage.cookie('CODIGO_SESSAO')
);
SET usuario_possui_permissao = (
    SELECT fp.id
    FROM usuarios u
    INNER JOIN funcoes_permissoes fp ON (fp.id_funcao = u.id_funcao)
    WHERE (u.id = $id_usuario::INTEGER AND fp.id_permissao = $funcao::INTEGER)
    LIMIT 1
);
SET alerta = (
    '?tipo=erro&titulo=Operação não permitida&mensagem=O usuário não possui permissão para realizar essa ação, entre em contato com o administrador do sistema solicitando que a permissão seja concedida.'
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
'\'||$alerta AS link
WHERE $usuario_possui_permissao IS NULL;
