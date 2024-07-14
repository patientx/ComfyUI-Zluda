<h1># ComfyUI-ZLUDA</h1>

* Windows only version of comfyui which uses ZLUDA to get better performance with AMD GPUs.

<h2>## What's New ?</h2>

(06.25) :: Added auto updating to "start.bat" . Just run  ``` git pull ``` once the command prompt inside comfyui-zluda folder from now on it would auto update to latest version on startup.

(06.16) :: Due to comfyui's addition of torchaudio to its requirements, it is recommended to run install.bat once again for a clean overall update.

(06.10) :: Updated ZLUDA to the latest version. After pulling the latest version with "git pull" while inside the directory, please run "patchzluda.bat" to get to the latest zluda version. Note: You need to restart your pc and also please note that the database building will happen once more.

(06.03) :: Added onnxruntime package to autoinstall, it is required by some nodes. Added "Comfyui-deepcache" . It is very useful and can double your generation speed at a minimal loss when used properly. Here is an [example workflow](https://github.com/patientx/ComfyUI-Zluda/blob/master/deepcache-sample.json) and some explanation inside it.

(06.02) :: Updated "torch" to the latest version (2.3.0) , also added Comfyui-Impact-Pack auto install. It has a lot of important ease-of-use stuff for people coming from other sd-webuis. So it is recommended to run install.bat once again for a clean overall update.

(05.26) :: If you update after today [ ComfyUI Revision: 2211 [16a493a1] | Released on '2024-05-26' ] Please re-run install.bat , there is a new package needed to be installed and after that we would also need to reapply the necessary torch changes , so to do this the easy way , be sure to update with "git pull" inside the folder, just run install.bat , it will setup the necessary stuff once again.

(05.14) :: Please try the "stop gen." button on menu, it is supposed to stop generation immediately, not effecting any other incoming queue items. Report any problems.

(05.14) :: Added ComfyUI-Manager auto install. Recommended a must have (maybe the first of many?) custom node.


<details>
 <summary><h2>## CREDITS</h2></summary>
 
- comfyui (https://github.com/comfyanonymous/ComfyUI)
- Zluda wiki from sdnext (https://github.com/vladmandic/automatic/wiki/ZLUDA)
- brknsoul for rocm libraries (https://github.com/brknsoul/ROCmLibs)
- lshqqytiger (https://github.com/lshqqytiger/ZLUDA)
- LeagueRaINi (https://github.com/LeagueRaINi/ComfyUI)
- ComfyUI-Manager (https://github.com/ltdrdata/ComfyUI-Manager)
 </details>

<details open>
 <summary><h2>## DEPENDENCIES</h2></summary>

If coming from the very start, you need :

1. **Git** : download from https://git-scm.com/download/win .
	During installation don't forget to check the box for "Use Git from the Windows Command line and also from 3rd-party-software" to add Git to your system's PATH .

2. **Python** (3.10.11 or 3.11 from the official website) : Install latest release from python.org .  DON'T USE WINDOWS STORE VERSION. If you have that installed, uninstall and please install from python.org .
	  During installation don't forget to check the box for "Add Python to PATH when you are at the the "Customize Python" screen.

3. **Visual C++ Runtime** : download from https://aka.ms/vs/17/release/vc_redist.x64.exe , install it.

4. Install **HIP SDK 5.7.1** from https://www.amd.com/en/developer/resources/rocm-hub/hip-sdk.html (UPDATE: HIP 6.1.2 released now, but there are problems so no need to use that one please be careful about selecting the correct version, "Windows 10 & 11	5.7.1	HIP SDK"

5.  add the system variable HIP_PATH , value : C:\\Program Files\\AMD\\ROCm\\5.7\\ (this is the default folder, if you installed it on another drive, change if necessary)

- 	1. Check the variables on the lower part (System Variables) , there should be a variable called : HIP_PATH .
- 	2. Also check the variables on the lower part (System Variables) , there should be a variable called : "Path".	   Double click it and click "New" add this : C:\Program Files\AMD\ROCm\5.7\bin
	
6. If you an AMD GPU below 6800 (6700,6600 etc.) , download the recommended library files for you gpu from : https://github.com/brknsoul/ROCmLibs/

- 	1. Go to folder C:\Program Files\AMD\ROCm\5.7\bin\rocblas , there would be a "library" folder, backup the files inside to somewhere else.
- 	2. Open your downloaded optimized library archive and put them inside the library folder (overwriting if necessary) : "C:\\Program Files\\AMD\\ROCm\\5.7\\bin\\rocblas\\library"

7. Reboot you system.
</details>

<h2>## SETUP (FOR WINDOWS ONLY)</h2>

Open a cmd prompt. 

```bash
git clone https://github.com/patientx/ComfyUI-Zluda
```
```bash
cd ComfyUI-Zluda
```
```bash
install.bat
```
to start for later use (or create a shortcut to) :
```bash
start.bat
```
also for later when you need to repatch zluda (maybe a torch update etc.) you can use :
```bash
patchzluda.bat
```
- The first generation would take around 10-15 minutes, there won't any progress or indicator on the webui or cmd window, just wait. Zluda creates a database for use with generation with your gpu.

 ** !!! This might happen with torch changes , zluda version changes and / or gpu driver changes. !!! **

<h2>## TROUBLESHOOTING</h2>

- wipe your pip cache ( C:\Users\[your windows username]\AppData\Local\pip\cache )
  You can also do this when venv is active with : ``` pip cache purge ```
  
- ```xformers``` isn't usable with zluda so any nodes / packages that require it doesn't work. ```Flash attention``` doesn't work. And lastly using ```codeformer``` for face restoration gives "Failed inference: CUDA driver error: unknown error" You should use gfpgan / gpen / restoreformer or other face restoration models.
  
- have the latest drivers installed for your amd gpu. ALSO REMOVE ANY NVIDIA DRIVERS you might have from previous nvidia gpu's.
- if you see zluda errors make sure these three files are inside "ComfyUI-Zluda\venv\Lib\site-packages\torch\lib\" 
   cublas64_11.dll (196kb) cusparse64_11.dll (193kb) nvrtc64_112_0.dll (125kb)
  If they are there but bigger files run : ``` patchzluda.bat ```
- if for some reason you can't solve with these and want to start from zero, delete "venv" folder and re-run ``` install.bat ```
- If you can't git pull to the latest version , run these commands, ``` git fetch --all ``` and then ``` git reset --hard origin/master ``` now you can git pull
- Problems with "caffe2_nvrtc.dll" : if you are sure you properly installed hip and can see it on path, please DON'T use python from windows store, use the link provided or 3.11 from the official website. After uninstalling python from windows store and installing the one from the website, be sure the delete venv folder, and run install.bat once again.
- If you have a rx 480 / rx 580 or one of their variants / lower cousins, and you get this error ; ``` For debugging consider passing CUDA_LAUNCH_BLOCKING=1. Compile with TORCH_USE_CUDA_DSA to enable device-side assertions ``` then run the ``` fixforrx580.bat ``` . It downgrades torch / torchvision and torchaudio to known working lower versions for that cards.
- If you have the correct setup zluda is working, device is showing correctly yet generation stops @ 1st step without any errors, try deleting the zluda cache file ``` C:\Users\[your username]\AppData\Local\ZLUDA\ComputeCache ``` and rebuilding it (by trying to generate once again).
