# syntax=docker/dockerfile:1
#
# ComfyUI on CUDA 13 (PyTorch cu130 wheels, which bundle the CUDA runtime; the
# host only needs the NVIDIA driver, 580+). Runs as a non-root user with the
# application read-only under /opt/ComfyUI. Everything ComfyUI writes (models,
# custom_nodes, input, output, temp, user) lives under --base-directory /data,
# and HOME points at /tmp for library caches.
FROM python:3.13-slim-trixie

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# renovate: datasource=github-releases depName=comfyanonymous/ComfyUI
ARG COMFYUI_VERSION=v0.44.0
ARG TORCH_VERSION=2.14.1
ARG TORCH_INDEX_URL=https://download.pytorch.org/whl/cu130

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_ROOT_USER_ACTION=ignore \
    HOME=/tmp

ADD https://github.com/comfyanonymous/ComfyUI/archive/refs/tags/${COMFYUI_VERSION}.tar.gz /tmp/comfyui.tar.gz

# Install torch from the CUDA index first, then pin what it resolved so the
# ComfyUI requirements cannot swap it for a different build from PyPI.
RUN mkdir -p /opt/ComfyUI \
    && tar -xzf /tmp/comfyui.tar.gz -C /opt/ComfyUI --strip-components=1 \
    && rm /tmp/comfyui.tar.gz \
    && pip install --index-url "${TORCH_INDEX_URL}" "torch==${TORCH_VERSION}" torchvision \
    && pip freeze | grep -E '^(torch|torchvision)==' > /tmp/torch-constraints.txt \
    && pip install -c /tmp/torch-constraints.txt -r /opt/ComfyUI/requirements.txt \
    && rm /tmp/torch-constraints.txt \
    && python -m compileall -q /opt/ComfyUI \
    && useradd --uid 1000 --user-group --no-create-home --home-dir /tmp comfy \
    && mkdir -p /data \
    && chown comfy:comfy /data

COPY --chmod=0755 entrypoint.sh /usr/local/bin/comfyui-entrypoint

ENV COMFYUI_DATA=/data
WORKDIR /opt/ComfyUI
USER 1000:1000
EXPOSE 8188
VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/comfyui-entrypoint"]
CMD ["--base-directory", "/data"]
