
/*
    COMPONENTE RESPONSÁVEL PELA EDIÇÃO DE AUDITORIAS

    REQUERIMENTOS:
        1. O requerente deve informar os atributos:
            1.1. id_auditoria (GET)
            1.2. id_base (POST)
            1.3. data_inicial (POST)
            1.4. data_final (POST)
            1.3. evento (POST)
*/

-- VERIFICA SE O REQUERENTE POSSUI PERMISSÃO PARA ACESSAR A ROTA, CASO NÃO TENHA, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','19')) AS properties; -- Permissão 19) Editar auditorias

-- DEFINE AS VARIÁVEIS UTILIZADAS NA ROTA
SET argumentos_corretos = (
    CASE WHEN ($id_auditoria IS NOT NULL AND :base IS NOT NULL AND :data_inicial IS NOT NULL AND :data_final IS NOT NULL AND :evento IS NOT NULL) THEN 'true' ELSE NULL END
);
SET id_auditoria_encontrada = (
    SELECT id
    FROM auditorias a
    WHERE a.id = $id_auditoria::INTEGER
    LIMIT 1
);
SET id_base_encontrada = (
    SELECT id
    FROM bases b
    WHERE b.id = :base::INTEGER
    LIMIT 1
);
SET mensagem_base_alterada_com_sucesso = (
    '?tipo=sucesso&titulo=Alteração realizada com sucesso&mensagem=A auditoria foi atualizado com sucesso'
);
SET mensagem_argumentos_incorretos = (
    '?tipo=erro&titulo=Argumentos incorretos&mensagem=Os argumentos necessários para acessar o endereço estão incorretos'
);
SET mensagem_auditoria_nao_encontrada = (
    '?tipo=erro&titulo=Auditoria não encontrada&mensagem=A auditoria que o usuário está tentando editar não existe no banco de dados'
);

-- VERIFICA SE TODOS OS ARGUMENTOS FORAM INFORMADOS, E CASO NÃO TENHAM, DIRECIONA O REQUERENTE PARA A ROTA \AUDITORIAS\
SELECT
'redirect' AS component,
'\entidades\auditorias\'||$mensagem_argumentos_incorretos AS link
WHERE $argumentos_corretos IS NULL;

-- VERIFICA SE O ID_AUDITORIA INFORMADO REALMENTE PERTENCE A UMA AUDITORIA CADASTRADA NO BANCO DE DADOS
SELECT
'redirect' AS component,
'\entidades\auditorias\'||$mensagem_auditoria_nao_encontrada AS link
WHERE $id_auditoria_encontrada IS NULL;

-- REALIZA A ALTERAÇÃO DA BASE NO BANCO DE DADOS

UPDATE auditorias
SET id_base=:base::INTEGER, data_inicial=:data_inicial::DATE, data_final=:data_final::DATE, pre_auditoria = (:evento = 'pre-auditoria')
WHERE id=$id_auditoria::INTEGER
RETURNING
'redirect' AS component,
'\entidades\auditorias\'||$mensagem_base_alterada_com_sucesso AS link;
