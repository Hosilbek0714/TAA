@echo off
rem ===========================================================================
rem  TAA Agent 2 - Windows xizmatini o'rnatish
rem
rem  ADMINISTRATOR sifatida ishga tushiring:
rem    faylga o'ng tugma -> "Run as administrator"
rem
rem  Kutiladi: C:\TAA\agent\taa_agent2.exe va C:\TAA\agent\taa_agent2.conf
rem
rem  Nega "taa_agent2.exe -i" emas: exe ichidagi xizmat nomi o'zgartirilmagan.
rem  Exe'ni o'zgartirib bo'lmaydi - Windows Smart App Control o'zgartirilgan
rem  exe'ni bloklaydi. Shuning uchun xizmat sc.exe orqali "TAA Agent 2" nomi
rem  bilan yaratiladi (exe -i bilan aynan bir xil buyruq qatori: -f=false).
rem ===========================================================================
setlocal
set "DIR=C:\TAA\agent"
set "EXE=%DIR%\taa_agent2.exe"
set "CONF=%DIR%\taa_agent2.conf"
set "SVC=TAA Agent 2"

net session >nul 2>&1
if errorlevel 1 (
	echo XATO: administrator sifatida ishga tushiring.
	pause
	exit /b 1
)
if not exist "%EXE%"  ( echo XATO: %EXE% topilmadi.  & pause & exit /b 1 )
if not exist "%CONF%" ( echo XATO: %CONF% topilmadi. & pause & exit /b 1 )

echo [1/5] Eski xizmatlarni olib tashlash...
sc query "Zabbix Agent 2" >nul 2>&1
if not errorlevel 1 (
	"%EXE%" -c "%CONF%" -x >nul 2>&1
	"%EXE%" -c "%CONF%" -d
)
sc query "%SVC%" >nul 2>&1
if not errorlevel 1 (
	sc stop "%SVC%" >nul 2>&1
	timeout /t 3 /nobreak >nul
	sc delete "%SVC%" >nul
)

echo [2/5] "%SVC%" xizmatini yaratish...
sc create "%SVC%" binPath= "\"%EXE%\" -c \"%CONF%\" -f=false" start= auto DisplayName= "TAA Agent 2"
if errorlevel 1 ( echo XATO: xizmat yaratilmadi. & pause & exit /b 1 )
sc description "%SVC%" "TAA monitoring tizimi agenti" >nul
sc failure "%SVC%" reset= 86400 actions= restart/60000/restart/60000/restart/60000 >nul

echo [3/5] Firewall qoidalari...
netsh advfirewall firewall delete rule name="TAA Agent" >nul 2>&1
netsh advfirewall firewall delete rule name="TAA Agent exe" >nul 2>&1
netsh advfirewall firewall add rule name="TAA Agent" dir=in action=allow protocol=TCP localport=10050 profile=any >nul
netsh advfirewall firewall add rule name="TAA Agent exe" dir=in action=allow program="%EXE%" profile=any >nul

echo [4/5] Ishga tushirish...
sc start "%SVC%" >nul
timeout /t 3 /nobreak >nul

echo [5/5] Holat:
sc query "%SVC%" | findstr /i "STATE"
echo.
echo Tayyor. Log: %DIR%\taa_agent2.log
pause
