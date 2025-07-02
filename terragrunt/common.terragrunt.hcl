locals {
  service          = "dynatrace"
  owner            = "hosted-platforms"
  business_unit    = "primary-care"
  product          = "dynatrace"
  account_state    = "0"
  programme_name   = "adelaide"
  project_name     = "brisbane"
  project_code     = "prj0011476"
  iac_source       = "terraform"
  dr               = "low-not required"
  dyn_otel_token   = get_env("TF_VAR_DYN_OTEL_TOKEN")
}
