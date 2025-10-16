# Locals para construir nomes e tags
locals {
  resource_prefix = "${var.app_name}-${var.environment}"
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "webapp"
    }
  )
}

# App Service Plan
resource "azurerm_service_plan" "this" {
  name                = "${local.resource_prefix}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Windows"
  sku_name            = "${var.sku.tier}_${var.sku.size}"

  tags = local.common_tags
}

# Windows Web App
resource "azurerm_windows_web_app" "this" {
  name                = "${local.resource_prefix}-webapp"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id

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
      "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.this[0].connection_string
      "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    } : {}
  )

  tags = local.common_tags
}

# Log Analytics Workspace (para Application Insights)
resource "azurerm_log_analytics_workspace" "this" {
  count = var.enable_monitoring ? 1 : 0

  name                = "${local.resource_prefix}-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.common_tags
}

# Application Insights
resource "azurerm_application_insights" "this" {
  count = var.enable_monitoring ? 1 : 0

  name                = "${local.resource_prefix}-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.this[0].id

  tags = local.common_tags
}
