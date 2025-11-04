# Build Order for PhoneHomePhone Stack

If you're getting "load metadata" errors, you may need to build the base images first. The build order is:

## 1. Build base-image first

```bash
cd C:\Users\User\Documents\Code\base-image
docker-compose build
# OR
docker build -t ghcr.io/phonehomephone/base-image:latest -f build/Dockerfile build/
```

## 2. Build python image (depends on base-image)

```bash
cd C:\Users\User\Documents\Code\python
docker-compose build
# OR check what base image it uses and ensure that's built first
```

## 3. Build comfyui image (depends on python image)

```bash
cd C:\Users\User\Documents\Code\comfyui
docker-compose build
```

## Alternative: Use Public Images

If the images are available on GitHub Container Registry (ghcr.io), you may need to:

1. **Authenticate to ghcr.io:**
   ```bash
   echo $GITHUB_TOKEN | docker login ghcr.io -u PhoneHomePhone --password-stdin
   ```

2. **Pull the base image first:**
   ```bash
   docker pull ghcr.io/phonehomephone/python:latest
   ```

3. **Then build comfyui:**
   ```bash
   docker-compose build
   ```

## Troubleshooting

- If `:latest` doesn't work, try checking what tags are actually available:
  - Visit: https://github.com/PhoneHomePhone/python/pkgs/container/python
  - Or use: `docker search ghcr.io/phonehomephone/python`

- You can also build locally using a relative path if building from source:
  ```bash
  # Build python image locally first, then reference it
  docker build -t phonehomephone-python:local -f build/Dockerfile build/
  # Then update comfyui Dockerfile to use: phonehomephone-python:local
  ```


