
/*
    COMPONENTE RESPONSÁVEL PELA EDIÇÃO DE causas

    REQUERIMENTOS:
        1. O requerente deve informar os atributos:
            1.1. id_causa (GET)
            1.2. causa (POST)
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA, CASO NÃO TENHA, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','32')) AS properties; -- Permissão 32) Editar causas

-- DEFINE AS VARIÁVEIS UTILIZADAS NA ROTA
SET argumentos_corretos = (
    CASE WHEN ($id_causa IS NOT NULL AND :causa IS NOT NULL) AND ($id_causa ~ '^[0-9]$') THEN 'true' ELSE NULL END
);
SET causa_encontrada = (
    SELECT c.id
    FROM causas c
    WHERE c.id = $id_causa::INTEGER
    LIMIT 1
);
SET id_causa_com_o_nome_informado = (
    SELECT c.id
    FROM causas c
    WHERE c.nome = :causa
    LIMIT 1
);
SET mensagem_causa_alterada_com_sucesso = (
    '?tipo=sucesso&titulo=Alteração realizada com sucesso&mensagem=A causa foi atualizada com sucesso'
);
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Argumentos incorretos&mensagem=Os argumentos necessários para acessar o endereço estão incorretos'
);
SET mensagem_causa_nao_encontrada = (
    '?tipo=erro&titulo=Causa não encontrada&mensagem=A causa que o usuário está tentando editar não existe na base de dados'
);
SET mensagem_edicao_para_uma_causa_ja_cadastrada = (
    '?tipo=erro&titulo=Erro na alteração&mensagem=Já existe uma causa com o nome informado, não é possível ter mais de uma causa com o mesmo nome'
);

-- VERIFICA SE TODOS OS ARGUMENTOS FORAM INFORMADOS, E CASO NÃO TENHAM, DIRECIONA O REQUERENTE PARA A ROTA \CAUSAS\
SELECT
'redirect' AS component,
'\entidades\causas\'||$mensagem_argumentos_incorretos AS link
WHERE $argumentos_corretos IS NULL;

-- VERIFICA SE O ID_CAUSA INFORMADO REALMENTE PERTENCE A UMA CAUSA CADASTRADA NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\causas\'||$mensagem_causa_nao_encontrada AS link
WHERE $causa_encontrada IS NULL;

-- VERIFICA SE O NOME INFORMADO JÁ PERTENCE A UMA CAUSA QUE NÃO SEJA A QUE ESTÁ SENDO EDITADA, OU SEJA, SE ESTÁ QUERENDO EDITAR UMA CAUSA PARA OUTRA QUE JÁ ESTÁ CADASTRADA, CASO A SITUAÇÃO ESTEJA ACONTECENDO O REQUERENTE É REDIRECIONADO PARA A ROTA \CAUSAS\
SELECT
'redirect' AS component,
'\entidades\causas\'||$mensagem_edicao_para_uma_causa_ja_cadastrada AS link
WHERE $id_causa_com_o_nome_informado IS NOT NULL AND ($id_causa_com_o_nome_informado::INTEGER != $id_causa::INTEGER)

-- REALIZA A ALTERAÇÃO DA CAUSA NO BANCO DE DADOS
UPDATE causas
SET nome = :causa
WHERE id = $id_causa::INTEGER
RETURNING
'redirect' AS component,
'\entidades\causas\'||$mensagem_causa_alterada_com_sucesso AS link;
