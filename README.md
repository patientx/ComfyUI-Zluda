ComfyUI
=======
Just a quick "edit" of comfyui for using with ZLUDA.

CREDITS ::::: comfyui , 
              the zluda wiki page for sdnext (https://github.com/vladmandic/automatic/wiki/ZLUDA) , brknsoul for rocm libraries (https://github.com/brknsoul/ROCmLibs) 
  (((WINDOWS)))
  
If coming from the very start, you need :

(1) Git                            ::: download from https://git-scm.com/download/win . 
    During installation don't forget to check the box for "Use Git from the Windows Command line and also from 3rd-party-software" to add Git to your system's PATH .
(2) Python (3.10.11 specifically)  ::: download from https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe . During installation
    During installation don't forget to check the box for "Add Python to PATH when you are at the the "Customize Python" screen.
(3) Visual C++ Runtime             ::: download from https://aka.ms/vs/17/release/vc_redist.x64.exe , install it.

*** (1) Download latest ZLUDA from : https://github.com/lshqqytiger/ZLUDA/releases (ZLUDA-windows-amd64.zip). Extract the archive to a folder.
  Add that folder with the files inside , to PATH :::
 
     (1) Click the Start button, type "env", click "Edit the system environment variables", then click the "Environment Variables" button at the bottom.
     (2) On the lower part (System Variables) , there is a variable called "Path" (might be a bit lower on the list , scroll down if necessary). 
         Click on it, click "Edit". Click "New". Add your zluda folder directory there for example : D:\ZLUDA . Click OK, OK. Done.

*** (2) You need install HIP SDK 5.7.1 from https://www.amd.com/en/developer/resources/rocm-hub/hip-sdk.html
      
     (1) Click the Start button, type "env", click "Edit the system environment variables", then click the "Environment Variables" button at the bottom.
     
     (2) Check the variables on the lower part (System Variables) , there should be a variable called : HIP_PATH . 
            IF there isn't, click the new button, name : HIP_PATH , value : C:\Program Files\AMD\ROCm\5.7\ (this is the default folder, if you installed it on another drive, change if necessary)
            
     (3) On the lower part (System Variables) , there is a variable called "Path" (might be a bit lower on the list , scroll down if necessary). 
         Click on it, click "Edit". Click "New". Add your %HIP_PATH% folder directory there such as : C:\Program Files\AMD\ROCm\5.7\bin . Click OK, OK. Done.

IF your amd gpu is above or equal to RX 6800 it is done so far, otherwise ;

    if you an AMD GPU below 6800 (6700,6600 etc.) , download the recommended library files for you gpu from : https://github.com/brknsoul/ROCmLibs/
    (For example for an RX6600 or its variants, you should get : https://github.com/brknsoul/ROCmLibs/blob/main/Optimised_ROCmLibs_gfx1032.7z)
    Go to folder C:\Program Files\AMD\ROCm\5.7\bin\rocblas , there would be a "library" folder, backup the files inside to somewhere else. 
    Open your downloaded optimized library archive and put them inside the library folder : "C:\Program Files\AMD\ROCm\5.7\bin\rocblas\library"

***** AFTER THESE INSTALLS ARE DONE REBOOT YOUR PC.  *****
***** AFTER THESE INSTALLS ARE DONE REBOOT YOUR PC.  *****
***** AFTER THESE INSTALLS ARE DONE REBOOT YOUR PC.  *****

  Modified the necessary files and requirements.txt to install the correct packages.
 
 ------------------------------------------------------
 **** If you already have a comfyui installation : ****
      Open a cmd prompt.
        Go to the comfyui folder. And execute those commands :
        For example if it is in "D:\comfyui" , enter :  
          
          cd /d D:\comfyui (press enter) 
          pip uninstall torch torchvision -y (press enter) 
          pip install torch==2.2.0 torchvision --index-url https://download.pytorch.org/whl/cu118 (press enter) 
           
  keep the cmd window open, do the next two steps then come back :
          
    (1) Only two files need some additions / changes , "cuda_malloc.py" and "comfy/model_management.py" .
          Get them from this repo and replace them with the files; "cuda_malloc.py" in main folder and  "model_management.py" under /comfy folder.
    
    (2) Open explorer , go to your ZLUDA folder, copy these three files into : " [comfyui folder]\venv\Lib\site-packages\torch\lib\ " (write over the original files)
       cublas.dll  , cusparse.dll , nvrtc.dll 
       Rename those three into these :
    "cublas.dll" to "cublas64_11.dll" , "cusparse.dll" to "cusparse64_11.dll" , "nvrtc.dll" to "nvrtc64_112_0.dll".

  now start the app with :
    python main.py

  The first run would take a few minutes, there won't any progress or indicator on the webui or cmd window, just wait. It creates some files for use with generation with your gpu. 
    
***** !!! This happens again if you change / update your display driver. !!! *****
  
  ----------------------------------------------
  **** For manual installation on windows : **** 
    Open a cmd prompt.
      git clone https://github.com/patientx/ComfyUI-Zluda.git
      cd ComfyUI-Zluda  
      pip install -r requirements.txt

   keep the cmd window open, do the next two steps then come back :

      We need to add change some files before going forward, Open explorer go to your ZLUDA folder, copy these three files into : " [comfyui folder]\venv\Lib\site-packages\torch\lib\ " (write over the original files)
       cublas.dll  , cusparse.dll , nvrtc.dll 
       Rename those three into these :
    "cublas.dll" to "cublas64_11.dll" , "cusparse.dll" to "cusparse64_11.dll" , "nvrtc.dll" to "nvrtc64_112_0.dll".

  now start the app with :
    python main.py

  The first run would take a few minutes, there won't any progress or indicator on the webui or cmd window, just wait. It creates some files for use with generation with your gpu. 
    
***** !!! This happens again if you change / update your display driver. !!! *****




      






