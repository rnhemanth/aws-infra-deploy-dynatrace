locals {
  region            = get_env("AWS_REGION")
  account_id        = get_env("AWS_ACCOUNT_ID")
  deployer_role     = get_env("DEPLOYER_ROLE_ARN")
  environment       = get_env("ENVIRONMENT")

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
  sql_inventory_targets                     = {
    key    = "tag:Name"
    values = ["*dssdb"]
  }

  create_finops_sql_registry_key_creator_ssm_association = true
  # sql_registry_key_creator_apply_only_at_cron_interval = true
  # sql_registry_key_creator_compliance_severity         = "UNSPECIFIED"
  # sql_registry_key_creator_schedule_expression         = "cron(0 45 10 ? * * *)"
  # sql_registry_key_creator_execution_timeout           = "3600"
  sql_registry_key_creator_targets                     = {
    key    = "tag:Name"
    values = ["*dssdb"]
  }

  create_finops_ssm_inventory_data_sync = true
  # s3_destination = {
  #   bucket_name = "ssm-resource-data-sync-inv"
  #   region      = "eu-west-2"
  #   sync_format = "JsonSerDe"
  # }
}
