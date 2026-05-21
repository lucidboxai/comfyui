#!/bin/false

build_nvidia_main() {
    build_nvidia_install_deps
    build_common_run_tests
    build_nvidia_run_tests
}

build_nvidia_install_deps() {
    short_cuda_version="cu$(cut -d '.' -f 1,2 <<< "${CUDA_VERSION}" | tr -d '.')"
    # xformers intentionally omitted: ComfyUI uses PyTorch native SDPA
    # attention, no bundled custom node requires xformers, and the latest
    # xformers wheel does not track torch 2.12. See COMPATIBILITY.md.
    "$COMFYUI_VENV_PIP" install --no-cache-dir \
        torch==${PYTORCH_VERSION} \
        torchvision==0.27.0 \
        torchaudio==${PYTORCH_VERSION} \
        --index-url=https://download.pytorch.org/whl/$short_cuda_version
}

build_nvidia_run_tests() {
    installed_pytorch_cuda_version=$("$COMFYUI_VENV_PYTHON" -c "import torch; print(torch.version.cuda)")
    if [[ "$CUDA_VERSION" != "$installed_pytorch_cuda_version"* ]]; then
        echo "Expected PyTorch CUDA ${CUDA_VERSION} but found ${installed_pytorch_cuda_version}\n"
        exit 1
    fi
}

build_nvidia_main "$@"