@echo off
set uaccheck=0
:CheckUAC
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Administrator Privileges are Required.
    goto UACAccess
) else ( goto Done )

:UACAccess
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\uac_get_admin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\uac_get_admin.vbs"

"%temp%\uac_get_admin.vbs"
exit /B

:Done
if exist "%temp%\uac_get_admin.vbs" (del "%temp%\uac_get_admin.vbs")
echo Administraotr privileges completed.
pushd "%CD%"
cd /D "%~dp0"

Title Live Response Ver_1_Kong Jong Hyun 

:start 

if exist ./log (
    @GOTO print
) else (
    mkdir log; log\network; log\process\system; log\process\console; log\user; log\network\information; log\network\route; log\network\bios
    @GOTO print 
)

:print
echo        ------- Development of Live Response Tools -------
echo.        
echo.        
echo                1. Computer Current Time 
echo                2. Output Process List
echo                3. Output Logon User 
echo                4. Netowrk Information Confirm 
echo                5. Network Route
echo                6. Output Directorys and File List
echo                7. Shared Directorys in the same Network Band
echo                8. Check for Scheduled Jobs 
echo                9. Net BIOS 
echo               10. Command History List 
echo.
echo.
echo    ------------ Draw up a Log List ------------
@GOTO SECOND

:SECOND
set s_hour=%time:~0,2%
IF "%s_hour:~0,1%" == " " SET s_hour=0%s_hour:~1,1%
set s_time=%s_hour%_%time:~3,2%_%time:~6,2%
set s_day=%date%_%s_time%

echo               1. Computer Current Time : %s_day%
echo Computer Current Time : %s_day% > ./log/%s_day%.txt
echo.

for /f "tokens=1 delims=" %%F in ('tasklist /v /fi "STATUS eq Running"') do (
    echo %%F >> ./log\process\console\%s_day%_Console.txt
)
echo             2-1. Running Process List  : Saving Finished.

for /f "tokens=1 delims=" %%F in ('tasklist /v /fi "SESSIONNAME eq Services"') do (
    echo %%F >> ./log\process\system\%s_day%_Service.txt
)
echo             2-2. System Process List   : Saving Finished.
echo.

net session >> ./log/user/%s_day%.txt
echo               3. Logon User List : Saving Finished.
echo.

for /f "tokens=1 delims=" %%G in ('netstat -na ^| findstr ESTABLISHED') do (
echo %%G >> ./log\network\information\%s_day%_netstat_established.txt
)
echo             4-1. Network Information ESTABLISHED : Saving Finished.

for /f "tokens=1 delims=" %%G in ('netstat -na ^| findstr LISTENING') do (
echo %%G >> ./log\network\information\%s_day%_netstat_listening.txt
)
echo             4-2. Network Information LISTENING : Saving Finished.

for /f "tokens=1 delims=" %%G in ('netstat -na ^| findstr :80') do (
echo %%G >> ./log\network\information\%s_day%_netstat_80PORT.txt
)
echo             4-3. Network Information 80Port : Saving Finished.
echo.

echo             5-1. Directory List :  PRINT
echo.
for /f "tokens=1 delims=" %%G in ('dir /AD') do (
echo             %%G 
)

echo. 
echo             5-2. File List : PRINT 
echo. 
for /f "tokens=1 delims=" %%G in ('dir /A-D') do (
echo             %%G 
)
PAUSE