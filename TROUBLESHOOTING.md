# Troubleshooting Build Issues

## Base Image Not Found Error

If you get: `ERROR [internal] load metadata for ghcr.io/phonehomephone/python:...`

### Solution 1: Build the base images locally first

The images need to be built in this order:

1. **base-image** (depends on nvidia/cuda:12.8.1-base-ubuntu24.04)
   ```bash
   cd C:\Users\User\Documents\Code\base-image
   docker-compose build
   # This creates: phonehomephone/base-image:v1-cuda-12.8.1-base-ubuntu24.04
   ```

2. **python** (depends on base-image)
   ```bash
   cd C:\Users\User\Documents\Code\python
   docker-compose build
   # This creates: phonehomephone/python:latest (or specific tag)
   ```

3. **comfyui** (depends on python)
   ```bash
   cd C:\Users\User\Documents\Code\comfyui
   docker-compose build
   ```

### Solution 2: Use locally built images

If you've built the python image locally, you can reference it directly:

```bash
# In docker-compose.yaml or as build arg:
IMAGE_BASE=phonehomephone/python:latest
```

### Solution 3: Check actual image tags

If images are published to a registry, verify the exact tag:

```bash
# For Docker Hub
docker search phonehomephone/python

# For GitHub Container Registry (requires auth)
docker pull ghcr.io/phonehomephone/python:latest
```

### Solution 4: Build with explicit local reference

If building locally, you can tag the python image and reference it:

```bash
# After building python image
docker tag <python-image-id> phonehomephone/python:latest

# Then build comfyui
docker-compose build
```

## Registry Authentication

If using GitHub Container Registry (ghcr.io), authenticate first:

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u PhoneHomePhone --password-stdin
```

Replace `$GITHUB_TOKEN` with your actual GitHub Personal Access Token (with `read:packages` permission).


