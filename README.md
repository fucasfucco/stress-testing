# POC Stress Test com Jmeter Remote Testing

## Iniciando os containers
`docker-compose up --scale server=3`

## Configurando o datasource do Elasticsearch no Grafana
Acessar `http://localhost:3000/connections/datasources`, selecionar o tipo de datasource `Elasticsearch` e preencher as informações abaixo:

```
HTTP/URL: `http://elasticsearch:9200`
Elasticsearch details/Index name: `docker-jmeter-remote-testing`
Elasticsearch details/Time field name: `Timestamp`
```

## Criando o dashborad no Grafana
Acessar `http://localhost:3000/dashboard/import` e colar o conteúdo do arquivo `./grafana/grafana-dashboard.json` no input da tela.

## Criando a massa de dados
Seguir os passos de montagem de ambiente e execução do script python em `./scripts/README.md`.

## Executando o plano de testes
`jmeter -n -t /usr/share/testPlans/riachuelo-desktop.jmx -R $WORKERS`

# Levantamentos para criar ambiente na AWS

## Serviços necessários
- Container `jmeter-client`
- Container `jmeter-server`
- EFS ou Bucket
- Elasticsearch (container?)
- Grafana (container?)
- Redis (container?)

## Pré-requisitos de rede
- Deve ser possível a comunicação entre `jmeter-client` e Elasticsearch
- Deve ser possível a comunicação entre `jmeter-server` e Redis
- Deve ser possível a comunicação entre Elasticsearch e Grafana
- Container `jmeter-client` na porta `60000`
- Container `jmeter-server` nas portas `1099` e `50000`
- Elasticsearch na porta `9200`
- Grafana (acesso pela internet para criação e visualização de dashboard)
- Redis (acesso pela internet para inserção da massa de dados) na porta `63790`

## Mapeamento de diretórios (volume)
- Container `jmeter-client` precisa de um diretório (`/usr/share/testPlans`) para upload dos planos de teste
- Container `jmeter-client` e `jmeter-server` precisam de um diretório (`/opt/apache-jmeter-5.6.3/bin/`) para compartilhar o `rmi_keystore.jks`

## Variáveis de ambiente
- Vamos precisar eventualmente sobrescrever um valor para `JVM_ARGS`
- Para deixar o `jmeter-client` dinâmico precisamos de uma variável de ambiente nomeada como `WORKERS`. Esta terá como valor o nome do "service" dos containers `jmeter-server`, este que deve ser configurado com `clusterIP: None` para retornar os IPs diretamente dos Pods sem realização de load balancing.

## Recursos para POC na AWS ambiente homologação
As configurações abaixo serão para a execução do próprio plano de testes desta POC local.

- jmeter-client: 1 vCPU e 1Gi RAM
- jmeter-server: 0.5 vCPU e 524Mi RAM
- Elasticsearch: 1 vCPU e 1Gi RAM
- Grafana: 0.5 vCPU e 524Mi RAM
- Redis: 0.5 vCPU e 524Mi RAM

## Informações compartilhadas pela Sofist (base para teste em nossa infra)
Informações históricas para servir de base para nosso stress test interno da empresa.

- Não foi utilizado jmeter mas sim uma ferramenta de mercado não revelada
- A ideia era chegar até 30000 threads simultâneas (ocorreram problemas e não foi atingido)
- O tempo das cargas totalizou 4 horas, sendo divididas em baterias de 30 minutos cada
- A máquina utilizada na AWS para o último stress test: `c5.9xlarge -> Family: c5 - 36vCPU - 72GiB RAM - Current Generation: true`

## Recursos para teste em ambiente de produção (5000 threads simultaneas)
O método utilizado foi com base em pesquisas, mas o própria complexidade do plano de testes (quantidade de requisições, uso de timers, assertions, etc) é uma grande influenciadora do consumo. Considerando também a utilização de todos os componentes como containers e nenhuma utilização de serviço gerenciado pela AWS.

- jmeter-client: 4 vCPUs e 8–12GB RAM (1 pod -> 4 vCPUs e 8–12GB RAM)
- jmeter-server: 1 vCPUs e 2–2.5GB RAM (25 pods -> 25 vCPUs e 50–62.5GB RAM) 
- Elasticsearch: 2-4 vCPUs e 2-4GB RAM (3 pods (master, data, ingest) -> 6-12 vCPUs e 6–12GB RAM)
- Grafana: 0.5 vCPUs e 0.5GB RAM
- Redis: 1 vCPUs e 0.5–1GB RAM

No cenário menos conservador, o consumo total seria:
36,5 vCPUs , 65GB RAM e ~82GB SSD

No cenário mais conservador, o consumo total seria:
42,5 vCPUs , 196GB RAM e ~82GB SSD

Obs.: Ressaltando que a duração do teste será de 4h.

## Dúvidas
- Faria sentido utilizar `Elasticache` ao invés de um container Redis?
- Faria sentido utilizar `Amazon OpenSearch Service` ao invés de um cluster Elasticsearch?
- Como observar o desempenho do ambiente (Prometheus + Grafana)?
