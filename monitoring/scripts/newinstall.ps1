

# Vars passed in from ssm
param (
  [Parameter(Mandatory=$true)]
  [string]$costcentre,
  [string]$product,
  [string]$msiName,
  [string]$monitormode,
  [string]$automationmode
)

# Get the current computer name
$computerName = $env:computername

#########################Computer config added here##############################

# Define a configuration table for computer name patterns and their corresponding values
$computerNameConfig = @(
    

    #add more here if needed here.


    #emisweb gp england 
    @{ Regex = '^ENEUW2GP.*APP.*$'; Service = 'emisweb'; Speciality = 'gp'; Locale = 'eng'; Type = 'app'; PD = { ('aws_eng_' + $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^ENEUW2GP.*DBS.*$'; Service = 'emisweb'; Speciality = 'gp'; Locale = 'eng'; Type = 'db'; PD = { ('aws_eng_' + $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^ENEUW2GP.*RS.*$'; Service = 'emisweb'; Speciality = 'gp'; Locale = 'eng'; Type = 'rs'; PD = { ('aws_eng_' + $computerName.Substring(6,4)).ToLower() } },
    #ccmh england 
    @{ Regex = '^ENEUW2CM.*APP.*$'; Service = 'emisweb'; Speciality = 'ccmh'; Locale = 'eng'; Type = 'app'; PD = { ('aws_eng_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^ENEUW2CM.*DB.*$'; Service = 'emisweb'; Speciality = 'ccmh'; Locale = 'eng'; Type = 'db'; PD = { ('aws_eng_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^ENEUW2CM.*RS-.*$'; Service = 'emisweb'; Speciality = 'ccmh'; Locale = 'eng'; Type = 'rs'; PD = { ('aws_eng_'+ $computerName.Substring(6,4)).ToLower() } },
    #cs england 
    @{ Regex = '^ENEUW2CS.*APP.*$'; Service = 'emisweb'; Speciality = 'clinical-svcs'; Locale = 'eng'; Type = 'app'; PD = { ('aws_eng_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^ENEUW2CS.*DBS.*$'; Service = 'emisweb'; Speciality = 'clinical-svcs'; Locale = 'eng'; Type = 'db'; PD = { ('aws_eng_'+ $computerName.Substring(6,4)).ToLower() } },
    #uat trn england 
    @{ Regex = '^ENEUW2UAT.*DB.*$'; Service = 'emisweb'; Speciality = 'ccmhuat'; Locale = 'eng'; Type = 'db'; PD = { ('aws_eng_'+ $computerName.Substring(6,6)).ToLower() } },
    @{ Regex = '^ENEUW2TRN.*DB.*$'; Service = 'emisweb'; Speciality = 'ccmhtrn'; Locale = 'eng'; Type = 'db'; PD = { ('aws_eng_'+ $computerName.Substring(6,6)).ToLower() } },
    
    #nations IOM emisweb
    @{ Regex = '^IMEUW2GP.*APP.*$'; Service = 'emisweb'; Speciality = 'gp'; Locale = 'iom'; Type = 'app'; PD = { ('aws_iom_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^IMEUW2GP.*DBS.*$'; Service = 'emisweb'; Speciality = 'gp'; Locale = 'iom'; Type = 'db'; PD = { ('aws_iom_'+ $computerName.Substring(6,4)).ToLower() } },
    #nations IOM ccmh
    @{ Regex = '^IMEUW2CM.*APP.*$'; Service = 'emisweb'; Speciality = 'ccmh'; Locale = 'iom'; Type = 'app'; PD = { ('aws_iom_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^IMEUW2CM.*DBS.*$'; Service = 'emisweb'; Speciality = 'ccmh'; Locale = 'iom'; Type = 'db'; PD = { ('aws_iom_'+ $computerName.Substring(6,4)).ToLower() } },
    #nations IOM trn UAT
    @{ Regex = '^IMEUW2UAT.*DB.*$'; Service = 'emisweb'; Speciality = 'ccmhuat'; Locale = 'iom'; Type = 'db'; PD = { ('aws_iom_'+ $computerName.Substring(6,5)).ToLower() } },
    @{ Regex = '^IMEUW2TRN.*DB.*$'; Service = 'emisweb'; Speciality = 'ccmhtrn'; Locale = 'iom'; Type = 'db'; PD = { ('aws_iom_'+ $computerName.Substring(6,5)).ToLower() } },
    #nations Jersey emisweb
    @{ Regex = '^JYEUW2GP.*APP.*$'; Service = 'emisweb'; Speciality = 'gp'; Locale = 'jersey'; Type = 'app'; PD = { ('aws_jersey_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^JYEUW2GP.*DBS.*$'; Service = 'emisweb'; Speciality = 'gp'; Locale = 'jersey'; Type = 'db'; PD = { ('aws_jersey_'+ $computerName.Substring(6,4)).ToLower() } },
   
    #nations Jersey trn aut
    @{ Regex = '^JYEUW2TRN.*DB.*$'; Service = 'emisweb'; Speciality = 'ccmhtrn'; Locale = 'iom'; Type = 'db'; PD = { ('aws_jersey_'+ $computerName.Substring(6,5)).ToLower() } },
    #nations SCOT emis web
    @{ Regex = '^SCEUW2CM.*APP.*$'; Service = 'emisweb'; Speciality = 'ccmh'; Locale = 'scot'; Type = 'app'; PD = { ('aws_scot_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^SCEUW2CM.*DBS.*$'; Service = 'emisweb'; Speciality = 'ccmh'; Locale = 'scot'; Type = 'db'; PD = { ('aws_scot_'+ $computerName.Substring(6,4)).ToLower() } },
    #nations scot cs
    @{ Regex = '^SCEUW2CS.*APP.*$'; Service = 'emisweb'; Speciality = 'cs'; Locale = 'scot'; Type = 'app'; PD = { ('aws_scot_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^SCEUW2CS.*DBS.*$'; Service = 'emisweb'; Speciality = 'cs'; Locale = 'scot'; Type = 'db'; PD = { ('aws_scot_'+ $computerName.Substring(6,4)).ToLower() } },
    #nations scot fam
    @{ Regex = '^SCEUW2FM.*APP.*$'; Service = 'emisweb'; Speciality = 'fam'; Locale = 'scot'; Type = 'app'; PD = { ('aws_scot_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^SCEUW2FMSTRM.*$'; Service = 'emisweb'; Speciality = 'fam'; Locale = 'scot'; Type = 'strm'; PD = { ('aws_scot_strm').ToLower() } },
    @{ Regex = '^SCEUW2FM.*DBS.*$'; Service = 'emisweb'; Speciality = 'fam'; Locale = 'scot'; Type = 'db'; PD = { ('aws_scot_'+ $computerName.Substring(6,4)).ToLower() } },
    #nations scot trn UAT
    @{ Regex = '^SCEUW2TRN.*DB.*$'; Service = 'emisweb'; Speciality = 'ccmhtrn'; Locale = 'scot'; Type = 'db'; PD = { ('aws_scot_'+ $computerName.Substring(6,5)).ToLower() } },
    @{ Regex = '^SCEUW2UAT.*DB.*$'; Service = 'emisweb'; Speciality = 'ccmhuat'; Locale = 'scot'; Type = 'db'; PD = { ('aws_scot_'+ $computerName.Substring(6,5)).ToLower() } },
    #nations NI
    @{ Regex = '^NIEUW2GP.*APP.*$'; Service = 'emisweb'; Speciality = 'gp'; Locale = 'ni'; Type = 'app'; PD = { ('aws_ni_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^NIEUW2GP.*DBS.*$'; Service = 'emisweb'; Speciality = 'gp'; Locale = 'ni'; Type = 'db'; PD = { ('aws_ni_'+ $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^NIEUW2GP.*RS.*$'; Service = 'emisweb'; Speciality = 'gp'; Locale = 'ni'; Type = 'rs'; PD = { ('aws_ni_' + $computerName.Substring(6,4)).ToLower() } },
    @{ Regex = '^NIEUW2UAT.*DB.*$'; Service = 'emisweb'; Speciality = 'ccmhuat'; Locale = 'ni'; Type = 'db'; PD = { ('aws_ni_'+ $computerName.Substring(6,6)).ToLower() } },
    @{ Regex = '^NIEUW2TRN.*DB.*$'; Service = 'emisweb'; Speciality = 'ccmhtrn'; Locale = 'ni'; Type = 'db'; PD = { ('aws_ni_'+ $computerName.Substring(6,6)).ToLower() } },

    #IBI Shared services
    @{ Regex = '.*EUW2IBISRS.*$'; Service = 'ibi'; Speciality = 'ibi'; Locale = 'ibi'; Type = 'db'; PD = {'aws_ibi'}},
    @{ Regex = '.*EUW2IBISAS.*$'; Service = 'ibi'; Speciality = 'ibi'; Locale = 'ibi'; Type = 'db'; PD = {'aws_ibi'}},
    @{ Regex = '.*EUW2IBISIS.*$'; Service = 'ibi'; Speciality = 'ibi'; Locale = 'ibi'; Type = 'db'; PD = {'aws_ibi'}},
    @{ Regex = '.*EUW2IBIMGT.*$'; Service = 'ibi'; Speciality = 'ibi'; Locale = 'ibi'; Type = 'mgmt'; PD = {'aws_ibi'}},

    #CPPO
    @{ Regex = '.*EUW2CPPODBS.*$'; Service = 'cppo'; Speciality = 'cppo'; Locale = 'cph'; Type = 'db'; PD = {'aws_cppo'}},
    @{ Regex = '.*EUW2CPPOAPP.*$'; Service = 'cppo'; Speciality = 'cppo'; Locale = 'cph'; Type = 'app'; PD = {'aws_cppo'}},
    @{ Regex = '.*EUW2CPPOBAS.*$'; Service = 'cppo'; Speciality = 'cppo'; Locale = 'cph'; Type = 'mgmt'; PD = {'aws_cppo'}},

    #INDEX
    @{ Regex = '.*EUW2IDX.*APP.*$'; Service = 'index'; Speciality = 'index'; Locale = 'idx'; Type = 'app'; PD = 'aws_idx' },
    @{ Regex = '.*EUW2IDX.*DBS.*$'; Service = 'index'; Speciality = 'index'; Locale = 'idx'; Type = 'db'; PD = 'aws_idx' },
    @{ Regex = '.*EUW2IDX.*RS.*$'; Service = 'index'; Speciality = 'index'; Locale = 'idx'; Type = 'rs'; PD = 'aws_idx' },

    #COM PHARM
    @{ Regex = '.*EMEUW2ECPH.*'; Service = 'emisconnect'; Speciality = 'comm-pharm'; Locale = 'cph'; Type = 'app'; PD = 'aws_cph_connect' },
    @{ Regex = '.*EMEUW2ECP.*DBS.*'; Service = 'emisconnect'; Speciality = 'comm-pharm'; Locale = 'cph'; Type = 'db'; PD = 'aws_cph_connect' },
    
    #LEGACY SS 
    @{ Regex = '.*RESPUB.*'; Service = 'respub'; Speciality = 'sharedservices'; Locale = 'respub_multi'; Type = 'app'; PD = 'res_pub' },
    @{ Regex = '.*RP.*DB.*'; Service = 'respub'; Speciality = 'sharedservices'; Locale = 'respub_multi'; Type = 'db'; PD = 'res_pub' },
    @{ Regex = '.*EC0.*DBS.*'; Service = 'emisconnect'; Speciality = 'sharedservices'; Locale = 'emisconnect_multi'; Type = 'db'; PD = 'healthconnect' },
    @{ Regex = '.*ECCRV.*'; Service = 'emisconnect'; Speciality = 'sharedservices'; Locale = 'emisconnect_multi'; Type = 'app'; PD = 'healthconnect' },
    @{ Regex = '.*ECMIG.*'; Service = 'emisconnect'; Speciality = 'sharedservices'; Locale = 'emisconnect_multi'; Type = 'app'; PD = 'healthconnect' },
    @{ Regex = '.*ECPFS.*'; Service = 'emisconnect'; Speciality = 'sharedservices'; Locale = 'emisconnect_multi'; Type = 'app'; PD = 'healthconnect' },

    @{ Regex = '.*ECSLP.*'; Service = 'emisconnect'; Speciality = 'sharedservices'; Locale = 'emisconnect_multi'; Type = 'app'; PD = 'healthconnect' },
    @{ Regex = '.*ECSPN.*'; Service = 'emisconnect'; Speciality = 'sharedservices'; Locale = 'emisconnect_multi'; Type = 'app'; PD = 'healthconnect' },
    @{ Regex = '.*ECGEN.*'; Service = 'emisconnect'; Speciality = 'sharedservices'; Locale = 'emisconnect_multi'; Type = 'app'; PD = 'healthconnect' },

    @{ Regex = '.*OAPIDBS.*'; Service = 'openapi'; Speciality = 'sharedservices'; Locale = 'openapi_multi'; Type = 'db'; PD = 'openapi' },
    @{ Regex = '.*OAPI.*'; Service = 'openapi'; Speciality = 'sharedservices'; Locale = 'openapi_multi'; Type = 'app'; PD = 'openapi' },
    @{ Regex = '.*PAPIDBS.*'; Service = 'partnerapi'; Speciality = 'sharedservices'; Locale = 'partnerapi_multi'; Type = 'db'; PD = 'partnerapi' },
    @{ Regex = '.*PAPI.*'; Service = 'partnerapi'; Speciality = 'sharedservices'; Locale = 'partnerapi_multi'; Type = 'app'; PD = 'partnerapi' },

    @{ Regex = '.*SDSPS.*'; Service = 'sds'; Speciality = 'sharedservices'; Locale = 'sds_multi'; Type = 'app'; PD = 'sds' },

    @{ Regex = '.*SSPDDBS.*'; Service = 'ss'; Speciality = 'sharedservices'; Locale = 'ss_multi'; Type = 'db'; PD = 'sharedservicepd' },
    @{ Regex = '.*SSPDAPP.*'; Service = 'ss'; Speciality = 'sharedservices'; Locale = 'ss_multi'; Type = 'app'; PD = 'sharedservicepd' },
        
    @{ Regex = '.*LIBDBS.*'; Service = 'ss'; Speciality = 'sharedservices'; Locale = 'ss_multi'; Type = 'db'; PD = 'library' },
    @{ Regex = '.*LIBAPP.*'; Service = 'ss'; Speciality = 'sharedservices'; Locale = 'ss_multi'; Type = 'app'; PD = 'library' },
     
    @{ Regex = '.*GPIP.*'; Service = 'ss'; Speciality = 'sharedservices'; Locale = 'ss_multi'; Type = 'db'; PD = 'gpip' },
    
    @{ Regex = '.*SS01DBS.*'; Service = 'ss'; Speciality = 'sharedservices'; Locale = 'ss_multi'; Type = 'db'; PD = 'ss01' },

    @{ Regex = '.*ESPDBS.*'; Service = 'ss'; Speciality = 'sharedservices'; Locale = 'ss_multi'; Type = 'db'; PD = 'pcs-esp' },
    @{ Regex = '.*ESP.*'; Service = 'ss'; Speciality = 'sharedservices'; Locale = 'ss_multi'; Type = 'app'; PD = 'pcs-esp' },

    #eng dev/stg  
    @{ Regex = '.*DEV.*APP.*'; Service = 'dev'; Speciality = 'dev'; Locale = 'eng'; Type = 'app'; PD = 'dev' },
    @{ Regex = '.*DEV.*DBS.*'; Service = 'dev'; Speciality = 'dev'; Locale = 'eng'; Type = 'db'; PD = 'dev' },
    @{ Regex = '.*DEV.*RS.*'; Service = 'dev'; Speciality = 'dev'; Locale = 'eng'; Type = 'rs'; PD = 'dev' },
    
    @{ Regex = '.*STG.*APP.*'; Service = 'stg'; Speciality = 'stg'; Locale = 'eng'; Type = 'app'; PD = 'stg' },
    @{ Regex = '.*STG.*DBS.*'; Service = 'stg'; Speciality = 'stg'; Locale = 'eng'; Type = 'db'; PD = 'stg' },
    @{ Regex = '.*STG.*RS.*'; Service = 'stg'; Speciality = 'stg'; Locale = 'eng'; Type = 'rs'; PD = 'stg' }

    #bastions 
    @{ Regex = '.*BASCON.*'; Service = 'bastionservices'; Speciality = 'bastion_con'; Locale = 'ss'; Type = 'bastion'; PD = 'bastion' },
    @{ Regex = '.*BASDBA.*'; Service = 'bastionservices'; Speciality = 'bastion_dba'; Locale = 'ss'; Type = 'bastion'; PD = 'bastion' },
    @{ Regex = '.*BASGEN.*'; Service = 'bastionservices'; Speciality = 'bastion_gen'; Locale = 'ss'; Type = 'bastion'; PD = 'bastion' },
    @{ Regex = '.*BASMIG.*'; Service = 'bastionservices'; Speciality = 'bastion_mig'; Locale = 'ss'; Type = 'bastion'; PD = 'bastion' },
    @{ Regex = '.*BASPCS.*'; Service = 'bastionservices'; Speciality = 'bastion_pcs'; Locale = 'ss'; Type = 'bastion'; PD = 'bastion' },
    @{ Regex = '.*MIGSQL.*'; Service = 'bastionservices'; Speciality = 'migsql'; Locale = 'ss'; Type = 'bastion'; PD = 'bastion' },

    #emis-x devtest
    @{ Regex = '^crrep.*221315.*$'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'rs'; PD = 'emis-x-int-td' }
    @{ Regex = '^cr1.*221315.*$'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'emis-x-int-td' }
    @{ Regex = '^cr2.*221315.*$'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'emis-x-int-td' }
    @{ Regex = '^idxdb.*221315.*$'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'emis-x-int-td' }
    @{ Regex = '^condb.*221315.*$'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'emis-x-int-td' }
    @{ Regex = '^idx1.*221315.*$'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'emis-x-int-td' }
    @{ Regex = '^APP1.*221315.*$'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'emis-x-int-td' }
    @{ Regex = '^CON1.*221315.*$'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'emis-x-int-td' }

    #devtest
    @{ Regex = '^ob-.*$'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'onebox'; PD = 'devtest' }
    @{ Regex = '.*TD1-APP1*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'devtest' }
    @{ Regex = '.*APP1-123976*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'devtest' }
    @{ Regex = '.*APP1-133207*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'devtest' }
    @{ Regex = '.*APP1-137532*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'devtest' }
    @{ Regex = '.*APP1-154319*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'devtest' }
    @{ Regex = '.*APP2-154319*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'devtest' }
    @{ Regex = '.*CON1-*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'devtest' }
    @{ Regex = '.*CONAPP-*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'devtest' }
    @{ Regex = '.*IDX1-*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'devtest' }
    @{ Regex = '.*IDXAPP*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'app'; PD = 'devtest' }
    @{ Regex = '.*CR1-*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'devtest' }
    @{ Regex = '.*CR2-*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'devtest' }
    @{ Regex = '.*WIN-258397*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'devtest' }
    @{ Regex = '.*CRREP-.*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'rs'; PD = 'devtest' }
    @{ Regex = '.*TD1-CRREP.*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'rs'; PD = 'devtest' }
    @{ Regex = '.*CON-DB-*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'devtest' }
    @{ Regex = '.*IDX-DB-*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'devtest' }
    @{ Regex = '.*CONDB-*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'devtest' }
    @{ Regex = '.*IDXDB-*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'db'; PD = 'devtest' }
    @{ Regex = '^spk.*$'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'spoke'; PD = 'devtest' }
    @{ Regex = '.*TD1-SPK1*'; Service = 'devtest'; Speciality = 'devtest'; Locale = 'eng'; Type = 'spoke'; PD = 'devtest' }
    #add more here if needed

)
##################computer config ends here#############################
# Function to get the computer name configuration
function Get-ComputerNameConfig {
    param (
        [string]$ComputerName
    )
    foreach ($entry in $computerNameConfig) {
        if ($ComputerName -match $entry.Regex) {
            # Evaluate the PD dynamically if it's a script block
            $pd = if ($entry.PD -is [scriptblock]) { & $entry.PD $ComputerName } else { $entry.PD }
            return @{
                Service = $entry.Service
                Speciality = $entry.Speciality
                Locale = $entry.Locale
                Type = $entry.Type
                PD = $pd
            }
        }
    }
    return $null
}

#Function for Envrionment based on domain name
function getenvironment { 
    $domain = (Get-WmiObject Win32_ComputerSystem).Domain
    if ($domain -match 'gplive') { return $('prd') }
    elseif ($domain -match 'ccmh') { return $('prd') }
    elseif ($domain -match 'cp') { return $('prd') }
    elseif ($domain -match 'white.local') { return $('prd') }
    elseif ($domain -match 'jersey') { return $('prd') }
    elseif ($domain -match 'iom') { return $('prd') }
    elseif ($domain -match 'hscni') { return $('prd') }
    elseif ($domain -match 'northernireland') { return $('prd') }
    elseif ($domain -match 'emishs') { return $('prd') }
    elseif ($domain -match 'cymru.nhs.uk') { return $('prd') }
    elseif ($domain -match 'devtest') { return $('dev') }
    elseif ($domain -match 'workgroup') { return $('dev') }
    elseIF ($domain -match 'DEV.') { return "dev" }
    elseIF ($domain -match 'STG.') { return "stg" }
    elseIF ($domain -match 'prd.') { return "prd" }
    elseIF ($domain -match 'england.emis-web.com') { return "prd" }
    elseIF ($domain -match 'dev.england.emis-web.com') { return "dev" }
    elseIF ($domain -match 'stg.england.emis-web.com') { return "stg" }
    elseIF ($domain -match 'shared-services.emis-web.com') { return "prd" }
    elseIF ($domain -match 'dev.england.shared-services.com') { return "dev" }
    elseIF ($domain -match 'stg.england.shared-services.com') { return "stg" }
    elseIF ($domain -match 'iom.emis-web.com') { return "prd" }
    elseIF ($domain -match 'jersey.emis-web.com') { return "prd" }
    elseIF ($domain -match 'scotland.emis-web.com') { return "prd" }
    elseIF ($domain -match 'devtest.emishosting.com') { return "dev" }
    elseIF ($domain -match 'awshosted.emis-clinical.com') { return "prd" }
    elseIF ($domain -match 'awshosted.dev.emis-clinical.com') { return "dev" }
    elseIF ($domain -match 'awshosted.stg.emis-clinical.com') { return "stg" }
    
    else { return $('unknown') }
}






# work out the availability zone using IMDSv1 or IMDSv2
# set all tags to unknown intially befoire calaculating dynamically for below code block
$az = "unknown"
#$serverfunction = "unknown"


try {
    $token = Invoke-RestMethod -Uri "http://169.254.169.254/latest/api/token" -Method PUT -Headers @{ 'X-aws-ec2-metadata-token-ttl-seconds' = '21600' }
    $az = (Invoke-RestMethod -Uri "http://169.254.169.254/latest/dynamic/instance-identity/document" -Headers @{ 'X-aws-ec2-metadata-token' = $token }).availabilityZone

    #Additonal ec2 tags IMDSv2 tag meta data not enabled by default readying for  future release.
    #$serverfunction = Invoke-RestMethod -Uri "http://169.254.169.254/latest/meta-data/tags/instance/server_function" -Headers @{ 'X-aws-ec2-metadata-token' = $token }
    #$serverfunction = "notset"


} catch {
    Write-Host "IMDSv2 failed. Trying IMDSv1..."
    # Attempt to get the availability zone using IMDSv1
    $az = (Invoke-RestMethod -Uri "http://169.254.169.254/latest/dynamic/instance-identity/document").availabilityZone

    #Additonal ec2 tags IMDSv1 tag meta data not enabled by default readying for  future release.
    #$serverfunction = Invoke-RestMethod -Uri "http://169.254.169.254/latest/meta-data/tags/instance/server_function" -ErrorAction SilentlyContinue
    #$serverfunction = "notset"

}
Write-Host "Availability Zone: $az"
Write-Host "Server Function Tag: $serverfunction"


#  Domain tag
$domain=(Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object Domain -ExpandProperty Domain)




$config = Get-ComputerNameConfig -ComputerName $computerName

if ($config -ne $null) {
    $service = $config.Service
    $speciality = $config.Speciality
    $locale = $config.Locale
    $type = $config.Type
    $pd = $config.PD
    Write-Host "Checking regex: $($entry.Regex)"

} else {
    Write-Host "No matching configuration found for computer name: $computerName"
    $service = 'unknown'
    $speciality = 'unknown'
    $locale = 'unknown'
    $type = 'unknown'
    $pd = 'unknown'
}



$environment = getenvironment
$hostgroup =  $locale+"_"+$environment+"_"+$type
$proxystr = "185.46.212.92:443"

#################################### End of Taging logic

# Output the resolved values for debugging
Write-Host "Service: $service"
Write-Host "Speciality: $speciality"
Write-Host "Locale: $locale"
Write-Host "Type: $type"
Write-Host "PD: $pd"
Write-Host "Environment: $environment"
Write-Host "Domain: $domain"
Write-Host "Availability Zone: $az"
Write-Host "Host Group: $hostgroup"
Write-Host "Proxy: $proxystr"
Write-Host "serverfunction: $serverfunction"
#Write-Host "Regex entry used: $entry.Regex"



####################################################

# # Check if any of the variables are 'unknown' and fail the script if so
# if ($service -eq 'unknown' -or $speciality -eq 'unknown' -or $locale -eq 'unknown' -or $type -eq 'unknown' -or $pd -eq 'unknown' -or $environment -eq 'unknown' -or $domain -eq 'unknown' -or $az -eq 'unknown') {
#     Write-Error "One or more required variables are 'unknown', please check the script has been updated to handle your environment. Failing the script."
#     exit 1
# }

# Check if any of the variables are 'unknown' and fail the script if so
if ($service -eq 'unknown' -or $speciality -eq 'unknown' -or $locale -eq 'unknown' -or $type -eq 'unknown' -or $pd -eq 'unknown' -or $environment -eq 'unknown' -or $domain -eq 'unknown' -or $az -eq 'unknown' -or $hostgroup -contains 'unknown' -or $proxystr -eq 'unknown') {
    Write-Error "One or more required variables/tags are 'unknown', please check the script has been updated to handle your environment. Failing the script."
    Write-Output "SSM Document Execution Failed: One or more required variables are 'unknown'. Please check the ssm output for more details."
    exit 1
}

###################################################




######Now install the agent

$hostname = $env:computername

#$monitormode  moved out and set in ssm doc
$logaccess = "true"
$proxystr = "185.46.212.92:443"

# Define the path to the Dynatrace OneAgent installer
$installerPath = "C:\EMIS\Dynatrace\Agent\$($msiName)"


# Define the installation parameters
$parameters = "/quiet --set-monitoring-mode=$($monitormode) --set-app-log-content-access=$($logaccess) --set-host-name=$($hostname) --set-host-tag=installtags=notset --set-host-group=standard --set-proxy=$($proxystr)"




# Run the installer with the specified parameters please note ssm needs to pass in "newinstall", if "updateinstall" then the installer will not run and only tags updated.
if ($automationmode -eq "newinstall")
{
Start-Process -FilePath $installerPath -ArgumentList $parameters -Wait -NoNewWindow
}


############################### Stop service and ready the Env tags and ctl updates
# stop process
$servicename = "Dynatrace OneAgent"
$servicefind = Get-Service -Name $servicename -ErrorAction SilentlyContinue

if ($servicefind) {Stop-service -Name $($servicename) -Force -ErrorAction SilentlyContinue}



# Formulate key pair values for metadata instead of tags.
$replacements = @{


    'host' = $computerName
    'Environment' = $environment 
    'pd' = $pd
    'service' = $service
    'speciality' = $speciality
    'region' = $locale
    'dc' = $az
    'domain' = $domain
    'type' = $type
    
    
}

# Update the hostcustomproperties file with key metadata
foreach ($key in $replacements.Keys) {
& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-property "$($key)=$($replacements[$key])"

}

Write-Host "Dynatrace Metadata set"

#set host group
& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-group=$($hostgroup)

Write-Host "Dynatrace Host Group set"


#set proxy
& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-proxy=$($proxystr)


#set costcentre
& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-property=dt.cost.costcenter=$($costcentre)

Write-Host "Dynatrace Host costcentre set"

#set product

& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-property=dt.cost.product=$($product)


Write-Host "Dynatrace Host product set"




# booting up the service
start-service -Name $($servicename) 

write-host "service starting and configs saved"

