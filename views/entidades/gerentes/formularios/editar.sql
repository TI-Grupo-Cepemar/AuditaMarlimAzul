
/*
    COMPONENTE RESPONSÁVEL POR CONTER OS CAMPOS UTILIZADOS NO FORMULÁRIO DE EDIÇÃO DO GERENTE

    1. REQUERIMENTOS:
        1.1. id_gerente
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÃO PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','2')) AS properties;

-- VERIFICA SE O USUÁRIO INFORMOU OS DADOS NECESSÁRIO PARA ENCONTRAR O GESTOR NO BANCO DE DADOS, CASO O REQUISITANTE NÃO TENHA INFORMADO, REDIRECIONA PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_gerente IS NULL;

-- DEFINE AS VARIÁVEIS NECESSÁRIAS PARA EXECUTAR A ROTA
SET nome_gerente = (
    SELECT nome
    FROM gestores
    WHERE id_gestor = $id_gerente::INTEGER
    LIMIT 1
);
SET tipo_gerente = (
    SELECT CASE WHEN e_gerente_regional THEN 'regional' ELSE 'local' END
    FROM gestores
    WHERE id_gestor = $id_gerente::INTEGER
    LIMIT 1
);

-- VERIFICA SE O GERENTE SOLICITADO PARA EDIÇÃO É UM GERENTE VÁLIDO CADASTRADO NO BANCO DE DADOS, CASO NÃO SEJA, REDIRECIONA O REQUISITANTE PARA A ROTA \LOGIN
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $nome_gerente IS NULL;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'form' AS component,
'\entidades\gerentes\crud_handles\edit?id_gerente='||$id_gerente AS action,
'' AS validate;
SELECT
'text' AS type,
'Nome' AS label,
'nome' AS name,
$nome_gerente AS value,
TRUE AS required;

SELECT
'select' AS type,
'Tipo' AS label,
'tipo' AS name,
TRUE AS required,
json_object('label':'Local',     'value':'local') AS options,
json_object('label':'Regional',  'value':'regional') AS options,
$tipo_gerente AS value;

SELECT
'submit' AS type,
'Salvar alterações' AS value,
'mt-3 bg-primary text-white fw-bold' AS class;
