"""
ZLUDA Ultralytics Fix - Forces Ultralytics YOLO to run on CPU
to avoid conv_transpose2d compatibility issues with ZLUDA
"""

import torch

# Check if running on ZLUDA
_is_zluda = False
if torch.cuda.is_available():
    try:
        device_name = torch.cuda.get_device_name(0)
        _is_zluda = "ZLUDA" in device_name
    except:
        pass

if _is_zluda:
    print("[ZLUDA] Patching Ultralytics to use CPU...")
    
    try:
        from ultralytics.engine import predictor
        from ultralytics.nn import autobackend
        
        # Patch 1: Override AutoBackend.warmup to use CPU tensors
        _original_warmup = autobackend.AutoBackend.warmup
        
        def _patched_warmup(self, imgsz=(1, 3, 640, 640)):
            # Move model to CPU and warmup with CPU tensor
            self.model = self.model.to('cpu')
            im = torch.empty(*imgsz, dtype=torch.float32, device='cpu')
            self.forward(im)
        
        autobackend.AutoBackend.warmup = _patched_warmup
        
        # Patch 2: Override forward to ensure CPU execution
        _original_forward = autobackend.AutoBackend.forward
        
        def _patched_forward(self, im, augment=False, visualize=False, embed=None, **kwargs):
            # Ensure input is on CPU
            if im.is_cuda:
                im = im.cpu()
            # Ensure model is on CPU
            if hasattr(self, 'model'):
                self.model = self.model.to('cpu')
            return _original_forward(self, im, augment, visualize, embed, **kwargs)
        
        autobackend.AutoBackend.forward = _patched_forward
        
        # Patch 3: Override predictor to set device to CPU
        _original_setup_model = predictor.BasePredictor.setup_model
        
        def _patched_setup_model(self, model, verbose=True):
            result = _original_setup_model(self, model, verbose)
            # Force CPU after model setup
            self.device = torch.device('cpu')
            if hasattr(self, 'model') and self.model is not None:
                self.model.to('cpu')
            return result
        
        predictor.BasePredictor.setup_model = _patched_setup_model
        
        # Patch 4: Override pre_transform to ensure CPU images
        _original_pre_transform = predictor.BasePredictor.pre_transform
        
        def _patched_pre_transform(self, im):
            result = _original_pre_transform(self, im)
            # Ensure result tensors are on CPU
            if isinstance(result, torch.Tensor) and result.is_cuda:
                result = result.cpu()
            elif isinstance(result, list):
                result = [r.cpu() if isinstance(r, torch.Tensor) and r.is_cuda else r for r in result]
            return result
        
        predictor.BasePredictor.pre_transform = _patched_pre_transform
        
        print("[ZLUDA] Ultralytics CPU patch applied successfully")
        
    except ImportError:
        print("[ZLUDA] Ultralytics not installed, skipping patch")
    except Exception as e:
        print(f"[ZLUDA] Failed to patch Ultralytics: {e}")
        import traceback
        traceback.print_exc()

NODE_CLASS_MAPPINGS = {}
NODE_DISPLAY_NAME_MAPPINGS = {}