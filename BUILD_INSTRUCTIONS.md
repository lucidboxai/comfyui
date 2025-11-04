# Build Instructions

## Prerequisites
- Docker installed and running
- Access to pull `ghcr.io/phonehomephone/python:v1-python3.12-cuda-12.8.1-runtime-ubuntu24.04`

## Build Options

### Option 1: Using Docker Compose (Recommended)

From the repository root:

```bash
docker-compose build
```

Or with specific build arguments:

```bash
PYTHON_VERSION=3.12 PYTORCH_VERSION=2.4.1 docker-compose build
```

### Option 2: Using Docker Build Directly

From the repository root:

```bash
docker build \
  --build-arg IMAGE_BASE=ghcr.io/phonehomephone/python:v1-python3.12-cuda-12.8.1-runtime-ubuntu24.04 \
  --build-arg PYTHON_VERSION=3.12 \
  --build-arg PYTORCH_VERSION=2.4.0 \
  -t ghcr.io/phonehomephone/comfyui:v1-python3.12-cuda-12.8.1-runtime-ubuntu24.04 \
  -f build/Dockerfile \
  build/
```

### Option 3: CPU-only Build

```bash
docker build \
  --build-arg IMAGE_BASE=ghcr.io/phonehomephone/python:v1-python3.12-cpu-ubuntu24.04 \
  --build-arg PYTHON_VERSION=3.12 \
  --build-arg PYTORCH_VERSION=2.4.0 \
  -t ghcr.io/phonehomephone/comfyui:v1-python3.12-cpu-ubuntu24.04 \
  -f build/Dockerfile \
  build/
```

## Troubleshooting

### Base Image Not Found
If you get an error about the base image not being found:
1. Verify the PhoneHomePhone/python image exists and is accessible
2. Check that you're authenticated to ghcr.io if needed:
   ```bash
   echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
   ```

### Build Errors
- Check that all build scripts in `build/COPY_ROOT_*` have execute permissions
- Verify the base image includes the expected environment variables (`VENV_DIR`, etc.)
- Review build logs in `/var/log/build.log` inside the container during build



