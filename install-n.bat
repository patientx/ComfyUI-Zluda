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
pip install --force-reinstall --pre torch torchvision torchaudio numpy==1.*
echo  ::  %time:~0,8%  ::  - Installing required packages
:: because we have already installed torch, pip should consider it already installed
pip install -r requirements.txt --quiet
echo  ::  %time:~0,8%  ::  - Installing onnxruntime (required by some nodes)
pip install onnxruntime --quiet
echo  ::  %time:~0,8%  ::  - (temporary numpy fix)
pip install --force-reinstall numpy==1.*

echo  ::  %time:~0,8%  ::  - Detecting Python version and installing appropriate triton package

for /f "tokens=1,2 delims=." %%a in ('python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"') do (
    set "PY_MAJOR=%%a"
    set "PY_MINOR=%%b"
    goto :version_detected
)

:version_detected
echo  ::  %time:~0,8%  ::  - Detected Python %PY_MAJOR%.%PY_MINOR%

if "%PY_MINOR%"=="12" (
    echo  ::  %time:~0,8%  ::  - Python 3.12 detected, installing triton for 3.12
    pip install --force-reinstall https://github.com/lshqqytiger/triton/releases/download/a9c80202/triton-3.4.0+gita9c80202-cp312-cp312-win_amd64.whl
) else if "%PY_MINOR%"=="11" (
    echo  ::  %time:~0,8%  ::  - Python 3.11 detected, installing triton for 3.11
    pip install --force-reinstall https://github.com/lshqqytiger/triton/releases/download/a9c80202/triton-3.4.0+gita9c80202-cp311-cp311-win_amd64.whl
) else (
    echo  ::  %time:~0,8%  ::  - WARNING: Unsupported Python version 3.%PY_MINOR%, skipping triton installation
    echo  ::  %time:~0,8%  ::  - Full version info:
    python -c "import sys; print(f'Python {sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}')"
)

:: patching triton & torch (from sfinktah ; https://github.com/sfinktah/amd-torch )
pip install --force-reinstall pypatch-url --quiet
pypatch-url apply https://raw.githubusercontent.com/sfinktah/amd-torch/refs/heads/main/patches/triton-3.4.0+gita9c80202-cp311-cp311-win_amd64.patch -p 4 triton

echo  ::  %time:~0,8%  ::  - Installing flash-attention

%SystemRoot%\system32\curl.exe -sL --ssl-no-revoke https://github.com/user-attachments/files/20140536/flash_attn-2.7.4.post1-py3-none-any.zip > fa.zip
%SystemRoot%\system32\tar.exe -xf fa.zip
pip install flash_attn-2.7.4.post1-py3-none-any.whl --quiet
del fa.zip
del flash_attn-2.7.4.post1-py3-none-any.whl
copy comfy\customzluda\fa\distributed.py %VIRTUAL_ENV%\Lib\site-packages\flash_attn\utils\distributed.py /y >NUL

echo  ::  %time:~0,8%  ::  - Installing and patching sage-attention
pip install --force-reinstall pypatch-url sageattention braceexpand --quiet
echo  ::  %time:~0,8%  ::  - Patching sage-attention
pypatch-url apply https://raw.githubusercontent.com/sfinktah/amd-torch/refs/heads/main/patches/sageattention-1.0.6+sfinktah+env-py3-none-any.patch -p 4 sageattention

echo.
echo  ::  %time:~0,8%  ::  Custom node(s) installation ...
echo. 
echo :: %time:~0,8%  ::  - Installing CFZ Nodes (description in readme on github) 
copy cfz\cfz_patcher.py custom_nodes\cfz_patcher.py /y >NUL
copy cfz\cfz_cudnn.toggle.py custom_nodes\cfz_cudnn.toggle.py /y >NUL
copy cfz\cfz_vae_loader.py custom_nodes\cfz_vae_loader.py /y >NUL
echo  ::  %time:~0,8%  ::  - Installing Comfyui Manager
cd custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git --quiet
echo  ::  %time:~0,8%  ::  - Installing ComfyUI-deepcache
git clone https://github.com/styler00dollar/ComfyUI-deepcache.git --quiet
cd ..

echo  ::  %time:~0,8%  ::  - Copying python libs
xcopy /E /I /Y "%LocalAppData%\Programs\Python\Python3%PY_MINOR%\libs" "venv\libs"
set ERRLEVEL=%errorlevel%
if %ERRLEVEL% neq 0 (
    echo "Failed to copy Python3%PY_MINOR%\libs to virtual environment."
    exit /b %ERRLEVEL%
)

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
echo *** Starting the Comfyui-ZLUDA for the first time, please be patient...
echo.
set FLASH_ATTENTION_TRITON_AMD_ENABLE=TRUE
set MIOPEN_FIND_MODE=2
set MIOPEN_LOG_LEVEL=3
.\zluda\zluda.exe -- python main.py --auto-launch --use-sage-attention



