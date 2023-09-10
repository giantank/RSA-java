@echo off
::[zh_CN] ��Windowsϵͳ��˫����������ű��ļ����Զ����java�ļ���������С����Ȱ�װ��JDK��֧��Java8(1.8)�����ϰ汾  
::�������BouncyCastle������ǿ����bcprov-jdk**-**.jar������ֱ�Ӹ��ƴ�jar�ļ���Դ���Ŀ¼���������к󼴿ɻ��ȫ������ǩ��ģʽ֧��  

::[en_US] Double-click to run this script file in Windows system to automatically compile and run the java file. JDK needs to be installed first, supporting Java8 (1.8) and above versions
::If you have the BouncyCastle encryption enhancement package (bcprov-jdk**-**.jar), please copy this jar file directly to the source code root directory. After compiling and running, you can get support for all encryption signature modes.


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
call:echo2 "��ʾ���ԣ���������    %cd%" "Language: English    %cd%"
echo.


set jarPath=
for /f "delims=" %%f in ('dir /b target\rsa-java.lib-*.jar 2^>nul') do set jarPath=target\%%f
if "%jarPath%"=="" goto jarPath_End
	call:echo2 "��⵽�Ѵ����jar��%jarPath%���Ƿ�ʹ�ô�jar������ԣ�(Y/N) N  " "A packaged jar is detected: %jarPath%, do you want to use this jar to participate in the test? (Y/N) N"
	set step=&set /p step=^> 
	if /i not "%step%"=="Y" set jarPath=
	if not "%jarPath%"=="" (
		call:echo2 "jar������ԣ�%jarPath%" "jar participates in the test: %jarPath%"
		echo.
	)
:jarPath_End

set rootDir=rsaTest
echo.
call:echo2 "���ڴ�Java��Ŀ%rootDir%..." "Creating Java project %rootDir%..."
echo.
if not exist %rootDir% (
	md %rootDir%
) else (
	del %rootDir%\* /Q > nul
)

if "%jarPath%"=="" (
	xcopy *.java %rootDir% /Y > nul
) else (
	xcopy Test.java %rootDir% /Y > nul
	xcopy %jarPath% %rootDir% /Y > nul
)
if exist *.jar (
	xcopy *.jar %rootDir% /Y > nul
)
cd %rootDir%


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
%jdkBinDir%javac -encoding utf-8 -cp "./*" *.java
if errorlevel 1 (
	echo.
	call:echo2 "Java�ļ�����ʧ��  " "Java file compilation failed"
	goto Pause
)

set dir=com\github\xiangyuecn\rsajava
if not exist %dir% (
	md %dir%
) else (
	del %dir%\*.class > nul
)
move *.class %dir% > nul

%jdkBinDir%java -cp "./;./*" com.github.xiangyuecn.rsajava.Test -cmd=1 -zh=%isZh%

:Pause
pause
:End