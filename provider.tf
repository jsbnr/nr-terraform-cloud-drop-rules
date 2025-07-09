terraform {
  required_version = "~> 1.11.3"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.63.0"
    }
    graphql = {
      source = "sullivtr/graphql"
      version = "2.6.1" 
    }
  }
}

provider "newrelic" {
  region = "US"
  api_key = var.NEW_RELIC_API_KEY
  account_id = var.accountId
}

provider "graphql" {
  url = "https://api.newrelic.com/graphql"
  headers = {
    "API-Key" = var.NEW_RELIC_API_KEY
  }
}

variable "NEW_RELIC_API_KEY" { 
  type = string
  sensitive = true
}

variable "accountId" { 
  type = string
}