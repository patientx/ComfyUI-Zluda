import torch
import torch.nn.functional as F
import comfy.sd
import contextlib

# Контекст для временного отключения cuDNN
@contextlib.contextmanager
def disable_cudnn():
    """Временно отключает cuDNN"""
    prev_enabled = torch.backends.cudnn.enabled
    prev_benchmark = torch.backends.cudnn.benchmark
    
    torch.backends.cudnn.enabled = False
    torch.backends.cudnn.benchmark = False
    
    try:
        yield
    finally:
        torch.backends.cudnn.enabled = prev_enabled
        torch.backends.cudnn.benchmark = prev_benchmark

# Патчим VAE encode
_original_vae_encode = comfy.sd.VAE.encode

def patched_vae_encode(self, pixel_samples):
    """VAE encode всегда без cuDNN"""
    print("[ZLUDA VAE] Encoding с отключённым cuDNN...")
    
    with disable_cudnn():
        try:
            result = _original_vae_encode(self, pixel_samples)
            print("[ZLUDA VAE] Encode успешно завершён")
            return result
        except RuntimeError as e:
            if "FIND was unable" in str(e):
                print("[ZLUDA VAE] GPU ошибка, используем CPU...")
                # Fallback на CPU
                torch.cuda.synchronize()
                torch.cuda.empty_cache()
                
                original_device = next(self.first_stage_model.parameters()).device
                self.first_stage_model.to('cpu')
                pixel_samples_cpu = pixel_samples.to('cpu')
                
                result = _original_vae_encode(self, pixel_samples_cpu)
                
                self.first_stage_model.to(original_device)
                return result.to(original_device)
            raise

comfy.sd.VAE.encode = patched_vae_encode

# Также патчим decode на всякий случай
_original_vae_decode = comfy.sd.VAE.decode

def patched_vae_decode(self, samples):
    """VAE decode с отключённым cuDNN"""
    with disable_cudnn():
        try:
            return _original_vae_decode(self, samples)
        except RuntimeError as e:
            if "FIND was unable" in str(e):
                print("[ZLUDA VAE] Decode fallback на CPU...")
                torch.cuda.synchronize()
                torch.cuda.empty_cache()
                
                original_device = next(self.first_stage_model.parameters()).device
                self.first_stage_model.to('cpu')
                samples_cpu = samples.to('cpu')
                
                result = _original_vae_decode(self, samples_cpu)
                
                self.first_stage_model.to(original_device)
                return result.to(original_device)
            raise

comfy.sd.VAE.decode = patched_vae_decode

print("=" * 50)
print("[ZLUDA] VAE авто-патч активирован")
print("[ZLUDA] VAE encode/decode = без cuDNN")
print("[ZLUDA] Остальное = с cuDNN")
print("=" * 50)
NODE_CLASS_MAPPINGS = {}