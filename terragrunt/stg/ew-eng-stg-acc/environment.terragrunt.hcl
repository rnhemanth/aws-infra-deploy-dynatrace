locals {
  region            = get_env("AWS_REGION")
  account_id        = get_env("AWS_ACCOUNT_ID")
  deployer_role     = get_env("DEPLOYER_ROLE_ARN")
  environment       = get_env("ENVIRONMENT")



  ### Activegate AWS INT items
  activegate_ec2_role_name = "arn:aws:iam::586794449617:role/asg-role-dyn-ag-main-ag-ec2-main"
  instance                  = "main"
  deployment_role_arns      = [local.deployer_role]
  ######## environment needs changing accordingly
  dyn_env_id                = "vfo08320"
  activegate_group          = "health-${local.environment}"
  dyntrace_get_agent_token  = get_env("TF_VAR_DYN_AG_TOKEN")
  service_version           = "v0.1.0"
  # end activegate module vars

  create_finops_sql_inventory_ssm_association = true
  # sql_inventory_apply_only_at_cron_interval = false
  # sql_inventory_schedule_expression         = "cron(0 50 10 ? * * *)"
  # sql_inventory_parameters = {
  #     applications                 = "Enabled"
  #     awsComponents                = "Disabled"
  #     billingInfo                  = "Disabled"
  #     customInventory              = "Disabled"
  #     instanceDetailedInformation  = "Enabled"
  #     networkConfig                = "Disabled"
  #     services                     = "Disabled"
  #     windowsRegistry              = "[{\"Path\":\"HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\EMIS_INVENTORY\",\"Recursive\":false,\"ValueNames\":[\"Edition\"]},{\"Path\":\"HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\EMIS_INVENTORY\",\"Recursive\":false,\"ValueNames\":[\"Version\"]},{\"Path\":\"HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Computername\\Computername\",\"Recursive\":false,\"ValueNames\":[\"Computername\"]}]"
  #     windowsRoles                 = "Disabled"
  #     windowsUpdates               = "Disabled"
  #   }
  # sql_inventory_targets                     = {
  #   key    = "tag:server_type"
  #   values = ["db", "DB", "CCM-TRN-onebox", "CCMH-UAT-onebox", "CCMH-LAD-onebox"]
  # }

  create_finops_sql_registry_key_creator_ssm_association = true
  # sql_registry_key_creator_apply_only_at_cron_interval = true
  # sql_registry_key_creator_compliance_severity         = "UNSPECIFIED"
  # sql_registry_key_creator_schedule_expression         = "cron(0 45 10 ? * * *)"
  # sql_registry_key_creator_execution_timeout           = "3600"
  # sql_registry_key_creator_targets                     = {
  #   key    = "tag:server_type"
  #   values = ["db", "DB", "CCM-TRN-onebox", "CCMH-UAT-onebox", "CCMH-LAD-onebox"]
  # }

  create_finops_ssm_inventory_data_sync = true
  # s3_destination = {
  #   bucket_name = "ssm-resource-data-sync-inv"
  #   region      = "eu-west-2"
  #   sync_format = "JsonSerDe"
  # }

  ###added in for dynamic values
  tags = {
    environment = "${local.environment}"
    service     = "dynatrace"
  }
  #####end

}
