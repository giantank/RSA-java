@echo off
::[zh_CN] ��Windowsϵͳ��˫����������ű��ļ����Զ����java�ļ�����ʹ����jar
::[en_US] Double-click to run this script file in the Windows system, and automatically complete the java file compilation and packaging into jar


::[zh_CN] �޸�����ָ����Ҫʹ�õ�JDK��\��βbinĿ¼����·����������ʹ���Ѱ�װ��Ĭ��JDK  
::[en_US] Modify here to specify the JDK to be used (full path to the bin directory ending with \), otherwise the installed default JDK will be used
set jdkBinDir=
::set jdkBinDir=D:\xxxx\jdk-18_windows-x64_bin\jdk-18.0.2.1\bin\


cls
::chcp 437
set isZh=0
ver | find "�汾%qjkTTT%" > nul && set isZh=1
goto Run
:echo2
	if "%isZh%"=="1" echo %~1
	if "%isZh%"=="0" echo %~2
	goto:eof

:Run
cd /d %~dp0
cd ..\
call:echo2 "��ʾ���ԣ���������    %cd%" "Language: English    %cd%"
echo.


call:echo2 "��������Ҫ���ɵ�jar�ļ��汾�ţ�  " "Please enter the version number of the jar file to be generated:"
set step=&set /p jarVer=^> 


set srcDir=target\src
if exist %srcDir% rd /S /Q %srcDir% > nul
md %srcDir%
xcopy RSA_PEM.java %srcDir% /Y > nul
xcopy RSA_Util.java %srcDir% /Y > nul
cd %srcDir%


if "%jdkBinDir%"=="" (
	call:echo2 "���ڶ�ȡJDK�汾������ָ��JDKΪ�ض��汾��Ŀ¼�����޸ı�bat�ļ���jdkBinDirΪJDK binĿ¼����  " "Reading the JDK Version (if you need to specify the JDK as a specific version or directory, please modify the jdkBinDir in this bat file to the JDK bin directory):"
) else (
	call:echo2 "���ڶ�ȡJDK��%jdkBinDir%���汾��  " "Reading JDK (%jdkBinDir%) Version:"
)


%jdkBinDir%javac -version
if errorlevel 1 (
	echo.
	call:echo2 "��Ҫ��װJDK���ܱ�������java�ļ�  " "JDK needs to be installed to compile and run java files"
	goto Pause
)

echo.
call:echo2 "���ڱ���Java�ļ�..." "Compiling Java files..."
echo.
%jdkBinDir%javac -encoding utf-8 -cp "./*" RSA_PEM.java RSA_Util.java
if errorlevel 1 (
	echo.
	call:echo2 "Java�ļ�����ʧ��  " "Java file compilation failed"
	goto Pause
)
cd ..\..

set dir=target\classes\com\github\xiangyuecn\rsajava
if exist target\classes rd /S /Q target\classes > nul
md %dir%
move %srcDir%\*.class %dir% > nul


call:echo2 "������ɣ���������jar..." "The compilation is complete, and the jar is being generated..."


set jarPath=target\rsa-java.lib-%jarVer%.jar
del %jarPath% /Q > nul 2>&1
if exist %jarPath% (
	echo.
	call:echo2 "�޷�ɾ�����ļ���%jarPath%  " "Unable to delete old file: %jarPath%"
	goto Pause
)

set MANIFEST=target\classes\MANIFEST.MF
echo Manifest-Version: 1.0>%MANIFEST%
echo Info-Name: RSA-java>>%MANIFEST%
echo Info-Version: %jarVer%>>%MANIFEST%
echo Info-Build-Date: %date:~,10%>>%MANIFEST%
for /f "delims=" %%v in ('javac -version 2^>^&1') do (
	echo Info-Build-JDK: %%v>>%MANIFEST%
)
echo Info-Copyright: MIT, Copyright %date:~,4% xiangyuecn>>%MANIFEST%
echo Info-Repository: https://github.com/xiangyuecn/RSA-java>>%MANIFEST%

%jdkBinDir%jar cfm %jarPath% %MANIFEST% -C target/classes/ com
if errorlevel 1 (
	echo.
	call:echo2 "����jarʧ��  " "Failed to generate jar"
	goto Pause
)
if not exist %jarPath% (
	echo.
	call:echo2 "δ�ҵ����ɵ�jar�ļ���%jarPath%  " "Generated jar file not found: %jarPath%"
	goto Pause
)
echo.
call:echo2 "������jar���ļ���Դ���Ŀ¼��%jarPath%����copy���jar�������Ŀ��ʹ�á�  " "The jar has been generated, and the file is in the root directory of the source code: %jarPath%, please copy this jar to use in your project."
echo.


:Pause
pause
:End