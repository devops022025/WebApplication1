# Locals funcionam como variáveis intermediárias para clareza e reuso
# Analogia: São como constantes privadas numa função
locals {
  resource_prefix = "${var.app_name}-${var.environment}"
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Terraform   = "true"
    }
  )
}

# Resource Group - Container lógico para agrupar recursos relacionados
resource "azurerm_resource_group" "main" {
  name     = "${local.resource_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

# App Service Plan - Define a capacidade computacional (CPU, RAM)
# Analogia: É como escolher o "tamanho da máquina" que rodará sua aplicação
resource "azurerm_service_plan" "main" {
  name                = "${local.resource_prefix}-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Windows"
  sku_name            = "${var.sku.tier}_${var.sku.size}"

  tags = local.common_tags
}

# App Service - A aplicação web propriamente dita
resource "azurerm_windows_web_app" "main" {
  name                = "${local.resource_prefix}-webapp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  https_only = var.enable_https_only

  site_config {
    minimum_tls_version = var.min_tls_version
    always_on           = var.sku.tier != "Free" && var.sku.tier != "Shared"

    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v8.0"
    }
  }

  app_settings = merge(
    var.app_settings,
    var.enable_monitoring ? {
      "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.main[0].connection_string
      "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    } : {}
  )

  tags = local.common_tags

  # Dependência explícita para garantir ordem de criação
  depends_on = [azurerm_service_plan.main]
}

# Application Insights para monitoramento (condicional)
# Analogia: É como ter um "dashboard de métricas" da sua aplicação
resource "azurerm_application_insights" "main" {
  count = var.enable_monitoring ? 1 : 0

  name                = "${local.resource_prefix}-insights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"

  tags = local.common_tags
}

# Log Analytics Workspace para Application Insights
resource "azurerm_log_analytics_workspace" "main" {
  count = var.enable_monitoring ? 1 : 0

  name                = "${local.resource_prefix}-logs"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.common_tags
}
