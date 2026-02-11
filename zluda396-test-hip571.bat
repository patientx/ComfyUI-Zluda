echo :: ZLUDA version 3.9.6 patcher (for hip 5.7.1) ::
rmdir /S /Q zluda 2>nul
%SystemRoot%\system32\curl.exe -sL --ssl-no-revoke https://github.com/lshqqytiger/ZLUDA/releases/download/rel.854c58e1565c3597e17046d7cc2b1eab96fcdf55/ZLUDA-windows-rocm5-amd64.zip > zluda.zip
%SystemRoot%\system32\tar.exe -xf zluda.zip
del zluda.zip
echo :: Patch DLLs ::
copy zluda\cublas.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cublas64_11.dll /y
copy zluda\cusparse.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cusparse64_11.dll /y
copy %VIRTUAL_ENV%\Lib\site-packages\torch\lib\nvrtc64_112_0.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\nvrtc_cuda.dll /y
copy zluda\nvrtc.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\nvrtc64_112_0.dll /y
copy zluda\cufft.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cufft64_10.dll /y
copy zluda\cufftw.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cufftw64_10.dll /y
echo :: Zluda 3.9.6 installed. ::
pause