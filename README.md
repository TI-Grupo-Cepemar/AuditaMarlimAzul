# AuditaMarlimBrasil

### Qual problema o sistema tenta solucionar?
> O sistema tem como intuito auxiliar os colaboradores do Grupo Cepemar na gestão e organização das auditorias realizadas, tanto internas como externas. As auditorias internas se tratam das auditorias feitas pelos próprios colaboradores, simulando uma auditoria externa. Já uma auditoria externa, se trata de uma auditoria realizada pela Vibra (antiga BR distribuidora), e impactam diretamento no faturamento, visto que as notas obtidas nestas auditorias, são fatos definitivo na decisão do faturamento pago pela Vibra.

### Como o sistema ajuda?
> O sistema além de ser um meio de consulta as auditorias realizadas e em realização, gerencia as auditorias realizadas internamente, auxiliando por exemplo na aprovação da documentação, solicitações de ajustes, avisos de envio não realizado, e aviso frente a auditorias que estão se aproximando, sejam internas ou externas.

### Como implantar o sistema?
Para implantar o sistema, siga os passos abaixo:
1. Baixe o repositório (fonte do projeto). O download pode ser realizado diretamente via interface do GitHub, ou via Git, com o comando abaixo.
```
git clone "https://github.com/TI-Grupo-Cepemar/AuditaMarlimAzul.git"
```

2. Instale o banco de dados [PostgreSQL](https://www.postgresql.org/), e por padrão o instale na porta 5432, que já é configurada por padrão ao instalar o PostgreSQL, a menos que seja configurada outra porta. No caso da porta configurada no banco de dados for diferente da 5432, no próximo passo o servidor não irá subir, nesse caso será necessário alterar a porta da aplicação no arquivo situado no seguinte caminho _sqlpage > sqlpage.json_. Adicionando o seguinte par chave-valor (altere a porta 5432 para a porta que tenha configurado o banco de dados):
```
port: 5432
```

3. Por fim, basta rodar o executável [_**sqlpage.exe**_](https://sql-page.com/), garantindo que a porta _8080_ não esteja em utilização.