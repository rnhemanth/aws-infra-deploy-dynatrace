locals {
  region            = get_env("AWS_REGION")
  account_id        = get_env("AWS_ACCOUNT_ID")
  deployer_role     = get_env("DEPLOYER_ROLE_ARN")
  environment       = get_env("ENVIRONMENT")


  create_finops_sql_inventory_ssm_association = true

  create_finops_sql_registry_key_creator_ssm_association = true


  create_finops_ssm_inventory_data_sync = true

  ### Activegate integrations catered for in common file so delaration needed.

  ###added in for dynamic values
  tags = {
    environment = "${local.environment}"
    service     = "dynatrace"
  }
  #####end


}
