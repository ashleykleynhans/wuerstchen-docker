import torch
from diffusers import AutoPipelineForText2Image, WuerstchenPriorPipeline

def fetch_pretrained_model(model_class, model_name, **kwargs):
    '''
    Fetches a pretrained model from the HuggingFace model hub.
    '''
    max_retries = 3
    for attempt in range(max_retries):
        try:
            return model_class.from_pretrained(model_name, **kwargs)
        except OSError as err:
            if attempt < max_retries - 1:
                print(
                    f"Error encountered: {err}. Retrying attempt {attempt + 1} of {max_retries}...")
            else:
                raise

def get_wuerstchen_pipelines():
    '''
    Fetches the Wuerstchen pipelines from the HuggingFace model hub.
    '''
    common_args = {
        "torch_dtype": torch.float16,
    }

    auto_pipe = fetch_pretrained_model(AutoPipelineForText2Image,
                                       "warp-ai/wuerstchen", **common_args)

    return auto_pipe

if __name__ == "__main__":
    get_wuerstchen_pipelines()
