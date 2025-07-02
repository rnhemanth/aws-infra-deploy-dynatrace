locals {
  region            = get_env("AWS_REGION")
  account_id        = get_env("AWS_ACCOUNT_ID")
  deployer_role     = get_env("DEPLOYER_ROLE_ARN")
  environment       = get_env("ENVIRONMENT")
  ### Activegate AWS INT items
  activegate_ec2_role_name = "arn:aws:iam::886436939380:role/asg-role-dyn-ag-main-ag-ec2-main"
  instance                  = "main"
  deployment_role_arns      = [local.deployer_role]
  aws_stream_enabled        = true
  ######## environment needs changing accordingly
  dyn_env_id                = "zoh82166"
  activegate_group          = "health-${local.environment}"
  dyntrace_get_agent_token  = get_env("TF_VAR_DYN_AG_TOKEN")
  service_version           = "v0.1.0"
  # end activegate module vars
}
