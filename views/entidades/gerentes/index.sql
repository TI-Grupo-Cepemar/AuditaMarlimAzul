
/*
    ROTA RESPONSÁVEL PELO CRUD DE GERENTES
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÕES SUFICIENTES PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','3')) AS properties; -- LEMBRANDO QUE O PARÂMETRO PASSADO SE TRATA DA PERMISSÃO MÍNIMA NECESSÁRIA PARA ACESSAR A ROTA

-- RENDERIZA O SHELL OU LAYOUT GENÉRICO DA ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\shell.sql') AS properties;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT
'title' AS component,
'Gerentes' AS contents,
1 AS level,
TRUE AS center;

SELECT -- POPUP QUE APARECERÁ QUANDO O USUÁRIO CLICAR PARA CADASTRAR UM NOVO GERENTE
'modal' AS component,
'cadastroGerente' AS id,
'Cadastrar gerente' AS title,
'\entidades\gerentes\formularios\' AS embed;

SELECT
'button' AS component,
'end' AS justify;
SELECT
'Cadastrar' AS title,
'plus' AS icon,
FALSE AS narrow,
'cadastroGerente' AS modal;

SELECT
'table' AS component,
'Pesquisar...' AS search_placeholder,
'Não há cadastros' AS empty_description,
TRUE AS sort,
TRUE AS search;
-- QUERY QUE PREENCHE A TABELA COM OS GERENTES ARMAZENADOS NO BANCO DE DADOS
SELECT 
ROW_NUMBER() OVER (ORDER BY g.nome) AS "ID",
g.nome AS "Nome", 
CASE WHEN g.e_gerente_regional THEN 'Regional' ELSE 'Local' END AS "Tipo"
FROM gestores g;
