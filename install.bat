@echo off
title ComfyUI-Zluda Installer
cls
echo -----------------------------------------------------
Echo *************** COMFYUI-ZLUDA INSTALL ***************
echo -----------------------------------------------------
echo.
echo *** Setting up the virtual enviroment
Set "VIRTUAL_ENV=venv"
echo .....................................................
If Not Exist "%VIRTUAL_ENV%\Scripts\activate.bat" (
    python.exe -m venv %VIRTUAL_ENV%
)

If Not Exist "%VIRTUAL_ENV%\Scripts\activate.bat" Exit /B 1

echo *** Virtual enviroment activation
Call "%VIRTUAL_ENV%\Scripts\activate.bat"
echo .....................................................
echo *** Updating the pip package 
python.exe -m pip install --upgrade pip --quiet
echo .....................................................
echo *** Installing required packages
pip install -r requirements.txt
echo ..................................................... 
echo *** Installing torch for AMD GPUs (First file is 2.7 GB, please be patient)
echo.
pip uninstall torch torchvision -y
pip install torch==2.3.0 torchvision --index-url https://download.pytorch.org/whl/cu118
echo .....................................................
echo *** Installing Comfyui Manager
echo.
cd custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
echo ..................................................... 
echo *** Installing ComfyUI-Impact-Pack
echo.
git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
cd ComfyUI-Impact-Pack
git clone https://github.com/ltdrdata/ComfyUI-Impact-Subpack impact_subpack
cd ..
cd ..
echo ..................................................... 
echo *** "Patching ZLUDA"
echo.
rmdir /S /q zluda
curl -s -L https://github.com/lshqqytiger/ZLUDA/releases/download/rel.11cc5844514f93161e0e74387f04e2c537705a82/ZLUDA-windows-amd64.zip > zluda.zip
tar -xf zluda.zip
del zluda.zip
copy zluda\cublas.dll venv\Lib\site-packages\torch\lib\cublas64_11.dll /y
copy zluda\cusparse.dll venv\Lib\site-packages\torch\lib\cusparse64_11.dll /y
copy zluda\nvrtc.dll venv\Lib\site-packages\torch\lib\nvrtc64_112_0.dll /y
echo.
@echo  *ZLUDA is patched. *
echo.
echo ..................................................... 
echo *** Installation is done. You can use "start.bat" to start the app later. 
echo .....................................................
echo.
echo *** For now app is going to start for the first time.
echo.
.\zluda\zluda.exe -- python main.py --auto-launch
