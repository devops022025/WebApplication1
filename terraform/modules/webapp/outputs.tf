output "webapp_url" {
  description = "URL padrão da aplicação web"
  value       = "https://${azurerm_windows_web_app.this.default_hostname}"
}

output "webapp_name" {
  description = "Nome do Web App"
  value       = azurerm_windows_web_app.this.name
}

output "webapp_id" {
  description = "ID do recurso Web App"
  value       = azurerm_windows_web_app.this.id
}

output "app_service_plan_id" {
  description = "ID do App Service Plan"
  value       = azurerm_service_plan.this.id
}

output "application_insights_instrumentation_key" {
  description = "Chave de instrumentação do Application Insights"
  value       = var.enable_monitoring ? azurerm_application_insights.this[0].instrumentation_key : null
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string do Application Insights"
  value       = var.enable_monitoring ? azurerm_application_insights.this[0].connection_string : null
  sensitive   = true
}
