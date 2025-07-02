# Deploy Dynatrace

0. Before proceeding please obtain get authorisation from finops then add in your COST_CENTER and PRODUCT to the respectivley named json file (in configuation_files folder) if this is not already in the list.


IF NOT ALREADY RUN PLEASE SEE /bootstrap/README.MD

This module creates all the resources required to deploy new Dynatrace agent install SSM Documents

To deploy on a new instance:

1. Export your AWS creds into local environment variables. You will need admistrative access to run bootstrap. You can copy the following values directly from the AWS console -

    export AWS_ACCESS_KEY_ID=""  
    export AWS_SECRET_ACCESS_KEY=""  
    export AWS_SESSION_TOKEN=""

2. Alternatively run the github actions workflow Dev-Deploy. Ensure you change the github dev enviornment secrets to match your account and deploy role arn



3. Each AWS account you wish to deploy, required setup of a new environment in github with the following secrets:
   AWS_ACCOUNT_ID
   DEPLOYER_ROLE_ARN

   Then put in a pull request in order to obtain the remaining required secrets in this repo: emisx-sre-config/data/github_repositories/README.md, upon approval and merge the additonal required variables will be populated, you will see these in environment variables.  Please note these are overwritten to support token recycling.
   DYNATRACE_API_TOKEN
   DYNATRACE_ENV_URL
   TF_VAR_DYN_AG_TOKEN
   TF_VAR_DYN_OTEL_TOKEN


4. Create a terragrunt file in the respective folder (in terragrunt folder) copy one of the available templates in the templates folder, these are distinctly differnet for production and non-prod.
   Create a folder indicating your environments name. Rename rename the file environment.terragrunt.hcl.

5. If this is a new environment be sure to update the newinstall.ps1 to cater for your configuration appropriatley.  $computerNameConfig block lookup table needs updating as does the getenvironment function.
This will be abstracted in a future release.

Please note this is for the setup of the agent only, any specific monitoring needs to be done either in your own repo or for Health SRE systems can be found in the health sre repository.
It is important to get all the tags correct otherwise monitoring is not possible, please note host_groups are fundemental to this functionality and dependant on the tagging logic so make these unique.



6. lastly upon a successfull deploy workflow, you will find output from the deploy workflow in the terragrunt deploy section simmilar to dynatrace-integration-roles = "arn:aws:iam::***:role/dynatrace-aws-integration-role-main"
This string needs to be added into the health sre repo (emishealth-sre-config), specifically ..\deploy\env\ environment folder \ common.tfv  add in this string to the "list_aws_account_roles_arn" array as a stringh replacing the 
asterix with the account number.


7. Be sure to add in the relevant resolver rule also - aws > route53 >resolver > rules.