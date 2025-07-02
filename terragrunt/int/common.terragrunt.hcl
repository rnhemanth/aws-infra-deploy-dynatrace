locals {
  ### Activegate AWS INT items
  activegate_ec2_role_name = "arn:aws:iam::585768186848:role/asg-role-dyn-ag-main-ag-ec2-main"
  instance                  = "main"
  ######## environment needs changing accordingly
  dyn_env_id                = "vfo08320"
  dyntrace_get_agent_token  = get_env("TF_VAR_DYN_AG_TOKEN")
  service_version           = "v0.1.0"
  # end activegate module vars
}
