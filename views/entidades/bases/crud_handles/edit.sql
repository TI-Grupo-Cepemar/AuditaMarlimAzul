
/*
    COMPONENTE RESPONSÁVEL PELA EDIÇÃO DE gerentes

    REQUERIMENTOS:
        1. O requerente deve informar os atributos:
            1.1. id_base (GET)
            1.2. sigla (POST)
            1.3. gerente_local (POST)
            1.4. gerente_regional (POST)
            1.5. municipio (POST)
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA, CASO NÃO TENHA, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','14')) AS properties; -- Permissão 14) Editar bases

-- DEFINE AS VARIÁVEIS UTILIZADAS NA ROTA
SET argumentos_corretos = (
    CASE WHEN ($id_base IS NOT NULL AND :sigla IS NOT NULL AND :gerente_local IS NOT NULL AND :gerente_regional IS NOT NULL AND :municipio IS NOT NULL) AND (:sigla ~ '^[A-Z]{3,}$') THEN 'true' ELSE NULL END
);
SET id_base_encontrada = (
    SELECT id
    FROM bases b
    WHERE b.id = $id_base::INTEGER
    LIMIT 1
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
    SELECT id
    FROM municipios m
    WHERE m.id = :municipio::INTEGER
    LIMIT 1
);
SET id_base_com_o_nome_informado_ja_cadastrada = (
    SELECT id
    FROM bases b
    WHERE b.sigla = :sigla AND b.id != $id_base_encontrada::INTEGER
    LIMIT 1
);
SET mensagem_base_alterada_com_sucesso = (
    '?tipo=sucesso&titulo=Alteração realizada com sucesso&mensagem=A base foi atualizado com sucesso'
);
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Argumementos incorretos&mensagem=Os argumentos necessário para acessar o endereço estão incorretos'
);
SET mensagem_base_nao_encontrada = (
    '?tipo=erro&titulo=Base não encontrada&mensagem=A base que o usuário está tentando editar não existe no banco de dados'
);
SET mensagem_edicao_para_uma_base_ja_cadastrada = (
    '?tipo=erro&titulo=Erro na alteração&mensagem=Já existe uma base com a sigla informada, não é possível ter mais de uma base com o mesmo nome'
);

-- VERIFICA SE TODOS OS ARGUMENTOS FORAM INFORMADOS, E CASO NÃO TENHAM, DIRECIONA O REQUERENTE PARA A ROTA \BASES\
SELECT
'redirect' AS component,
'\entidades\bases\'||$mensagem_argumentos_incorretos AS link
WHERE $argumentos_corretos IS NULL;

-- VERIFICA SE O ID_BASE INFORMADO REALMENTE PERTENCE A UMA BASE CADASTRADO NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\bases\'||$mensagem_base_nao_encontrada AS link
WHERE $id_base_encontrada IS NULL;

-- VERIFICA SE A SIGLA INFORMADA JÁ PERTENCE A UMA BASE QUE NÃO SEJA A QUE ESTÁ SENDO EDITADA, OU SEJA, SE ESTÁ QUERENDO EDITAR UMA BASE COM OS DADOS DE OUTRA QUE JÁ ESTÁ CADASTRADA, CASO A SITUAÇÃO ESTEJA ACONTECENDO O REQUERENTE É REDIRECIONADO PARA A ROTA \BASES\
SELECT
'redirect' AS component,
'\entidades\bases\'||$mensagem_edicao_para_uma_base_ja_cadastrada AS link
WHERE $id_base_com_o_nome_informado_ja_cadastrada IS NOT NULL

-- REALIZA A ALTERAÇÃO DA BASE NO BANCO DE DADOS
UPDATE bases
SET sigla = :sigla, id_gerente = :gerente_local::INTEGER, id_gerente_regional = :gerente_regional::INTEGER, id_municipio = :municipio::INTEGER
WHERE id = $id_base::INTEGER
RETURNING
'redirect' AS component,
'\entidades\bases\'||$mensagem_base_alterada_com_sucesso AS link;
