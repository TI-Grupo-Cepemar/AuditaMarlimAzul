/*
    COMPONENTE RESPONSÁVEL POR REALIZA A AUTENTICAÇÃO DO USUÁRIO NO SISTEMA

    Requerimentos:
        1. Informar os atributos (via método POST):
            1.1) usuario
            1.2) senha.
*/

-- DEFINE AS VARIÁVEIS UTILIZADAS NA ROTA
SET atributos_informados = (
    CASE WHEN ($usuario IS NOT NULL AND $senha IS NOT NULL) THEN '1' ELSE NULL END
);
SET senha_usuario_requisitante = (
    SELECT senha_hash
    FROM usuarios
    WHERE usuario = :usuario
);
SET id_usuario_requisitante = (
    SELECT id_usuario
    FROM usuarios
    WHERE usuario = :usuario
);
SET codigo_sessao_criada = (
    sqlpage.random_string(18)||TO_CHAR(NOW(), 'YYMMDDHH24MISS')
);

-- VERIFICA SE FOI INFORMADO O USUÁRIO E A SENHA, E CASO NÃO CONTRÁRIO REDIRECIONA O USUÁRIO PARA A ROTA /LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $atributos_informados IS NULL;

-- VERIFICA SE AS CREDENCIAIS INFORMADAS ESTÃO CORRETAS, E CASO CONTRÁRIO, REDIRECIONA O USUÁRIO PARA A ROTA /LOGIN
SELECT
'authentication' AS component,
'\c\login\?titulo=Credenciais incorretas&mensagem=Favor tente novamente.' AS link,
:senha AS password,
$senha_usuario_requisitante AS password_hash;

/*  
    CASO O USUÁRIO TENHA INSERIDO AS CREDENCIAIS DE ACESSO CORRETAS (VERIFICADAS NA INSTRUÇÃO ANTERIOR), 
    CASO UM OU MAIS CÓDIGOS DE SESSÃO EXISTAM PARA AQUELE USUÁRIO (MAS NÃO ESTEJA GRAVADO EM UM COOKIE NO NAVEGADOR DO REQUISITANTE) 
    A(S) SESSÕES SÃO APAGADAS, O CÓDIGO DE SESSÃO É CRIADO (MAIS ACIMA NO CÓDIGO, NA PARTE DE DEFINIÇÕES DE VARIÁVEIS), ARMAZENADO NO 
    BANCO DE DADOS, E O COOKIE CONTENDO O CÓDIGO DE SESSÃO É GRAVADO NO NAVEGADOR DO REQUISITANTE, APÓS ESSE PROCESSO O USUÁRIO É 
    DIRECIONADO PARA A ROTA "/", OU SEJA "/INDEX"
*/

DELETE FROM sessoes
WHERE id_usuario = $id_usuario_requisitante::INTEGER;

INSERT INTO sessoes (id_usuario, codigo_sessao)
VALUES($id_usuario_requisitante::INTEGER, $codigo_sessao_criada);

SELECT
'cookie' AS component,
'CODIGO_SESSAO' AS name,
$codigo_sessao_criada AS value,
false AS secure,
21600 AS max_age;

SELECT
'redirect' AS component,
'\' AS link;
