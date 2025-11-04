[![Docker Build](https://github.com/PhoneHomePhone/comfyui/actions/workflows/docker-build.yml/badge.svg)](https://github.com/PhoneHomePhone/comfyui/actions/workflows/docker-build.yml)

# Modernized AI-Dock + ComfyUI Docker Image

This is a modernized fork of the original `ai-dock/comfyui` project, updated to work with Ubuntu 24.04 and Python 3.12.

Run [ComfyUI](https://github.com/comfyanonymous/ComfyUI) in a highly-configurable, cloud-first AI-Dock container.

>[!NOTE]
>These images do not bundle models or third-party configurations. You should use a [provisioning script](https://github.com/ai-dock/base-image/wiki/4.0-Running-the-Image#provisioning-script) to automatically configure your container. You can find examples, including `SD3` & `FLUX.1` setup, in `config/provisioning`.


## Documentation

All containers in this modernized stack share a common base which is designed to make running on cloud services such as [vast.ai](https://link.ai-dock.org/vast.ai) and [runpod.io](https://link.ai-dock.org/runpod.io) as straightforward and user friendly as possible.

Common features and options are documented in the **[base image repository wiki](https://github.com/ai-dock/base-image/wiki)** but any additional features unique to this image will be detailed below.

#### Version Tags

The `:latest` tag points to the latest stable CUDA runtime build (`:v1-python3.12-cuda-12.8.1-runtime-ubuntu24.04`).

Tags follow a clear and consistent pattern:
`v1-python<version>-<platform>-<platform_version>-<os_version>`

##### _CUDA_
*   **Example:** `:v1-python3.12-cuda-12.8.1-runtime-ubuntu24.04`
*   **Latest Tag:** `:latest`

##### _ROCm_
*   **Example:** `:v1-python3.12-rocm-6.2-runtime-ubuntu22.04`
*   **Note:** ROCm builds currently use an Ubuntu 22.04 base pending official driver support for 24.04.

##### _CPU_
*   **Example:** `:v1-python3.12-cpu-ubuntu24.04`
*   **Latest Tag:** `:latest-cpu`

Browse the available image tags on **[GitHub Packages](https://github.com/PhoneHomePhone/comfyui/pkgs/container/comfyui)** page for this repository.

Supported Platforms: `NVIDIA CUDA`, `AMD ROCm`, `CPU`

## Additional Environment Variables

| Variable                 | Description |
| ------------------------ | ----------- |
| `AUTO_UPDATE`            | Update ComfyUI on startup (default `false`) |
| `CIVITAI_TOKEN`          | Authenticate download requests from Civitai - Required for gated models |
| `COMFYUI_ARGS`           | Startup arguments. eg. `--gpu-only --highvram` |
| `COMFYUI_PORT_HOST`      | ComfyUI interface port (default `8188`) |
| `COMFYUI_REF`            | Git reference for auto update. Accepts branch, tag or commit hash. Default: latest release |
| `COMFYUI_URL`            | Override `$DIRECT_ADDRESS:port` with URL for ComfyUI |
| `HF_TOKEN`               | Authenticate download requests from HuggingFace - Required for gated models (SD3, FLUX, etc.) |

See the base environment variables [here](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) for more configuration options. Common features for the underlying base image are documented in the **[base image repository wiki](https://github.com/PhoneHomePhone/base-image/wiki)**.

### Additional Python Environments

| Environment    | Packages |
| -------------- | ----------------------------------------- |
| `comfyui`      | ComfyUI and dependencies |
| `api`          | ComfyUI API wrapper and dependencies |


The `comfyui` environment will be activated on shell login.

~~See the base micromamba environments [here](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software#installed-micromamba-environments).~~

## Additional Services

The following services will be launched alongside the [default services](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software) provided by the base image.

### ComfyUI

The service will launch on port `8188` unless you have specified an override with `COMFYUI_PORT_HOST`.

You can set startup flags by using variable `COMFYUI_ARGS`.

To manage this service you can use `supervisorctl [start|stop|restart] comfyui`.


### ComfyUI API Wrapper

This service is available on port `8188` and is a work-in-progress to replace previous serverless handlers which have been depreciated; Old Docker images and sources remain available should you need them.

You can access the api directly at `/ai-dock/api/` or you can use the Swager/openAPI playground at `/ai-dock/api/docs`.

>[!NOTE]
>All services are password protected by default. See the [security](https://github.com/ai-dock/base-image/wiki#security) and [environment variables](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) documentation for more information.

---

### Credits and Acknowledgements

This project is a direct fork and modernization of the original, excellent work done by **[ai-dock](https://github.com/ai-dock)**. All credit for the foundational architecture and scripts belongs to the original author, [@robballantyne](https://github.com/robballantyne).

This fork is maintained by [@PhoneHomePhone](https://github.com/PhoneHomePhone).
