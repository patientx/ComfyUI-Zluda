@echo off
chcp 65001 >nul

title ComfyUI-Zluda Installer

set HIP_SDK_DIR=C:\Program Files\AMD\ROCm\6.5
set ZLUDA_COMGR_LOG_LEVEL=1
set ESC=

setlocal EnableDelayedExpansion
set "startTime=%time: =0%"

cls

echo %ESC%[96m╔══════════════════════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[91m   ____                 __       _   _ ____   ___           _        _ _    %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[91m  / ___^|___  _ __ ___  / _^|_   _^| ^| ^| ^|_ _^|  ^|_ _^|_ __  ___^| ^|_ __ _^| ^| ^|   %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[91m ^| ^|   / _ \^| '_ ` _ \^| ^|_^| ^| ^| ^| ^| ^| ^|^| ^|    ^| ^|^| '_ \/ __^| __/ _` ^| ^| ^|   %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[91m ^| ^|__^| (_) ^| ^| ^| ^| ^| ^|  _^| ^|_^| ^| ^|_^| ^|^| ^|    ^| ^|^| ^| ^| \__ \ ^|^| (_^| ^| ^| ^|   %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[91m  \____\___/^|_^| ^|_^| ^|_^|_^|  \__, ^|\___/^|___^|  ^|___^|_^| ^|_^|___/\__\__,_^|_^|_^|   %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[91m                           ^|___/                                            %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m                                                                              %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[93m                    ╔══════════════════════════════════╗                    %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[93m                    ║%ESC%[0m %ESC%[95m     ZLUDA for AMD GPUs         %ESC%[0m %ESC%[93m║                    %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[93m                    ╚══════════════════════════════════╝                    %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m                                                                              %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[92m  ◆ PyTorch 2.8 (CUDA-compatible layer)                                     %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[92m  ◆ Triton 3.4 (High-performance GPU computing)                             %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[92m  ◆ Flash Attention 2 (Memory-efficient attention for Triton)               %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[92m  ◆ Sage Attention 1 (Advanced attention mechanisms)                        %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[92m  ◆ HIP SDK 6.5 (ROCm development toolkit)                                  %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[92m  ◆ MIOpen (AMD's machine learning primitives library)                      %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m                                                                              %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[94m  ┌─────────────────────────────────────────────────────────────────────┐   %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[94m  │%ESC%[0m %ESC%[97m  Bringing CUDA compatibility to AMD Radeon Graphics Cards         %ESC%[0m %ESC%[94m│   %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[94m  │%ESC%[0m %ESC%[97m        Powered by ZLUDA translation layer technology              %ESC%[0m %ESC%[94m│   %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m║%ESC%[0m %ESC%[94m  └─────────────────────────────────────────────────────────────────────┘   %ESC%[0m %ESC%[96m║%ESC%[0m
echo %ESC%[96m╚══════════════════════════════════════════════════════════════════════════════╝%ESC%[0m
echo.
pause
echo  ::  %time:~0,8%  ::  - Setting up the virtual enviroment
Set "VIRTUAL_ENV=venv"
If Not Exist "%VIRTUAL_ENV%\Scripts\activate.bat" (
    python.exe -m venv %VIRTUAL_ENV%
)

If Not Exist "%VIRTUAL_ENV%\Scripts\activate.bat" Exit /B 1

echo  ::  %time:~0,8%  ::  - Virtual enviroment activation
Call "%VIRTUAL_ENV%\Scripts\activate.bat"
echo  ::  %time:~0,8%  ::  - Updating the pip package
python.exe -m pip install --upgrade pip --quiet
echo.
echo  ::  %time:~0,8%  ::  Beginning installation ...
echo.
echo  ::  %time:~0,8%  ::  - Installing torch for AMD GPUs (First file is 2.7 GB, please be patient)
:: install pytorch 2.8 for cuda11.8
pip install --force-reinstall --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu118 --quiet
echo  ::  %time:~0,8%  ::  - Installing required packages
:: because we have already installed torch, pip should consider it already installed
pip install -r requirements.txt --quiet
echo  ::  %time:~0,8%  ::  - Installing onnxruntime (required by some nodes)
pip install onnxruntime --quiet
echo  ::  %time:~0,8%  ::  - (temporary numpy fix)
pip install --force-reinstall "numpy<2" --quiet

echo  ::  %time:~0,8%  ::  - Detecting Python version and installing appropriate triton package
for /f "tokens=2 delims=." %%a in ('python -c "import sys; print(sys.version)"') do (
    set "PY_MINOR=%%a"
    goto :version_detected
)
:version_detected

if "%PY_MINOR%"=="12" (
    echo  ::  %time:~0,8%  ::  - Python 3.12 detected, installing triton for 3.12
    pip install --force-reinstall https://github.com/lshqqytiger/triton/releases/download/a9c80202/triton-3.4.0+gita9c80202-cp312-cp312-win_amd64.whl
) else if "%PY_MINOR%"=="11" (
    echo  ::  %time:~0,8%  ::  - Python 3.11 detected, installing triton for 3.11
    pip install --force-reinstall https://github.com/lshqqytiger/triton/releases/download/a9c80202/triton-3.4.0+gita9c80202-cp311-cp311-win_amd64.whl
) else (
    echo  ::  %time:~0,8%  ::  - WARNING: Unsupported Python version 3.%PY_MINOR%, skipping triton installation
    echo  ::  %time:~0,8%  ::  - Full version string:
    python -c "import sys; print(sys.version)"
)

:: lets just assume triton has been installed, and patch it
pip install --force-reinstall pypatch-url --quiet
pypatch-url apply https://raw.githubusercontent.com/sfinktah/amd-torch/refs/heads/main/patches/triton-3.4.0+gita9c80202-cp311-cp311-win_amd64.patch -p 4 triton

echo  ::  %time:~0,8%  ::  - Installing flash-attention

%SystemRoot%\system32\curl.exe -sL --ssl-no-revoke https://github.com/user-attachments/files/20140536/flash_attn-2.7.4.post1-py3-none-any.zip > fa.zip
%SystemRoot%\system32\tar.exe -xf fa.zip
pip install flash_attn-2.7.4.post1-py3-none-any.whl --quiet
del fa.zip
del flash_attn-2.7.4.post1-py3-none-any.whl
copy comfy\customzluda\fa\distributed.py %VIRTUAL_ENV%\Lib\site-packages\flash_attn\utils\distributed.py /y >NUL

pip install --force-reinstall sageattention --quiet
echo  ::  %time:~0,8%  ::  - Patching sage-attention
copy comfy\customzluda\sa\quant_per_block.py %VIRTUAL_ENV%\Lib\site-packages\sageattention\quant_per_block.py /y >NUL
copy comfy\customzluda\sa\attn_qk_int8_per_block_causal.py %VIRTUAL_ENV%\Lib\site-packages\sageattention\attn_qk_int8_per_block_causal.py /y >NUL
copy comfy\customzluda\sa\attn_qk_int8_per_block.py %VIRTUAL_ENV%\Lib\site-packages\sageattention\attn_qk_int8_per_block.py /y >NUL

echo.
echo  ::  %time:~0,8%  ::  Custom node(s) installation ...
echo.
echo :: %time:~0,8%  ::  - Installing CFZ Nodes (description in readme on github)
copy cfz\cfz_patcher.py custom_nodes\cfz_patcher.py /y >NUL
copy cfz\cfz_cudnn.toggle.py custom_nodes\cfz_cudnn.toggle.py /y >NUL
copy cfz\cfz_vae_loader.py custom_nodes\cfz_vae_loader.py /y >NUL
echo  ::  %time:~0,8%  ::  - Installing Comfyui Manager

:: Step 13: Copy Python libs
xcopy /E /I /Y "%LocalAppData%\Programs\Python\Python3%PY_MINOR%\libs" "venv\libs"
set ERRLEVEL=%errorlevel%
if %ERRLEVEL% neq 0 (
    echo "Failed to copy Python3%PY_MINOR%\libs to virtual environment."
    exit /b %ERRLEVEL%
)

:: Step 13b: Check if HIP SDK exists, otherwise download and extract it
set "HIP_SDK_PARENT=%HIP_SDK_DIR%"
for %%A in ("%HIP_SDK_PARENT%\.") do set "HIP_SDK_PARENT=%%~dpA"
if "%HIP_SDK_PARENT:~-1%"=="\" set "HIP_SDK_PARENT=%HIP_SDK_PARENT:~0,-1%"
set "TEST_FILE=%HIP_SDK_PARENT%\__write_test__.tmp"
echo HIP_SDK_DIR: %HIP_SDK_DIR%
echo HIP_SDK_PARENT: %HIP_SDK_PARENT%
echo HIP_ZIP_PATH: %HIP_ZIP_PATH%
if not exist "%HIP_SDK_DIR%\bin\clang.exe" (
    echo HIP SDK not found at %HIP_SDK_DIR%.
    if exist "%HIP_ZIP_PATH%" (
        echo Using previously downloaded file: %HIP_ZIP_PATH%
    ) else (
        echo Attempting to download...
        curl -o "%HIP_ZIP_PATH%" "%HIP_ZIP_URL%"
        set ERRLEVEL=!errorlevel!
        if !ERRLEVEL! neq 0 (
            echo "Failed to download HIP SDK archive."
            exit /b !ERRLEVEL!
        )
        if not exist "%HIP_ZIP_PATH%" (
            echo "HIP SDK archive not found after download attempt."
            exit /b 1
        )
    )

    :: --- Check write permission to HIP_SDK_PARENT ---
    :check_hip_write
    echo Checking write access to: %HIP_SDK_PARENT%

    :: Create test file
    echo Checking to see if we have write access to the SDK directory by writing to %TEST_FILE%
    break > "%TEST_FILE%" 2>nul
    set ERRLEVEL=%errorlevel%

    if %ERRLEVEL% neq 0 (
        echo We couldn't write to %TEST_FILE%
    )

    :: Try modifying it
    if exist "%TEST_FILE%" (
        >> "%TEST_FILE%" echo test >>nul 2>nul
        set MODIFY_ERR=!errorlevel!
        del "%TEST_FILE%" >nul 2>&1
    )

    :: Check create permission
    if %ERRLEVEL% neq 0 (
        echo [ERROR] Could not create test file in %HIP_SDK_PARENT%.
        goto :request_admin_fix
    )

    :: Check modify permission
    if defined MODIFY_ERR (
        if !MODIFY_ERR! neq 0 (
            echo [ERROR] Could not write to test file in %HIP_SDK_PARENT%.
            goto :request_admin_fix
        )
    )

    echo Write access confirmed.
    goto :hip_access_ok

    :request_admin_fix
    echo.
    echo You do not have write access to:
    echo     %HIP_SDK_PARENT%
    echo.
    echo To fix this, open an **Admin Command Prompt** and run:
    echo     takeown /f "%HIP_SDK_PARENT%" /r /d y
    echo     icacls "%HIP_SDK_PARENT%" /grant "%USERNAME%:F" /t
    echo.
    pause
    goto check_hip_write

    :hip_access_ok
    :: --- Extract the HIP SDK using tar ---
    echo Extracting HIP SDK archive using tar...  tar -xf "%HIP_ZIP_PATH%" -C "%HIP_SDK_PARENT%"
    tar -xf "%HIP_ZIP_PATH%" -C "%HIP_SDK_PARENT%"
    set ERRLEVEL=%errorlevel%
    if not %ERRLEVEL%==0 (
        echo [ERROR] Failed to extract HIP SDK archive using tar.
        exit /b %ERRLEVEL%
    )

    if not exist "%HIP_SDK_DIR%\bin\clang.exe" (
        echo HIP SDK not found at %HIP_SDK_DIR%, which is annoying, since we just put it there.
        exit /b 1
    )
)


cd custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git --quiet
echo  ::  %time:~0,8%  ::  - Installing ComfyUI-deepcache
git clone https://github.com/styler00dollar/ComfyUI-deepcache.git --quiet
cd ..
echo.
echo  ::  %time:~0,8%  ::  - Patching ZLUDA
:: Download ZLUDA version 3.9.5 nightly
rmdir /S /Q zluda 2>nul
mkdir zluda
cd zluda
%SystemRoot%\system32\curl.exe -sL --ssl-no-revoke https://github.com/lshqqytiger/ZLUDA/releases/download/rel.5e717459179dc272b7d7d23391f0fad66c7459cf/ZLUDA-nightly-windows-rocm6-amd64.zip > zluda.zip
%SystemRoot%\system32\tar.exe -xf zluda.zip
del zluda.zip
cd ..
:: Patch DLLs
copy zluda\cublas.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cublas64_11.dll /y >NUL
copy zluda\cusparse.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cusparse64_11.dll /y >NUL
copy %VIRTUAL_ENV%\Lib\site-packages\torch\lib\nvrtc64_112_0.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\nvrtc_cuda.dll /y >NUL
copy zluda\nvrtc.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\nvrtc64_112_0.dll /y >NUL
copy zluda\cudnn.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cudnn64_9.dll /y >NUL
copy zluda\cufft.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cufft64_10.dll /y >NUL
copy zluda\cufftw.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cufftw64_10.dll /y >NUL
copy comfy\customzluda\zluda.py comfy\zluda.py /y >NUL

echo  ::  %time:~0,8%  ::  - ZLUDA 3.9.5 nightly patched for HIP SDK 6.2.4 with miopen and triton-flash attention.
echo.
set "endTime=%time: =0%"
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
echo .....................................................
echo *** Installation is completed in %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1% .
echo *** You can use "comfyui-n.bat" to start the app later.
echo *** It is advised to make a copy of "comfyui-n.bat" and modify it to your liking so when updating later it won't cause problems.
echo *** You can use -- "--use-pytorch-cross-attention" , "--use-quad-cross-attention" , "--use-flash-attention" or "--use-sage-attention"
echo .....................................................
echo.
