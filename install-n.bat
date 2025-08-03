@echo off

title ComfyUI-Zluda Installer

set ZLUDA_COMGR_LOG_LEVEL=1
setlocal EnableDelayedExpansion
set "startTime=%time: =0%"

cls
echo ---------------------------------------------------------------
Echo * COMFYUI-ZLUDA INSTALL (for HIP 6.2.4 with MIOPEN and Triton)*
echo ---------------------------------------------------------------
echo.
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
echo  ::  %time:~0,8%  ::  - Installing required packages
pip install --force-reinstall --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu118 --quiet
pip install -r requirements.txt --quiet
echo  ::  %time:~0,8%  ::  - Installing torch for AMD GPUs (First file is 2.7 GB, please be patient)
echo  ::  %time:~0,8%  ::  - Installing onnxruntime (required by some nodes)
pip install onnxruntime --quiet
echo  ::  %time:~0,8%  ::  - (temporary numpy fix)
pip uninstall numpy -y --quiet
pip install numpy==1.26.4 --quiet

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

:: patching triton
pip install --force-reinstall pypatch-url --quiet
pypatch-url apply https://raw.githubusercontent.com/sfinktah/amd-torch/refs/heads/main/patches/triton-3.4.0+gita9c80202-cp311-cp311-win_amd64.patch -p 4 triton
pypatch-url apply https://raw.githubusercontent.com/sfinktah/amd-torch/refs/heads/main/patches/torch-2.7.0+cu118-cp311-cp311-win_amd64.patch -p 4 torch

echo  ::  %time:~0,8%  ::  - Installing flash-attention

%SystemRoot%\system32\curl.exe -sL --ssl-no-revoke https://github.com/user-attachments/files/20140536/flash_attn-2.7.4.post1-py3-none-any.zip > fa.zip
%SystemRoot%\system32\tar.exe -xf fa.zip
pip install flash_attn-2.7.4.post1-py3-none-any.whl --quiet
del fa.zip
del flash_attn-2.7.4.post1-py3-none-any.whl
copy comfy\customzluda\fa\distributed.py %VIRTUAL_ENV%\Lib\site-packages\flash_attn\utils\distributed.py /y >NUL

echo  ::  %time:~0,8%  ::  - Installing and patching sage-attention
pip install sageattention --quiet
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
.\zluda\zluda.exe -- python main.py --auto-launch --use-quad-cross-attention

