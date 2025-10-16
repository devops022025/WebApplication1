# 🚀 Quick Start - Deploy WebApplication1 no Azure

Guia rápido para provisionar a infraestrutura em menos de 10 minutos.

## ⚡ Pré-requisitos (5 minutos)

### 1. Instalar Terraform

**macOS**:
```bash
brew install terraform
```

**Linux**:
```bash
wget https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip
unzip terraform_1.9.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

**Windows**:
```powershell
choco install terraform
```

**Verificar**:
```bash
terraform version
# Esperado: Terraform v1.9.0
```

### 2. Configurar Azure CLI

**Instalar**:
```bash
# macOS
brew install azure-cli

# Linux
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Windows
choco install azure-cli
```

**Login**:
```bash
az login
az account show
az account set --subscription "SUA-SUBSCRIPTION-ID"
```

## 🎯 Deploy em 3 Passos (5 minutos)

### Passo 1: Preparar Configuração

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edite `terraform.tfvars`:
```hcl
environment = "dev"
location    = "East US"
app_name    = "mywebapp"  # ⚠️ Mude para um nome único!

sku = {
  tier = "Basic"
  size = "B1"
}

enable_monitoring = true
enable_https_only = true
```

### Passo 2: Inicializar e Planejar

```bash
# Inicializar Terraform (baixa providers)
terraform init

# Formatar e validar
terraform fmt
terraform validate

# Ver o que será criado
terraform plan
```

**O que você verá**:
- ✅ 1 Resource Group
- ✅ 1 App Service Plan
- ✅ 1 Windows Web App
- ✅ 1 Application Insights
- ✅ 1 Log Analytics Workspace

### Passo 3: Aplicar!

```bash
terraform apply
```

Digite `yes` quando solicitado.

**Tempo estimado**: 3-5 minutos ⏱️

## 🎉 Pronto!

Após o apply bem-sucedido:

```bash
# Ver URL da aplicação
terraform output webapp_url

# Exemplo: https://mywebapp-dev-webapp.azurewebsites.net
```

Acesse a URL no navegador! 🌐

## 📊 Verificar Recursos Criados

```bash
# Via Terraform
terraform show

# Via Azure CLI
az group show --name mywebapp-dev-rg
az webapp show --name mywebapp-dev-webapp --resource-group mywebapp-dev-rg
```

## 🔧 Comandos Úteis

### Ver outputs
```bash
terraform output
terraform output webapp_url
terraform output -json
```

### Ver state
```bash
terraform state list
terraform show
```

### Aplicar mudanças
```bash
# Edite terraform.tfvars ou main.tf
terraform plan
terraform apply
```

### Destruir infraestrutura
```bash
terraform destroy
# ⚠️ Cuidado: Remove TODOS os recursos!
```

## 🏗️ Próximos Passos

### 1. Deploy da Aplicação

```bash
# Build da aplicação .NET
cd ../WebApplication1
dotnet publish -c Release -o ./publish

# Deploy via Azure CLI
az webapp deployment source config-zip \
  --resource-group mywebapp-dev-rg \
  --name mywebapp-dev-webapp \
  --src ./publish.zip
```

### 2. Configurar Backend Remoto

Para trabalhar em equipe, configure um backend remoto:

1. **Criar Storage Account**:
```bash
# Criar Resource Group para o state
az group create --name terraform-state-rg --location "East US"

# Criar Storage Account
az storage account create \
  --name tfstatestorage12345 \
  --resource-group terraform-state-rg \
  --location "East US" \
  --sku Standard_LRS

# Criar container
az storage container create \
  --name tfstate \
  --account-name tfstatestorage12345
```

2. **Atualizar versions.tf**:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatestorage12345"
    container_name       = "tfstate"
    key                  = "webapp.terraform.tfstate"
  }
}
```

3. **Migrar state**:
```bash
terraform init -migrate-state
```

### 3. Adicionar Ambientes

**Opção A: Workspaces**
```bash
# Criar workspace de staging
terraform workspace new staging

# Ajustar variáveis
echo 'environment = "staging"' > terraform.tfvars

# Deploy
terraform apply

# Voltar para dev
terraform workspace select dev
```

**Opção B: Diretórios separados**
```bash
mkdir -p environments/staging
cp terraform.tfvars environments/staging/
cd environments/staging
# Editar terraform.tfvars
terraform init
terraform apply
```

### 4. Configurar CI/CD

O workflow em `.github/workflows/terraform-validation.yml` já está pronto!

Apenas configure secrets no GitHub:
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

**Criar Service Principal**:
```bash
az ad sp create-for-rbac \
  --name "github-actions-terraform" \
  --role Contributor \
  --scopes /subscriptions/YOUR-SUBSCRIPTION-ID \
  --sdk-auth
```

Copie o JSON retornado e adicione aos secrets do GitHub.

### 5. Configurar Pre-commit

```bash
# Instalar
pip install pre-commit

# Configurar
pre-commit install

# Testar
pre-commit run -a
```

Agora todas as validações rodarão automaticamente antes de cada commit! ✅

## 💰 Estimativa de Custos

Com as configurações padrão (Basic B1):
- **App Service Plan B1**: ~$13/mês
- **Application Insights**: ~$2.30/GB ingerido
- **Log Analytics**: ~$2.30/GB ingerido

**Total estimado**: ~$15-20/mês

💡 **Dica**: Use `Free` tier para desenvolvimento:
```hcl
sku = {
  tier = "Free"
  size = "F1"
}
```

## 🆘 Troubleshooting

### Erro: Nome da aplicação já existe

```bash
# Mude o app_name no terraform.tfvars
app_name = "mywebapp-xyz123"  # Use um nome único
```

### Erro: Subscription não encontrada

```bash
# Liste subscriptions
az account list --output table

# Selecione a correta
az account set --subscription "SUBSCRIPTION-ID"
```

### Erro: Permissões insuficientes

Você precisa da role **Contributor** na subscription:
```bash
az role assignment create \
  --assignee USER-EMAIL \
  --role Contributor \
  --scope /subscriptions/SUBSCRIPTION-ID
```

### State locked

Se o state ficou travado após erro:
```bash
# Listar locks
az lock list --resource-group mywebapp-dev-rg

# Unlock (use com cuidado!)
terraform force-unlock LOCK-ID
```

## 📚 Documentação Completa

Este é um guia rápido. Para informações detalhadas:

- 📖 **README completo**: [`README.md`](./README.md)
- 📚 **Guia Terraform**: [`../TERRAFORM_GUIDE.md`](../TERRAFORM_GUIDE.md)
- 🤖 **Instruções IA**: [`../AI_AGENT_INSTRUCTIONS.md`](../AI_AGENT_INSTRUCTIONS.md)

## 🎓 Aprender Mais

**Tutoriais Oficiais**:
- [Get Started - Azure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)
- [Learn Terraform](https://developer.hashicorp.com/terraform/tutorials)

**Documentação**:
- [Terraform Language](https://developer.hashicorp.com/terraform/language)
- [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

**Comunidade**:
- [HashiCorp Discuss](https://discuss.hashicorp.com/c/terraform-core)
- [r/Terraform](https://reddit.com/r/Terraform)

---

**Pronto para começar?** 🚀 Execute os 3 passos acima e sua infraestrutura estará no ar!
