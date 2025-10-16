# Infraestrutura como Código - WebApplication1

Este diretório contém a infraestrutura como código (IaC) para deploy da WebApplication1 no Azure usando **Terraform**.

## 📋 Resumo

Esta configuração Terraform provisiona:
- **Resource Group** do Azure (container lógico)
- **App Service Plan** (capacidade computacional)
- **Windows Web App** (aplicação ASP.NET Core)
- **Application Insights** (monitoramento - opcional)
- **Log Analytics Workspace** (logs centralizados - opcional)

## 🏗️ Estrutura de Arquivos

```
terraform/
├── versions.tf            # Versões do Terraform e providers
├── variables.tf           # Definição de variáveis de entrada
├── main.tf               # Recursos principais
├── outputs.tf            # Valores de saída úteis
├── terraform.tfvars.example  # Exemplo de valores
└── README.md             # Este arquivo
```

**Analogia**: Pense nesses arquivos como:
- `variables.tf` → **Parâmetros** de uma função
- `main.tf` → **Corpo** da função (lógica principal)
- `outputs.tf` → **Valores de retorno** da função
- `versions.tf` → **Dependências** e versões requeridas

## 🚀 Como Usar

### Pré-requisitos

1. **Terraform instalado** (versão ~> 1.9)
   ```bash
   terraform version
   ```

2. **Azure CLI autenticado**
   ```bash
   az login
   az account show
   az account set --subscription "<sua-subscription-id>"
   ```

3. **Credenciais configuradas** (via Azure CLI, Service Principal ou Managed Identity)

### Passos para Deploy

#### 1. Inicializar o Terraform

O comando `init` baixa os providers necessários (análogo a `npm install` ou `pip install`):

```bash
cd terraform
terraform init
```

#### 2. Configurar Variáveis

Copie o arquivo de exemplo e ajuste conforme seu ambiente:

```bash
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seus valores
```

**IMPORTANTE**: Nunca commite `terraform.tfvars` com dados sensíveis! Ele já está no `.gitignore`.

Exemplo de `terraform.tfvars`:

```hcl
environment = "dev"
location    = "East US"
app_name    = "mywebapp"

sku = {
  tier = "Basic"
  size = "B1"
}

enable_monitoring = true
enable_https_only = true
min_tls_version   = "1.2"
```

#### 3. Validar e Formatar

Sempre valide e formate o código antes de aplicar:

```bash
# Formatar código HCL
terraform fmt -recursive

# Validar sintaxe
terraform validate
```

#### 4. Planejar Mudanças

O `plan` é como um **"diff" da infraestrutura** - mostra o que será criado/modificado/destruído:

```bash
terraform plan
```

**Analogia**: `terraform plan` é como revisar um Pull Request antes do merge. Você vê exatamente o que mudará.

#### 5. Aplicar Mudanças

O `apply` executa as mudanças de forma **transacional**:

```bash
terraform apply
```

Revise o plano exibido e digite `yes` para confirmar.

**Analogia**: `terraform apply` é a execução do plano - como fazer o merge do PR após revisão.

#### 6. Verificar Outputs

Após o apply, os outputs mostram informações úteis:

```bash
terraform output
terraform output webapp_url
```

Acesse a URL fornecida para verificar sua aplicação.

## 🧩 Conceitos Principais (com Analogias)

### State (Estado)

O **state** é o "banco de dados" da sua infraestrutura. O Terraform usa o state para:
- Mapear recursos reais aos definidos no código
- Rastrear metadados
- Melhorar performance (caching)

**Backend**: Define **onde** o state fica armazenado.
- Local (padrão): `terraform.tfstate` no diretório atual
- Remoto (recomendado): S3, Azure Storage, Terraform Cloud

**Locking**: Previne conflitos quando múltiplas pessoas trabalham simultaneamente.

**Configuração recomendada** (descomente em `versions.tf`):

```hcl
backend "azurerm" {
  resource_group_name  = "terraform-state-rg"
  storage_account_name = "tfstatestorage"
  container_name       = "tfstate"
  key                  = "webapp.terraform.tfstate"
}
```

**Analogia**: State remoto com lock é como um banco de dados com bloqueio transacional - evita que duas pessoas editem simultaneamente e causem conflitos.

### Variables (Variáveis)

As variáveis são **parâmetros de entrada** que tornam seu código reutilizável:

```hcl
variable "environment" {
  type        = string
  description = "Nome do ambiente"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "O ambiente deve ser dev, staging ou prod."
  }
}
```

**Tipos suportados**:
- Primitivos: `string`, `number`, `bool`
- Complexos: `list`, `set`, `map`, `object`, `tuple`

**Validações** garantem que os valores atendam regras específicas.

### Locals

`locals` são variáveis intermediárias para clareza e reuso:

```hcl
locals {
  resource_prefix = "${var.app_name}-${var.environment}"
  common_tags = merge(var.tags, { Environment = var.environment })
}
```

**Analogia**: Como variáveis privadas/constantes dentro de uma função - não são expostas externamente.

### Outputs

`outputs` expõem valores úteis após o apply:

```hcl
output "webapp_url" {
  description = "URL da aplicação"
  value       = "https://${azurerm_windows_web_app.main.default_hostname}"
}
```

Use `sensitive = true` para outputs com dados confidenciais (ex.: chaves de API).

### for_each vs count

Ambos são "loops declarativos" para criar múltiplos recursos:

**`for_each`** (recomendado): Usa chaves estáveis (map ou set)
```hcl
variable "buckets" {
  type = map(object({ versioning = bool }))
}

resource "aws_s3_bucket" "this" {
  for_each = var.buckets
  bucket   = each.key  # Chave estável
  # ...
}
```

**`count`**: Usa índices numéricos (lista)
```hcl
variable "instances" {
  type = number
}

resource "aws_instance" "this" {
  count = var.instances
  # Acesso via count.index
}
```

**Trade-off**: `for_each` é melhor para itens com identidade própria (evita recriação desnecessária ao reordenar). `count` é adequado para recursos homogêneos e ordenados.

### depends_on

Cria dependências **explícitas** entre recursos:

```hcl
resource "azurerm_windows_web_app" "main" {
  # ...
  depends_on = [azurerm_service_plan.main]
}
```

**Analogia**: É como uma "aresta" explícita em um grafo de dependências. O Terraform já infere muitas dependências automaticamente (implícitas), mas `depends_on` força uma ordem específica.

### dynamic blocks

Cria blocos condicionais ou repetidos dinamicamente:

```hcl
dynamic "application_insights_connection_string" {
  for_each = var.enable_monitoring ? [1] : []
  content {
    value = azurerm_application_insights.main[0].connection_string
  }
}
```

**Analogia**: Similar a um loop `for` que gera estruturas de configuração baseadas em condições.

## 🔒 Segurança e Boas Práticas

### 1. Nunca Commite Segredos

❌ **Evite**:
```hcl
app_settings = {
  "ConnectionString" = "Server=...;Password=secret123"
}
```

✅ **Faça**:
```hcl
# Use variáveis de ambiente
export TF_VAR_connection_string="Server=...;Password=secret123"

# Ou Azure Key Vault
data "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  key_vault_id = var.key_vault_id
}
```

### 2. Backend Remoto e Lock

Use backend remoto (Azure Storage, S3, Terraform Cloud) com **state locking** para trabalho em equipe:

```hcl
backend "azurerm" {
  resource_group_name  = "terraform-state-rg"
  storage_account_name = "tfstatestorage"
  container_name       = "tfstate"
  key                  = "webapp.terraform.tfstate"
}
```

### 3. Version Pinning

Sempre fixe versões do Terraform e providers com SemVer:

```hcl
terraform {
  required_version = "~> 1.9"  # >= 1.9.0, < 2.0.0
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # >= 3.0.0, < 4.0.0
    }
  }
}
```

### 4. Outputs Sensíveis

Marque outputs com dados confidenciais:

```hcl
output "application_insights_instrumentation_key" {
  value     = azurerm_application_insights.main[0].instrumentation_key
  sensitive = true
}
```

### 5. Validação de Tipos

Use tipos explícitos e validações:

```hcl
variable "environment" {
  type = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Ambiente inválido."
  }
}
```

## 🔍 Validação e Qualidade

### Ferramentas Recomendadas

1. **Formatação e Validação**:
   ```bash
   terraform fmt -recursive
   terraform validate
   ```

2. **Linting** (TFLint):
   ```bash
   # Instalar: https://github.com/terraform-linters/tflint
   tflint --init
   tflint
   ```

3. **Análise de Segurança** (tfsec):
   ```bash
   # Instalar: https://github.com/aquasecurity/tfsec
   tfsec .
   ```

4. **Análise de Segurança** (Checkov):
   ```bash
   # Instalar: pip install checkov
   checkov -d .
   ```

5. **Estimativa de Custos** (Infracost):
   ```bash
   # Instalar: https://github.com/infracost/infracost
   infracost breakdown --path .
   ```

### Pre-commit Hooks

Configure hooks para validação automática antes do commit:

```bash
# Instalar: https://github.com/antonbabenko/pre-commit-terraform
pip install pre-commit
pre-commit install
```

Arquivo `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tflint
      - id: terraform_tfsec
```

## 🚦 CI/CD (GitHub Actions)

Exemplo de workflow para validação em PRs:

```yaml
name: Terraform Validation
on: [pull_request]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.9.0
      
      - name: Terraform Format
        run: terraform fmt -check -recursive
        
      - name: Terraform Init
        run: terraform init -backend=false
        
      - name: Terraform Validate
        run: terraform validate
        
      - name: TFLint
        uses: terraform-linters/setup-tflint@v3
        with:
          tflint_version: latest
      
      - name: Run TFLint
        run: |
          tflint --init
          tflint
      
      - name: Terraform Plan
        run: terraform plan -no-color
        env:
          ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
          ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
          ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
          ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
```

## 📊 Workspaces (Ambientes)

Workspaces permitem gerenciar múltiplos ambientes com o **mesmo código**:

```bash
# Criar workspace para staging
terraform workspace new staging

# Listar workspaces
terraform workspace list

# Selecionar workspace
terraform workspace select prod

# Ver workspace atual
terraform workspace show
```

**Analogia**: Workspaces são como "ambientes lógicos" compartilhando código, mas com estados separados. Cada workspace tem seu próprio state file.

**Trade-off**: Úteis para ambientes simples, mas **não substituem** estratégias de branching/diretórios para cenários complexos.

**Uso no código**:
```hcl
locals {
  env_suffix = terraform.workspace == "prod" ? "" : "-${terraform.workspace}"
  app_name   = "myapp${local.env_suffix}"
}
```

## 🗑️ Destruir Infraestrutura

Para remover todos os recursos (use com cautela!):

```bash
terraform destroy
```

O Terraform mostrará o que será destruído e pedirá confirmação.

## 🐛 Troubleshooting

### State Desatualizado

Se o state estiver desatualizado em relação à infraestrutura real:

```bash
terraform refresh
```

### Drift Detection

Verificar se houve mudanças manuais fora do Terraform:

```bash
terraform plan -detailed-exitcode
```

Código de saída:
- 0: Sem mudanças
- 1: Erro
- 2: Mudanças detectadas (drift)

### Import de Recursos Existentes

Para trazer recursos já existentes para o Terraform:

```bash
terraform import azurerm_resource_group.main /subscriptions/<sub-id>/resourceGroups/<rg-name>
```

### Remover Recurso do State (sem destruir)

```bash
terraform state rm azurerm_windows_web_app.main
```

## 📚 Referências

### Documentação Oficial HashiCorp

- **Linguagem (HCL)**: https://developer.hashicorp.com/terraform/language
- **CLI Commands**: https://developer.hashicorp.com/terraform/cli/commands
- **Funções**: https://developer.hashicorp.com/terraform/language/functions
- **Variáveis**: https://developer.hashicorp.com/terraform/language/values/variables
- **Locals**: https://developer.hashicorp.com/terraform/language/values/locals
- **Outputs**: https://developer.hashicorp.com/terraform/language/values/outputs
- **Expressões e Tipos**: https://developer.hashicorp.com/terraform/language/expressions
- **Dynamic Blocks**: https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks
- **Backends**: https://developer.hashicorp.com/terraform/language/settings/backends/configuration
- **Workspaces**: https://developer.hashicorp.com/terraform/cli/workspaces
- **Refatoração (moved blocks)**: https://developer.hashicorp.com/terraform/language/modules/develop/refactoring#moved-blocks
- **Tutoriais (Learn)**: https://developer.hashicorp.com/terraform/tutorials

### Registry (Providers e Módulos)

- **Terraform Registry**: https://registry.terraform.io
- **Azure Provider**: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- **AWS Provider**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

### GitHub Oficial

- **Terraform Core**: https://github.com/hashicorp/terraform
- **Azure Provider**: https://github.com/hashicorp/terraform-provider-azurerm
- **AWS Provider**: https://github.com/hashicorp/terraform-provider-aws

### Qualidade, Segurança e Automação

- **TFLint**: https://github.com/terraform-linters/tflint
- **tfsec**: https://github.com/aquasecurity/tfsec
- **Checkov**: https://github.com/bridgecrewio/checkov
- **Pre-commit Terraform**: https://github.com/antonbabenko/pre-commit-terraform
- **Infracost**: https://github.com/infracost/infracost

### Exemplos e Padrões

- **Azure Terraform Examples**: https://github.com/Azure/terraform-azurerm-examples
- **Terraform Best Practices**: https://www.terraform-best-practices.com/
- **Gruntwork Terraform Modules**: https://github.com/gruntwork-io

## 📝 Próximos Passos

1. ✅ Configure backend remoto em `versions.tf`
2. ✅ Ajuste `terraform.tfvars` para seu ambiente
3. ✅ Execute `terraform init && terraform plan`
4. ✅ Configure pre-commit hooks para validação automática
5. ✅ Integre tfsec/Checkov no pipeline de CI/CD
6. ✅ Configure Infracost para estimativa de custos
7. ✅ Documente runbooks de operação e troubleshooting

## 🤝 Contribuindo

Ao modificar esta infraestrutura:

1. **Formate o código**: `terraform fmt -recursive`
2. **Valide sintaxe**: `terraform validate`
3. **Execute tflint**: `tflint`
4. **Análise de segurança**: `tfsec .`
5. **Gere plan**: `terraform plan -out=tfplan`
6. **Revise mudanças** antes de aplicar
7. **Documente** alterações importantes no README ou CHANGELOG

---

**Dúvidas?** Consulte as [referências oficiais](#-referências) ou abra uma issue no repositório.
