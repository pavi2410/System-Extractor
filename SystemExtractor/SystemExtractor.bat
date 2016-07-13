@echo off
title System Extractor
mode con:cols=80 lines=30
mkdir firmware
mkdir output
mkdir wip
mkdir system

:prestart
cls
echo.
echo              ____                     __                         
echo             /\  _`\                  /\ \__                      
echo             \ \,\L\_\  __  __    ____\ \ ,_\    __    ___ ___    
echo              \/_\__ \ /\ \/\ \  /',__\\ \ \/  /'__`\/' __` __`\  
echo                /\ \L\ \ \ \_\ \/\__, `\\ \ \_/\  __//\ \/\ \/\ \ 
echo                \ `\____\/`____ \/\____/ \ \__\ \____\ \_\ \_\ \_\
echo                 \/_____/`/___/  \/___/   \/__/\/____/\/_/\/_/\/_/
echo                            /\___/                                
echo                            \/__/                                 
echo        ____            __                          __                   
echo       /\  _`\         /\ \__                      /\ \__                
echo       \ \ \L\_\  __  _\ \ ,_\  _ __    __      ___\ \ ,_\   ___   _ __  
echo        \ \  _\L /\ \/'\\ \ \/ /\`'__\/'__`\   /'___\ \ \/  / __`\/\`'__\
echo         \ \ \L\ \/    / \ \ \_\ \ \//\ \L\.\_/\ \__/\ \ \_/\ \L\ \ \ \/ 
echo          \ \____//\_/\_\ \ \__\\ \_\\ \__/.\_\ \____\\ \__\ \____/\ \_\ 
echo           \/___/ \//\/_/  \/__/ \/_/ \/__/\/_/\/____/ \/__/\/___/  \/_/ 
echo.
pause
goto start1

:start1
cls
echo.
echo Do you want to extract system from a firmware/Odin package or from the phone?
echo   1.Firmware/Odin package
echo   2.Phone
echo.
set /p odin=
if %odin%==1 (goto start)
if %odin%==2 (goto start2)

:start2
mkdir output\system
%cd%\tools\adb.exe devices
cls
echo.
echo Connect your device and make sure that you have usb debug active
echo.
%cd%\tools\adb.exe wait-for-devices
%cd%\tools\adb.exe remount
%cd%\tools\adb.exe pull /system %cd%\output\system\
goto finish

:start
cls
echo.
echo  Things to do:
echo.
echo     1.Place the firmware in firmware folder (Example: xxlq4.tar.md5)
echo     2.Make sure that there is only one file in the firmware folder
echo.
pause
goto next

:next
cls
echo.
echo Extracting firmware...
%cd%\tools\7za x "%cd%\firmware\*" -o"%cd%\wip"
cls
echo.
echo Copying system...
copy %cd%\wip\system.img.md5 %cd%\system\system.img.md5
rmdir /S /Q %cd%\wip
mkdir wip
copy %cd%\system\system.img.md5 %cd%\wip\system.img.md5
rd /s /q %cd%\system
rename %cd%\wip\system.img.md5 system.img
goto next2

:next2
cls
echo.
echo How much ram do you want to use? (512, 1024, 2048)
set /p ram=
echo.
echo Opening sgs2toext4...
echo.
echo  Go to wip folder and drag system.img and drop it in sgs2toext4 window
echo.
echo  When the process is finished close the sgs2toext4 window
echo  If you close it before it finish the extract will fail
echo.
cd tools
java -Xmx%ram%m -jar sgs2toext4.jar
cd ..
cls
del /s /q %cd%\wip\system.img
start %cd%\tools\ext4_unpacker.exe
echo.
echo Now open system.ext4.img located in wip folder
echo using ext4 unpacker and extract it to output folder
echo.
pause
goto finish

:finish
cls
echo.
echo              Extract finished!
echo   You will find the result in output folder
echo.
pause
exit