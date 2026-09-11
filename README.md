# terraform_projeto

Infraestrutura como código (IaC) na AWS usando Terraform, organizada em módulos reutilizáveis para provisionar rede e computação.

## Descrição

Este projeto provisiona, de forma automatizada, uma infraestrutura básica na AWS composta por uma VPC com subnet pública e uma instância EC2 associada, utilizando Amazon Linux 2023. A infraestrutura é dividida em dois módulos Terraform: `network` (rede) e `compute` (computação), promovendo reuso e organização do código.

## Arquitetura

```
terraform_projeto/
├── main.tf              # Orquestra os módulos network e compute
├── data.tf              # Data source para a AMI mais recente (Amazon Linux 2023)
├── locals.tf            # Valores locais (ex: name_prefix)
├── variables.tf          # Variáveis de entrada do projeto raiz
├── outputs.tf            # Outputs expostos pelo projeto raiz
├── providers.tf          # Configuração do provider AWS
├── versions.tf            # Versões do Terraform e dos providers
├── terraform.tfvars      # Valores das variáveis (não versionar dados sensíveis)
└── modules/
    ├── network/
    │   ├── main.tf        # VPC, subnet pública, internet gateway, route table
    │   ├── variables.tf   # Variáveis do módulo (vpc_cidr, name_prefix, etc.)
    │   └── outputs.tf     # vpc_id, public_subnet_id
    └── compute/
        ├── main.tf        # Security group e instância EC2
        ├── variables.tf   # Variáveis do módulo (ami_id, instance_type, etc.)
        └── outputs.tf     # instance_id, public_ip, private_ip, security_group_id
```

### Módulo `network`

Responsável por criar a rede da aplicação:

- VPC com CIDR block configurável
- Subnet pública
- Internet Gateway
- Route table pública e associação com a subnet

**Variáveis de entrada:**

| Nome | Descrição | Tipo |
|---|---|---|
| `name_prefix` | Prefixo usado para nomear os recursos | `string` |
| `vpc_cidr` | CIDR block da VPC | `string` |
| `public_subnet_cidr` | CIDR block da subnet pública | `string` |
| `availability_zone` | Availability zone onde a subnet será criada | `string` |

**Outputs:**

| Nome | Descrição |
|---|---|
| `vpc_id` | ID da VPC criada |
| `public_subnet_id` | ID da subnet pública criada |

### Módulo `compute`

Responsável por criar os recursos de computação:

- Security Group (libera SSH na porta 22)
- Instância EC2 (Amazon Linux 2023)

**Variáveis de entrada:**

| Nome | Descrição | Tipo |
|---|---|---|
| `name_prefix` | Prefixo usado para nomear os recursos | `string` |
| `ami_id` | ID da AMI usada na instância EC2 | `string` |
| `instance_type` | Tipo da instância EC2 | `string` |
| `subnet_id` | ID da subnet onde a instância será criada | `string` |
| `vpc_id` | ID da VPC onde os recursos serão criados | `string` |

**Outputs:**

| Nome | Descrição |
|---|---|
| `instance_id` | ID da instância EC2 criada |
| `public_ip` | IP público da instância EC2 |
| `private_ip` | IP privado da instância EC2 |
| `security_group_id` | ID do security group da instância |

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/downloads) instalado
- Conta AWS com credenciais configuradas (`aws configure` ou variáveis de ambiente)
- Permissões IAM para criar VPC, subnet, EC2, security group

## Instalação e uso

1. Clone o repositório:
   ```bash
   git clone https://gitlab.com/edina25-group/terraform_projeto.git
   cd terraform_projeto
   ```

2. Inicialize o Terraform (baixa providers e módulos):
   ```bash
   terraform init
   ```

3. Valide a sintaxe da configuração:
   ```bash
   terraform validate
   ```

4. Visualize o plano de execução (o que será criado):
   ```bash
   terraform plan
   ```

5. Aplique a infraestrutura:
   ```bash
   terraform apply
   ```

6. Consulte os outputs gerados (ex: IP da instância):
   ```bash
   terraform output
   ```

7. Para destruir a infraestrutura ao final do uso:
   ```bash
   terraform destroy
   ```

## Variáveis principais do projeto

Defina os valores no arquivo `terraform.tfvars` (não versionado com dados sensíveis) ou via linha de comando:

| Nome | Descrição | Default |
|---|---|---|
| `aws_region` | Região AWS onde os recursos serão criados | `us-east-1` |
| `environment` | Nome do ambiente (`dev`, `qa` ou `prod`) | — |
| `project_name` | Nome do projeto | — |
| `instance_type` | Tipo da instância EC2 | `t3.micro` |

## Observações

- O CIDR da VPC utilizado neste projeto é `10.18.0.0/16`, com subnet pública `10.18.1.0/24`.
- A AMI utilizada é obtida dinamicamente via `data "aws_ami"`, sempre buscando a versão mais recente do Amazon Linux 2023 disponível na região.
- O arquivo `terraform.tfstate` **não deve ser versionado** — ele está listado no `.gitignore` por conter informações sensíveis sobre a infraestrutura provisionada.
- Contas AWS possuem, por padrão, um limite de 5 VPCs por região. Caso o `apply` falhe com `VpcLimitExceeded`, é necessário remover VPCs não utilizadas ou solicitar aumento de quota antes de tentar novamente.

## Autoria

Projeto desenvolvido por Édina Prado como parte de laboratório prático de Terraform na AWS.
