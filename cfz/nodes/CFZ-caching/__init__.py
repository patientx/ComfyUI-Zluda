from .cfz_caching_condition import save_conditioning, load_conditioning, CFZ_PrintMarker, CFZ_CUDNN

NODE_CLASS_MAPPINGS = {
    "CFZ_save_conditioning": save_conditioning,
    "CFZ_load_conditioning": load_conditioning,
    "CFZ_PrintMarker": CFZ_PrintMarker,   # NEW
    "CFZ_CUDNN": CFZ_CUDNN,   # NEW
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "CFZ_save_conditioning": "CFZ Save Conditioning",
    "CFZ_load_conditioning": "CFZ Load Conditioning",
    "CFZ_PrintMarker": "CFZ Print Marker",
    "CFZ_CUDNN": "CFZ CUDNN",   # NEW
}
