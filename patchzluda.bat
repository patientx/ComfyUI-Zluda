@Echo off
rmdir /S /q zluda
curl -s -L https://github.com/lshqqytiger/ZLUDA/releases/download/rel.2804604c29b5fa36deca9ece219d3970b61d4c27/ZLUDA-windows-amd64.zip > zluda.zip
tar -xf zluda.zip
del zluda.zip
copy zluda\cublas.dll venv\Lib\site-packages\torch\lib\cublas64_11.dll /y
copy zluda\cusparse.dll venv\Lib\site-packages\torch\lib\cusparse64_11.dll /y
copy zluda\nvrtc.dll venv\Lib\site-packages\torch\lib\nvrtc64_112_0.dll /y
cd ..
echo.
@echo zluda patched.
