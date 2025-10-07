
/*
    ROTA RESPONSÁVEL PELO CRUD DE BASES

    REQUERIMENTOS:
      1. O requisitante deve ter a permissão "21) Visualizar tópicos"
      2. O requisitante deve informar os seguintes atributos
        2.1. auditoria (representa o id da auditoria a qual se deseja visualizar os tópicos)

*/

-- VERIFICA SE O USUÁRIO POSSUI PERMISSÕES SUFICIENTES PARA ACESSAR A ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\controle_de_acesso.sql', json_object('funcao','21')) AS properties; -- Permissão 21) Visualizar tópicos

-- VERIFICA SE O USUÁRIO INFORMOU OS ATRIBUTOS NECESSÁRIOS PARA EXECUTAR A ROTA
SELECT
'rediret' AS component,
'\c\login\' AS link
WHERE $auditoria IS NULL;

-- DEFINE AS VARIÁVEIS UTILIZADAS PELA ROTA
SET id_auditoria_validada = (
  SELECT id
  FROM auditorias a
  WHERE a.id = $auditoria::INTEGER
  LIMIT 1
);
SET sigla_base_auditoria = (
  SELECT 
  b.sigla AS "Sigla"
  FROM auditorias a
  INNER JOIN bases b ON (b.id = a.id_base)
  WHERE a.id = $auditoria::INTEGER
  LIMIT 1
);
SET data_inicial_auditoria = (
  SELECT 
  TO_CHAR(data_inicial,'dd/MM/yyyy') AS "Data Inicial"
  FROM auditorias a
  WHERE a.id = $auditoria::INTEGER
  LIMIT 1
);
SET data_final_auditoria = (
  SELECT 
  TO_CHAR(data_final,'dd/MM/yyyy') AS "Data Final"
  FROM auditorias a
  WHERE a.id = $auditoria::INTEGER
  LIMIT 1
);
SET evento_auditoria = (
  SELECT 
  CASE WHEN pre_auditoria THEN 'Pré-auditoria' ELSE 'Auditoria' END AS "Evento"
  FROM auditorias a
  WHERE a.id = $auditoria::INTEGER
  LIMIT 1
);

-- VERIFICA SE A AUDITORIA INFORMADA REALMENTE EXISTE NA BASE DE DADOS, E CASO NÃO EXISTA, REDIRECIONA O USUÁRIO PARA A ROTA \C\LOGIN\
SELECT
'redirect' AS component,
'\c\login\' AS link
WHERE $id_auditoria_validada IS NULL;

-- RENDERIZA O SHELL OU LAYOUT GENÉRICO DA ROTA
SELECT
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\shell.sql') AS properties;

-- RENDERIZA OS COMPONENTES VISUAIS DA ROTA
SELECT -- TÍTULO DA PÁGINA
'title' AS component,
'Auditoria' AS contents,
1 AS level,
'my-0 py-0' AS class,
TRUE AS center;

SELECT -- FORMULÁRIO CONTENDO INFORMAÇÕES DA AUDITORIA
'form' AS component,
'' AS validate;
SELECT -- CAMPO ID
'ID' AS label,
$id_auditoria_validada AS value,
2 AS width,
TRUE AS disabled;
SELECT -- CAMPO BASE
'Base' AS label,
$sigla_base_auditoria AS value,
2 AS width,
TRUE AS disabled;
SELECT -- CAMPO EVENTO
'Evento' AS label,
$evento_auditoria AS value,
2 AS width,
TRUE AS disabled;
SELECT -- CAMPO ESTADO
'Estado' AS label,
'Aberto' AS value,
2 AS width,
TRUE AS disabled;
SELECT -- CAMPO "DATA INICIAL"
'Data Inicial' AS label,
$data_inicial_auditoria AS value,
2 AS width,
TRUE AS disabled;
SELECT -- CAMPO "DATA FINAL"
'Data Final' AS label,
$data_final_auditoria AS value,
2 AS width,
TRUE AS disabled;

SELECT
'tabs' AS component,
json_object('titulo':'Tópicos','active':'true','embed':'\entidades\auditorias\topicos\tabs_contents') AS abas,
json_object('titulo':'Solicitações de documentação','embed':'\entidades\auditorias\formularios\') AS abas;

/*
SELECT -- POPUP QUE APARECERÁ QUANDO O REQUISITANTE CLICAR PARA CADASTRAR UMA NOVA BASE
'modal' AS component,
'cadastroBase' AS id,
'Cadastrar base' AS title,
'\entidades\bases\formularios\' AS embed;

SELECT -- POPUP QUE APARECERÁ QUANDO O REQUISITANTE CLICAR EM EDITAR UMA BASE
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\componentes_dinamicos\modal.sql', json_object('id_modal':'modal_editar_'||b.id,'titulo_modal':'Editar base','url_iframe':'\entidades\bases\formularios\editar?id_base='||b.id)) AS properties
FROM bases b;

SELECT -- POPUP QUE APARECERÁ QUANDO O REQUISITANTE CLICAR EM REMOVER UMA BASE
'dynamic' AS component,
sqlpage.run_sql('..\view_configs\componentes_dinamicos\modal.sql', json_object('id_modal':'modal_remover_'||b.id,'titulo_modal':'Remover base','url_iframe':'\entidades\bases\formularios\remover?id_base='||b.id)) AS properties
FROM bases b;

SELECT
'button' AS component,
'end' AS justify;
SELECT
'Cadastrar' AS title,
'plus' AS icon,
FALSE AS narrow,
'cadastroBase' AS modal;

SELECT
'table' AS component,
'Pesquisar...' AS search_placeholder,
'Não há cadastros' AS empty_description,
TRUE AS sort,
TRUE AS search,
'Ações' AS markdown;
-- QUERY QUE PREENCHE A TABELA COM AS BASES ARMAZENADOS NO BANCO DE DADOS
SELECT 
ROW_NUMBER() OVER (ORDER BY g.id) AS "ID",
b.sigla AS "Código IATA", 
g.nome AS "Gerente Local",
g1.nome AS "Gerente Regional",
CONCAT(m.nome,' / ',e.nome) AS "Localização",
'<div class="dropdown">
  <a href="#" class="btn dropdown-toggle" data-bs-toggle="dropdown"><svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-dots"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12m-1 0a1 1 0 1 0 2 0a1 1 0 1 0 -2 0" /><path d="M12 12m-1 0a1 1 0 1 0 2 0a1 1 0 1 0 -2 0" /><path d="M19 12m-1 0a1 1 0 1 0 2 0a1 1 0 1 0 -2 0" /></svg></a>
  <div class="dropdown-menu">
    <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#modal_editar_'||b.id||'"><svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-edit"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 7h-1a2 2 0 0 0 -2 2v9a2 2 0 0 0 2 2h9a2 2 0 0 0 2 -2v-1" /><path d="M20.385 6.585a2.1 2.1 0 0 0 -2.97 -2.97l-8.415 8.385v3h3l8.385 -8.415z" /><path d="M16 5l3 3" /></svg>Editar</a>
    <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#modal_remover_'||b.id||'"><svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-trash"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M4 7l16 0" /><path d="M10 11l0 6" /><path d="M14 11l0 6" /><path d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12" /><path d="M9 7v-3a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v3" /></svg>Remover</a>
  </div>
</div>' AS "Ações"
FROM bases b
INNER JOIN gerentes g ON (g.id = b.id_gerente)
INNER JOIN gerentes g1 ON (g1.id = b.id_gerente_regional)
INNER JOIN municipios m ON (m.id = b.id_municipio)
INNER JOIN estados e ON (m.id_estado = e.id);

SELECT -- COMPONENTE NECESSÁRIO PARA QUE O EVENTO "DOMCONTENTLOADED" SEJA DISPARADO E EXECUTADO SOBRE OS MODAIS QUE UTILIZAM O CASCADING DROPDOWN
'form' AS component,
'd-none' AS class;
*/
