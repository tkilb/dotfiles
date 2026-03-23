# NVIDIA/Hyprland Troubleshooting Notes (RTX 3080)

## Hardware & Environment
- **OS:** Arch Linux (Fresh Install)
- **Kernel:** 6.19.9-arch1-1 (Plain Linux)
- **GPU:** RTX 3080 (Ampere Architecture)
- **Goal:** Stable boot into Hyprland (Wayland)

## Current Status
- **Issue:** System hangs at "Initial ramdisk" during boot.
- **Last Attempt:** Switched to `nvidia-dkms`, enabled GSP firmware, enabled `fbdev=1`, and disabled "Early KMS" by clearing `MODULES` in `mkinitcpio.conf`.
- **Result:** Still hanging at "Initial ramdisk".

## Configurations Applied
- **Driver:** `nvidia-dkms` with `linux-headers`.
- **Repository:** `multilib` enabled (required for 32-bit libs).
- **Microcode:** Detected and installed (`intel-ucode` or `amd-ucode`).
- **Kernel Params (GRUB):** `nvidia-drm.modeset=1`.
- **Modprobe Options:** `nvidia-drm modeset=1`, `nvidia-drm fbdev=1`, `nvidia NVreg_EnableGpuFirmware=1`.
- **mkinitcpio:** `microcode` and `kms` hooks added; `MODULES=()` (Late KMS).
- **Hyprland Optimization:** Custom NVIDIA application profile created at `/etc/nvidia/nvidia-application-profiles-rc.d/50-hyprland.json` (CRITICAL).

## Known Findings
1. **Early KMS Hang:** Putting `nvidia` modules in `mkinitcpio.conf` (Early KMS) caused a hang.
2. **Late KMS Hang:** Removing modules from `mkinitcpio.conf` (Late KMS) also caused a hang.
3. **GSP Firmware:** Ampere cards generally require GSP firmware (`NVreg_EnableGpuFirmware=1`), but it may be causing issues in some configurations.
4. **Microcode:** If not loaded correctly, the kernel can hang at this exact step.

## Next Steps for Troubleshooting
1. **Try Disabling GSP:** Although usually required, try `NVreg_EnableGpuFirmware=0` with the proprietary driver.
2. **Debug GRUB Params:** Verify no conflicting parameters (like `nomodeset` or `vga=`) are present.
3. **Serial/Log Access:** If possible, boot without `quiet` to see the exact line before the hang.
4. **Integrated Graphics:** Check if an iGPU is interfering (try `blacklist i915` or `blacklist radeon/amdgpu` if applicable).
5. **Microcode Loading:** Verify GRUB is actually loading the `.img` file for microcode.
