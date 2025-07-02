variable "ps_install_script_name" {
  type        = string
  description = "the name of the powershell script to install otel"
  default     = "installoneagent.ps1"
}

#variable "tags" {
#  type = object({
#    environment = string
#    service     = string
#    identifier  = string
#  })
#  description = "environment, service and identifier. part of tagging"
#}




##########updating the below to dynamic pass from tg file
#variable "tags" {
#  type = map(string)
#  default = {
#    environment = "dev123"
#    service     = "dynatrace123"
#  }
#  description = "environment, service and identifier. part of tagging"
#}

###>>>>>>
variable "tags" {
  type = object({
    environment = string
    service     = string
  })
  description = "environment, service and identifier. part of tagging"
}



###



variable "instance" {
  type    = string
  default = "main"
}



variable "activegate_group" {
  type        = string
  description = "The activegate group value"
}

variable "dyn_env_id" {
  description = "Dynatrace environment ID"
  type        = string
}

variable "dyntrace_get_agent_token" {
  description = "Dynatrace get agent token"
  type        = string
  sensitive   = true
}

variable "deployment_role_arns" {
  type        = list(string)
  description = "List of deployment roles to manage resources"
}


variable "environment" {
  type        = string
  description = "The environment"

}


variable "account_id" {
  type        = string
  description = "Account ID"
}


variable "service_version" {
  type        = string
  description = "The version of the service"

}

variable "activegate_ec2_role_name" {
  default     = null
  type        = string
  description = "The version of the service"
}

variable "dyn_otel_token" {
  type        = string
  description = "The OTEL ingestion token for Dynatrace"
  sensitive   = true
}

variable "aws_intg_enabled" {
  type        = bool
  description = "Toggle enable AWS integration module"
  default     = true
}

variable "aws_stream_enabled" {
  type        = bool
  description = "Toggle enable AWS stream module"
  default     = false

}