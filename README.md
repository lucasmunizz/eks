# Deploy de API Spring Boot no EKS com Terraform e GitHub Actions

Este projeto configura uma infraestrutura na AWS usando Terraform para deploy de uma API Spring Boot simples em um cluster EKS (Elastic Kubernetes Service) com Fargate, integrada com ECR (Elastic Container Registry) para armazenamento da imagem Docker e VPC para networking. O deploy é automatizado via GitHub Actions.

## Objetivo
- Provisionar uma VPC com subnets públicas e privadas.
- Criar um cluster EKS com Fargate para rodar containers sem gerenciar nós.
- Configurar um repositório ECR para armazenar a imagem Docker da API.
- Automatizar o build, push da imagem e deploy no EKS usando GitHub Actions.
- Expor a API via Load Balancer público.

## Estrutura do Projeto

```code
eks/
│
├── src/                          # Arquivos Terraform
│   ├── main.tf                  # VPC, EKS, ECR
│   ├── provider.tf              # Provedor AWS
│   ├── variables.tf             # Variáveis
│   └── terraform.tfvars         # Valores das variáveis
│
├── api/                         # Código da API Spring Boot
│   ├── src/                     # Código fonte (Java)
│   ├── Dockerfile               # Configuração da imagem Docker
│   ├── pom.xml                  # Dependências Maven
│   └── k8s/                     # Manifests Kubernetes
│       ├── deployment.yaml      # Deployment da API
│       └── service.yaml         # Serviço com Load Balancer
│
├── .github/                     # Configurações do GitHub
│   └── workflows/
│       └── terraform.yml        # Workflow GitHub Actions
│
└── README.md                    # Este arquivo
```


## Componentes

### 1. Terraform (`src/`)
- **VPC**: Criada com o módulo `terraform-aws-modules/vpc/aws`, inclui subnets públicas e privadas, NAT Gateway e VPN Gateway para conectividade.
- **EKS**: Usa o módulo `terraform-aws-modules/eks/aws` para criar um cluster com Fargate Profiles no namespace `default`.
- **ECR**: Repositório `spring-boot-api-repo` para armazenar a imagem Docker da API.

### 2. API Spring Boot (`api/`)
- Uma API simples com um endpoint `/hello` que retorna `"Hello, World!"`.
- Construída com Maven e empacotada em uma imagem Docker via `Dockerfile`.

### 3. GitHub Actions (`.github/workflows/terraform.yml`)
- **Passos**:
  1. Configura credenciais AWS.
  2. Executa `terraform init` e `apply` para provisionar a infraestrutura.
  3. Faz login no ECR, builda e envia a imagem Docker.
  4. Configura o `kubectl` e aplica os manifests Kubernetes.

### 4. Kubernetes (`api/k8s/`)
- **Deployment**: Roda a API com a imagem do ECR em pods Fargate com recursos mínimos (250m CPU, 512Mi memória).
- **Service**: Expõe a API via Load Balancer público na porta 80.

## Pré-requisitos
- **AWS CLI** e **kubectl** instalados localmente para testes.
- Conta AWS com permissões para criar VPC, EKS, ECR e Load Balancers.
- GitHub Secrets configurados:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_BUCKET_NAME` (bucket S3 para o backend Terraform)
  - `AWS_BUCKET_FILE` (arquivo de estado, ex.: `terraform.tfstate`)

## Configuração

### 1. Clonar o Repositório
```bash
git clone https://github.com/lucasmunizz/eks
cd eks
```

### 2. Configurar Secrets no GitHub
- No GitHub, vá para Settings > Secrets and variables > Actions.
- Adicione os secrets listados em "Pré-requisitos".

### 3. Deploy Automático
- Faça um push no branch main:
```bash
  git add .
  git commit -m "Deploy inicial"
  git push origin main
```
- O workflow em .github/workflows/terraform.yml será disparado.

## Testando a API

### 1. Configurar o kubectl:

```bash
  aws configure  # Insira suas credenciais AWS
  aws eks update-kubeconfig --region us-east-1 --name eks-api
```

### 2. Verificar os Pods:
```bash
  kubectl get pods -n default
```

### 3. Pegar o Endereço do Load Balancer:
```bash
  kubectl get svc -n default
```
- Anote o EXTERNAL-IP do spring-boot-api-service.

### 4. Testar o Endpoint:
```bash
  curl http://<EXTERNAL-IP>/eks
```
- Esperado: "fui deployado no eks"


