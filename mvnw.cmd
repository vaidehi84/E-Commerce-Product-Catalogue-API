@REM Licensed to the Apache Software Foundation (ASF) under one
@REM or more contributor license agreements.  See the NOTICE file
@REM distributed with this work for additional information
@REM regarding copyright ownership.  The ASF licenses this file
@REM to you under the Apache License, Version 2.0 (the
@REM "License"); you may not use this file except in compliance
@REM with the License.  You may obtain a copy of the License at
@REM
@REM    https://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing,
@REM software distributed under the License is distributed on an
@REM "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
@REM KIND, either express or implied.  See the License for the
@REM specific language governing permissions and limitations
@REM under the License.
@REM ----------------------------------------------------------------------------
@REM Maven Wrapper startup script, version 3.2.0
@REM
@REM Required ENV vars:
@REM JAVA_HOME - location of a JDK home dir
@REM
@REM Optional ENV vars
@REM MAVEN_OPTS - parameters passed to the Java VM when running Maven
@REM     e.g. to debug Maven itself, use
@REM       set MAVEN_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000
@REM MAVEN_SKIP_RC - flag to disable loading of mavenrc files
@REM ----------------------------------------------------------------------------

@if "%DEBUG%" == "" @echo off
@REM ###########################################################################
@REM #                                                                       ##
@REM #  Gradle startup script for Windows                                       ##
@REM #                                                                       ##
@REM ###########################################################################

@REM
@REM $Revision: 8474 $ $Date: 2023-11-16 20:19:58 +0000 (Thu, 16 Nov 2023) $
@REM

@REM Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%

@REM Resolve any "." and ".." in APP_HOME to make it shorter.
for %%i in ("%APP_HOME%") do set APP_HOME=%%~fi

@REM Add default JVM options here. You can also use JAVA_OPTS and MAVEN_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS="-Xmx64m" "-Xms64m"

@REM Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto init

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto init

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:init
@REM Get command-line arguments, handling Windows variants

if not "%OS%" == "Windows_NT" goto win9xME_args

:win9xME_args
@REM Slurp the command line arguments.
set CMD_LINE_ARGS=
set _SKIP=2

:win9xME_args_slurp
if "x%~1" == "x" goto execute

set CMD_LINE_ARGS=%CMD_LINE_ARGS% %~1
shift

goto win9xME_args_slurp

:win9xME_args_done
@REM Don't call me, I'm just here for backwards compatibility

:execute
@REM Setup the command line

set CLASSPATH=%APP_HOME%\maven-wrapper.jar

@REM Execute Maven
"%JAVA_EXE%" ^
  %DEFAULT_JVM_OPTS% ^
  %JAVA_OPTS% ^
  %MAVEN_OPTS% ^
  "-Dmaven.multiModuleProjectDirectory=%MAVEN_PROJECTBASEDIR%" ^
  "-Dmaven.home=%APP_HOME%\.mvn" ^
  "-Dclassworlds.conf=%APP_HOME%\.mvn\wrapper\maven-wrapper.properties" ^
  "-Dmaven.wrapper.version=3.2.0" ^
  "-Dmaven.wrapper.vendor=Apache" ^
  "-Dmaven.wrapper.main.class=org.apache.maven.wrapper.MavenWrapperMain" ^
  "-Dmaven.wrapper.vendor.version=3.2.0" ^
  "-Dmaven.wrapper.main.jar.file=maven-wrapper.jar" ^
  "-Dmaven.wrapper.classpath=%APP_HOME%\maven-wrapper.jar" ^
  "-Dmaven.wrapper.java.command=%JAVA_EXE%" ^
  "-Dmaven.wrapper.user.home=%MAVEN_USER_HOME%" ^
  %CLASSPATH_PREFIX% ^
  %CMD_LINE_ARGS% ^
  org.apache.maven.wrapper.MavenWrapperMain ^
  %MAVEN_CONFIG% ^
  %MAVEN_OPTS% ^
  %*

goto end

:fail
rem Set variable MAVEN_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd_ return code.
if  not "" == "%MAVEN_EXIT_CONSOLE%" exit 1
exit /b 1

:end
if "%OS%"=="Windows_NT" endlocal

:omega