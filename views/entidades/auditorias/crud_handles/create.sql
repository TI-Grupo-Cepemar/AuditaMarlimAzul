
/*
    COMPONENTE RESPONSÁVEL PELA AÇÃO "CREATE" DE AUDITORIAS

    REQUERIMENTOS:
        1. O requisitante deve informar os seguintes atributos:
            1.1. base
            1.2. data_inicial
            1.3. data_final
            1.4. evento
*/

-- VERIFICA SE O REQUISITANTE POSSUI PERMISSÃO PARA ACESSAR ESSA ROTA, CASO NÃO TENHA, REDIRECIONA O REQUISITANTE PARA A ROTA \AUDITORIAS\
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','18')) AS properties; -- Permissão 18) Cadastrar auditorias

-- DEFINE AS VARIÁVEIS UTILIZADAS PELA ROTA
SET variaveis_informadas_corretamente = (
    CASE WHEN ((:base IS NOT NULL AND :data_inicial IS NOT NULL AND :data_final IS NOT NULL AND :evento IS NOT NULL) AND (:base ~ '^[1-9][0-9]*$' AND :data_inicial ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' AND :data_final ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' AND (:evento = 'auditoria' OR :evento = 'pre-auditoria'))) THEN 'true' ELSE NULL END
);
SET id_base_encontrada = (
    SELECT id
    FROM bases
    WHERE id = :base::INTEGER
    LIMIT 1
);
-- SET parametros_get_auditoria_ja_cadastrada = (
--     '?tipo=erro&titulo=Auditoria já cadastrada&mensagem=Não foi possível cadastrar a base devido o cadastro já ter sido realizado.'
-- );
SET parametros_get_auditoria_cadastrada_com_sucesso = (
    '?tipo=sucesso&titulo=Auditoria cadastrada&mensagem=Cadastro realizado com sucesso.'
);

-- VERIFICA SE O REQUISITANTE FORNECEU OS PARÂMETROS base, data_inicial, data_final, E pre_auditoria, E CASO NÃO TENHA FORNECIDO, REDIRECIONA O USUÁRIO PARA A ROTA \LOGIN\
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $variaveis_informadas_corretamente IS NULL;

-- VERIFICA SE O PARÂMETROS INFORMADOS PELO USUÁRIO (CHAVES PRIMÁRIAS) REALMENTE EXISTEM NO BANCO DE DADOS, E CASO NÃO EXISTAM, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN\
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_base_encontrada IS NULL

-- -- VERIFICA SE JÁ HÁ UMA AUDITORIA CADASTRADA PARA A MESMA BASE, E QUE AS DATAS DE REALIZAÇÃO SE CONFLUEM COM AS DATAS DA AUDITORIA QUE SE DESEJA CADASTRAR, CASO HAJA, REDIRECINA PARA A ROTA /AUDITORIAS/
-- SELECT
-- 'redirect' AS component,
-- '\entidades\auditorias\'||$parametros_get_auditoria_ja_cadastrada AS link
-- WHERE $base_ja_cadastrada IS NOT NULL;

-- CASO OS DADOS TENHAM SIDO PASSADOS CORRETAMENTE, E A BASE NÃO JÁ ESTEJA PREVIAMENTE CADASTRADADA NO SISTEMA, O CADASTRO É REALIZADO
INSERT INTO auditorias (id_base, data_inicial, data_final, pre_auditoria)
VALUES(:base::INTEGER, :data_inicial::DATE, :data_final::DATE, :evento = 'pre-auditoria')
RETURNING 
'redirect' AS component,
'\entidades\auditorias\'||$parametros_get_auditoria_cadastrada_com_sucesso AS link;
