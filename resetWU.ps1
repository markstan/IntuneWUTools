 

net stop wuauserv
net stop bits
net stop cryptsvc

Remove-Item $env:systemroot\SoftwareDistribution -Recurse -Force

del "$env:ALLUSERSPROFILE\Application Data\Microsoft\Network\Downloader\qmgr*.dat"

if (Test-Path $env:Systemroot\System32\catroot2) {
    $ext = [System.IO.Path]::GetRandomFileName()  
    Rename-Item $env:Systemroot\System32\catroot2 catroot2.bak.$ext 
    }

$ACL = 'D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)'
sc.exe sdset bits     $ACL
sc.exe sdset wuauserv $ACL

 
$dlls = @(
     "atl.dll",
     "urlmon.dll",
     "mshtml.dll",
     "shdocvw.dll",
     "browseui.dll",
     "jscript.dll",
     "vbscript.dll",
     "scrrun.dll",
     "msxml.dll",
     "msxml3.dll",
     "msxml6.dll",
     "actxprxy.dll",
     "softpub.dll",
     "wintrust.dll",
     "dssenh.dll",
     "rsaenh.dll",
     "gpkcsp.dll",
     "sccbase.dll",
     "slbcsp.dll",
     "cryptdlg.dll",
     "oleaut32.dll",
     "ole32.dll",
     "shell32.dll",
     "initpki.dll",
     "wuapi.dll",
     "wuaueng.dll",
     "wuaueng1.dll",
     "wucltui.dll",
     "wups.dll",
     "wups2.dll",
     "wuweb.dll",
     "qmgr.dll",
     "qmgrprxy.dll",
     "wucltux.dll",
     "muweb.dll",
     "wuwebv.dll"
    )

foreach ($dll in $dlls ) {

    $fileName = Join-Path "$env:Systemroot\system32" $dll
    if (Test-Path $fileName) {
        regsvr32 /s $fileName
        }

}

netsh winsock reset

net start bits
net start wuauserv   
net start cryptsvc
 