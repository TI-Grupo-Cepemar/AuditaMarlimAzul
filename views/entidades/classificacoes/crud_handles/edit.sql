
/*
    COMPONENTE RESPONSÁVEL PELA EDIÇÃO DE causas

    REQUERIMENTOS:
        1. O requerente deve informar os atributos:
            1.1. id_classificacao (GET)
            1.2. classificacao (POST)
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA, CASO NÃO TENHA, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','36')) AS properties; -- Permissão 36) Editar classificações

-- DEFINE AS VARIÁVEIS UTILIZADAS NA ROTA
SET argumentos_corretos = (
    CASE WHEN ($id_classificacao IS NOT NULL AND :classificacao IS NOT NULL) AND ($id_classificacao ~ '^[0-9]$') THEN 'true' ELSE NULL END
);
SET classificacao_encontrada = (
    SELECT c.id
    FROM classificacoes c
    WHERE c.id = $id_classificacao::INTEGER
    LIMIT 1
);
SET id_classificacao_com_o_nome_informado = (
    SELECT c.id
    FROM classificacoes c
    WHERE c.nome = :classificacao
    LIMIT 1
);
SET mensagem_classificacao_alterada_com_sucesso = (
    '?tipo=sucesso&titulo=Alteração realizada com sucesso&mensagem=A classificação foi atualizada com sucesso'
);
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Argumentos incorretos&mensagem=Os argumentos necessários para acessar o endereço estão incorretos'
);
SET mensagem_classificacao_nao_encontrada = (
    '?tipo=erro&titulo=Classificação não encontrada&mensagem=A classificação que o usuário está tentando editar não existe na base de dados'
);
SET mensagem_edicao_para_uma_classificacao_ja_cadastrada = (
    '?tipo=erro&titulo=Erro na alteração&mensagem=Já existe uma classificação com o nome informado, não é possível ter mais de uma classificação com o mesmo nome'
);

-- VERIFICA SE TODOS OS ARGUMENTOS FORAM INFORMADOS, E CASO NÃO TENHAM, DIRECIONA O REQUERENTE PARA A ROTA \CLASSIFICACOES\
SELECT
'redirect' AS component,
'\entidades\classificacoes\'||$mensagem_argumentos_incorretos AS link
WHERE $argumentos_corretos IS NULL;

-- VERIFICA SE O ID_CLASSIFICACAO INFORMADO REALMENTE PERTENCE A UMA CLASSIFICACAO CADASTRADA NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\classificacoes\'||$mensagem_classificacao_nao_encontrada AS link
WHERE $classificacao_encontrada IS NULL;

-- VERIFICA SE O NOME INFORMADO JÁ PERTENCE A UMA CLASSIFICAÇÃO QUE NÃO SEJA A QUE ESTÁ SENDO EDITADA, OU SEJA, SE ESTÁ QUERENDO EDITAR UMA CLASSIFICAÇÃO PARA OUTRA QUE JÁ ESTÁ CADASTRADA, CASO A SITUAÇÃO ESTEJA ACONTECENDO O REQUERENTE É REDIRECIONADO PARA A ROTA \CLASSIFICACOES\
SELECT
'redirect' AS component,
'\entidades\classificacoes\'||$mensagem_edicao_para_uma_classificacao_ja_cadastrada AS link
WHERE $id_classificacao_com_o_nome_informado IS NOT NULL AND ($id_classificacao_com_o_nome_informado::INTEGER != $id_classificacao::INTEGER)

-- REALIZA A ALTERAÇÃO DA CAUSA NO BANCO DE DADOS
UPDATE classificacoes
SET nome = :classificacao
WHERE id = $id_classificacao::INTEGER
RETURNING
'redirect' AS component,
'\entidades\classificacoes\'||$mensagem_classificacao_alterada_com_sucesso AS link;
