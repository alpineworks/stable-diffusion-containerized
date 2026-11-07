#!/bin/sh
# ComfyUI expects these under --base-directory and fails to start without
# custom_nodes. Create them on an empty volume, then hand over to ComfyUI.
set -eu
data="${COMFYUI_DATA:-/data}"
mkdir -p "$data/custom_nodes" "$data/models" "$data/input" "$data/output" \
  "$data/temp" "$data/user"
exec python /opt/ComfyUI/main.py --listen 0.0.0.0 --port 8188 "$@"
