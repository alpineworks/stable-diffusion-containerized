# Stable Diffusion Containerized

A container image for [ComfyUI](https://github.com/comfyanonymous/ComfyUI) on
NVIDIA GPUs.

Versions before v2.0.0 packaged AUTOMATIC1111's stable-diffusion-webui. v2.0.0
replaced it with ComfyUI.

## What's in the image

- ComfyUI pinned to a release tag (`COMFYUI_VERSION` in the `Dockerfile`).
- PyTorch from the CUDA 13.0 wheel index. The wheels bundle the CUDA runtime,
  so the host only needs the NVIDIA driver (580 or newer). That covers RTX 50
  series (Blackwell, sm_120).
- Runs as uid/gid 1000. The application is read-only under `/opt/ComfyUI`.
- No ComfyUI-Manager. Custom nodes are whatever you put in
  `/data/custom_nodes`.

## Running

Everything ComfyUI writes goes under `/data`: `models`, `custom_nodes`,
`input`, `output`, `temp` and `user`. `HOME` is `/tmp`, for library caches.
Both paths need to be writable, and the root filesystem can be read-only.

```sh
docker run --rm --gpus all -p 8188:8188 \
  --read-only --tmpfs /tmp \
  -v comfyui-data:/data \
  ghcr.io/alpineworks/stable-diffusion-containerized:v2.0.0
```

The entrypoint is `python main.py --listen 0.0.0.0 --port 8188`, and the
default arguments are `--base-directory /data`. Any arguments you pass replace
those defaults, so include `--base-directory /data` yourself, for example:

```sh
... ghcr.io/alpineworks/stable-diffusion-containerized:v2.0.0 \
  --base-directory /data --offline --disable-smart-memory
```

## Releases

Releases are cut by semantic-release from conventional commits on `main`, and
each release builds and pushes `ghcr.io/alpineworks/stable-diffusion-containerized:<version>`.
To move to a new ComfyUI version, bump `COMFYUI_VERSION` with a `feat:` commit.
