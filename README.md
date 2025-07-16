# Stable Diffusion Containerized

⚠️ **WORK IN PROGRESS** - This project is actively under development and currently optimized specifically for NVIDIA RTX 5000 series GPUs.

A Docker container for running Stable Diffusion with GPU acceleration using NVIDIA CUDA.

## Features

- NVIDIA CUDA runtime support with latest drivers
- Pre-configured Python environment with PyTorch
- Web UI interface on port 7860
- Optimized for RTX 5xxx GPU architecture
- Support for modern Stable Diffusion models

## Requirements

- Docker with NVIDIA container runtime
- **NVIDIA RTX 5000 series GPU** (primary target)
- At least 12GB GPU memory recommended
- Latest NVIDIA drivers (570+ series recommended)

## Usage

### Building the Image

```bash
docker build -t stable-diffusion .
```

### Running the Container

```bash
docker run --gpus all -p 7860:7860 stable-diffusion
```

## Accessing the Web UI

Once the container is running, access the web interface at `http://localhost:7860`

## Model Requirements

Currently, this automatically downloads all models