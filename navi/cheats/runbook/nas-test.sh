#!/usr/bin/env bash
set -euo pipefail

# Configuration: Reads from environment variables or command-line arguments, with fallback prompts
NAS_HOST="${NAS_HOST:-${1:-}}"
NAS_USERNAME="${NAS_USERNAME:-${2:-}}"
NAS_PASSWORD="${NAS_PASSWORD:-${3:-}}"
NAS_SHARE="${NAS_SHARE:-${4:-}}"

# Check prerequisites
if ! command -v smbclient &> /dev/null; then
    echo "[ERROR] 'smbclient' is not installed. Please install it (e.g., 'sudo apt-get install smbclient' or 'sudo dnf install samba-client')." >&2
    exit 1
fi

# Prompt for missing host
if [[ -z "${NAS_HOST}" ]]; then
    read -r -p "Enter NAS IP or Hostname: " NAS_HOST
fi

# Prompt for missing username
if [[ -z "${NAS_USERNAME}" ]]; then
    read -r -p "Enter NAS Username: " NAS_USERNAME
fi

# Prompt for missing password (hidden input)
if [[ -z "${NAS_PASSWORD}" ]]; then
    read -r -s -p "Enter NAS Password: " NAS_PASSWORD
    echo ""
fi

echo "=========================================="
echo " Starting NAS Health & SMB Check"
echo " Target Host: ${NAS_HOST}"
echo " User:        ${NAS_USERNAME}"
echo "=========================================="

# 1. Port Reachability Check (TCP 445 / 139)
echo -n "[1/3] Checking SMB network port reachability... "
if (echo > "/dev/tcp/${NAS_HOST}/445") 2>/dev/null; then
    echo "OK (Port 445 is open)"
elif (echo > "/dev/tcp/${NAS_HOST}/139") 2>/dev/null; then
    echo "OK (Port 139 is open)"
else
    echo "FAILED"
    echo "[ERROR] Could not establish a TCP connection to ${NAS_HOST} on port 445 or 139." >&2
    exit 1
fi

# 2. Authentication & Share Listing Check
echo "[2/3] Verifying SMB credentials and listing available shares..."
if share_list=$(smbclient -L "//${NAS_HOST}" -U "${NAS_USERNAME}%${NAS_PASSWORD}" -m SMB3 2>&1); then
    echo "  -> Authentication SUCCESSFUL!"
    echo "------------------------------------------"
    echo "${share_list}" | grep -E "Disk|IPC|Printer" || echo "${share_list}"
    echo "------------------------------------------"
else
    echo "  -> Authentication FAILED!"
    echo "[ERROR] smbclient output:" >&2
    echo "${share_list}" >&2
    exit 1
fi

# 3. Optional Specific Share Access Test
if [[ -n "${NAS_SHARE}" ]]; then
    echo "[3/3] Testing access to share: '${NAS_SHARE}'..."
    if smbclient "//${NAS_HOST}/${NAS_SHARE}" -U "${NAS_USERNAME}%${NAS_PASSWORD}" -m SMB3 -c "ls" &>/dev/null; then
        echo "  -> Successfully connected and listed contents of share '${NAS_SHARE}'."
    else
        echo "  -> FAILED to access share '${NAS_SHARE}'. Check permissions or share name." >&2
        exit 1
    fi
else
    echo "[3/3] No specific share provided (NAS_SHARE). Skipping individual share contents test."
fi

echo "=========================================="
echo " NAS SMB Check completed successfully!"
echo "=========================================="
