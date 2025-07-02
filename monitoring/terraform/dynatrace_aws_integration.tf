module "aws_intg" {
  count  = var.aws_intg_enabled ? 1 : 0
  source = "git@github.com:emisgroup/emisx-sre-config.git//modules/dyn_aws_integration?ref=tf-module-dyn-aws-intg@v1.1.2"
  #checkov:skip=CKV_TF_1:This is a trusted internal resource

  environment           = local.environment
  aws_account_id        = var.account_id
  instance              = var.instance
  dyn_iam_role_name     = "dynatrace-aws-integration-role"
  tags                  = module.default_tags.tags
  active_gate_local     = false
  active_gate_role_name = var.activegate_ec2_role_name
  services              = ["ec2", "ebs", "s3"]
}


module "aws_stream" {
  count  = var.aws_stream_enabled ? 1 : 0
  source = "github.com/emisgroup/emisx-sre-config//modules/dyn_aws_stream?ref=12e015478547a818b8e55a3726651395f72fec59" // tf-module-dyn-aws-stream@v0.2.4
  #checkov:skip=CKV_TF_1:This is a trusted internal resource
  deployment_role_arns = var.deployment_role_arns
  instance             = "default"
  dyn_ingest_token     = var.dyn_otel_token
  dyn_environment_url  = "https://${var.dyn_env_id}.live.dynatrace.com"
  tags                 = module.default_tags.tags
  include_filters = [
    {
      namespace    = "AWS/NetworkELB",
      metric_names = ["ActiveFlowCount", "ActiveFlowCount_TCP", "ActiveFlowCount_TLS", "TCP_Client_Reset_Count", "TCP_ELB_Reset_Count", "TCP_Target_Reset_Count", "PortAllocationErrorCount", "HealthyHostCount", "UnHealthyHostCount"]
    },
    {
      namespace    = "AWS/ElastiCache",
      metric_names = ["AuthenticationFailures", "BytesUsedForCache", "CacheHitRate", "CacheHits", "CacheMisses", "ChannelAuthorizationFailures", "ClusterBasedCmds", "ClusterBasedCmdsLatency", "CommandAuthorizationFailures", "CurrConnections", "CurrItems", "DB0AverageTTL","DatabaseMemoryUsagePercentage", "EngineCPUUtilization", "Evictions", "FreeableMemory", "FreeableMemory", "GetTypeCmds", "GetTypeCmdsLatency", "HashBasedCmds", "HashBasedCmdsLatency", "IamAuthenticationExpirations", "IamAuthenticationThrottling", "IsMaster", "KeyAuthorizationFailures", "KeyBasedCmds", "KeyBasedCmdsLatency", "NetworkBandwidthInAllowanceExceeded", "NetworkBandwidthOutAllowanceExceeded", "NetworkBytesIn", "NetworkBytesOut", "NewConnections", "Reclaimed", "ReplicationLag", "ReplicationBytes", "SetTypeCmds", "SetTypeCmdsLatency", "SwapUsage"]
    }
  ]
}
