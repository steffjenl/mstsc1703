function Show-Menu
{
     param (
           [string]$Title = 'Patch Microsoft Remote Desktop'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Patch mstsc.exe and mstscax.dll"
     Write-Host "2: Restore original files"
     Write-Host "Q: Press 'Q' to quit."
}

do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                'Patch mstsc.exe and mstscax.dll'

Stop-Process -Name "mstsc"
#Create local folder
New-Item -ItemType directory -path C:\MSTSC -Force
New-Item -ItemType directory -path C:\MSTSC\backup -Force

#download files
$url = "https://github.com/steffjenl/mstsc1703/raw/master/mstsc.exe"
$output = "C:\MSTSC\mstsc.exe"
Invoke-WebRequest -Uri $url -OutFile $output

$url = "https://github.com/steffjenl/mstsc1703/raw/master/mstscax.dll"
$output = "C:\MSTSC\mstscax.dll"
Invoke-WebRequest -Uri $url -OutFile $output


#Applying permission changed to rename file.
echo "Giving permission over files"
$rule=new-object System.Security.AccessControl.FileSystemAccessRule ("$env:userdomain\$env:username","FullControl","Allow")
$acl = Get-ACL C:\Windows\System32\mstsc.exe
$acl.SetAccessRule($rule)
Set-ACL -Path C:\Windows\System32\mstsc.exe -AclObject $acl


$rule=new-object System.Security.AccessControl.FileSystemAccessRule ("$env:userdomain\$env:username","FullControl","Allow")
$acl = Get-ACL C:\Windows\System32\mstscax.dll
$acl.SetAccessRule($rule)
Set-ACL -Path C:\Windows\System32\mstscax.dll -AclObject $acl

#Create backup of excisting Files
if (Test-Path C:\MSTSC\backup\mstscax.dll)
{
        echo "C:\MSTSC\backup\mstscax.dll already exist"
}
else
{
    mv C:\Windows\System32\mstscax.dll c:\MSTSC\backup\mstscax.dll
}

if (Test-Path C:\MSTSC\backup\mstsc.exe)
{
    echo "C:\MSTSC\backup\mstsc.exe already exist"
}
else
{
    mv C:\Windows\System32\mstsc.exe c:\MSTSC\backup\mstsc.exe
}

#Moving new files to location
copy "c:\MSTSC\mstsc.exe" "C:\Windows\System32\"
copy "c:\MSTSC\mstscax.dll" "C:\Windows\System32\"

#Giving Ownership back to file.
icacls "C:\Windows\System32\mstsc.exe" /setowner "NT Service\TrustedInstaller"
icacls "C:\Windows\System32\mstscax.dll" /setowner "NT Service\TrustedInstaller"

           } '2' {
                cls
                'Restore original files'

Stop-Process -Name "mstsc"
#Applying permission changed to rename file.
echo "Giving permission over files"
$rule=new-object System.Security.AccessControl.FileSystemAccessRule ("$env:userdomain\$env:username","FullControl","Allow")
$acl = Get-ACL C:\Windows\System32\mstsc.exe
$acl.SetAccessRule($rule)
Set-ACL -Path C:\Windows\System32\mstsc.exe -AclObject $acl


$rule=new-object System.Security.AccessControl.FileSystemAccessRule ("$env:userdomain\$env:username","FullControl","Allow")
$acl = Get-ACL C:\Windows\System32\mstscax.dll
$acl.SetAccessRule($rule)
Set-ACL -Path C:\Windows\System32\mstscax.dll -AclObject $acl

#Moving backup files to location
copy "c:\MSTSC\backup\mstsc.exe" "C:\Windows\System32\"
copy "c:\MSTSC\backup\mstscax.dll" "C:\Windows\System32\"

#Giving Ownership back to file.
icacls "C:\Windows\System32\mstsc.exe" /setowner "NT Service\TrustedInstaller"
icacls "C:\Windows\System32\mstscax.dll" /setowner "NT Service\TrustedInstaller"

           } 'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')
