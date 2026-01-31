import torch
import os
import folder_paths 

class GetOutputDirectory:
    @classmethod
    def INPUT_TYPES(s):
        return {"required": {},
                "optional": {},
        }
    RETURN_TYPES = ("STRING",) 
    FUNCTION = "get_output_path"
    def get_output_path(self):
        output_dir = folder_paths.get_output_directory()
        return (output_dir,)

NODE_CLASS_MAPPINGS = {"GetOutputDirectory": GetOutputDirectory}
NODE_DISPLAY_NAME_MAPPINGS = {"GetOutputDirectory_Custom": "Get Output Directory Path"}