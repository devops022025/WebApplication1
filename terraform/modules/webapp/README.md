# Módulo: webapp

Este é um módulo reutilizável para provisionar uma aplicação web ASP.NET Core no Azure.

## 🎯 Propósito

Encapsula a lógica de criação de um Web App no Azure, incluindo:
- App Service Plan
- Windows Web App
- Application Insights (opcional)
- Log Analytics Workspace (opcional)

**Analogia**: Pense em módulos como **funções reutilizáveis**:
- `variables.tf` → Parâmetros de entrada
- `main.tf` → Corpo da função (lógica)
- `outputs.tf` → Valores de retorno

## 📦 Uso

```hcl
module "webapp_dev" {
  source = "./modules/webapp"

  environment         = "dev"
  location           = "East US"
  resource_group_name = azurerm_resource_group.main.name
  app_name           = "myapp"
  
  sku = {
    tier = "Basic"
    size = "B1"
  }

  enable_monitoring = true
  enable_https_only = true
  
  tags = {
    ManagedBy = "Terraform"
    Project   = "WebApplication1"
  }
}

# Acessar outputs do módulo
output "dev_webapp_url" {
  value = module.webapp_dev.webapp_url
}
```

## 📥 Inputs

| Nome | Tipo | Descrição | Padrão | Obrigatório |
|------|------|-----------|--------|-------------|
| `environment` | `string` | Nome do ambiente (dev, staging, prod) | - | ✅ |
| `location` | `string` | Região do Azure | - | ✅ |
| `resource_group_name` | `string` | Nome do Resource Group | - | ✅ |
| `app_name` | `string` | Nome base da aplicação | - | ✅ |
| `sku` | `object` | Configuração do App Service Plan | `{ tier = "Basic", size = "B1" }` | ❌ |
| `enable_monitoring` | `bool` | Habilitar Application Insights | `true` | ❌ |
| `enable_https_only` | `bool` | Forçar HTTPS apenas | `true` | ❌ |
| `min_tls_version` | `string` | Versão mínima do TLS | `"1.2"` | ❌ |
| `tags` | `map(string)` | Tags a aplicar nos recursos | `{}` | ❌ |

## 📤 Outputs

| Nome | Descrição | Sensível |
|------|-----------|----------|
| `webapp_url` | URL da aplicação web | ❌ |
| `webapp_name` | Nome do Web App | ❌ |
| `webapp_id` | ID do recurso Web App | ❌ |
| `app_service_plan_id` | ID do App Service Plan | ❌ |
| `application_insights_instrumentation_key` | Chave de instrumentação do App Insights | ✅ |
| `application_insights_connection_string` | Connection string do App Insights | ✅ |

## 🧪 Testes

Para testar este módulo, use **Terratest**:

```go
// test/webapp_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestWebAppModule(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../examples/webapp",
        Vars: map[string]interface{}{
            "environment": "test",
            "app_name":    "testapp",
        },
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    webappURL := terraform.Output(t, terraformOptions, "webapp_url")
    assert.NotEmpty(t, webappURL)
}
```

## 🔄 Versionamento

Este módulo segue **Semantic Versioning** (SemVer):

- **MAJOR** (1.x.x): Mudanças incompatíveis
- **MINOR** (x.1.x): Novas funcionalidades compatíveis
- **PATCH** (x.x.1): Correções de bugs

Para usar uma versão específica:

```hcl
module "webapp" {
  source  = "git::https://github.com/org/repo.git//modules/webapp?ref=v1.2.3"
  # ...
}
```

## 📚 Referências

- **Módulos Terraform**: https://developer.hashicorp.com/terraform/language/modules
- **Registry de Módulos**: https://registry.terraform.io/browse/modules
- **Best Practices**: https://developer.hashicorp.com/terraform/language/modules/develop
- **Terratest**: https://terratest.gruntwork.io/
