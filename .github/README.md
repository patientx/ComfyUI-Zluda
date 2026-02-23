<div align="center">

# ComfyUI-ZLUDA

Windows-only version of ComfyUI which uses ZLUDA to get better performance with AMD GPUs.

</div>

*** Comfyui now has proper AMD GPU support on windows for select GPU's. (namely RDNA3 and RDNA4 ; aka 7000 series and 9000 series) If you have one of those you can follow comfy's own guides to install and use them, you don't need zluda to use your gpu with windows. (Of course it still works with the setup below , just informing the users here that another newer option is available). Now , regarding RDNA2 aka 6000 series, up until a few days ago, there wasn't proper rocm and pytorch builds for RDNA2 available on windows. BUT first I built them myself a few days ago and just after that AMD themselves decided to finally build them daily just like 7000s and 9000s, for the time being these official builds aren't RELEASED YET so if you are an 6000 series owner (GFX103x or RNDA2) you can check this thread (with my rocm & pytorch builds for rdna2) https://github.com/patientx/ComfyUI-Zluda/issues/435 for how to setup rocm & pytorch so you can use your gpu on windows WITHOUT ZLUDA. (This repo is mainly for zluda so these guides etc are not on the frontpage. I just put them there since people have been asking about them a lot lately.) ***

<details>
<summary><strong>FOR THOSE THAT ARE GETTING TROJAN DETECTIONS IN NCCL.DLL IN ZLUDA FOLDER</strong></summary>

In the developer's words: "nccl.dll is a dummy file, it does nothing. When one of its functions is called, it will just return 'not supported' status. nccl.dll and cufftw.dll are dummy files introduced only for compatibility (to run applications that reject to start without them, but rarely or never use them).

zluda.exe hijacks Windows API and injects some DLLs. Its behavior can be considered malicious by some antiviruses, but it does not hurt the user.

The antiviruses, including Windows Defender on my computer, didn't detect them as malicious when I made the nightly build. But somehow the nightly build is now detected as a virus on my end too."

**SOLUTION: IGNORE THE WARNING AND EXCLUDE THE ZLUDA (or better the whole comfyui-zluda) FOLDER FROM DEFENDER.**
</details>

<details>
<summary><strong>What's New? (07-01-2026)</strong> [:: simpler cfz-cudnn node added ::] </summary>

### Recent Updates

 Added a simple "cfz-cudnn" node to the cfz-caching nodes. It is able to connect to ANY node AND can work without outputting to anything so it can be used like this for example (just to make vae work) :

 <img width="842" height="255" alt="image" src="https://github.com/user-attachments/assets/085848e6-814a-4c28-9b79-356e50ad57c1" />

In this example we disable cudnn just for vae decoding and enable it after , without connecting the node to image (we could do it but just showing how it can work) 

- Our friend sfinktah's impressive solution for automatically enabling-disabling cudnn on comfyui, the "ovum-cudnn-wrapper" node is now automatically installed when install-n is used. Be sure to go to the node's github page and give him a star. "[https://github.com/sfinktah/ovum-cudnn-wrapper](https://github.com/sfinktah/ovum-cudnn-wrapper]" . Also adding a new "wan 2.2 i2v workflow" based on kijai's excellent wan wrapper node pack into the cfz/workflows folder, try it and of course you can remove the image input and just use it as a t2v as well (with correct loras for that). Please read the nodes carefully, 

- **Changed node storage folder and added CFZ-Condition-Caching node. This allows you to save-load conditionings -prompts basically- it helps on two fronts, if you are using same prompts over and over it skips the clip part AND more importantly it skips loading clip model all together, giving you more memory to load other stuff, main model being the most important. (It is based on this nodepack, [https://github.com/alastor-666-1933/caching_to_not_waste](https://github.com/alastor-666-1933/caching_to_not_waste))

<img width="1292" height="979" alt="Screenshot 2025-09-02 182907" src="https://github.com/user-attachments/assets/e7ab712b-4adc-426a-932a-acd0e49a30e0" />

* I also uploaded an example workflow on how to use the nodes in your workflows. It is not fully working, and it is there to an idea how to incorporate to your workflows.

- **Added "cfz-vae-loader" node** to CFZ folder - enables changing VAE precision on the fly without using `--fp16-vae` etc. on the starting command line. This is important because while "WAN" works faster with fp16, Flux produces black output if fp16 VAE is used. Start ComfyUI normally and add this node to your WAN workflow to change it only with that model type.

- **Use update.bat** if comfyui.bat or comfyui-n.bat can't update (as when they are the files that need to be updated, so delete them, run update.bat). When you run your comfyui(-n).bat afterwards, it now copies correct ZLUDA and uses that.

- **Updated included ZLUDA version** for the new install method to 3.9.5 nightly (latest version available). You MUST use latest AMD GPU drivers with this setup otherwise there would be problems later (drivers >= 25.5.1).

### New Nodes

- **Added "CFZ Cudnn Toggle" node** - for some models not working with cuDNN (which is enabled by default on new install method). To use it:
  - Connect it before KSampler (latent_image input or any latent input)
  - Disable cuDNN
  - After VAE decoding (where most problems occur), re-enable cuDNN
  - Add it after VAE decoding, select audio_output and connect to save audio node
  - Enable cuDNN now

- **"CFZ Checkpoint Loader" was completely redone** - the previous version was broken and might corrupt models if you loaded with it and quit halfway. The new version works outside checkpoint loading, doesn't touch the original file, and when it quantizes the model, it makes a copy first. 
  - Please delete "cfz_checkpoint_loader.py" and use the newly added "cfz_patcher.py"
  - It has three separate nodes and is much safer and better

**Note**: Both nodes are inside the "cfz" folder. To use them, copy them into custom_nodes - they will appear next time you open ComfyUI. To find them, search for "cfz".

### Model Fixes

- **Florence2 is now fixed** (probably some other nodes too) - you need to disable "do_sample", meaning change it from True to False. Now it works without needing to edit its node.

### Custom ZLUDA Versions

- **Added support for any ZLUDA version** - to use with HIP versions you want (such as 6.1 - 6.2). After installing:
  1. Close the app
  2. Run `patchzluda2.bat`
  3. It will ask for URL of the ZLUDA build you want to use
  4. Choose from [lshyqqtiger's ZLUDA Fork](https://github.com/lshqqytiger/ZLUDA/releases)
  5. Paste the link via right-click (correct link example: `https://github.com/lshqqytiger/ZLUDA/releases/download/rel.d60bddbc870827566b3d2d417e00e1d2d8acc026/ZLUDA-windows-rocm6-amd64.zip`)
  6. Press enter and it will patch that ZLUDA into ComfyUI for you

### Documentation

- **Added a "Small Flux Guide"** - aims to use low VRAM and provides the basic necessary files needed to get Flux generation running. [View Guide](fluxguide.md)

</details>

## Pre-Requisites

* GIT, available from [https://git-scm.com/download/win](https://git-scm.com/download/win). During installation don't forget to check the box for "Use Git from the Windows Command line and also from 3rd-party-software" to add Git to your system's PATH.
* Python 3.11.9 or higher (3.12 is a minimum for using Triton), available from [https://www.python.org/downloads/windows/](https://www.python.org/downloads/windows/) (*The Microsoft Store version will not work.*). Make sure you check the box for "Add Python to PATH when you are at the "Customize Python" screen.
* Visual C++ Runtime Library, available from [https://aka.ms/vs/17/release/vc_redist.x64.exe](https://aka.ms/vs/17/release/vc_redist.x64.exe)
* Visual Studio Build Tools, available from [https://aka.ms/vs/17/release/vs_BuildTools.exe](https://aka.ms/vs/17/release/vs_BuildTools.exe)

## Installation (Windows-Only)
### Important Note
**DON'T INSTALL** into your user directory or inside Windows or Program Files directories. Don't install to a directory with Non-English characters. Best option is to install to the root directory of whichever drive you'd like.

<details>
<summary><strong>For Old Ryzen APU's, RX400-500 Series GPU's (HIP 5.7.1)</strong></summary>

Note: You *might* need older drivers for sdk 5.7.1 and old ZLUDA to work so if you are getting errors with latest drivers please install an older version (below 25.5.1) 

1. Install HIP SDK 5.7.1 from "[https://www.amd.com/en/developer/resources/rocm-hub/hip-sdk.html](https://www.amd.com/en/developer/resources/rocm-hub/hip-sdk.html)", "Windows 10 & 11 5.7.1 HIP SDK"

2. Make the following changes to your system environment variables (instructions [here](https://imatest.atlassian.net/wiki/spaces/KB/pages/12049809418/Editing+System+Environment+Variables)):

  * Add entries for `HIP_PATH` and `HIP_PATH_57` to your System Variables (not user variables), both should have this value: `C:\Program Files\AMD\ROCm\5.7\`
  * Check the PATH system variable and ensure that `C:\Program Files\AMD\ROCm\5.7\bin` is in the list. If not, add it.
  * Make sure the system variables HIP_PATH and HIP_PATH_57 exist, both should have this value: `C:\Program Files\AMD\ROCm\5.7\`

3. Get library files for your GPU from Brknsoul Repository (for HIP 5.7.1) [https://github.com/brknsoul/ROCmLibs](https://github.com/brknsoul/ROCmLibs) or [https://www.mediafire.com/file/boobrm5vjg7ev50/rocBLAS-HIP5.7.1-win%2528old_gpu%2529.rar/fil`](https://www.mediafire.com/file/boobrm5vjg7ev50/rocBLAS-HIP5.7.1-win%2528old_gpu%2529.rar/file)

* Go to folder `C:\Program Files\AMD\ROCm\5.7\bin\rocblas`, look for a "library" folder, backup the files inside to somewhere else.

* Open your downloaded optimized library archive and put them inside the library folder (overwriting if necessary): `C:\Program Files\AMD\ROCm\5.7\bin\rocblas\library`

* There could be a rocblas.dll file in the archive as well, if it is present then copy it inside `C:\Program Files\AMD\ROCm\5.7\bin`

4. Restart your system.

5. Open a cmd prompt. Easiest way to do this is, in Windows Explorer go to the folder or drive you want to install this app to, in the address bar type "cmd" and press enter.

6. Copy these commands one by one and press enter after each one:

```bash
git clone -b pre24patched https://github.com/patientx/ComfyUI-Zluda 
```

```bash
cd ComfyUI-Zluda
```

```bash
install-for-older-amd.bat
```

* You can use `comfyui.bat` or put a shortcut of it on your desktop, to run the app later. My recommendation is make a copy of `comfyui.bat` with another name maybe and modify that copy so when updating you won't get into trouble.
</details>

<details>
<summary><strong>For AMD GPU VEGA through 6700</strong> (HIP 6.2.4)</summary>

  **IMPORTANT**: With this install method you MUST make sure you have the latest GPU drivers (specifically you need drivers above 25.5.1)

The GPUs listed below should have HIP 6.4.2 drivers available (though they have not been tested, and some may not work with the newer triton-miopen stuff). If you are updating from 6.2.4 to 6.4.2, remember to **uninstall 6.2.4 and then delete the ROCm directory from your Program Files folder** otherwise there may be problems even after uninstalling.

| **Card Type**  | **Model Numbers** | **gfx code** |
| ------------- | ------------- | ------------- |
| AMD Radeon  | RX 5500XT  | gfx1012 |
| AMD Radeon  | RX 5700XT | gfx1010 |
| AMD Radeon  | Pro 540  | gfx1011 |
| AMD Radeon  | RX 6500, 6500XT, 6500M, 6400, 6300, 6450, W6400 | gfx1034 |
| AMD Radeon  | RX 6600/6600XT  | gfx1032 |
| AMD Radeon  | RX 6700/6700XT  | gfx1031 |
| **Mobile and Integrated** |  |  |
| AMD Radeon  | RX 780M/ 740M / Ryzen Z1  | gfx1103 |
| AMD Radeon  | RX 660M / 680M  | gfx1035 |
| AMD Radeon Graphics | 128SP (All 7000 series IGP Variants) | gfx1036 |

* [There is a legacy installer method still available with `install-legacy.bat` (this is the old "install.bat") which doesn't include miopen-triton stuff, but I strongly recommend a standard install, since we have solved most of the problems with these GPUs. If you want you can still install hip 5.7.1 and use the libraries for your gpu for hip 5.7.1 or 6.2.4 and you don't need to install miopen stuff. You can use the `install-legacy.bat` but first try the install-n.bat if you have problems than go back to the legacy one.]

1 Install HIP SDK 6.2.4 from [AMD ROCm Hub](https://www.amd.com/en/developer/resources/rocm-hub/hip-sdk.html) - "Windows 10 & 11 6.2.4 HIP SDK"

2. Make the following changes to your system environment variables (instructions [here](https://imatest.atlassian.net/wiki/spaces/KB/pages/12049809418/Editing+System+Environment+Variables)):

* Add entries for `HIP_PATH` and `HIP_PATH_62` to your System Variables (not user variables), both should have this value: `C:\Program Files\AMD\ROCm\6.2\`

* Check the PATH system variable and ensure that `C:\Program Files\AMD\ROCm\6.2\bin` is in the list. If not, add it.

3. Download this addon package from [Google Drive](https://drive.google.com/file/d/1Gvg3hxNEj2Vsd2nQgwadrUEY6dYXy0H9/view?usp=sharing) (or [alternative source](https://www.mediafire.com/file/ooawc9s34sazerr/HIP-SDK-extension(zluda395).zip/file))

* Extract the addon package into `C:\Program Files\AMD\ROCm\6.2` overwriting files if asked

* Get library files for your GPU from [likelovewant Repository](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU/releases/tag/v0.6.2.4) (for HIP 6.2.4)

* Go to folder `C:\Program Files\AMD\ROCm\6.2\bin\rocblas`, there should be a "library" folder. **Backup the files inside to somewhere else.**

* Open your downloaded optimized library archive and put them inside the library folder (overwriting if necessary): `C:\Program Files\AMD\ROCm\6.2\bin\rocblas\library`

* If there's a `rocblas.dll` file in the archive, copy it inside `C:\Program Files\AMD\ROCm\6.2\bin`

4. **Restart your system**

5. Open a command prompt. Easiest way: in Windows Explorer, go to the folder or drive where you want to install this app, in the address bar type "cmd" and press enter

* Copy these commands one by one and press enter after each:

```bash
git clone https://github.com/patientx/ComfyUI-Zluda
```

```bash
cd ComfyUI-Zluda
```

```bash
install-n.bat
```
</details>

<details>
<summary><strong>For AMD GPU 6800 and above (Including 7000 and 9000 series)</strong></summary>
**IMPORTANT**
-  With this install method you MUST make sure you have the latest GPU drivers (specifically above 25.5.1)

1. Install HIP SDK 6.4.2 from [AMD ROCm Hub](https://www.amd.com/en/developer/resources/rocm-hub/hip-sdk.html) - "Windows 10 & 11 6.4.2 HIP SDK"

2. Make the following changes to your system environment variables (instructions [here](https://imatest.atlassian.net/wiki/spaces/KB/pages/12049809418/Editing+System+Environment+Variables)):

* Add entries for `HIP_PATH` and `HIP_PATH_64` to your System Variables (not user variables), both should have this value: `C:\Program Files\AMD\ROCm\6.4\`

* Check the PATH system variable and ensure that `C:\Program Files\AMD\ROCm\6.4\bin` is in the list. If not, add it.

3. **Restart your system**

4. Open a command prompt. Easiest way: in Windows Explorer, go to the folder or drive where you want to install this app, in the address bar type "cmd" and press enter

* Copy these commands one by one and press enter after each:

```bash
git clone https://github.com/patientx/ComfyUI-Zluda
```

```bash
cd ComfyUI-Zluda
```

```bash
install-n.bat
```

IF YOUR GPU IS NOT LISTED AS SUPPORTED BY HIP 6.4.2:

* Get library files for your GPU from [6.4.2 Libraries for unsupported GPU's](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU/releases/tag/v0.6.4.2) (for HIP 6.4.2)
* Go to folder `C:\Program Files\AMD\ROCm\6.4\bin\rocblas`, there should be a "library" folder. **Backup the files inside to somewhere else.**
* Open your downloaded optimized library archive and put them inside the library folder (overwriting if necessary): `C:\Program Files\AMD\ROCm\6.4\bin\rocblas\library`
* If there's a `rocblas.dll` file in the archive, copy it inside `C:\Program Files\AMD\ROCm\6.4\bin`

</details>

## First-Time Launch
* If you have done every previous step correctly, it will install without errors and start ComfyUI-ZLUDA for the first time. If you already have checkpoints copy them into your `models/checkpoints` folder so you can use them with ComfyUI's default workflows. You can use [ComfyUI's Extra Model Paths YAML file](https://docs.comfy.org/development/core-concepts/models) to specify custom folders.

* The first generation will take longer than usual, ZLUDA is compiling for your GPU, it does this once for every new model type. This is necessary and unavoidable.
* To run in the future, run `comfyui-n.bat` (unless you are on an Older GPU, in which case run `comfyui.bat`.
* You can add custom settings to `comfyui-user.bat` which will not get overwritten during software updates.

## Updating ComfyUI-ZLUDA
* Everytime comfyui.bat is run, it automatically updates to the latest ZLUDA-compatible version.  Using ComfyUI's Software Update may break your installation. Always either depend on the launcher batch file or do a new `git pull`
* Only use ComfyUI-Manager to update the extensions (Manager -> Custom Nodes Manager -> Set Filter To Installed -> Click Check Update On The Bottom Of The Window)

## Troubleshooting
### Incompatibilities
- DO NOT use non-english characters as folder names to put comfyui-zluda under.
- `xformers` isn't usable with zluda so any nodes / packages that require it doesn't work.
- Make sure you do not have any residual NVidia graphics drivers instlled on your system.
  
### Common Error Messages
- `module 'torch.compiler' has no attribute 'is_compiling'` error, add `--disable-async-offload` to the launcher batch file. (this is now added by default to both bat files, you can try without it and if that works for you, all is good.) (thanks https://github.com/nota-rudveld)
aster` now you can git pull
-  `caffe2_nvrtc.dll`-related errors: if you are sure you properly installed hip and can see it on path, please DON'T use python from windows store, use the link provided or 3.11 from the official website. After uninstalling python from windows store and installing the one from the website, be sure the delete venv folder, and run install.bat once again.
- `RuntimeError: GET was unable to find an engine to execute this computation` or `RuntimeError: FIND was unable to find an engine to execute this computation` in the vae decoding stage, please use CFZ CUDNN Toggle node between ksampler latent and vae decoding. And leave the enable_cudnn setting "False" , this persists until you close the comfyui from the commandline for the rest of that run. So you won't see this error again.

<img width="667" height="350" alt="Screenshot 2025-08-25 123335" src="https://github.com/user-attachments/assets/db56d460-34aa-4fda-94e2-f0bae7162691" />

That node can actually be used between conditioning or image loading etc so it's not only usable between latent and vae decoding , also you can use it in a simple workflow that it makes the setting disabled , than you can use any other workflow for the rest of the instance without worry. (try running the  [1step-cudnn-disabler-workflow](https://github.com/patientx/ComfyUI-Zluda/blob/master/cfz/workflows/1step-cudnn-disabler-workflow.json) in cfz folder once after you start comfyui-zluda, it can use any sd15 or sdxl model it would just generate 1 step image than preview it so no saving) after that workflow runs once, switch to any workflow or start a new one.

### Triton-related Errors
- Remove visual studio 2022 (if you have already installed it and getting errors) and install "https://aka.ms/vs/17/release/vs_BuildTools.exe" , and then use  "Developer Command Prompt" to run comfyui. This option shouldn't be needed for many but nevertheless try.
- `RuntimeError: CUDNN_BACKEND_OPERATIONGRAPH_DESCRIPTOR: cudnnFinalize FailedmiopenStatusInternalError cudnn_status: miopenStatusUnknownError` , if this is encountered at the end, while vae-decoding, use tiled-vae decoding either from official comfy nodes or from Tiled-Diffussion (my preference). Also vae-decoding is overall better with tiled-vae decoding. 
* Note for 7900XT users: If running comfyui-n or comfyui-user terminates in the middle of the triton kernel test, follow the instructions in this bug: https://github.com/patientx/ComfyUI-Zluda/issues/384#issuecomment-3619519443
  
### Resetting An Installation and Clearing Caches
- If for some reason you can't solve with these and want to start from zero, delete "venv" folder and re-run the whole setup again step by step.
- Wipe your pip cache "C:\Users\USERNAME\AppData\Local\pip\cache" You can also do this when venv is active with :  `pip cache purge`
- Run `cache-clean.bat` from the Comfyui-ZLUDA folder to clear caches from the following directories (note that this will require recompiling models again but may fix errors):
  1. `C:\Users\yourusername\AppData\Local\ZLUDA\ComputeCache`
  2. `C:\Users\yourusername\.miopen`
  3. `C:\Users\yourusername\.triton`
- If you can't git pull to the latest version, run these commands, `git fetch --all` and then `git reset --hard origin/m`

### If ComfyUI is Rendering Using Your Integrated Graphics
- If you have an integrated GPU by AMD (e.g. AMD Radeon(TM) Graphics) you need to add `HIP_VISIBLE_DEVICES=1` to your environment variables. Other possible variables to use :
   `ROCR_VISIBLE_DEVICES=1` `HCC_AMDGPU_TARGET=1` . This basically tells it to use 1st gpu -this number could be different if you have multiple gpu's-
  Otherwise it will default to using your iGPU, which will most likely not work. This behavior is caused by a bug in the ROCm-driver.

  
## Credits

- [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- [Zluda Wiki from SdNext](https://github.com/vladmandic/sdnext/wiki/ZLUDA)
- [Brknsoul for Rocm Libraries](https://github.com/brknsoul/ROCmLibs)
- [likelovewant for Rocm Libraries](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU/releases/tag/v0.6.2.4)
- [Lshqqytiger](https://github.com/lshqqytiger/ZLUDA)
- [LeagueRaINi](https://github.com/LeagueRaINi/ComfyUI)
- [ComfyUI-Manager](https://github.com/ltdrdata/ComfyUI-Manager)
- [Sfinktah](https://github.com/sfinktah)
- [jeremymeyers](https://github.com/jeremymeyers)
