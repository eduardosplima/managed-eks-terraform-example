# Exemplo de criação de cluster EKS gerenciado - Terraform

## Visão macro da arquitetura

![Cluster EKS - Visão Macro](/docs/macro_architecture.png "Cluster EKS - Visão Macro")

## Pré-requisitos

1. aws cli
2. terraform cli
3. kubectl (para testar o acesso ao cluster)

## Provisionando os recursos

1. Configurar o aws cli para fazer conectar na conta aws desejada
   - **TIP**: Caso tenha mais de um perfil configurado, recomenda-se o uso da variável de ambiente AWS_PROFILE, conforme [documentação oficial](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
2. Na pasta do projeto, inicializar o terraform usando `terraform init`
3. (Opcional) Na pasta do projeto, executar `terraform plan -var-file=environment/test/vars.tfvars` para visualizar o plano de execução (alterações) que serão aplicadas pelo terraform
4. Na pasta do projeto, executar `terraform apply -var-file=environment/test/vars.tfvars` para aplicar o provisionamento

## Inputs

### aws_region

Região da aws onde os recursos serão provisionados

### azs

Lista das zonas de disponibilidade que serão utilizadas na criação dos recursos

### vpc_cidr

Bloco cidr da vpc

### cluster_name

Nome do cluster

### kubernetes_version

Versão do kubernetes

### node_instance_type

Tipo da instância de cada nó

### nodes_desired_capacity

Número de nós desejado

### nodes_min_capacity

Número mínimo de nós

### nodes_max_capacity

Número máximo de nós

## Acessando o cluster

- Configurar o kubeconfig: `aws eks update-kubeconfig --name <NOME DO CLUSTER>`
- Validar a conexão: `kubectl version`
