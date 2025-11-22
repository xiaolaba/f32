REM uses flash mode DIO, ESP32
REM 2022-10-09, ESP32_Frequency_generation_2MHz_10MHz.ino firmware
REM burn test ok

:: To erase esp32 completely, do not rely on Arduino IDE and code upload, it has cluster and odd thing when uses FATFS, 
:: unless format SPIFFS or FATFS everytime on the fly
:: xiaolaba, 2020-MAR-02
:: Arduino 1.8.16, esptool and path,

REM %userprofile%

cls
prompt $xiao


set comport=COM8
REM set esptoolpath="C:\Users\user0\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\3.1.0/esptool.exe"
REM set esptoolpath="%userprofile%\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\3.1.0/esptool.exe"
REM set esptoolpath="%userprofile%\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\4.2.1/esptool.exe"
set esptoolpath="esptool_5.1.0.exe"

set MCU=esp32c3
set BAUDRATE=921600
REM set BAUDRATE=512000

set project=f32



:: 
%esptoolpath% ^
--chip %MCU% ^
--port %comport% ^
--baud %BAUDRATE% ^
flash-id


%esptoolpath% ^
--chip %MCU% ^
--port %comport% ^
--baud %BAUDRATE% ^
read-mac

%esptoolpath% ^
--chip %MCU% ^
--port %comport% ^
--baud %BAUDRATE% ^
get-security-info

::goto end
::goto flash_chip

%esptoolpath% --chip %MCU% ^
merge-bin -o "merged.bin" ^
--pad-to-size 4MB ^
--flash-mode keep ^
--flash-freq keep ^
--flash-size keep ^
0x0000 "%project%.bootloader.bin" ^
0x8000 "%project%.partitions.bin" ^
0xe000 "boot_app0.bin" ^
0x10000 "%project%.bin"


:: erase whole flash of esp32
%esptoolpath% --chip %MCU% ^
--port %comport% ^
--baud %BAUDRATE% ^
erase-flash



REM pause

:burn_flash
%esptoolpath% ^
--chip %MCU% ^
--port %comport% ^
--baud %BAUDRATE% ^
--before default-reset ^
--after hard-reset ^
write-flash -e -z ^
--flash-mode keep ^
--flash-freq keep ^
--flash-size keep ^
0x0000 %project%.bootloader.bin ^
0x8000 %project%.partitions.bin ^
0xe000 boot_app0.bin ^
0x10000 %project%.bin

goto end


:end
pause



