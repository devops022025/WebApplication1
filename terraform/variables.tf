variable "environment" {
  type        = string
  description = "Nome do ambiente (dev, staging, prod)"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "O ambiente deve ser dev, staging ou prod."
  }
}

variable "location" {
  type        = string
  description = "Região do Azure para os recursos"
  default     = "East US"

  validation {
    condition     = can(regex("^[A-Z][a-z]+ [A-Z][a-z]+$", var.location))
    error_message = "A localização deve estar no formato 'East US', 'West Europe', etc."
  }
}

variable "app_name" {
  type        = string
  description = "Nome base da aplicação (será prefixado com o ambiente)"

  validation {
    condition     = length(var.app_name) > 0 && length(var.app_name) <= 20
    error_message = "O nome da aplicação deve ter entre 1 e 20 caracteres."
  }
}

variable "sku" {
  description = "Configuração do App Service Plan"
  type = object({
    tier = string
    size = string
  })
  default = {
    tier = "Basic"
    size = "B1"
  }

  validation {
    condition     = contains(["Free", "Shared", "Basic", "Standard", "Premium", "PremiumV2", "PremiumV3"], var.sku.tier)
    error_message = "O tier do SKU deve ser um dos valores válidos do Azure App Service."
  }
}

variable "tags" {
  description = "Tags comuns a serem aplicadas a todos os recursos"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "WebApplication1"
  }
}

variable "app_settings" {
  description = "Configurações específicas da aplicação (variáveis de ambiente)"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "enable_monitoring" {
  type        = bool
  description = "Habilitar Application Insights para monitoramento"
  default     = true
}

variable "enable_https_only" {
  type        = bool
  description = "Forçar HTTPS apenas"
  default     = true
}

variable "min_tls_version" {
  type        = string
  description = "Versão mínima do TLS"
  default     = "1.2"

  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.min_tls_version)
    error_message = "A versão do TLS deve ser 1.0, 1.1 ou 1.2."
  }
}
