# WebApplication1 - ASP.NET Core + Terraform IaC

[![Terraform Validation](https://github.com/devops022025/WebApplication1/actions/workflows/terraform-validation.yml/badge.svg)](https://github.com/devops022025/WebApplication1/actions/workflows/terraform-validation.yml)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Aplicação web ASP.NET Core com **Infraestrutura como Código (IaC)** completa usando **Terraform** e **Azure**.

## 📋 Visão Geral

Este projeto demonstra as melhores práticas para:
- ✅ **Aplicação ASP.NET Core** moderna
- ✅ **Infraestrutura como Código** com Terraform
- ✅ **CI/CD automatizado** no GitHub Actions
- ✅ **Segurança e qualidade** com análise automática
- ✅ **Documentação abrangente** em português

## 🚀 Quick Start

### Deploy da Infraestrutura (5 minutos)

```bash
# 1. Pré-requisitos
terraform version  # >= 1.9.0
az login

# 2. Configurar
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seus valores

# 3. Deploy!
terraform init
terraform apply
```

📖 **Guia detalhado**: [`terraform/QUICKSTART.md`](terraform/QUICKSTART.md)

### Executar a Aplicação Localmente

```bash
cd WebApplication1
dotnet restore
dotnet run
```

Acesse: http://localhost:5000

## 📂 Estrutura do Projeto

```
WebApplication1/
├── 📁 WebApplication1/          # Código da aplicação ASP.NET Core
│   ├── Pages/                   # Razor Pages
│   ├── wwwroot/                 # Assets estáticos
│   ├── Program.cs               # Entry point
│   └── WebApplication1.csproj   # Projeto .NET
│
├── 📁 terraform/                 # Infraestrutura como Código
│   ├── main.tf                  # Recursos principais
│   ├── variables.tf             # Variáveis de entrada
│   ├── outputs.tf               # Outputs úteis
│   ├── versions.tf              # Versões e providers
│   ├── terraform.tfvars.example # Exemplo de configuração
│   ├── README.md                # Documentação Terraform
│   ├── QUICKSTART.md            # Guia rápido
│   └── modules/                 # Módulos reutilizáveis
│       └── webapp/              # Módulo Web App
│
├── 📁 .github/
│   └── workflows/
│       └── terraform-validation.yml  # CI/CD Terraform
│
├── 📄 .pre-commit-config.yaml   # Pre-commit hooks
├── 📄 .tflint.hcl               # Configuração TFLint
├── 📄 TERRAFORM_GUIDE.md        # Guia completo Terraform/HCL
├── 📄 AI_AGENT_INSTRUCTIONS.md  # Instruções para IA
└── 📄 README.md                 # Este arquivo
```

## 🏗️ Arquitetura Azure

A infraestrutura Terraform provisiona:

```
┌─────────────────────────────────────────────────────┐
│              Azure Subscription                     │
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │         Resource Group                        │ │
│  │                                               │ │
│  │  ┌─────────────────────────────────────────┐ │ │
│  │  │     App Service Plan                    │ │ │
│  │  │  (Windows, B1)                          │ │ │
│  │  └─────────────────────────────────────────┘ │ │
│  │                    │                          │ │
│  │                    ▼                          │ │
│  │  ┌─────────────────────────────────────────┐ │ │
│  │  │     Windows Web App                     │ │ │
│  │  │  (ASP.NET Core 8.0)                     │ │ │
│  │  │  - HTTPS Only                           │ │ │
│  │  │  - TLS 1.2+                             │ │ │
│  │  └─────────────────────────────────────────┘ │ │
│  │                    │                          │ │
│  │                    ▼                          │ │
│  │  ┌─────────────────────────────────────────┐ │ │
│  │  │     Application Insights                │ │ │
│  │  │  (Monitoramento)                        │ │ │
│  │  └─────────────────────────────────────────┘ │ │
│  │                    │                          │ │
│  │                    ▼                          │ │
│  │  ┌─────────────────────────────────────────┐ │ │
│  │  │     Log Analytics Workspace             │ │ │
│  │  │  (Logs centralizados)                   │ │ │
│  │  └─────────────────────────────────────────┘ │ │
│  └───────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

## 📚 Documentação

### Para Usuários

| Documento | Descrição |
|-----------|-----------|
| [`terraform/QUICKSTART.md`](terraform/QUICKSTART.md) | ⚡ Guia rápido (5 min) |
| [`terraform/README.md`](terraform/README.md) | 📖 Documentação completa Terraform |
| [`TERRAFORM_GUIDE.md`](TERRAFORM_GUIDE.md) | 📚 Guia de referência HCL/Terraform |

### Para Desenvolvedores/IA

| Documento | Descrição |
|-----------|-----------|
| [`AI_AGENT_INSTRUCTIONS.md`](AI_AGENT_INSTRUCTIONS.md) | 🤖 Instruções para agentes de IA |
| [`.tflint.hcl`](.tflint.hcl) | 🔍 Configuração de linting |
| [`.pre-commit-config.yaml`](.pre-commit-config.yaml) | ✅ Hooks de validação |

## 🎓 Conceitos-Chave (com Analogias)

Este projeto implementa explicações claras usando analogias:

| Conceito | Analogia |
|----------|----------|
| **Módulos Terraform** | Funções: `variables` = parâmetros, `outputs` = retorno |
| **State** | Banco de dados da infraestrutura |
| **Backend** | Localização do banco (local, S3, Azure Storage) |
| **terraform plan** | "Diff" da infraestrutura (revisão do PR) |
| **terraform apply** | Execução transacional (merge do PR) |
| **for_each** | Loop com chaves estáveis (dicionário) |
| **count** | Loop com índices (lista ordenada) |
| **locals** | Variáveis internas/constantes privadas |

📖 **Mais analogias**: [`TERRAFORM_GUIDE.md`](TERRAFORM_GUIDE.md#-conceitos-principais-com-analogias)

## 🔒 Segurança

### Implementado

- ✅ **HTTPS Only** obrigatório
- ✅ **TLS 1.2+** mínimo
- ✅ **Secrets** via variáveis de ambiente (não hardcoded)
- ✅ **Outputs sensíveis** marcados como `sensitive = true`
- ✅ **tfsec** para análise de segurança
- ✅ **Pre-commit hooks** para validação
- ✅ **State remoto** com lock recomendado

### Análise Automática

```bash
# Análise de segurança
cd terraform
tfsec .

# Checkov
checkov -d .

# TFLint
tflint --init
tflint
```

## 🔄 CI/CD

### GitHub Actions

O workflow em `.github/workflows/terraform-validation.yml` executa automaticamente:

✅ **Em Pull Requests**:
- Format check (`terraform fmt`)
- Validation (`terraform validate`)
- Linting (`tflint`)
- Security scan (`tfsec`)
- Plan (comentado no PR)
- Cost estimation (`infracost`)

✅ **Em Push para main**:
- Todas as validações acima
- Opcional: Deploy automático

### Pre-commit Hooks

```bash
# Instalar
pip install pre-commit
pre-commit install

# Executar manualmente
pre-commit run -a
```

Hooks configurados:
- `terraform_fmt` - Formatação
- `terraform_validate` - Validação
- `terraform_tflint` - Linting
- `terraform_tfsec` - Segurança
- `terraform_docs` - Documentação

## 🛠️ Desenvolvimento

### Requisitos

- .NET 8.0 SDK
- Terraform >= 1.9.0
- Azure CLI
- (Opcional) Visual Studio / VS Code

### Comandos Úteis

#### Aplicação

```bash
# Restaurar dependências
dotnet restore

# Build
dotnet build

# Executar
dotnet run

# Testes
dotnet test

# Publicar
dotnet publish -c Release
```

#### Infraestrutura

```bash
# Formatar código
terraform fmt -recursive

# Validar
terraform validate

# Planejar
terraform plan

# Aplicar
terraform apply

# Ver outputs
terraform output

# Destruir
terraform destroy
```

## 💰 Custos Estimados

Com configuração padrão (Basic B1):

| Recurso | Custo Mensal (USD) |
|---------|-------------------|
| App Service Plan B1 | ~$13.00 |
| Application Insights | ~$2.30/GB |
| Log Analytics | ~$2.30/GB |
| **Total** | **~$15-20** |

💡 **Dica**: Use tier `Free` para desenvolvimento/testes.

📊 **Análise detalhada**: Execute `infracost breakdown --path terraform`

## 🌍 Ambientes

### Opção 1: Workspaces

```bash
# Criar ambientes
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Alternar
terraform workspace select staging
```

### Opção 2: Diretórios Separados

```bash
terraform/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
└── modules/
```

📖 **Mais detalhes**: [`terraform/README.md#-workspaces-ambientes`](terraform/README.md#-workspaces-ambientes)

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/melhoria`)
3. Commit suas mudanças (`git commit -m 'Add: melhoria'`)
4. Push para a branch (`git push origin feature/melhoria`)
5. Abra um Pull Request

### Checklist antes do PR

- [ ] `terraform fmt -recursive`
- [ ] `terraform validate`
- [ ] `tflint`
- [ ] `tfsec .`
- [ ] Documentação atualizada
- [ ] Testes passando

## 📖 Recursos de Aprendizado

### Documentação Oficial

- **Terraform**: https://developer.hashicorp.com/terraform
- **Azure Provider**: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- **ASP.NET Core**: https://learn.microsoft.com/aspnet/core

### Tutoriais

- [Get Started - Azure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Azure Architecture Center](https://learn.microsoft.com/azure/architecture/)

### Comunidade

- [HashiCorp Discuss](https://discuss.hashicorp.com/c/terraform-core)
- [r/Terraform](https://reddit.com/r/Terraform)
- [Azure Community](https://techcommunity.microsoft.com/azure)

## 📝 Licença

Este projeto é licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- **HashiCorp** pela ferramenta Terraform
- **Microsoft** pelo Azure e .NET
- **Comunidade open-source** pelas ferramentas de qualidade (tflint, tfsec, checkov)

## 📞 Suporte

Encontrou um problema ou tem uma sugestão?

1. 📖 Consulte a [documentação](terraform/README.md)
2. 🔍 Procure em [Issues](https://github.com/devops022025/WebApplication1/issues)
3. 🆕 Abra uma [nova issue](https://github.com/devops022025/WebApplication1/issues/new)

---

**Feito com ❤️ usando Terraform e ASP.NET Core**

⭐ Se este projeto foi útil, considere dar uma estrela!
