@{
    RootModule        = 'PSModule.psm1'
    ModuleVersion     = '2.1.3'
    GUID              = '1d73a601-4a6c-43c5-ba3f-619b18bbb404'
    Author            = 'Microsoft Corporation'
    CompanyName       = 'Microsoft Corporation'
    Copyright         = '(c) Microsoft Corporation. All rights reserved.'
    Description       = 'PowerShell module with commands for discovering, installing, updating and publishing the PowerShell artifacts like Modules, DSC Resources, Role Capabilities and Scripts.'
    PowerShellVersion = '3.0'
    FormatsToProcess  = 'PSGet.Format.ps1xml'
FunctionsToExport = @(
	'Find-Command',
	'Find-DSCResource',
	'Find-Module',
	'Find-RoleCapability',
	'Find-Script',
	'Get-InstalledModule',
	'Get-InstalledScript',
	'Get-PSRepository',
	'Install-Module',
	'Install-Script',
	'New-ScriptFileInfo',
	'Publish-Module',
	'Publish-Script',
	'Register-PSRepository',
	'Save-Module',
	'Save-Script',
	'Set-PSRepository',
	'Test-ScriptFileInfo',
	'Uninstall-Module',
	'Uninstall-Script',
	'Unregister-PSRepository',
	'Update-Module',
	'Update-ModuleManifest',
	'Update-Script',
	'Update-ScriptFileInfo')

    VariablesToExport = "*"
    AliasesToExport   = @('inmo', 'fimo', 'upmo', 'pumo')
    FileList          = @('PSModule.psm1',
        'PSGet.Format.ps1xml',
        'PSGet.Resource.psd1')
    RequiredModules   = @(@{ModuleName = 'PackageManagement'; ModuleVersion = '1.1.7.0' })
    PrivateData       = @{
        "PackageManagementProviders"           = 'PSModule.psm1'
        "SupportedPowerShellGetFormatVersions" = @('1.x', '2.x')
        PSData                                 = @{
            Tags         = @('Packagemanagement',
                'Provider',
                'PSEdition_Desktop',
                'PSEdition_Core',
                'Linux',
                'Mac')
            ProjectUri   = 'https://go.microsoft.com/fwlink/?LinkId=828955'
            LicenseUri   = 'https://go.microsoft.com/fwlink/?LinkId=829061'
            ReleaseNotes = @'
## 2.1.3
New Features

- Added -Scope parameter to Update-Module (Thanks @lwajswaj!) (#471)
- Added -Exclude parameter to Publish-Module (Thanks @Benny1007!) (#191)
- Added -SkipAutomticTags parameter to Publish-Module (Thanks @awickham10!) (#452)

Bug Fix

- Fixed issue with finding modules using macOS and .NET Core 3.0

## 2.1.2

New Feature

- Added support for registering repositories with special characters

## 2.1.1

- Fix DSC resource folder structure

## 2.1.0

Breaking Change

- Default installation scope for Update-Module and Update-Script has changed to match Install-Module and Install-Script. For Windows PowerShell (version 5.1 or below), the default scope is AllUsers when running in an elevated session, and CurrentUser at all other times.
  For PowerShell version 6.0.0 and above, the default installation scope is always CurrentUser. (#421)

Bug Fixes

- Update-ModuleManifest no longer clears FunctionsToExport, AliasesToExport, nor NestModules (#415 & #425) (Thanks @pougetat and @tnieto88!)
- Update-Module no longer changes repository URL (#407)
- Update-ModuleManifest no longer preprends 'PSGet_' to module name (#403) (Thanks @ThePoShWolf)
- Update-ModuleManifest now throws error and fails to update when provided invalid entries (#398) (Thanks @pougetat!)
- Ignore files no longer being included when uploading modules (#396)

New Features

- New DSC resource, PSRepository (#426) (Thanks @johlju!)
- Piping of PS respositories (#420)
- utf8 support for .nuspec (#419)

## 2.0.4

Bug Fix
* Remove PSGallery availability checks (#374)

## 2.0.3

Bug fixes and Improvements
* Fix CommandAlreadyAvailable error for PackageManagement module (#333)
* Remove trailing whitespace when value is not provided for Get-PSScriptInfoString (#337) (Thanks @thomasrayner)
* Expanded aliases for improved readability (#338) (Thanks @lazywinadmin)
* Improvements for Catalog tests (#343)
* Fix Update-ScriptInfoFile to preserve PrivateData (#346) (Thanks @tnieto88)
* Import modules with many commands faster (#351)

New Features
* Tab completion for -Repository parameter (#339) and for Publish-Module -Name (#359) (Thanks @matt9ucci)

## 2.0.1

Bug fixes
- Resolved Publish-Module doesn't report error but fails to publish module (#316)
- Resolved CommandAlreadyAvailable error while installing the latest version of PackageManagement module (#333)

## 2.0.0

Breaking Change
- Default installation scope for Install-Module, Install-Script, and Install-Package has changed. For Windows PowerShell (version 5.1 or below), the default scope is AllUsers when running in an elevated session, and CurrentUser at all other times.
  For PowerShell version 6.0.0 and above, the default installation scope is always CurrentUser.

## 1.6.7

Bug fixes
- Resolved Install/Save-Module error in PSCore 6.1.0-preview.4 on Ubuntu 18.04 OS (WSL/Azure) (#313)
- Updated error message in Save-Module cmdlet when the specified path is not accessible (#313)
- Added few additional verbose messages (#313)

## 1.6.6

Dependency Updates
* Add dependency on version 4.1.0 or newer of NuGet.exe
* Update NuGet.exe bootstrap URL to https://aka.ms/psget-nugetexe

Build and Code Cleanup Improvements
* Improved error handling in network connectivity tests.

Bug fixes
- Change Update-ModuleManifest so that prefix is not added to CmdletsToExport.
- Change Update-ModuleManifest so that parameters will not reset to default values.
- Specify AllowPrereleseVersions provider option only when AllowPrerelease is specified on the PowerShellGet cmdlets.

## 1.6.5

New features
* Allow Pester/PSReadline installation when signed by non-Microsoft certificate (#258)
  - Whitelist installation of non-Microsoft signed Pester and PSReadline over Microsoft signed Pester and PSReadline.

Build and Code Cleanup Improvements
* Splitting of functions (#229) (Thanks @Benny1007)
  - Moves private functions into respective private folder.
  - Moves public functions as defined in PSModule.psd1 into respective public folder.
  - Removes all functions from PSModule.psm1 file.
  - Dot sources the functions from PSModule.psm1 file.
  - Uses Export-ModuleMember to export the public functions from PSModule.psm1 file.

* Add build step to construct a single .psm1 file (#242) (Thanks @Benny1007)
  - Merged public and private functions into one .psm1 file to increase load time performance.

Bug fixes
- Fix null parameter error caused by MinimumVersion in Publish-PackageUtility (#201)
- Change .ExternalHelp link from PSGet.psm1-help.xml to PSModule-help.xml in PSModule.psm1 file (#215)
- Change Publish-* to allow version comparison instead of string comparison (#219)
- Ensure Get-InstalledScript -RequiredVersion works when versions have a leading 0 (#260)
- Add positional path to Save-Module and Save-Script (#264, #266)
- Ensure that Get-AuthenticodePublisher verifies publisher and that installing or updating a module checks for approprite catalog signature (#272)
- Update HelpInfoURI to 'http://go.microsoft.com/fwlink/?linkid=855963' (#274)


## 1.6.0

New features
* Prerelease Version Support (#185)
  - Implemented prerelease versions functionality in PowerShellGet cmdlets.
  - Enables publishing, discovering, and installing the prerelease versions of modules and scripts from the PowerShell Gallery.
  - [Documentation](https://docs.microsoft.com/en-us/powershell/gallery/psget/module/PrereleaseModule)

* Enabled publish cmdlets on PWSH and Nano Server (#196)
  - Dotnet command version 2.0.0 or newer should be installed by the user prior to using the publish cmdlets on PWSH and Windows Nano Server.
  - Users can install the dotnet command by following the instructions specified at https://aka.ms/dotnet-install-script.
  - On Windows, users can install the dotnet command by running *Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile '.\dotnet-install.ps1'; & '.\dotnet-install.ps1' -Channel Current -Version '2.0.0'*
  - Publish cmdlets on Windows PowerShell supports using the dotnet command for publishing operations.

Breaking Change
- PWSH: Changed the installation location of AllUsers scope to the parent of $PSHOME instead of $PSHOME. It is the SHARED_MODULES folder on PWSH.

Bug fixes
- Update HelpInfoURI to 'https://go.microsoft.com/fwlink/?linkid=855963' (#195)
- Ensure MyDocumentsPSPath path is correct (#179) (Thanks @lwsrbrts)


## 1.5.0.0

New features
* Added support for modules requiring license acceptance (#150)
  - [Documentation](https://docs.microsoft.com/en-us/powershell/gallery/psget/module/RequireLicenseAcceptance)

* Added version for REQUIREDSCRIPTS (#162)
  - Enabled following scenarios for REQUIREDSCRIPTS
    - [1.0] - RequiredVersion
    - [1.0,2.0] - Min and Max Version
    - (,1.0] - Max Version
    - 1.0 - Min Version

Bug fixes
* Fixed empty version value in nuspec (#157)


## 1.1.3.2
* Disabled PowerShellGet Telemetry on PS Core as PowerShell Telemetry APIs got removed in PowerShell Core beta builds. (#153)
* Fixed for DateTime format serialization issue. (#141)
* Update-ModuleManifest should add ExternalModuleDependencies value as a collection. (#129)

## 1.1.3.1

New features
* Added `PrivateData` field to ScriptFileInfo. (#119)

Bug fixes
* Fixed Add-Type issue in v6.0.0-beta.1 release of PowerShellCore. (#125, #124)
* Install-Script -Scope CurrentUser PATH changes should not require a reboot for new PS processes. (#124)
    - Made changes to broadcast the Environment variable changes, so that other processes pick changes to Environment variables without having to reboot or logoff/logon.
* Changed `Get-EnvironmentVariable` to get the unexpanded version of `%path%`. (#117)
* Refactor credential parameter propagation to sub-functions. (#104)
* Added credential parameter to subsequent calls of `Publish-Module/Script`. (#93)
    - This is needed when a module is published that has the RequiredModules attribute in the manifest on a repository that does not have anonymous access because the required module lookups will fail.

## 1.1.2.0

Bug fixes
* Renamed `PublishModuleIsNotSupportedOnNanoServer` errorid to `PublishModuleIsNotSupportedOnPowerShellCoreEdition`. (#44)
    - Also renamed `PublishScriptIsNotSupportedOnNanoServer` to `PublishScriptIsNotSupportedOnPowerShellCoreEdition`.
* Fixed an issue in `Update-Module` and `Update-Script` cmdlets to show proper version of current item being updated in `Confirm`/`WhatIf` message. (#44)
* Updated `Test-ModuleInstalled` function to return single module instead of multiple modules. (#44)
* Updated `ModuleCommandAlreadyAvailable` error message to include all conflicting commands instead of one.  (#44)
    - Corresponding changes to collect the complete set of conflicting commands from the being installed.
    - Also ensured that conflicting commands from PSModule.psm1 are ignored in the command collision analysis as Get-Command includes the commands from current local scope as well.

* Fixed '[Test-ScriptFileInfo] Fails on *NIX newlines (LF vs. CRLF)' (#18)


## 1.1.1.0

Bug fixes
* Fixed 'Update-Module fails with `ModuleAuthenticodeSignature` error for modules with signed PSD1'. (#12) (#8)
* Fixed 'Properties of `AdditionalMetadata` are case-sensitive'. #7
* Changed `ErrorAction` to `Ignore` for few cmdlet usages as they should not show up in ErrorVariable.
    - For example, error returned by `Get-Command Test-FileCatalog` should be ignored.


## 1.1.0.0

* Initial release from GitHub.
* PowerShellCore support.
* Security enhancements including the enforcement of catalog-signed modules during installation.
* Authenticated Repository support.
* Proxy Authentication support.
* Responses to a number of user requests and issues.
'@
        }
    }

    HelpInfoURI       = 'http://go.microsoft.com/fwlink/?linkid=855963'
}


# SIG # Begin signature block
# MIIjgwYJKoZIhvcNAQcCoIIjdDCCI3ACAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBFR7xvIklGNvWz
# JsQ3u2FrcplM/5oSV9U3Ke1bEf+kBaCCDYEwggX/MIID56ADAgECAhMzAAABA14l
# HJkfox64AAAAAAEDMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMTgwNzEyMjAwODQ4WhcNMTkwNzI2MjAwODQ4WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDRlHY25oarNv5p+UZ8i4hQy5Bwf7BVqSQdfjnnBZ8PrHuXss5zCvvUmyRcFrU5
# 3Rt+M2wR/Dsm85iqXVNrqsPsE7jS789Xf8xly69NLjKxVitONAeJ/mkhvT5E+94S
# nYW/fHaGfXKxdpth5opkTEbOttU6jHeTd2chnLZaBl5HhvU80QnKDT3NsumhUHjR
# hIjiATwi/K+WCMxdmcDt66VamJL1yEBOanOv3uN0etNfRpe84mcod5mswQ4xFo8A
# DwH+S15UD8rEZT8K46NG2/YsAzoZvmgFFpzmfzS/p4eNZTkmyWPU78XdvSX+/Sj0
# NIZ5rCrVXzCRO+QUauuxygQjAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUR77Ay+GmP/1l1jjyA123r3f3QP8w
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDM3OTY1MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAn/XJ
# Uw0/DSbsokTYDdGfY5YGSz8eXMUzo6TDbK8fwAG662XsnjMQD6esW9S9kGEX5zHn
# wya0rPUn00iThoj+EjWRZCLRay07qCwVlCnSN5bmNf8MzsgGFhaeJLHiOfluDnjY
# DBu2KWAndjQkm925l3XLATutghIWIoCJFYS7mFAgsBcmhkmvzn1FFUM0ls+BXBgs
# 1JPyZ6vic8g9o838Mh5gHOmwGzD7LLsHLpaEk0UoVFzNlv2g24HYtjDKQ7HzSMCy
# RhxdXnYqWJ/U7vL0+khMtWGLsIxB6aq4nZD0/2pCD7k+6Q7slPyNgLt44yOneFuy
# bR/5WcF9ttE5yXnggxxgCto9sNHtNr9FB+kbNm7lPTsFA6fUpyUSj+Z2oxOzRVpD
# MYLa2ISuubAfdfX2HX1RETcn6LU1hHH3V6qu+olxyZjSnlpkdr6Mw30VapHxFPTy
# 2TUxuNty+rR1yIibar+YRcdmstf/zpKQdeTr5obSyBvbJ8BblW9Jb1hdaSreU0v4
# 6Mp79mwV+QMZDxGFqk+av6pX3WDG9XEg9FGomsrp0es0Rz11+iLsVT9qGTlrEOla
# P470I3gwsvKmOMs1jaqYWSRAuDpnpAdfoP7YO0kT+wzh7Qttg1DO8H8+4NkI6Iwh
# SkHC3uuOW+4Dwx1ubuZUNWZncnwa6lL2IsRyP64wggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVWDCCFVQCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAQNeJRyZH6MeuAAAAAABAzAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgBq4+3VNA
# MmkZTXlJnc1LQNZd/wkIdq2y7zo4YGGeif4wQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQBUdG3vr+jxY39ZAY2fEZkqehu4Xqr2BtVH85sjArwQ
# zaBnjhmSATkeI6vVNjKaFUM2ztTO3cy/CLrPZuVtVDfPXwiscHpr3hWUkAz9pPSi
# znjgAX4Z214ZSvnN0zIbf1lu1tIQK+1ITLVU6uJC2kR1z62Sl0DB+uFMwqXVuOia
# oN2Mz7W6XHKf5RaTkrcr7Rb0jwq4KMo0DSBJ/1S5f+6O4bCUCVrtqlkOXCA4LfmQ
# XsV4IoRqZVxhI/7z6Ry74sbsj5zUSIvS4ZVBrN3CFUL4v4ul+94YANh93vgrhe6J
# 7OgKuvt5lyAfox+li71n2e3+4xl75Fh+6+EJwGuLSk36oYIS4jCCEt4GCisGAQQB
# gjcDAwExghLOMIISygYJKoZIhvcNAQcCoIISuzCCErcCAQMxDzANBglghkgBZQME
# AgEFADCCAVEGCyqGSIb3DQEJEAEEoIIBQASCATwwggE4AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEICNjRA/J9UX8C02xZMnws36xWHtpOBnGjaAFDXl+
# 2XnJAgZcyeiYO/wYEzIwMTkwNTE0MDAwNzU4LjU0OFowBIACAfSggdCkgc0wgcox
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1p
# Y3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1Mg
# RVNOOjhBODItRTM0Ri05RERBMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
# cCBTZXJ2aWNloIIOOTCCBPEwggPZoAMCAQICEzMAAADwvF+brrNM/yUAAAAAAPAw
# DQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcN
# MTgxMDI0MjExNDIyWhcNMjAwMTEwMjExNDIyWjCByjELMAkGA1UEBhMCVVMxEzAR
# BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2Eg
# T3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046OEE4Mi1FMzRGLTlE
# REExJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggEiMA0G
# CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDgNDVNasZyacqap9zBtsIEWmGWdkJx
# nMAI97MUGYXVAfpQrCVbM9YUX0yIokD+KcMkZ0ArB0B0RbhOI7q3EGfTHkRf2Ln3
# 9A9RZnVThRyczf0PqDYl/upaLQPXj1aR70GwjfMUYX6nEAIkrCvON2u/QFKhrIwn
# d1ViVq/tc56A1rKj0mFz0TcSk6T/AzDfOyLNHLeaxDhCIX9WPwpr6sZPv2D1ZbZA
# kSbthl5vUNYFdtxNx/haTCpo2FoH9fv4zJySfCncXJ/sy+kaBXVXtLT5j2gPQYGY
# cesf0BEj5X5IITTvlMVj1peVWs8CI5+YRPqNdZLGoIGY27WIM+i0NjGTAgMBAAGj
# ggEbMIIBFzAdBgNVHQ4EFgQU26J6c6P3TjgxiTuSb4gD+ZYCTNEwHwYDVR0jBBgw
# FoAU1WM6XIoxkPNDe3xGG8UzaFqFbVUwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDov
# L2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljVGltU3RhUENB
# XzIwMTAtMDctMDEuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0
# cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNUaW1TdGFQQ0FfMjAx
# MC0wNy0wMS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDCDAN
# BgkqhkiG9w0BAQsFAAOCAQEAbTLoGg593wQgWbkR6AkAX7ybv8N/EbxJXRXX99p2
# /4I3nsGcFaTKZKhDZ+DyzWWFNoOIJhrWxHrWvLSXsl0xilhpntb5oyhvwkXUYmr9
# 6hD7Q8wUT4d9Lu49PV/stCz0Br14iicOn6TCeLu8keiPQZ8PZeA3g+/eIgT8egry
# hv2m8i+qfowAbuEtHJIhH/MY3Jvo6sX2GNn5CUgLpmKnY1ceHoMchJAUb9qzP2fX
# knilmvBjNqPOukVrTz1hu3RyXNZ1edIL1xGaeCAK/Vgrk9wS5SXZIDvuJHbY9vqA
# igwc8Dk0XsHB1yiDTmcQUnawMDJjZttLBhXTavLiYp00rDCCBnEwggRZoAMCAQIC
# CmEJgSoAAAAAAAIwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRp
# ZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTEwMDcwMTIxMzY1NVoXDTI1MDcwMTIx
# NDY1NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
# A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggEiMA0GCSqGSIb3
# DQEBAQUAA4IBDwAwggEKAoIBAQCpHQ28dxGKOiDs/BOX9fp/aZRrdFQQ1aUKAIKF
# ++18aEssX8XD5WHCdrc+Zitb8BVTJwQxH0EbGpUdzgkTjnxhMFmxMEQP8WCIhFRD
# DNdNuDgIs0Ldk6zWczBXJoKjRQ3Q6vVHgc2/JGAyWGBG8lhHhjKEHnRhZ5FfgVSx
# z5NMksHEpl3RYRNuKMYa+YaAu99h/EbBJx0kZxJyGiGKr0tkiVBisV39dx898Fd1
# rL2KQk1AUdEPnAY+Z3/1ZsADlkR+79BL/W7lmsqxqPJ6Kgox8NpOBpG2iAg16Hgc
# sOmZzTznL0S6p/TcZL2kAcEgCZN4zfy8wMlEXV4WnAEFTyJNAgMBAAGjggHmMIIB
# 4jAQBgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQU1WM6XIoxkPNDe3xGG8UzaFqF
# bVUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1Ud
# EwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186aGMQwVgYD
# VR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwv
# cHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsGAQUFBwEB
# BE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9j
# ZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwgaAGA1UdIAEB/wSBlTCB
# kjCBjwYJKwYBBAGCNy4DMIGBMD0GCCsGAQUFBwIBFjFodHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vUEtJL2RvY3MvQ1BTL2RlZmF1bHQuaHRtMEAGCCsGAQUFBwICMDQe
# MiAdAEwAZQBnAGEAbABfAFAAbwBsAGkAYwB5AF8AUwB0AGEAdABlAG0AZQBuAHQA
# LiAdMA0GCSqGSIb3DQEBCwUAA4ICAQAH5ohRDeLG4Jg/gXEDPZ2joSFvs+umzPUx
# vs8F4qn++ldtGTCzwsVmyWrf9efweL3HqJ4l4/m87WtUVwgrUYJEEvu5U4zM9GAS
# inbMQEBBm9xcF/9c+V4XNZgkVkt070IQyK+/f8Z/8jd9Wj8c8pl5SpFSAK84Dxf1
# L3mBZdmptWvkx872ynoAb0swRCQiPM/tA6WWj1kpvLb9BOFwnzJKJ/1Vry/+tuWO
# M7tiX5rbV0Dp8c6ZZpCM/2pif93FSguRJuI57BlKcWOdeyFtw5yjojz6f32WapB4
# pm3S4Zz5Hfw42JT0xqUKloakvZ4argRCg7i1gJsiOCC1JeVk7Pf0v35jWSUPei45
# V3aicaoGig+JFrphpxHLmtgOR5qAxdDNp9DvfYPw4TtxCd9ddJgiCGHasFAeb73x
# 4QDf5zEHpJM692VHeOj4qEir995yfmFrb3epgcunCaw5u+zGy9iCtHLNHfS4hQEe
# gPsbiSpUObJb2sgNVZl6h3M7COaYLeqN4DMuEin1wC9UJyH3yKxO2ii4sanblrKn
# QqLJzxlBTeCG+SqaoxFmMNO7dDJL32N79ZmKLxvHIa9Zta7cRDyXUHHXodLFVeNp
# 3lfB0d4wwP3M5k37Db9dT+mdHhk4L7zPWAUu7w2gUDXa7wknHNWzfjUeCLraNtvT
# X4/edIhJEqGCAsswggI0AgEBMIH4oYHQpIHNMIHKMQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBP
# cGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo4QTgyLUUzNEYtOURE
# QTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcG
# BSsOAwIaAxUADTYHhHELq8EAYxBiH4KhJQYLM7+ggYMwgYCkfjB8MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
# VGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIFAOCEOOgwIhgPMjAx
# OTA1MTQwMjQxNDRaGA8yMDE5MDUxNTAyNDE0NFowdDA6BgorBgEEAYRZCgQBMSww
# KjAKAgUA4IQ46AIBADAHAgEAAgIZfDAHAgEAAgIRrjAKAgUA4IWKaAIBADA2Bgor
# BgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAID
# AYagMA0GCSqGSIb3DQEBBQUAA4GBAE5ML5NXTNMTYCXte2XUtC5qd472tJiADHQW
# h0WYLh6Vu6sZD9nASsQDD7FEPmbcQqxo3ocNp+MRP3rqFLR3/pPgwOz+pXFyYj6B
# AxCyf7npoM14zKuRIkWLeEiS7c/TNz4SrbOPl8pDO15Gt4rdvn7UBjHFSSH0moYi
# CrF96fAOMYIDDTCCAwkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTACEzMAAADwvF+brrNM/yUAAAAAAPAwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqG
# SIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQgHbvZmwoSdhDN
# bPZRfndZ0ZnKQsyLLA+gc0wZO+qubUowgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHk
# MIG9BCAM3kFp/S9Ebkh5zng8cKV03M2jYZcrfVf0y1QYlsYAkDCBmDCBgKR+MHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAA8Lxfm66zTP8lAAAAAADw
# MCIEIK0EOWNk7pi4r7raVEr1HjDNaEfYc2RMKo23pIjpx/fPMA0GCSqGSIb3DQEB
# CwUABIIBABo0Fo5g0hYVTGr7m+2h01lTH8dbP4lJHEc7IYLJ0kBtuOk05PVsIDIR
# tjnqaWNAM9GgjQh+Cd7vYKLxxEoeWneTK0W5zvz0z7IfGYi5HcEi19mIpNGkIoY+
# /wB3km4DgLsZMMob6QBLoPTr2JvZmqfIOrRWtbMUzVGoHZf5WSgZ9icpsk7D4jqP
# tiuvq+lESiYl2nLIg7NxsmzeaXipcuq6EOxZOv17FxY584n0zBbhpaaZoYXaAUSF
# if5FgwtdEzpGo5dbaq+hjl3rPzuHfFvGTr/sjgoY60vveL2SRHRDWH/vGxZVXM/T
# iRAD5rRpFPjvB1b0C6MSQbXuIp1WgxA=
# SIG # End signature block
