#!/bin/bash

# This file will be sourced in init.sh — an ai-dock ComfyUI PROVISIONING_SCRIPT.
# Ref: https://raw.githubusercontent.com/ai-dock/comfyui/main/config/provisioning/default.sh
#
# modern-imagegen-stack — a generic, ready-to-run provisioning script for the current
# generation of OPEN image-gen models. All models are ungated (no HF_TOKEN required).
#
# A PROVISIONING_SCRIPT REPLACES the default provisioning, so this script sets up the
# ComfyUI model-dir symlinks itself (provisioning_link_models) — otherwise downloads land
# under ${WORKSPACE}/storage and stay invisible to ComfyUI. It uses modern model dirs
# (diffusion_models/, text_encoders/, …) and is idempotent, so it is safe on stock ai-dock
# images and on images that already pre-link those dirs.
#
# Included by default (confirmed ungated):
#   • FLUX.1-schnell (fp8, all-in-one)          — fast Apache-2.0 baseline
#   • Krea 2 Turbo (DiT + Qwen3-VL enc + VAE)   — modern 8-step model
#   • SDXL base 1.0 (+ VAE)                     — classic broadly-compatible baseline
# Optional (uncomment + confirm the repackaged repo/filename for your ComfyUI build):
#   • FLUX.2 [klein], Z-Image                   — newest open releases
#
# Optional env: COMFYUI_OVERRIDE_SHA=<sha> bumps ComfyUI to a specific commit (newer model
# support). HF_TOKEN is only needed if you add a gated model — none here require it.

APT_PACKAGES=(
)

PIP_PACKAGES=(
    # Attention backbones — OPT-IN only. PyTorch native SDPA already dispatches a fused
    # FlashAttention-2 kernel on Ampere+; install these only for models that hard-require
    # flash_attn, or to try SageAttention. NOTE: SageAttention can produce black images on
    # some DiT models (e.g. Qwen-Image family) — enable per-loader, never globally.
    #"https://github.com/mjun0812/flash-attention-prebuild-wheels/releases/download/v0.9.4/flash_attn-2.8.3+cu126torch2.11-cp312-cp312-linux_x86_64.whl"
    #"sageattention>=2.2.0"
)

NODES=(
    # Quantized (GGUF) model support — common for running big models on smaller GPUs.
    "https://github.com/city96/ComfyUI-GGUF"
)

# All-in-one checkpoints (transformer + CLIP + VAE) -> models/checkpoints
CHECKPOINT_MODELS=(
    "https://huggingface.co/Comfy-Org/flux1-schnell/resolve/main/flux1-schnell-fp8.safetensors"
    "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
)

# Bare diffusion transformers (load with UNETLoader) -> models/diffusion_models
UNET_MODELS=(
    "https://huggingface.co/Comfy-Org/Krea-2/resolve/main/diffusion_models/krea2_turbo_fp8_scaled.safetensors"
    # FLUX.2 [klein] — uncomment + confirm the repackaged repo/filename for your ComfyUI:
    #"https://huggingface.co/Comfy-Org/<flux2-klein-repackage>/resolve/main/<flux2_klein_fp8.safetensors>"
)

# Text encoders -> models/text_encoders
CLIP_MODELS=(
    "https://huggingface.co/Comfy-Org/Krea-2/resolve/main/text_encoders/qwen3vl_4b_fp8_scaled.safetensors"
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors"
)

# VAEs -> models/vae
VAE_MODELS=(
    "https://huggingface.co/Comfy-Org/Krea-2/resolve/main/vae/qwen_image_vae.safetensors"
    "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
)

LORA_MODELS=(
)

CONTROLNET_MODELS=(
)

# Upscalers -> models/upscale_models
ESRGAN_MODELS=(
    "https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"
    "https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    if [[ ! -d /opt/environments/python ]]; then
        export MAMBA_BASE=true
    fi
    source /opt/ai-dock/etc/environment.sh
    source /opt/ai-dock/bin/venv-set.sh comfyui

    # PROVISIONING_SCRIPT replaces default provisioning, so create the model-dir symlinks
    # ourselves or downloads under ${WORKSPACE}/storage are invisible to ComfyUI. Idempotent.
    provisioning_link_models
    provisioning_link_user
    provisioning_override_comfyui_ref

    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/checkpoints" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/diffusion_models" \
        "${UNET_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/text_encoders" \
        "${CLIP_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/loras" \
        "${LORA_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/upscale_models" \
        "${ESRGAN_MODELS[@]}"
    provisioning_print_end
}

# Symlink /opt/ComfyUI/models/<type> -> ${WORKSPACE}/storage/…/models/<type> so downloads
# persist and are visible. NOTE: no "unet" — ComfyUI aliases unet/ -> diffusion_models/.
function provisioning_link_models() {
    local models_root="${WORKSPACE}/storage/stable_diffusion/models"
    local comfyui_models="/opt/ComfyUI/models"
    declare -A model_mappings=(
        ["checkpoints"]="${models_root}/checkpoints"
        ["loras"]="${models_root}/loras"
        ["vae"]="${models_root}/vae"
        ["controlnet"]="${models_root}/controlnet"
        ["upscale_models"]="${models_root}/upscale_models"
        ["diffusion_models"]="${models_root}/diffusion_models"
        ["clip"]="${models_root}/clip"
        ["clip_vision"]="${models_root}/clip_vision"
        ["text_encoders"]="${models_root}/text_encoders"
        ["embeddings"]="${models_root}/embeddings"
        ["style_models"]="${models_root}/style_models"
        ["vae_approx"]="${models_root}/vae_approx"
    )
    for type in "${!model_mappings[@]}"; do
        local src="${model_mappings[$type]}"
        local dest="${comfyui_models}/${type}"
        [[ ! -d "$src" ]] && mkdir -p "$src"
        if [[ -d "$dest" && ! -L "$dest" ]]; then
            # Clear ai-dock placeholders (inconsistent names) + boot .gitkeep or the symlink is blocked.
            rm -f "$dest"/put_* "$dest"/.gitkeep 2>/dev/null
            if ! rmdir "$dest" 2>/dev/null; then
                printf "WARN: %s has non-placeholder files; not symlinking. Move them to %s and rerun.\n" \
                    "$dest" "$src" >&2
                continue
            fi
        fi
        [[ ! -L "$dest" ]] && ln -s "$src" "$dest"
    done
    printf "Linked %d model directories to %s\n" "${#model_mappings[@]}" "$models_root"
}

# Persist ComfyUI user data (workflows, UI settings) across stop/start.
function provisioning_link_user() {
    local user_persist="${WORKSPACE}/storage/comfyui_user"
    local user_link="/opt/ComfyUI/user"
    if [[ ! -d "$user_persist" ]]; then
        mkdir -p "$user_persist"
        [[ -d "$user_link" && ! -L "$user_link" ]] && cp -rT "$user_link" "$user_persist" 2>/dev/null || true
    fi
    [[ -d "$user_link" && ! -L "$user_link" ]] && rm -rf "$user_link"
    if [[ ! -L "$user_link" ]]; then
        ln -s "$user_persist" "$user_link"
        printf "Linked /opt/ComfyUI/user -> %s\n" "$user_persist"
    fi
}

# Optional: bump ComfyUI to a specific commit (newer model support). No-op unless
# COMFYUI_OVERRIDE_SHA is set in the pod env.
function provisioning_override_comfyui_ref() {
    [[ -z "$COMFYUI_OVERRIDE_SHA" ]] && return 0
    [[ ! -d /opt/ComfyUI/.git ]] && { printf "WARN: /opt/ComfyUI not a git checkout; skip ref override\n" >&2; return 0; }
    local current_sha
    current_sha=$(cd /opt/ComfyUI && git rev-parse HEAD 2>/dev/null)
    [[ "$current_sha" == "$COMFYUI_OVERRIDE_SHA"* ]] && { printf "ComfyUI already at %s\n" "$COMFYUI_OVERRIDE_SHA"; return 0; }
    printf "Bumping ComfyUI %s -> %s\n" "${current_sha:0:10}" "$COMFYUI_OVERRIDE_SHA"
    ( cd /opt/ComfyUI && git fetch --depth=200 origin && git checkout "$COMFYUI_OVERRIDE_SHA" )
    [[ -f /opt/ComfyUI/requirements.txt ]] && pip_install -r /opt/ComfyUI/requirements.txt
}

function pip_install() {
    if [[ -z $MAMBA_BASE ]]; then
        "$COMFYUI_VENV_PIP" install --no-cache-dir "$@"
    else
        micromamba run -n comfyui pip install --no-cache-dir "$@"
    fi
}

function provisioning_get_apt_packages() {
    [[ -n $APT_PACKAGES ]] && sudo $APT_INSTALL ${APT_PACKAGES[@]}
}

function provisioning_get_pip_packages() {
    [[ -n $PIP_PACKAGES ]] && pip_install ${PIP_PACKAGES[@]}
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ ! -d $path ]]; then
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            [[ -e $requirements ]] && pip_install -r "${requirements}"
        fi
    done
}

function provisioning_get_models() {
    [[ -z $2 ]] && return 0
    dir="$1"; mkdir -p "$dir"; shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n"
    printf   "#      Modern open image-gen stack           #\n"
    printf   "#   FLUX.1-schnell · Krea 2 Turbo · SDXL      #\n"
    printf   "##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete: ComfyUI Web UI will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET \
        "https://huggingface.co/api/whoami-v2" \
        -H "Authorization: Bearer $HF_TOKEN" -H "Content-Type: application/json")
    [ "$response" -eq 200 ]
}

function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    fi
    if [[ -n $auth_token ]]; then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition \
            --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

provisioning_start
