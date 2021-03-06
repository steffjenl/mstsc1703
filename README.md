## Message from Microsoft
We have found out that it is a known issue and our internal team is working on it.

EVENT_SYSTEM_FOREGROUND comes too soon on the server. We end up sending the incorrect z-order to the client because in some scenarios the z-order calculation has not completed before we send it. A race condition exists in RemoteApp when a window is activated resulting in the activated window opening behind the previous foreground window. After the RemoteApp widow is activated, RdpShell.exe checks the server z-order before win32k.sys finishes computing the new z-order. When this condition occurs, Rdpshell.exe sends the wrong z-order instructions to mstsc.exe on the client. This fix introduces timer code to cause RdpShell.exe to wait for win32k.sys to finish computing the z-order before sending the new z-order to the client.

The fix is likely to get released by March or April.

I will provide you with the update, as and when if there is any.

## Installation
1. Copy downloaded mstscfix.ps1, to the root of your PCs C: drive
2. Close any Remote Apps or RDP sessions, ensure mstsc.exe is not running under task manager
3. Search for & Run: Windows Powershell as administrator (right click to run as administrator)
4. Run: Set-ExecutionPolicy Unrestricted
5. Select: A
6. Run: cd /
7. Run: & '.\mstscfix.ps1'
8. Run: Set-ExecutionPolicy restricted
9. Close Windows Powershell

## More information
* Thanks to (http://www.knowall.net/blog/known-bug-with-windows-10-and-remote-desktop-rds-remote-apps-selected-windows-do-not-respond-fix/) for the fix!
* https://social.technet.microsoft.com/Forums/en-US/cdf12bbc-ff78-4d6e-9e12-63f99ae4d511/w10-1709-remoteapp-popups-hidden-behind-main-window?forum=winserverTS