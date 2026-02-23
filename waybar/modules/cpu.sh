#!/bin/bash
# ╔══════════════════════════════════════╗
# ║  CPU Module - Bisexual Color Scheme  ║
# ╚══════════════════════════════════════╝

PINK="#d4679a"
DIM="#7a6f96"

# ── CPU Temperature ──
temp=$(sensors | grep Tctl | awk '{printf "%d", $2}' | tr -d '+°C')

# ── CPU Usage (two-snapshot delta from /proc/stat) ──
read -r cpu user nice system idle iowait irq softirq steal _ _ < /proc/stat
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
prev_idle=$((idle + iowait))

sleep 0.5

read -r cpu user nice system idle iowait irq softirq steal _ _ < /proc/stat
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_now=$((idle + iowait))

total_diff=$((total - prev_total))
idle_diff=$((idle_now - prev_idle))

if [ "$total_diff" -gt 0 ]; then
    cpu_usage=$((100 * (total_diff - idle_diff) / total_diff))
else
    cpu_usage=0
fi

# ── Rich Tooltip (newlines escaped as \n for JSON) ──
cpu_model=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | xargs)
core_count=$(nproc)
core_temps=$(sensors | grep -E "Tccd|Tctl" | sed 's/^[[:space:]]*/  /' | sed 's/  (.*//' | tr '\n' '|' | sed 's/|/\\n/g' | sed 's/\\n$//')

tooltip="┌─ ${cpu_model}\\n├─ Cores: ${core_count}\\n├─ Usage: ${cpu_usage}%\\n├─ Temp:  ${temp}°C\\n└─ Sensors:\\n${core_temps}"

# ── Bar Output:  42% · 58°C ──
text="<span color='${PINK}'>󰻠 ${cpu_usage}%</span> <span color='${DIM}'>·</span> <span color='${PINK}'>${temp}°C</span>"

printf '{"text": "%s", "tooltip": "%s", "class": "cpu"}\n' "$text" "$tooltip"
