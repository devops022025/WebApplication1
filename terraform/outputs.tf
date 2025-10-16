# Outputs são valores úteis expostos após o apply
# Analogia: São como o "valor de retorno" de uma função

output "resource_group_name" {
  description = "Nome do Resource Group criado"
  value       = azurerm_resource_group.main.name
}

output "webapp_url" {
  description = "URL padrão da aplicação web"
  value       = "https://${azurerm_windows_web_app.main.default_hostname}"
}

output "webapp_name" {
  description = "Nome do Web App"
  value       = azurerm_windows_web_app.main.name
}

output "webapp_id" {
  description = "ID do recurso Web App"
  value       = azurerm_windows_web_app.main.id
  sensitive   = false
}

output "app_service_plan_id" {
  description = "ID do App Service Plan"
  value       = azurerm_service_plan.main.id
}

output "application_insights_instrumentation_key" {
  description = "Chave de instrumentação do Application Insights"
  value       = var.enable_monitoring ? azurerm_application_insights.main[0].instrumentation_key : null
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string do Application Insights"
  value       = var.enable_monitoring ? azurerm_application_insights.main[0].connection_string : null
  sensitive   = true
}

output "environment" {
  description = "Ambiente atual da infraestrutura"
  value       = var.environment
}
