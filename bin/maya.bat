:: Task API for Maya
:: Create and launch from Maya working directory
::
:: This file is called whenever a user launches Maya
::
:: Arguments:
:: 	 %1: Name of task, e.g. modeling, animation
::
:: Example:
::   $ p999_Meindbender_Sync
::   $ Fiona
::   $ maya modeling

@echo off

:: if user doesn't have app installed
if Not exist "c:\program files\autodesk\maya2016\bin\maya.exe" goto :missing_app

:: if user forgot to set project or asset
if "%PROJECTDIR%"=="" goto :missing_set_project
if "%ASSET%"=="" goto :missing_set_asset

:: If user forgets to include task with "maya"..
if "%1"=="" goto :missing_task

set WORKDIR=%CD%\work\%1\%USERNAME%\maya
if Not exist %WORKDIR% (
	echo Creating new task "%1"..

	mkdir %WORKDIR%\scenes
	mkdir %WORKDIR%\data
    mkdir %WORKDIR%\renderData\shaders
	mkdir %WORKDIR%\images
	rem etc..

    copy %PYBLISH%\etc\maya\workspace.mel %WORKDIR% >NUL
)

:: userSetup.py files
set PYTHONPATH=%PYBLISH_MAYA%\pyblish_maya\pythonpath;%PYTHONPATH%
set PYTHONPATH=%PYBLISH_MINDBENDER%\mindbender\maya\pythonpath;%PYTHONPATH%

:: MB Tools
rem set MAYA_PLUG_IN_PATH=M:\f03_assets\include\maya\scripts\Plugins;%MAYA_PLUG_IN_PATH%
rem set PYTHONPATH=M:\f03_assets\include\maya\scripts;%PYTHONPATH%

:: These cause Maya to "phone home" which occasionally causes
:: a lag or delay in the user interface. They have no side-effect.
set MAYA_DISABLE_CIP=1
set MAYA_DISABLE_CER=1

:: Launch (local) Maya
echo Launching Maya @ %WORKDIR%..
start "Maya" "c:\program files\autodesk\maya2016\bin\maya.exe" -proj %WORKDIR% %*

goto :eof

:missing_task
   	echo Which task? E.g. "maya modeling" or "maya rigging"
:missing_set_project
    echo You must set a project before Launch
    exit /B
:missing_set_asset
    echo You have a project set %PROJECTDIR%
    echo You must set a Asset before Launch
    exit /B
:missing_app
    echo You dont have the app installed on your workstation, or could be you dont have correct version
    exit /B
