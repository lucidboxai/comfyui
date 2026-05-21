# Compatibility Matrix

The lucidboxai ComfyUI image is a 3-tier Docker stack. Each tier is built
`FROM` the previous one, so they must be built and published in order:

```
lucidboxai/base-image  →  lucidboxai/python  →  lucidboxai/comfyui
```

## Current pinned stack (NVIDIA / CUDA)

| Component        | Version | Set in |
|------------------|---------|--------|
| Ubuntu           | 24.04   | `*/docker-build.yml` (nvidia job `UBUNTU_VERSION`) |
| CUDA (base image)| 12.6.3  | `base-image` CUDA matrix; `nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04` |
| Python           | 3.12    | `python`/`comfyui` `PYTHON_VERSION` build arg |
| PyTorch          | 2.12.0  | `comfyui` `PYTORCH_VERSION` build arg |
| torchvision      | 0.27.0  | `comfyui` `layer0/nvidia.sh` |
| torchaudio       | 2.12.0  | `comfyui` `layer0/nvidia.sh` (tracks PyTorch) |
| PyTorch wheel idx| cu126   | derived from `CUDA_VERSION` in `layer0/nvidia.sh` |
| xformers         | —       | not installed (see below) |
| ComfyUI          | v0.22.0 | `comfyui` `docker-build.yml` matrix `comfyui:` |
| Node (base)      | v22.22.3| `base-image` Dockerfile `NODE_VERSION` |
| Go (caddy build) | 1.26.3  | `base-image` Dockerfile |
| xcaddy           | 0.4.5   | `base-image` Dockerfile |

## Binding constraints — read before bumping anything

- **PyTorch ↔ CUDA wheel index.** PyTorch only publishes wheels for specific
  `cuXXX` indexes per release. PyTorch 2.12 publishes **cu126** and **cu130**
  only (cu128 was dropped). The CUDA base image's major.minor must match an
  index PyTorch actually ships. `layer0/nvidia.sh` derives `cuXXX` from the
  base image's `CUDA_VERSION`.
- **torchvision / torchaudio** are version-locked to each PyTorch release
  (torch 2.12.0 → torchvision 0.27.0, torchaudio 2.12.0).
- **xformers** is intentionally NOT installed. ComfyUI uses PyTorch native
  SDPA attention; an audit of the bundled provisioning custom nodes
  (ComfyUI-Manager, ComfyUI_essentials, AnimateDiff-Evolved,
  Advanced-ControlNet, SeargeSDXL) found none require the `xformers` package.
  The latest xformers wheel also does not track torch 2.12. If a future need
  arises, install a torch-matched xformers — do not let it pin the stack back.
- **CUDA 13 vs 12.6.** 12.6 chosen for host-driver breadth on cloud GPU hosts
  (RunPod) — CUDA 13 needs NVIDIA driver R580+. No perf difference on Ampere
  (RTX 30-series, A40). Revisit when newer GPUs / drivers are the norm.
- **Ubuntu 24.04 / PEP 668.** System Python is externally-managed; all package
  installs go into venvs (`$COMFYUI_VENV`, `$API_VENV`, etc.). Never use
  `--break-system-packages`.
- **ComfyUI** declares `requires-python >=3.10`, `numpy>=1.25.0` (numpy-2
  ready, no upper bound). It imposes no real ceiling on the stack.

## How to bump the stack

1. Check the binding constraints above — usually PyTorch is what moves first.
2. Pick a PyTorch release; read its published CUDA wheel indexes and the
   matching torchvision/torchaudio versions.
3. Pick a `nvidia/cuda` base tag whose major.minor matches a published index
   and that has a `cudnn-runtime-ubuntu<VER>` variant.
4. Update, in order: `base-image` (CUDA/OS) → `python` (Python/base tag) →
   `comfyui` (PyTorch/torchvision/torchaudio/ComfyUI ref/base tag).
5. Build and publish each tier's `docker-build.yml` in order before the next.
6. Update this table.

## Build order & verification

Each repo's `Docker Build` workflow is `workflow_dispatch`. Run base-image,
wait for success, then python, then comfyui. The in-image build tests assert
the installed PyTorch and CUDA versions match the build args.
