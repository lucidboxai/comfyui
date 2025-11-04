# Getting the Base Images

You have two options: **Pull from Registry** (faster) or **Build Locally** (if images aren't published yet).

## Option 1: Pull from Registry (Recommended - Faster)

The images are published to **GitHub Container Registry (ghcr.io)** and **Docker Hub**. Pull them in order:

### Step 1: Authenticate (if needed)

For GitHub Container Registry:
```powershell
# Replace YOUR_GITHUB_TOKEN with a Personal Access Token
$env:GITHUB_TOKEN = "YOUR_GITHUB_TOKEN"
echo $env:GITHUB_TOKEN | docker login ghcr.io -u PhoneHomePhone --password-stdin
```

For Docker Hub (if using):
```powershell
docker login
```

### Step 2: Pull base-image

```powershell
# From GitHub Container Registry
docker pull ghcr.io/phonehomephone/base-image:v1-cuda-12.8.1-runtime-ubuntu24.04
docker tag ghcr.io/phonehomephone/base-image:v1-cuda-12.8.1-runtime-ubuntu24.04 phonehomephone/base-image:v1-cuda-12.8.1-base-ubuntu24.04

# OR from Docker Hub
docker pull phonehomephone/base-image:v1-cuda-12.8.1-runtime-ubuntu24.04
docker tag phonehomephone/base-image:v1-cuda-12.8.1-runtime-ubuntu24.04 phonehomephone/base-image:v1-cuda-12.8.1-base-ubuntu24.04
```

### Step 3: Pull python image

```powershell
# From GitHub Container Registry
docker pull ghcr.io/phonehomephone/python:latest
docker tag ghcr.io/phonehomephone/python:latest phonehomephone/python:latest

# OR specific tag
docker pull ghcr.io/phonehomephone/python:v1-python3.12-cuda-12.8.1-runtime-ubuntu24.04
docker tag ghcr.io/phonehomephone/python:v1-python3.12-cuda-12.8.1-runtime-ubuntu24.04 phonehomephone/python:latest
```

### Step 4: Verify images are available

```powershell
docker images | Select-String "phonehomephone"
```

You should see:
- `phonehomephone/base-image`
- `phonehomephone/python`

### Step 5: Build comfyui

```powershell
cd C:\Users\User\Documents\Code\comfyui
docker-compose build
```

## Option 2: Build Locally (If Images Aren't Published)

If the images aren't available in registries, build them locally in order:

### Step 1: Build base-image

```powershell
cd C:\Users\User\Documents\Code\base-image
docker-compose build
```

This creates: `phonehomephone/base-image:v1-cuda-12.8.1-base-ubuntu24.04`

### Step 2: Build python image

```powershell
cd C:\Users\User\Documents\Code\python
docker-compose build
```

This creates: `phonehomephone/python:latest` (or specific tag)

### Step 3: Build comfyui

```powershell
cd C:\Users\User\Documents\Code\comfyui
docker-compose build
```

## Option 3: Export/Import from Home Computer

If you have the images on your home computer, you can export and transfer them:

### On Home Computer:

```bash
# Save images to tar files
docker save phonehomephone/base-image:v1-cuda-12.8.1-base-ubuntu24.04 -o base-image.tar
docker save phonehomephone/python:latest -o python.tar

# Or save both at once
docker save phonehomephone/base-image:v1-cuda-12.8.1-base-ubuntu24.04 phonehomephone/python:latest -o images.tar
```

### Transfer files and load on this computer:

```powershell
# Load the images
docker load -i base-image.tar
docker load -i python.tar

# Or if combined
docker load -i images.tar

# Verify
docker images | Select-String "phonehomephone"
```

## Quick Check: Are Images Published?

Check if images exist in registries:

**GitHub Container Registry:**
- https://github.com/PhoneHomePhone/base-image/pkgs/container/base-image
- https://github.com/PhoneHomePhone/python/pkgs/container/python

**Docker Hub:**
- https://hub.docker.com/r/phonehomephone/base-image/tags
- https://hub.docker.com/r/phonehomephone/python/tags

## Troubleshooting

### "manifest unknown" or "not found" errors
- Images may not be published yet → Use Option 2 (Build Locally)
- Check authentication → Run `docker login` commands
- Verify tag names match exactly

### "unauthorized" errors
- Authenticate to the registry first
- For private repos, ensure you have access permissions


