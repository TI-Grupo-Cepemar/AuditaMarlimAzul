
/*
    COMPONENTE RESPONSÁVEL PELA EDIÇÃO DE GESTORES

    REQUERIMENTOS:
        1. O requerente deve informar os atributos:
            1.1. id_gerente (GET)
            1.2. nome (POST)
            1.3. tipo (POST)
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA, CASO NÃO TENHA, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','3')) AS properties;

-- DEFINE AS VARIÁVEIS UTILIZADAS NA ROTA
SET argumentos_corretos = (
    CASE WHEN ($id_gerente IS NOT NULL AND :nome IS NOT NULL AND :tipo IS NOT NULL) THEN 'true' ELSE NULL END
);
SET gestor_encontrado = (
    SELECT id_gestor
    FROM gestores
    WHERE id_gestor = $id_gerente::INTEGER
    LIMIT 1
);
SET id_gestor_com_o_nome_informado = (
    SELECT id_gestor
    FROM gestores
    WHERE nome = :nome
    LIMIT 1
);
SET mensagem_gestor_alterado_com_sucesso = (
    '?tipo=sucesso&titulo=Alteração realizada com sucesso&mensagem=O gerente foi atualizado com sucesso'
);
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Argumementos incorretos&mensagem=Os argumentos necessário para acessar o endereço estão incorretos'
);
SET mensagem_gestor_nao_encontrado = (
    '?tipo=erro&titulo=Gestor não encontrado&mensagem=O gestor que o usuário está tentando editar não existe na base de dados'
);
SET mensagem_edicao_para_um_gestor_ja_cadastrado = (
    '?tipo=erro&titulo=Erro na alteração&mensagem=Já existe um gerente com o nome informado, não é possível ter mais de um gestor com o mesmo nome'
);

-- VERIFICA SE TODOS OS ARGUMENTOS FORAM INFORMADOS, E CASO NÃO TENHAM, DIRECIONA O REQUERENTE PARA A ROTA \GERENTES\
SELECT
'redirect' AS component,
'\entidades\gerentes\'||$mensagem_argumentos_incorretos AS link
WHERE $argumentos_corretos IS NULL;

-- VERIFICA SE O ID_GERENTE INFORMADO REALMENTE PERTENCE A UM GESTOR CADASTRADO NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\gerentes\'||$mensagem_gestor_nao_encontrado AS link
WHERE $gestor_encontrado IS NULL;

-- VERIFICA SE O NOME INFORMADO JÁ PERTENCE A UM GESTOR QUE NÃO SEJA O QUE ESTÁ SENDO EDITADO, OU SEJA, SE ESTÁ QUERENDO EDITAR UM GESTOR PARA OUTRO QUE JÁ ESTÁ CADASTRADO, CASO A SITUAÇÃO ESTEJA ACONTECENDO O REQUERENTE É REDIRECIONADO PARA A ROTA \GERENTES\
SELECT
'redirect' AS component,
'\entidades\gerentes\'||$mensagem_edicao_para_um_gestor_ja_cadastrado AS link
WHERE $id_gestor_com_o_nome_informado IS NOT NULL AND ($id_gestor_com_o_nome_informado::INTEGER != $id_gerente::INTEGER)

-- REALIZA A ALTERAÇÃO DO GESTOR NO BANCO DE DADOS
UPDATE gestores
SET nome = :nome, e_gerente_regional = (:tipo = 'regional')
WHERE id_gestor = $id_gerente::INTEGER
RETURNING
'redirect' AS component,
'\entidades\gerentes\'||$mensagem_gestor_alterado_com_sucesso AS link;
