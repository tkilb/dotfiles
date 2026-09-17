# Runbook: Setting Up Ollama with Docker & GPU on Arch Linux

This runbook guides you through deploying **Ollama** inside Docker with **NVIDIA GPU acceleration** on Arch Linux, configuring CLI access, and setting up an interactive AI coding assistant that provides an **`agy`**-like workflow in your terminal.

---

## 1. Prerequisites (Arch Linux & NVIDIA Drivers)

### 1.1. Install Docker & NVIDIA Container Toolkit

Ensure proprietary NVIDIA drivers, Docker, and the NVIDIA container toolkit are installed on Arch Linux:

```bash
# Install Docker, Docker Compose plugin, and NVIDIA container toolkit
sudo pacman -Syu docker docker-compose nvidia-container-toolkit

# IMPORTANT (Arch Linux): If pacman updated the Linux kernel or NVIDIA drivers,
# reboot before starting system services so the running kernel matches /lib/modules/
sudo reboot
```

After rebooting:

```bash
# Configure the Docker daemon to use the NVIDIA container runtime
sudo nvidia-ctk runtime configure --runtime=docker

# Enable and start Docker service
sudo systemctl enable --now docker.service
sudo systemctl restart docker.service

# (Optional) Add your user to the docker group to run without sudo
sudo usermod -aG docker "$USER"
newgrp docker
```

### 1.2. Verify GPU Detection in Docker

Test that Docker can access your NVIDIA GPU:

```bash
docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi
```

_You should see your NVIDIA GPU model, driver version, and VRAM output._

---

## 2. Deploy Ollama via Docker

You can run Ollama using either a direct `docker run` command or `docker-compose`.

### Option A: Direct Docker Run (Recommended)

Run the Ollama container with GPU passthrough and a persistent volume for downloaded models:

```bash
docker run -d \
  --name ollama \
  --restart unless-stopped \
  --gpus all \
  -v ollama_models:/root/.ollama \
  -p 11434:11434 \
  ollama/ollama:latest
```

### Option B: Docker Compose

*(Requires `sudo pacman -S docker-compose` if not installed during Step 1.1)*

Create a `docker-compose.yml` file:

```yaml
services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    ports:
      - "127.0.0.1:11434:11434"
    volumes:
      - ollama_models:/root/.ollama
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]

volumes:
  ollama_models:
```

Start the container:

```bash
docker compose up -d
```

---

## 3. Configuring Native CLI Access

To run `ollama` commands seamlessly in your shell without typing `docker exec` each time:

### Method 1: Shell Alias / Function

Add the following alias to your `~/.bashrc` or `~/.zshrc`:

```bash
# Direct Ollama CLI wrapper via Docker
alias ollama="docker exec -it ollama ollama"
```

Reload your shell:

```bash
source ~/.bashrc   # or source ~/.zshrc
```

### Method 2: Native Arch Linux Package (Client Only)

You can also install the official Ollama package on Arch and point it to your Docker container daemon:

```bash
sudo pacman -S ollama
export OLLAMA_HOST="http://127.0.0.1:11434"
```

_(Add `export OLLAMA_HOST="http://127.0.0.1:11434"` to your shell profile)_

---

## 4. Downloading Recommended Models

Pull models suited for general coding and conversation based on your VRAM:

| Model                   | Parameters | Minimum VRAM | Best For                               | Command                         |
| ----------------------- | ---------- | ------------ | -------------------------------------- | ------------------------------- |
| **Qwen 2.5 Coder**      | `7b`       | 6 GB         | Fast, excellent coding & reasoning     | `ollama pull qwen2.5-coder:7b`  |
| **Qwen 2.5 Coder**      | `14b`      | 10–12 GB     | Stronger logic & multi-file coding     | `ollama pull qwen2.5-coder:14b` |
| **DeepSeek R1 Distill** | `8b`       | 8 GB         | Deep reasoning & architecture planning | `ollama pull deepseek-r1:8b`    |
| **Llama 3.1**           | `8b`       | 8 GB         | General conversation & writing         | `ollama pull llama3.1:8b`       |

Download your preferred model:

```bash
ollama pull qwen2.5-coder:7b
```

---

## 5. Setting Up an `agy`-like Agent CLI Experience

By default, running `ollama run <model>` provides a basic text chat REPL. To get an interactive agent experience like **`agy`** (capable of inspecting project files, making in-place code edits, running git operations, and pairing in your terminal), we configure **Aider** against your local Ollama instance.

### 5.1. Install the CLI Agent

Install `pipx` (or use a virtualenv) to install the CLI tool cleanly on Arch:

```bash
sudo pacman -S python-pipx
pipx ensurepath
pipx install aider-chat
```

### 5.2. Launching the Agent with Local Ollama

> [!NOTE]
> **No sign-in or API keys are required.** Running `aider` with the `ollama_chat/...` prefix tells it to talk exclusively to your local Docker container on `127.0.0.1:11434` without any external accounts or telemetry. (Running `aider` bare without flags defaults to OpenAI/Anthropic and asks to sign in).

Aider requires running inside a git repository (or using `--no-git`). Set `OLLAMA_API_BASE` and run:

```bash
export OLLAMA_API_BASE="http://127.0.0.1:11434"

# Using Qwen 2.5 Coder 7B (100% local, no login required)
aider --model ollama_chat/qwen2.5-coder:7b --no-analytics

# Or using Qwen 2.5 Coder 14B (if you have >= 12GB VRAM)
aider --model ollama_chat/qwen2.5-coder:14b --no-analytics
```

### 5.3. Create an `agy`-style Shell Shortcut

To launch this workflow with a single command from any project directory, add this alias and environment variable to your `~/.bashrc` or `~/.zshrc`:

```bash
# Local Ollama endpoint for CLI tools
export OLLAMA_API_BASE="http://127.0.0.1:11434"

# Launch local coding assistant like agy
alias local-agy="aider --model ollama_chat/qwen2.5-coder:7b --no-analytics"
```

### 5.4. How to Use the Agent Workflow

Once launched in a git repository:

1. **Add files to context**: `/add src/main.py` or `/add file.go`
2. **Ask the agent to modify code**: `Add unit tests for the login function`
3. **Ask questions / review code**: `Explain how the authentication middleware works`
4. **Run terminal commands**: `!npm test` or `!pytest`
5. **Exit**: `/exit` or `Ctrl+D`

---

## 6. Verification and Maintenance

### Check Container Status & Logs

```bash
docker ps -f name=ollama
docker logs -f ollama
```

### Verify GPU Utilization During Inference

In another terminal, monitor GPU utilization:

```bash
watch -n 1 nvidia-smi
```

### Updating Ollama

To update the Ollama container image to the latest release:

```bash
docker pull ollama/ollama:latest
docker stop ollama
docker rm ollama
# Re-run the docker run command from Step 2
```

---

## 7. Troubleshooting

- **`permission denied while trying to connect to the Docker daemon socket`**:
  - **Cause**: The user was added to the `docker` group, but the current terminal session hasn't refreshed group tokens.
  - **Fix**: Run `newgrp docker` in your current terminal session, or log out and log back in.
- **`docker.service` fails with `iptables failed: Could not fetch rule set generation id: Invalid argument`**:
  - **Cause (Arch Linux Kernel Mismatch)**: Arch removes older kernel modules when the kernel is updated. If `uname -r` does not match the modules directory in `/lib/modules/`, Docker cannot load required `ip_tables`/`nf_tables` modules.
  - **Fix**: Reboot your system to boot into the newly installed kernel (`sudo reboot`).
- **`nvidia-smi` fails inside Docker**: Ensure `nvidia-ctk runtime configure --runtime=docker` was run and `docker.service` was restarted.
- **Out of Memory (OOM) / Slow CPU fallback**: If the model size exceeds your available VRAM, Ollama offloads layers to system RAM/CPU. Use a smaller quantization or parameter size (e.g. `qwen2.5-coder:7b` instead of `14b`).
- **Connection Refused on 11434**: Verify the container is running with `docker ps` and port `11434` is bound properly.
