@echo off
cls
echo -----------------------------------------------------------------------
echo                   * ZLUDA Patcher (for HIP 5.7.1)*
echo -----------------------------------------------------------------------
echo.
where curl >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: curl is not installed or not in PATH.
    pause
    exit /b
)

where tar >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: tar is not installed or not in PATH.
    pause
    exit /b
)

echo :: Activating virtual environment
if not exist "%~dp0venv\Scripts\activate.bat" (
    echo Error: venv not found in script directory: %~dp0
    pause
    exit /b
)

call "venv\Scripts\activate.bat"
if not defined VIRTUAL_ENV (
    echo Error: Failed to activate virtual environment.
    pause
    exit /b
)

where pip >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: pip not found in PATH after activating venv.
    pause
    exit /b
)

echo :: Uninstalling previous torch packages
pip uninstall torch torchvision torchaudio -y --quiet
rmdir /S /Q "venv\Lib\site-packages\torch" 2>nul

echo :: Installing torch 2.3 - torchaudio 2.3 and torchvision 0.18
pip install torch==2.3.0 torchvision==0.18.0 torchaudio==2.3.0 --index-url https://download.pytorch.org/whl/cu118 --quiet

echo :: Re-installing numpy 1.26.4
pip uninstall numpy -y --quiet
pip install numpy==1.26.4 --quiet

echo :: Removing previous zluda install
rmdir /S /Q zluda 2>nul

echo :: Downloading and patching zluda 3.9.5 for HIP 5.x
%SystemRoot%\system32\curl.exe -sL --ssl-no-revoke https://github.com/lshqqytiger/ZLUDA/releases/download/rel.5e717459179dc272b7d7d23391f0fad66c7459cf/ZLUDA-windows-rocm5-amd64.zip > zluda.zip
%SystemRoot%\system32\tar.exe -xf zluda.zip
del zluda.zip

echo :: Patching torch DLLs
copy "zluda\cublas.dll" "venv\Lib\site-packages\torch\lib\cublas64_11.dll" /y
if %errorlevel% neq 0 (
    echo Error copying cublas.dll
    pause
    exit /b
copy "zluda\cusparse.dll" "venv\Lib\site-packages\torch\lib\cusparse64_11.dll" /y
if %errorlevel% neq 0 (
    echo Error copying cusparse.dll
    pause
    exit /b
copy "zluda\nvrtc.dll" "venv\Lib\site-packages\torch\lib\nvrtc64_112_0.dll" /y
if %errorlevel% neq 0 (
    echo Error copying nvrtc.dll
    pause
    exit /b
echo.
echo :: ZLUDA 3.9.5 patched for HIP SDK 5.7.1.
pause
