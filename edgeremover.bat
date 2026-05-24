@echo off
chcp 65001 >nul
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [1/6] Права администратора получены. Начинаем...
) else (
    echo ОШИБКА: Запустите этот скрипт от имени АДМИНИСТРАТОРА!
    pause
    exit /b
)

echo [2/6] Закрытие процессов Microsoft Edge...
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im MicrosoftEdgeUpdate.exe >nul 2>&1

echo [3/6] Принудительное удаление файлов браузера...
if exist "C:\Program Files (x86)\Microsoft\Edge" (
    rmdir /s /q "C:\Program Files (x86)\Microsoft\Edge"
)
if exist "C:\Program Files (x86)\Microsoft\EdgeUpdate" (
    rmdir /s /q "C:\Program Files (x86)\Microsoft\EdgeUpdate"
)

echo [4/6] Очистка пользовательского кэша...
if exist "%LOCALAPPDATA%\Microsoft\Edge" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge"
)

echo [5/6] Запись запрета на установку Edge в реестр...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1 /f >nul

echo [6/6] Очистка остаточных ярлыков...
del /f /q "%userprofile%\Desktop\Microsoft Edge.lnk" >nul 2>&1
del /f /q "%public%\Desktop\Microsoft Edge.lnk" >nul 2>&1
del /f /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" >nul 2>&1
del /f /q "%programdata%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" >nul 2>&1
del /f /q "%appdata%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk" >nul 2>&1

:: Перезапуск проводника для мгновенного обновления иконок без лишних окон
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo === ГОТОВО! Edge удален, ярлыки стерты, обновления заблокированы. ===
pause
