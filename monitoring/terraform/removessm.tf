resource "aws_ssm_document" "Remove_dynatrace_agent" {
  name          = "Remove_dynatrace_agent"
  document_type = "Command"
  content       = <<DOC
{
  "description": "Removes the Dynatrace Agent",
  "mainSteps": [
    {
      "action": "aws:runPowerShellScript",
      "inputs": {
        "DocumentType": "PowerShell",
        "RunCommand": [
          "Write-Host 'Retrieving Dynatrace installation files from S3...'",
          "if(-not([System.IO.Directory]::Exists('c:\\EMIS\\Dynatrace'))){",
          "New-Item -Path 'c:\\EMIS\\' -Name 'Dynatrace' -ItemType 'directory'}",
          "Read-S3Object -BucketName '{{S3BucketName}}' -KeyPrefix '{{s3InstallerKey}}' -Folder 'C:\\emis\\dynatrace\\{{s3InstallerKey}}'",
          "Read-S3Object -BucketName '{{S3BucketName}}' -KeyPrefix '{{s3ConfKey}}' -Folder 'C:\\emis\\dynatrace\\{{s3ConfKey}}'",
          "Read-S3Object -BucketName '{{S3BucketName}}' -KeyPrefix '{{s3ScriptsKey}}' -Folder 'C:\\emis\\dynatrace\\{{s3ScriptsKey}}'",
          "$files = Get-ChildItem 'C:\\emis\\dynatrace\\'",
          "foreach ($f in $files) {",
          "Write-Host 'required files retrieved' }"
        ]
      },
      "name": "Download_Files"
    },
    {
      "action": "aws:runPowerShellScript",
      "inputs": {
        "RunCommand": [
          "C:\\emis\\dynatrace\\scripts\\{{PSInstallScript}}"
        ]
      },
      "name": "Remove_dYNA"
    }
  ],
  "parameters": {
    "PSInstallScript": {
      "default": "removeagent.ps1",
      "type": "String"
    },
    "S3BucketName": {
      "default": "${var.tags.environment}-${var.tags.service}-s3-bucket-${var.account_id}",
      "description": "The bucket for installation files",
      "type": "String"
    },
    "s3InstallerKey": {
      "default": "agent",
      "description": "The key for the installation files in the S3 bucket",
      "type": "String"
    },
    "s3ConfKey": {
      "default": "config",
      "description": "The key for the installation files in the S3 bucket",
      "type": "String"
    },
    "s3ScriptsKey": {
      "default": "scripts",
      "description": "The key for the installation files in the S3 bucket",
      "type": "String"
    }
  },
  "schemaVersion": "2.2"
}
DOC

  tags = {
    "team_sre_ssm"  = "true"
    "team_operations_ssm" = "true"
    "team_platforms_ssm"  = "true"
    "team_devops_ssm"  = "true"
    #team platforms gives all users access if this is set to true.
 
    #"Namespace" = "Sre,Operations"

  }

}
