#!/bin/bash

# This file will be sourced in init.sh

# https://raw.githubusercontent.com/ai-dock/comfyui/main/config/provisioning/default.sh

# Packages are installed after nodes so we can fix them...

#DEFAULT_WORKFLOW="https://..."

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
    # ADR-007: commit SHAs pinned via @<sha> suffix. Refresh by picking a
    # commit ≥72hr old and verifying via:
    #   gh api /repos/<owner>/<repo>/commits/<sha> --jq '.commit.author.date'
    # Tag-based references (e.g. @v1.2.3) work the same way.
    # Operators using PROVISIONING_SCRIPT can opt out of pinning by omitting
    # the @suffix; that preserves the existing "git clone HEAD" behavior.
    "https://github.com/ltdrdata/ComfyUI-Manager@bf5c3464285e808eadbcad3b474997f43982a418"  # 2026-05-20; ADR-007 pin
    # cubiq/ComfyUI_essentials dropped from defaults (was upstream-inherited;
    # not load-bearing for known lucidboxai workflows; repo in maintenance
    # mode since 2025-04). Operators who want it can add it to their own
    # PROVISIONING_SCRIPT NODES — the @sha syntax works for them too.
)

# Model arrays — DEFAULT: all entries commented out (blank canvas).
# Uncomment specific URLs to enable downloads on pod boot, OR override this
# entire file via the PROVISIONING_SCRIPT env var pointing at your own
# script. See sibling files in this directory (flux.sh, sd3.sh, etc.) for
# task-specific examples.
# Lines below are kept as reference examples; uncomment what you need.

CHECKPOINT_MODELS=(
    #"https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt"
    #"https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt"
    #"https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
    #"https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors"
)

UNET_MODELS=(

)

LORA_MODELS=(
    #"https://civitai.com/api/download/models/16576"
)

VAE_MODELS=(
    #"https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors"
    #"https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
    #"https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
)

ESRGAN_MODELS=(
    #"https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"
    #"https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"
    #"https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth"
)

CONTROLNET_MODELS=(
    #"https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_canny_mid.safetensors"
    #"https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_depth_mid.safetensors?download"
    #"https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/t2i-adapter_diffusers_xl_openpose.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_depth-fp16.safetensors"
    #"https://huggingface.co/kohya-ss/ControlNet-diff-modules/resolve/main/diff_control_sd15_depth_fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_hed-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_mlsd-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_normal-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_scribble-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_seg-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_color-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_depth-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_keypose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_seg-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_sketch-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_style-fp16.safetensors"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    # ADR-007: default AUTO_UPDATE to "false" if unset. Closes the
    # "next pod restart pulls latest custom node code" vector for
    # unpinned operator-added nodes. Operators wanting per-restart
    # auto-updates set AUTO_UPDATE=true in their RunPod template.
    # Pinned nodes (PORT-009's URL@SHA syntax) get drift-detection
    # re-checkout regardless of AUTO_UPDATE.
    export AUTO_UPDATE="${AUTO_UPDATE:-false}"

    if [[ ! -d /opt/environments/python ]]; then
        export MAMBA_BASE=true
    fi
    source /opt/ai-dock/etc/environment.sh
    source /opt/ai-dock/bin/venv-set.sh comfyui

    # PORT-013: set up persistent model + user-data symlinks before any
    # downloads land. Without these, models would download to a path
    # ComfyUI doesn't look at, and workflows would be lost on pod restart.
    provisioning_link_models
    provisioning_link_user

    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages
    # Per-array destinations updated to modern ComfyUI directory names
    # (PORT-013). Array variable names kept as-is for backward compat
    # with operator-side PROVISIONING_SCRIPT files.
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/checkpoints" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/diffusion_models" \
        "${UNET_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/loras" \
        "${LORA_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/upscale_models" \
        "${ESRGAN_MODELS[@]}"
    provisioning_print_end
}

function pip_install() {
    if [[ -z $MAMBA_BASE ]]; then
            "$COMFYUI_VENV_PIP" install --no-cache-dir "$@"
        else
            micromamba run -n comfyui pip install --no-cache-dir "$@"
        fi
}

# PORT-013: Symlink ComfyUI model directories to the persistent workspace
# volume. Lets models survive pod restarts; lets ComfyUI see models
# downloaded to the persistent path. Each entry maps a ComfyUI model
# type to the persistent storage path. Adding a new type means: it
# persists across restarts AND ComfyUI sees models that land there.
function provisioning_link_models() {
    local models_root="${WORKSPACE}/storage/stable_diffusion/models"
    local comfyui_models="/opt/ComfyUI/models"

    declare -A model_mappings=(
        # ── ComfyUI core: base T2I ──
        ["checkpoints"]="${models_root}/checkpoints"
        ["loras"]="${models_root}/loras"
        ["vae"]="${models_root}/vae"
        ["controlnet"]="${models_root}/controlnet"
        ["upscale_models"]="${models_root}/upscale_models"
        ["diffusion_models"]="${models_root}/diffusion_models"
        ["unet"]="${models_root}/diffusion_models"  # legacy alias — same target as diffusion_models
        # ── ComfyUI core: encoders + extras ──
        ["clip"]="${models_root}/clip"
        ["clip_vision"]="${models_root}/clip_vision"
        ["text_encoders"]="${models_root}/text_encoders"
        ["embeddings"]="${models_root}/embeddings"
        ["style_models"]="${models_root}/style_models"
        ["vae_approx"]="${models_root}/vae_approx"
        # ── ComfyUI core: legacy but recognized ──
        ["gligen"]="${models_root}/gligen"
        ["hypernetworks"]="${models_root}/hypernetworks"
        ["photomaker"]="${models_root}/photomaker"
        # ── photobooth-relevant custom-node directories ──
        ["pulid"]="${models_root}/pulid"
        ["insightface"]="${models_root}/insightface"
        ["facerestore_models"]="${models_root}/facerestore_models"
        # ── animation custom-node directories ──
        ["animatediff_models"]="${models_root}/animatediff_models"
        ["animatediff_motion_lora"]="${models_root}/animatediff_motion_lora"
    )

    for type in "${!model_mappings[@]}"; do
        local src="${model_mappings[$type]}"
        local dest="${comfyui_models}/${type}"

        # Ensure the persistent target exists
        if [[ ! -d "$src" ]]; then mkdir -p "$src"; fi

        # Replace real directory with symlink if needed
        if [[ -d "$dest" && ! -L "$dest" ]]; then
            # Try graceful removal first (only succeeds if empty)
            if ! rmdir "$dest" 2>/dev/null; then
                # Non-empty: operator likely has models from a pre-PORT-013
                # build. Skip with warning rather than silently destroying
                # their files. Operator should manually move files into the
                # persistent path.
                printf "WARN: %s exists with files; not symlinking. Move files to %s and rerun.\n" \
                    "$dest" "$src" >&2
                continue
            fi
        fi
        if [[ ! -L "$dest" ]]; then
            ln -s "$src" "$dest"
        fi
    done
    printf "Linked %d model directories to %s\n" "${#model_mappings[@]}" "$models_root"
}

# PORT-013: Persist ComfyUI user data (workflows, UI settings) across
# pod restarts. Without this, operators lose their workflow library
# every pod restart.
function provisioning_link_user() {
    local user_persist="${WORKSPACE}/storage/comfyui_user"
    local user_link="/opt/ComfyUI/user"

    if [[ ! -d "$user_persist" ]]; then
        mkdir -p "$user_persist"
        # Seed with ComfyUI's default user dir contents on first persist
        if [[ -d "$user_link" && ! -L "$user_link" ]]; then
            cp -rT "$user_link" "$user_persist" 2>/dev/null || true
        fi
    fi
    if [[ -d "$user_link" && ! -L "$user_link" ]]; then
        rm -rf "$user_link"
    fi
    if [[ ! -L "$user_link" ]]; then
        ln -s "$user_persist" "$user_link"
        printf "Linked /opt/ComfyUI/user -> %s\n" "$user_persist"
    fi

    # Optional persistence (commented; uncomment if disk usage is acceptable):
    # output_persist="${WORKSPACE}/storage/comfyui_output"
    # input_persist="${WORKSPACE}/storage/comfyui_input"
    # Generated images and uploaded inputs accumulate fast on photo-gen
    # workloads. PHP-lineage default is OFF to avoid surprise disk usage.
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip_install ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    for entry in "${NODES[@]}"; do
        # Parse entry: "URL" or "URL@SHA-or-ref" (ADR-007 SHA pinning).
        # Assumes HTTPS URLs (no embedded @); SSH-form URLs are not supported.
        if [[ "$entry" == *@* ]]; then
            repo="${entry%@*}"
            pin="${entry##*@}"
        else
            repo="$entry"
            pin=""
        fi
        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ -n "$pin" ]]; then
                # Pinned node: verify we're at the pin; re-checkout on drift.
                current="$(cd "$path" && git rev-parse HEAD 2>/dev/null || echo "")"
                if [[ "$current" != "$pin"* ]]; then
                    printf "Re-pinning node %s to %s...\n" "$dir" "$pin"
                    ( cd "$path" && git fetch && git checkout "$pin" )
                    if [[ -e $requirements ]]; then
                        pip_install -r "$requirements"
                    fi
                fi
            elif [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip_install -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s%s...\n" "${repo}" "${pin:+ @ ${pin}}"
            git clone "${repo}" "${path}" --recursive
            if [[ -n "$pin" ]]; then
                ( cd "$path" && git checkout "$pin" )
            fi
            if [[ -e $requirements ]]; then
                pip_install -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_default_workflow() {
    if [[ -n $DEFAULT_WORKFLOW ]]; then
        workflow_json=$(curl -s "$DEFAULT_WORKFLOW")
        if [[ -n $workflow_json ]]; then
            echo "export const defaultGraph = $workflow_json;" > /opt/ComfyUI/web/scripts/defaultGraph.js
        fi
    fi
}

function provisioning_get_models() {
    if [[ -z $2 ]]; then return 1; fi
    
    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
    if [[ $DISK_GB_ALLOCATED -lt $DISK_GB_REQUIRED ]]; then
        printf "WARNING: Your allocated disk size (%sGB) is below the recommended %sGB - Some models will not be downloaded\n" "$DISK_GB_ALLOCATED" "$DISK_GB_REQUIRED"
    fi
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Web UI will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

provisioning_start
