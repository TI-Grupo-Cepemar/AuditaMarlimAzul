
/*
    ROTA RESPONSÁVEL PELO CRUD DE GERENTES
*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÕES SUFICIENTES PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','9')) AS properties; -- Permissão 9) Visualizar gestores

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

SELECT -- POPUP QUE APARECERÁ QUANDO O REQUISITANTE CLICAR PARA CADASTRAR UM NOVO GERENTE
'modal' AS component,
'cadastroGerente' AS id,
'Cadastrar gerente' AS title,
'\entidades\gerentes\formularios\' AS embed;

SELECT -- POPUP QUE APARECERÁ QUANDO O REQUISITANTE CLICAR EM EDITAR UM GERENTE
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\componentes_dinamicos\modal.sql', json_object('id_modal':'modal_editar_'||g.id,'titulo_modal':'Editar gestor','url_iframe':'\entidades\gerentes\formularios\editar?id_gerente='||g.id)) AS properties
FROM gerentes g;

SELECT -- POPUP QUE APARECERÁ QUANDO O REQUISITANTE CLICAR EM REMOVER UM GERENTE
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\componentes_dinamicos\modal.sql', json_object('id_modal':'modal_remover_'||g.id,'titulo_modal':'Remover gestor','url_iframe':'\entidades\gerentes\formularios\remover?id_gerente='||g.id)) AS properties
FROM gerentes g;

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
TRUE AS search,
'Ações' AS markdown;
-- QUERY QUE PREENCHE A TABELA COM OS GERENTES ARMAZENADOS NO BANCO DE DADOS
SELECT 
ROW_NUMBER() OVER (ORDER BY g.id) AS "ID",
g.nome AS "Nome", 
CASE WHEN g.regional THEN 'Regional' ELSE 'Local' END AS "Tipo",
'<div class="dropdown">
  <a href="#" class="btn dropdown-toggle" data-bs-toggle="dropdown"><svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-dots"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12m-1 0a1 1 0 1 0 2 0a1 1 0 1 0 -2 0" /><path d="M12 12m-1 0a1 1 0 1 0 2 0a1 1 0 1 0 -2 0" /><path d="M19 12m-1 0a1 1 0 1 0 2 0a1 1 0 1 0 -2 0" /></svg></a>
  <div class="dropdown-menu">
    <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#modal_editar_'||g.id||'"><svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-edit"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 7h-1a2 2 0 0 0 -2 2v9a2 2 0 0 0 2 2h9a2 2 0 0 0 2 -2v-1" /><path d="M20.385 6.585a2.1 2.1 0 0 0 -2.97 -2.97l-8.415 8.385v3h3l8.385 -8.415z" /><path d="M16 5l3 3" /></svg>Editar</a>
    <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#modal_remover_'||g.id||'"><svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-trash"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M4 7l16 0" /><path d="M10 11l0 6" /><path d="M14 11l0 6" /><path d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12" /><path d="M9 7v-3a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v3" /></svg>Remover</a>
  </div>
</div>' AS "Ações"
FROM gerentes g;
