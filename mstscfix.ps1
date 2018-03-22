
#Create local folder

if (Test-Path C:\MSTSC)
{
    echo "C:\MSTSC" existing folder
}
else
{
    New-Item -ItemType directory -path C:\MSTSC
}


#download files

$url = "https://github.com/steffjenl/mstsc1703/raw/master/mstsc.exe"
$output = "C:\MSTSC\mstsc.exe"
Invoke-WebRequest -Uri $url -OutFile $output

$url = "https://github.com/steffjenl/mstsc1703/raw/master/mstscax.dll"
$output = "C:\MSTSC\mstscax.dll"
Invoke-WebRequest -Uri $url -OutFile $output

#taking ownship of files to change permission
echo "Taking Ownership of files"
takeown /f "C:\Windows\System32\mstsc.exe"
takeown /f "C:\Windows\System32\mstscax.dll"


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

#Rename Files
ren C:\Windows\System32\mstsc.exe mstsc.exe.bak
ren C:\Windows\System32\mstscax.dll mstscax.dll.bak

#moving old MSTSC files into location

copy "C:\MSTSC\mstsc.exe" "C:\Windows\System32\"
copy "C:\MSTSC\mstscax.dll" "C:\Windows\System32\"

#Giving Ownership back to file.
icacls "C:\Windows\System32\mstsc.exe" /setowner "NT Service\TrustedInstaller"
icacls "C:\Windows\System32\mstscax.dll" /setowner "NT Service\TrustedInstaller"
