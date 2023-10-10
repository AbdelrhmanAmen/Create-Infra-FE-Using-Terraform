terraform {
    required_providers {
        flexibleengine = {
            source = "FlexibleEngineCloud/flexibleengine"
            version = ">= 1.20.0"
        }
    }
}
provider "flexibleengine" {
    access_key  = var.access_key
    secret_key  = var.secret_key
    domain_name = var.domain_name
    region      = var.region
    tenant_id =  var.tenant_id
}
