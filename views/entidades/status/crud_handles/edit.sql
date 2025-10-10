
/*
    COMPONENTE RESPONSÁVEL PELA EDIÇÃO DE gerentes

    REQUERIMENTOS:
        1. O requerente deve informar os atributos:
            1.1. id_status (GET)
            1.2. status (POST)
            1.3. cor (POST)
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA, CASO NÃO TENHA, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','40')) AS properties; -- Permissão 10) Editar status

-- DEFINE AS VARIÁVEIS UTILIZADAS NA ROTA
SET argumentos_corretos = (
    CASE WHEN ($id_status IS NOT NULL AND :status IS NOT NULL AND :cor IS NOT NULL) AND (:cor ~ '^#[\dA-Fa-f]{6}$' AND $id_status ~ '^[0-9]+$') THEN 'true' ELSE NULL END
);
SET status_encontrado = (
    SELECT id
    FROM status
    WHERE id = $id_status::INTEGER
    LIMIT 1
);
SET id_status_com_o_nome_informado = (
    SELECT id
    FROM status
    WHERE nome = :status
    LIMIT 1
);
SET mensagem_status_alterado_com_sucesso = (
    '?tipo=sucesso&titulo=Alteração realizada com sucesso&mensagem=O status foi atualizado com sucesso'
);
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Argumentos incorretos&mensagem=Os argumentos necessário para acessar o endereço estão incorretos'
);
SET mensagem_status_nao_encontrado = (
    '?tipo=erro&titulo=Status não encontrado&mensagem=O status que o usuário está tentando editar não existe na base de dados'
);
SET mensagem_edicao_para_um_status_ja_cadastrado = (
    '?tipo=erro&titulo=Erro na alteração&mensagem=Já existe um status com o nome informado, não é possível ter mais de um status com o mesmo nome'
);

-- VERIFICA SE TODOS OS ARGUMENTOS FORAM INFORMADOS, E CASO NÃO TENHAM, DIRECIONA O REQUERENTE PARA A ROTA \STATUS\
SELECT
'redirect' AS component,
'\entidades\status\'||$mensagem_argumentos_incorretos AS link
WHERE $argumentos_corretos IS NULL;

-- VERIFICA SE O ID_STATUS INFORMADO REALMENTE PERTENCE A UM STATUS CADASTRADO NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\status\'||$mensagem_status_nao_encontrado AS link
WHERE $status_encontrado IS NULL;

-- VERIFICA SE O NOME INFORMADO JÁ PERTENCE A UM STATUS QUE NÃO SEJA O QUE ESTÁ SENDO EDITADO, OU SEJA, SE ESTÁ QUERENDO EDITAR UM STATUS PARA OUTRO QUE JÁ ESTÁ CADASTRADO, CASO A SITUAÇÃO ESTEJA ACONTECENDO O REQUERENTE É REDIRECIONADO PARA A ROTA \STATUS\
SELECT
'redirect' AS component,
'\entidades\status\'||$mensagem_edicao_para_um_status_ja_cadastrado AS link
WHERE $id_status_com_o_nome_informado IS NOT NULL AND ($id_status_com_o_nome_informado::INTEGER != $id_status::INTEGER)

-- REALIZA A ALTERAÇÃO DO STATUS NO BANCO DE DADOS
UPDATE status
SET nome = :status, coloracao = :cor
WHERE id = $id_status::INTEGER
RETURNING
'redirect' AS component,
'\entidades\status\'||$mensagem_status_alterado_com_sucesso AS link;
