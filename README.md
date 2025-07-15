# Stable Diffusion Containerized

A Docker container for running Stable Diffusion with GPU acceleration using NVIDIA CUDA.

## Features

- NVIDIA CUDA 11.7.1 runtime support
- Pre-configured Python 3.8.5 environment with PyTorch
- Textual inversion support
- Web UI interface on port 7860
- Support for GFPGAN and RealESRGAN upscaling models

## Requirements

- Docker with NVIDIA container runtime
- NVIDIA GPU with CUDA support
- At least 8GB GPU memory recommended

## Usage

### Building the Image

```bash
docker build -t stable-diffusion .
```

### Running the Container

```bash
docker run --gpus all -p 7860:7860 \
  -v /path/to/models:/models \
  -v /path/to/output:/output \
  -v /path/to/cache:/cache \
  stable-diffusion
```

### Volume Mounts

- `/models` - Directory containing your Stable Diffusion model files (.ckpt)
- `/output` - Directory where generated images will be saved
- `/cache` - Directory for caching transformers and torch models

### Environment Variables

- `CLI_ARGS` - Additional command line arguments for the web UI
- `GFPGAN_PATH` - Path to GFPGAN model (default: `/stable-diffusion/src/gfpgan/experiments/pretrained_models/GFPGANv1.3.pth`)
- `RealESRGAN_PATH` - Path to RealESRGAN model
- `RealESRGAN_ANIME_PATH` - Path to RealESRGAN anime model

## Accessing the Web UI

Once the container is running, access the web interface at `http://localhost:7860`

## Model Requirements

Place your Stable Diffusion model file (usually named `model.ckpt`) in the `/models` directory that you mount to the container.