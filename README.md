# AWS EKS Cluster com Terraform & EKS Auto Mode 

Este projeto demonstra a criação e orquestração de uma infraestrutura de contentores na AWS utilizando **Terraform** para o aprovisionamento de infraestrutura como código (IaC) e o **Amazon EKS (Elastic Kubernetes Service) Auto Mode** para a gestão automática de nós e rede.

O objetivo principal foi realizar o deploy automatizado de uma aplicação frontend (Docker) integrada com o AWS ECR (Elastic Container Registry) e exposta para a internet através de um AWS Load Balancer.

##  Tecnologias Utilizadas

* **Terraform**: Criação de VPC, Subnets Públicas, Internet Gateway e Tabelas de Rotas.
* **AWS EKS (Auto Mode)**: Orquestração do cluster Kubernetes com provisionamento automático de instâncias de computação.
* **Amazon ECR**: Armazenamento seguro da imagem Docker da aplicação.
* **Kubectl**: Gestão, criação de deployments e serviços dentro do cluster.
* **Docker**: Criação e empacotamento da imagem do frontend.

##  Arquitetura da Infraestrutura

A rede foi desenhada para garantir alta disponibilidade e comunicação direta com os serviços da AWS:

* **1 VPC** principal (`10.0.0.0/16`).
* **2 Subnets Públicas** distribuídas em zonas de disponibilidade diferentes (`us-east-2a` e `us-east-2b`) com atribuição de IP público automático.
* **Internet Gateway (IGW)** e Tabelas de Rotas configuradas para permitir tráfego público (`0.0.0.0/0`).

##  Desafios Enfrentados e Aprendizados (Troubleshooting)

Durante a execução do projeto, foram enfrentados desafios reais de engenharia de plataformas e problemas de integração clássicos de ambientes AWS/Kubernetes. Abaixo estão documentados os erros e as soluções encontradas:

### 1. Serviço de LoadBalancer Travado em `<pending>`
* **O Erro:** `Warning FailedBuildModel ... unable to resolve at least one subnet (0 match VPC and tags)`
* **A Causa:** O EKS Auto Mode tenta gerenciar a rede de forma automática, mas precisa saber exatamente quais subnets estão autorizadas a receber tráfego público externo. Como as subnets originais não possuíam as tags exigidas pela AWS, o Kubernetes não conseguia associar o LoadBalancer.
* **A Solução:** Adicionar explicitamente a tag `"kubernetes.io/role/elb" = "1"` nas subnets públicas dentro do código Terraform para permitir o mapeamento automático do balanceador de carga.

### 2. Erros de Sintaxe no Terraform (Pontos Vermelhos no Editor)
* **O Erro:** O editor de texto (VS Code) acusava múltiplos erros de sintaxe inválida ao tentar injetar as novas tags no ficheiro de configuração.
* **A Causa:** Ao copiar blocos de código de fontes externas, o editor de texto converteu as aspas retas padrão (`" "`) em aspas tipográficas/curvas (`“ ”`). O Terraform possui uma sintaxe rígida e não reconhece caracteres especiais de formatação de texto.
* **A Solução:** Correção manual de sintaxe e uso de comandos Linux via terminal (`cat << 'EOF'`) para reescrever o ficheiro de forma limpa, garantindo apenas aspas retas e codificação correta.

### 3. Erro de Permissão no Kubectl (`Forbidden`) ao Destruir Recursos
* **O Erro:** `Error from server (Forbidden): ... User "arn:aws:iam::...:root" cannot delete resource`
* **A Causa:** O acesso ao cluster estava a ser realizado utilizando as credenciais da conta **Root** da AWS. Por boas práticas e diretivas rígidas de segurança de IAM, a AWS bloqueia ações diretas do usuário Root no RBAC interno da API do Kubernetes sem configuração prévia.
* **A Solução:** Ignorar a deleção manual via API do Kubernetes e delegar o processo de destruição diretamente ao **Terraform CLI**, que possui o mapeamento de estado (`state`) e consegue forçar a limpeza dos recursos principais a partir da infraestrutura da AWS.

##  Como Executar o Projeto

### 1. Provisionar a Infraestrutura com Terraform
Dentro do diretório do projeto, inicialize e aplique o código:
```bash
terraform init
terraform apply -auto-approve
