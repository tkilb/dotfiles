# NVIDIA Driver Installation Troubleshooting Notes (RTX 3080 / Arch / Hyprland)

## Common Issues & Solutions

### 1. Black Screen on Boot (Wayland/Hyprland)
- **Cause:** `nvidia-drm.modeset=1` is missing from kernel parameters.
- **Solution:** Ensure `GRUB_CMDLINE_LINUX_DEFAULT` in `/etc/default/grub` includes `nvidia-drm.modeset=1`.
- **Note:** For newer kernels (6.11+), `nvidia-drm.fbdev=1` is also recommended.

### 2. Screen Tearing or Flickering
- **Cause:** Missing DRM Kernel Mode Setting (KMS) or hardware cursor issues.
- **Solution:** 
    - Ensure `nvidia-drm.modeset=1` is set.
    - Set environment variable `WLR_NO_HARDWARE_CURSORS=1` for Hyprland.

### 3. Hyprland Fails to Start
- **Cause:** NVIDIA modules not loaded early enough or environment variables missing.
- **Solution:** 
    - Add `nvidia nvidia_modeset nvidia_uvm nvidia_drm` to `MODULES` in `/etc/mkinitcpio.conf`.
    - Set `LIBVA_DRIVER_NAME=nvidia`, `XDG_SESSION_TYPE=wayland`, `GBM_BACKEND=nvidia-drm`, `__GLX_VENDOR_LIBRARY_NAME=nvidia`.

### 4. Pacman Updates Breaking Drivers
- **Cause:** Kernel update without rebuilding NVIDIA modules.
- **Solution:** Use `nvidia-dkms` instead of `nvidia`.
- **Precaution:** Ensure a pacman hook exists in `/etc/pacman.d/hooks/nvidia.hook` to trigger `mkinitcpio -P` after NVIDIA driver updates.

### 5. 32-bit Games (Steam) Not Launching
- **Cause:** Missing 32-bit libraries.
- **Solution:** Enable `[multilib]` in `/etc/pacman.conf` and install `lib32-nvidia-utils`.

### 6. "nouveau" Conflicts
- **Cause:** The open-source `nouveau` driver is still active.
- **Solution:** Blacklist `nouveau` (though installing `nvidia` drivers usually does this automatically). The early loading of `nvidia` modules also helps.

## Verification Commands
- `nvidia-smi`: Check if the GPU is recognized and driver is active.
- `lsmod | grep nvidia`: Confirm modules are loaded.
- `cat /sys/module/nvidia_drm/parameters/modeset`: Should return `Y`.
- `cat /proc/cmdline`: Verify kernel parameters are applied.
