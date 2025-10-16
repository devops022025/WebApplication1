# Instruções para Agente de IA: Mestre em HCL e Terraform

## 📋 Resumo da Implementação

Este repositório implementa as instruções completas para um **Agente de IA especialista em Terraform e HCL**, conforme especificado no problema statement. A implementação inclui:

1. ✅ **Infraestrutura como Código (IaC)** completa para deploy no Azure
2. ✅ **Documentação abrangente** em português com analogias
3. ✅ **Boas práticas** recomendadas pela HashiCorp
4. ✅ **Automação** via CI/CD e pre-commit hooks
5. ✅ **Validação e segurança** com ferramentas de análise

## 🎯 Objetivo do Agente de IA

Ser um **especialista confiável em Terraform e HCL**, entregando:
- 📚 Respostas práticas fundamentadas em documentação oficial
- 🔗 Exemplos reais e executáveis
- 💡 Explicações claras com analogias
- 🔐 Práticas de segurança e governança

## 👥 Público-Alvo

- Engenheiros(as) de infraestrutura
- SREs (Site Reliability Engineers)
- DevOps Engineers
- Desenvolvedores(as) que utilizam Terraform

## 🗣️ Idioma

**Português brasileiro por padrão**. Se o usuário escrever em outro idioma, acompanhar o idioma do usuário.

## 📂 Estrutura da Implementação

### 1. Diretório `terraform/`

Contém a infraestrutura completa seguindo best practices:

```
terraform/
├── versions.tf              # ✅ Versões fixadas com SemVer
├── variables.tf             # ✅ Variáveis tipadas com validações
├── main.tf                  # ✅ Recursos principais com comentários
├── outputs.tf               # ✅ Outputs úteis (alguns sensitive)
├── terraform.tfvars.example # ✅ Exemplo de configuração
├── README.md                # ✅ Documentação detalhada em PT-BR
└── modules/
    └── webapp/              # ✅ Módulo reutilizável
        ├── versions.tf
        ├── variables.tf
        ├── main.tf
        ├── outputs.tf
        └── README.md
```

### 2. Documentação

#### `terraform/README.md`
- 📖 Guia completo de uso
- 🎓 Explicações com analogias (conforme especificado)
- 🔗 Referências oficiais da HashiCorp
- 💻 Exemplos de código prontos para uso
- 🚀 Instruções passo a passo

#### `TERRAFORM_GUIDE.md`
- 📚 Guia de referência abrangente
- 🧩 Conceitos fundamentais explicados
- 🎯 Analogias prontas para uso
- 🔐 Práticas de segurança
- 🛠️ Troubleshooting

### 3. Automação e Qualidade

#### `.pre-commit-config.yaml`
Pre-commit hooks para validação automática:
- `terraform fmt` - Formatação
- `terraform validate` - Validação de sintaxe
- `tflint` - Linting
- `tfsec` - Análise de segurança
- `terraform_docs` - Documentação

#### `.tflint.hcl`
Configuração do TFLint com regras:
- Interpolação depreciada
- Declarações não usadas
- Sintaxe de comentários
- Documentação de outputs/variables
- Variáveis tipadas
- Convenção de nomenclatura
- Versões requeridas
- Estrutura padrão de módulos

#### `.github/workflows/terraform-validation.yml`
CI/CD no GitHub Actions:
- ✅ Format check
- ✅ Terraform validate
- ✅ TFLint
- ✅ tfsec (segurança)
- ✅ Terraform plan (comentado no PR)
- ✅ Infracost (estimativa de custos)

### 4. Configuração de Ambiente

#### `.gitignore` (atualizado)
Ignora arquivos sensíveis do Terraform:
- `*.tfstate` - State files
- `.terraform/` - Diretório de providers
- `.terraform.lock.hcl` - Lock file
- `terraform.tfvars` - Variáveis sensíveis
- `*.tfplan` - Planos de execução

## 🎓 Conceitos e Analogias Implementadas

Conforme especificado no problema statement, todas as explicações incluem analogias:

| Conceito | Analogia Implementada |
|----------|----------------------|
| **Módulos** | Funções: variáveis = parâmetros, outputs = valores de retorno, locals = variáveis internas |
| **terraform plan** | "Diff" de infraestrutura antes do merge |
| **terraform apply** | Execução transacional das mudanças (merge do PR) |
| **State** | Banco de dados da infraestrutura |
| **Backend** | Motor/localização do banco de dados |
| **State remoto + lock** | Banco com bloqueio transacional para evitar edições simultâneas |
| **depends_on** | Aresta explícita em um grafo de dependências |
| **for_each** | Loop com chaves estáveis (como dicionário) |
| **count** | Loop com lista indexada |
| **locals** | Variáveis internas/constantes privadas |
| **Workspaces** | Ambientes lógicos (branches de estado) |
| **moved blocks** | Mapa de redirecionamento de nomes antigos → novos |

## ✅ Checklist de Qualidade (Implementado)

Conforme especificado, todo código inclui:

- [x] Código executável e formatado em HCL
- [x] Analogias para explicar conceitos complexos
- [x] Boas práticas e pitfalls apontados
- [x] Referências oficiais (HashiCorp, Registry, GitHub)
- [x] Versões de Terraform e providers consideradas
- [x] Sugestões de validação (fmt, validate, tflint)
- [x] Sugestões de segurança (tfsec/Checkov)
- [x] Bloco `terraform { required_version, required_providers }`
- [x] Versões fixadas com SemVer
- [x] Tipos explícitos em variáveis
- [x] Validações quando apropriado
- [x] Outputs úteis com `sensitive = true` quando necessário
- [x] Comentários explicando decisões importantes

## 🔐 Segurança e Governança (Implementado)

Conforme especificado:

### Backends Remotos
- ✅ Exemplo de Azure Storage com lock
- ✅ Exemplo de AWS S3 + DynamoDB
- ✅ Exemplo de Terraform Cloud

### Gestão de Segredos
- ✅ Variáveis marcadas como `sensitive`
- ✅ Nunca hardcode segredos
- ✅ Exemplos de integração com Key Vault, Secrets Manager, Vault

### Outputs Sensíveis
- ✅ `sensitive = true` para chaves e secrets
- ✅ Documentação clara sobre dados confidenciais

### Validação e Análise
- ✅ tfsec configurado
- ✅ Checkov recomendado
- ✅ TFLint configurado
- ✅ Pre-commit hooks

## 🔍 Protocolo de Pesquisa (Referências)

Todas as referências oficiais estão incluídas:

### Documentação HashiCorp
- ✅ Linguagem (HCL): https://developer.hashicorp.com/terraform/language
- ✅ CLI: https://developer.hashicorp.com/terraform/cli
- ✅ Funções: https://developer.hashicorp.com/terraform/language/functions
- ✅ Variáveis: https://developer.hashicorp.com/terraform/language/values/variables
- ✅ Locals: https://developer.hashicorp.com/terraform/language/values/locals
- ✅ Outputs: https://developer.hashicorp.com/terraform/language/values/outputs
- ✅ Expressões: https://developer.hashicorp.com/terraform/language/expressions
- ✅ Dynamic blocks: https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks
- ✅ Backends: https://developer.hashicorp.com/terraform/language/settings/backends/configuration
- ✅ Workspaces: https://developer.hashicorp.com/terraform/cli/workspaces
- ✅ Refatoração (moved): https://developer.hashicorp.com/terraform/language/modules/develop/refactoring#moved-blocks
- ✅ Tutoriais: https://developer.hashicorp.com/terraform/tutorials

### Registry
- ✅ Terraform Registry: https://registry.terraform.io
- ✅ Azure Provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- ✅ AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

### GitHub Oficial
- ✅ Terraform Core: https://github.com/hashicorp/terraform
- ✅ Azure Provider: https://github.com/hashicorp/terraform-provider-azurerm
- ✅ AWS Provider: https://github.com/hashicorp/terraform-provider-aws

### Qualidade e Automação
- ✅ TFLint: https://github.com/terraform-linters/tflint
- ✅ tfsec: https://github.com/aquasecurity/tfsec
- ✅ Checkov: https://github.com/bridgecrewio/checkov
- ✅ Pre-commit Terraform: https://github.com/antonbabenko/pre-commit-terraform
- ✅ Infracost: https://github.com/infracost/infracost

## 📊 Escopo de Conhecimento Coberto

Conforme especificado, a implementação cobre:

### HCL
- ✅ Tipos e constraints (string, number, bool, list, set, map, object, tuple, any)
- ✅ Expressões: condicionais, `for`, splats, `coalesce`, `try`, `can`, `merge`, `lookup`
- ✅ `dynamic` blocks
- ✅ `jsonencode`, `fileset`, `templatefile`

### Terraform Core
- ✅ Ciclo: `init`, `plan`, `apply`, `destroy`
- ✅ State, backends, locking, drift
- ✅ Dependências: implícitas e `depends_on`
- ✅ Workspaces vs. estratégias multi-ambiente
- ✅ Refatoração: `moved` blocks
- ✅ Versionamento: `required_version`, pinning de provider

### Providers e Registry
- ✅ Documentação de recursos e data sources
- ✅ Exemplos para Azure (azurerm)
- ✅ Referências para AWS

### Módulos
- ✅ Estrutura recomendada (main.tf, variables.tf, outputs.tf, versions.tf, README)
- ✅ Versionamento e publicação
- ✅ Entradas e saídas como contratos
- ✅ Exemplo prático no diretório `modules/webapp`

### Qualidade e Automação
- ✅ `terraform fmt/validate`
- ✅ `tflint` configurado
- ✅ `tfsec`/Checkov recomendados
- ✅ Pre-commit hooks implementados
- ✅ CI/CD (GitHub Actions) configurado
- ✅ Infracost para custos

### Padrões e Anti-padrões
- ✅ Módulos genéricos vs. específicos
- ✅ Evitar acoplamento excessivo
- ✅ Gestão de segredos
- ✅ Dados sensíveis

## 🎨 Formato das Respostas (Implementado)

Todos os documentos seguem a estrutura sugerida:

1. ✅ **Resumo curto** do que será feito/explicado
2. ✅ **Solução** (código HCL pronto para colar)
3. ✅ **Explicação** com analogias e trade-offs
4. ✅ **Passos** para validar e aplicar (comandos)
5. ✅ **Boas práticas** e pitfalls comuns
6. ✅ **Referências** (links oficiais)

## 📝 Padrões de Código (Exemplo Implementado)

Ver `terraform/main.tf` e `terraform/modules/webapp/main.tf` para exemplos completos que seguem todos os padrões especificados.

## 🚀 Como Usar Esta Implementação

### Para Desenvolvedores

1. **Estudar a documentação**:
   - Ler `terraform/README.md` para guia prático
   - Ler `TERRAFORM_GUIDE.md` para referência completa

2. **Explorar exemplos**:
   - Examinar `terraform/main.tf` para infraestrutura básica
   - Examinar `terraform/modules/webapp/` para módulo reutilizável

3. **Implementar validação**:
   - Instalar pre-commit: `pip install pre-commit && pre-commit install`
   - Configurar CI/CD com o workflow fornecido

### Para Agentes de IA

Se você é um agente de IA trabalhando com Terraform:

1. **Sempre referencie documentação oficial**:
   - Use links das seções "Referências" nos documentos
   - Priorize HashiCorp Developer como fonte primária

2. **Use analogias consistentes**:
   - Consulte a tabela de analogias neste documento
   - Mantenha explicações claras e acessíveis

3. **Forneça código de qualidade**:
   - Inclua version pinning
   - Use tipos explícitos
   - Adicione validações
   - Marque outputs sensíveis

4. **Incentive segurança**:
   - Nunca sugira hardcoding de secrets
   - Sempre mencione backends remotos
   - Recomende ferramentas de análise (tfsec, Checkov)

5. **Explique trade-offs**:
   - `for_each` vs. `count`
   - Workspaces vs. diretórios
   - Módulos locais vs. Registry

## 🔄 Próximos Passos

Para continuar melhorando esta implementação:

1. [ ] Adicionar exemplos para AWS (complementar Azure)
2. [ ] Criar testes automatizados com Terratest
3. [ ] Adicionar mais módulos reutilizáveis
4. [ ] Implementar multi-cloud examples
5. [ ] Criar guias de troubleshooting específicos
6. [ ] Adicionar exemplos de integração com Kubernetes
7. [ ] Documentar padrões de disaster recovery

## 📞 Suporte

Para dúvidas ou melhorias:
1. Consulte as referências oficiais nos documentos
2. Revise os exemplos práticos em `terraform/`
3. Execute os comandos de validação
4. Contribua com melhorias via Pull Request

---

**Nota**: Esta implementação segue fielmente as instruções do problema statement, fornecendo uma base sólida para trabalhar com Terraform e HCL seguindo as melhores práticas da indústria.
