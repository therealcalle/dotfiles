#!/bin/bash
# ╔══════════════════════════════════════╗
# ║  GPU Module - Bisexual Color Scheme  ║
# ╚══════════════════════════════════════╝

PURPLE="#b07cd8"
DIM="#7a6f96"

# ── Query all GPU data in one call ──
QUERY=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total,name,driver_version --format=csv,noheader,nounits 2>/dev/null)

if [ -z "$QUERY" ]; then
    echo '{"text": "<span color=\"#b07cd8\">󰍛  N/A</span>", "tooltip": "GPU not detected", "class": "gpu"}'
    exit 0
fi

GPU_USAGE=$(echo "$QUERY" | awk -F, '{print $1}' | tr -d ' ')
TEMP=$(echo "$QUERY" | awk -F, '{print $2}' | tr -d ' ')
MEM_USED=$(echo "$QUERY" | awk -F, '{print $3}' | tr -d ' ')
MEM_TOTAL=$(echo "$QUERY" | awk -F, '{print $4}' | tr -d ' ')
GPU_NAME=$(echo "$QUERY" | awk -F, '{print $5}' | xargs)
DRIVER=$(echo "$QUERY" | awk -F, '{print $6}' | xargs)

# ── Memory calculations ──
if [ "$MEM_TOTAL" -gt 0 ] 2>/dev/null; then
    MEM_PCT=$((MEM_USED * 100 / MEM_TOTAL))
else
    MEM_PCT=0
fi

MEM_USED_GIB=$(awk "BEGIN {printf \"%.1f\", ${MEM_USED}/1024}")
MEM_TOTAL_GIB=$(awk "BEGIN {printf \"%.1f\", ${MEM_TOTAL}/1024}")

# ── Rich Tooltip (newlines escaped as \n for JSON) ──
tooltip="┌─ ${GPU_NAME}\\n├─ Usage: ${GPU_USAGE}%\\n├─ Temp:  ${TEMP}°C\\n├─ VRAM:  ${MEM_USED_GIB} / ${MEM_TOTAL_GIB} GiB (${MEM_PCT}%)\\n└─ Driver: ${DRIVER}"

# ── Bar Output: 󰍛 20% · 49°C ──
text="<span color='${PURPLE}'>󰍛 ${GPU_USAGE}%</span> <span color='${DIM}'>·</span> <span color='${PURPLE}'>${TEMP}°C</span>"

printf '{"text": "%s", "tooltip": "%s", "class": "gpu"}\n' "$text" "$tooltip"
