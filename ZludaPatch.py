# Note: some function of this file is copied from https://github.com/vladmandic/automatic/blob/master/installer.py


import logging
import os
import shutil
import urllib
import zipfile

log = logging.getLogger("sd")

zluda_ver = "rel.2804604c29b5fa36deca9ece219d3970b61d4c27"

def find_zluda():
    zluda_path = os.environ.get('ZLUDA', None)
    if zluda_path is None:
        paths = os.environ.get('PATH', '').split(';')
        log.debug(f'ZLUDA: searching for ZLUDA in PATH: {paths}')
        for path in paths:
            if os.path.exists(os.path.join(path, 'zluda_redirect.dll')):
                zluda_path = path
                break
    return zluda_path


def patch_zluda():
    zluda_path = find_zluda()
    if zluda_path is None:
        log.warning('Failed to automatically patch torch with ZLUDA. Could not find ZLUDA from PATH.')
        return
    python_dir = os.path.dirname(shutil.which('python'))
    if shutil.which('conda') is None:
        python_dir = os.path.dirname(python_dir)
    venv_dir = os.environ.get('VENV_DIR', python_dir)
    log.info(f'ZLUDA: found VENV in PATH: {venv_dir}')
    dlls_to_patch = {
        'cublas.dll': 'cublas64_11.dll',
        #'cudnn.dll': 'cudnn64_8.dll',
        'cusparse.dll': 'cusparse64_11.dll',
        'nvrtc.dll': 'nvrtc64_112_0.dll',
    }
    try:
        for k, v in dlls_to_patch.items():
            shutil.copyfile(os.path.join(zluda_path, k), os.path.join(venv_dir, 'Lib', 'site-packages', 'torch', 'lib', v))
    except Exception as e:
        log.warning(f'ZLUDA: failed to automatically patch torch: {e}')


def main():
    if os.environ.get('ZLUDA', None) is None:
        log.warning('ZLUDA environment variable is not set. ZLUDA is required for ZLUDAPatch.')

        log.info('Downloading ZLUDA...')
        zluda_url = f"https://github.com/lshqqytiger/ZLUDA/releases/download/{zluda_ver}/ZLUDA-windows-amd64.zip"
        archive_type = zipfile.ZipFile       
        urllib.request.urlretrieve(zluda_url, '_zluda')
        log.info('Extracting ZLUDA...')
        with archive_type('_zluda', 'r') as f:
            f.extractall('.zluda')
            zluda_path = os.path.abspath('./.zluda')
        os.remove('_zluda')
    patch_zluda()