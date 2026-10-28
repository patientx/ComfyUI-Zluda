@echo off
cls
echo -----------------------------------------------------------------------
echo     * ZLUDA Patcher (for HIP 6.2.4 / 6.4.2 with MIOPEN and Triton)*
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

set "sitePKG=%~dp0venv\Lib\site-packages"

echo :: Uninstalling previous torch packages
pip uninstall torch torchvision torchaudio -y --quiet
if exist "%sitePKG%\torch" rmdir /S /Q "%sitePKG%\torch" 2>nul
if exist "%sitePKG%\torchvision" rmdir /S /Q "%sitePKG%\torchvision" 2>nul
if exist "%sitePKG%\torchaudio" rmdir /S /Q "%sitePKG%\torchaudio" 2>nul

echo :: Installing torch 2.7 - torchaudio 2.7 and torchvision 0.22
pip install torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0 --index-url https://download.pytorch.org/whl/cu118 --quiet

echo :: Re-installing numpy 1.26.4
pip uninstall numpy -y --quiet
if exist "%sitePKG%\numpy" rmdir /S /Q "%sitePKG%\numpy" 2>nul
pip install numpy==1.26.4 --quiet

pip show torch >nul || (
    echo Error: Torch installation failed.
    pause
    exit /b 1
)

echo :: Removing previous zluda install
rmdir /S /Q zluda 2>nul
mkdir "zluda"
cd "zluda"

echo :: Downloading and patching zluda 3.9.5 nightly for HIP 6.x
%SystemRoot%\system32\curl.exe -sL --ssl-no-revoke https://github.com/lshqqytiger/ZLUDA/releases/download/rel.5e717459179dc272b7d7d23391f0fad66c7459cf/ZLUDA-nightly-windows-rocm6-amd64.zip > zluda.zip
if not exist zluda.zip (
    echo Error: ZLUDA download failed!
    pause
    exit /b 1
)

%SystemRoot%\system32\tar.exe -xf zluda.zip
del zluda.zip
cd ..

echo :: Patching torch DLLs
:: Pre-check: nvrtc64_112_0.dll and nvrtc_cuda.dll inside torch\lib should NOT be identical
set "FILE1=venv\Lib\site-packages\torch\lib\nvrtc64_112_0.dll"
set "FILE2=venv\Lib\site-packages\torch\lib\nvrtc_cuda.dll"
for /f "tokens=*" %%A in ('certutil -hashfile "%FILE1%" SHA256 ^| find /i /v "hash of" ^| find /i /v "certutil"') do set "HASH1=%%A"
for /f "tokens=*" %%B in ('certutil -hashfile "%FILE2%" SHA256 ^| find /i /v "hash of" ^| find /i /v "certutil"') do set "HASH2=%%B"
if "%HASH1%"=="%HASH2%" (
    echo WARNING: Files nvrtc64_112_0.dll and nvrtc_cuda.dll inside torch\lib are identical (same SHA-256 hash)
	echo          Likely already patched, incorrectly.
	pause
	echo.
	set /p confirm=Patch anyway? Type YES to proceed with patching: 
	if /I not "%confirm%"=="YES" (
        echo :: Aborting patch.
        exit /b
    )
)

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
copy "venv\Lib\site-packages\torch\lib\nvrtc64_112_0.dll" "venv\Lib\site-packages\torch\lib\nvrtc_cuda.dll" /y
copy "zluda\nvrtc.dll" "venv\Lib\site-packages\torch\lib\nvrtc64_112_0.dll" /y
if %errorlevel% neq 0 (
    echo Error copying nvrtc.dll
    pause
    exit /b
copy "zluda\cufft.dll" "venv\Lib\site-packages\torch\lib\cufft64_10.dll" /y
if %errorlevel% neq 0 (
    echo Error copying cufft.dll
    pause
    exit /b
copy "zluda\cufftw.dll" "venv\Lib\site-packages\torch\lib\cufftw64_10.dll" /y
if %errorlevel% neq 0 (
    echo Error copying cufftw.dll
    pause
    exit /b
echo :: Patching zluda.py
copy "comfy\customzluda\zluda.py" "comfy\zluda.py" /y >NUL
if %errorlevel% neq 0 (
    echo Error copying zluda.py
    pause
    exit /b
echo.
echo :: ZLUDA 3.9.5 nightly patched for HIP SDK 6.2.4 / 6.4.2 with miopen and triton-flash attention.
pause
