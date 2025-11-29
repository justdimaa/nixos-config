# ❄️ NixOS Flake Configuration

![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)
![KDE Plasma](https://img.shields.io/badge/Desktop-KDE_Plasma_6-blueviolet?style=flat-square&logo=kde)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)
![Home Manager](https://img.shields.io/badge/Home_Manager-Disabled-red?style=flat-square)

My personal multi-host NixOS configuration using Flakes. It's nothing fancy, just the setup I run on my machines, keeping things simple by avoiding Home Manager.

---

## ✨ Features

### 🛡️ Core & Security

- **Flakes:** Modern, reproducible Nix configuration.
- **LUKS Encryption:** Full disk encryption (host-specific configuration).
- **Lanzaboote:** Secure Boot support.
- **Fish Shell:** Default user shell with organized config.
- **Automatic GC:** Weekly garbage collection to keep disk usage low.

### 🖥️ Desktop & Hardware

- **KDE Plasma 6:** Wayland session enabled by default.
- **NVIDIA:** Proprietary driver support included.
- **Audio:** Modern PipeWire setup.
- **Connectivity:** Full Bluetooth and network support.

### 📦 Services & Programs (Optional)

- **Virtualization:** Docker and Virt-Manager (KVM/QEMU).
- **Flatpak:** Universal package support (requires one-time setup).
- **RGB:** OpenRGB / LedFx support.
- **Tools:** VS Code, Git, direnv, OBS Studio, Audacity.

---

## 🚀 Initial Setup

Follow these steps to bootstrap a new machine.

### 1. Generate Hardware Configuration

Replace the default hardware configuration with the one specific to your current machine:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/desktop/hardware-configuration.nix
```

### 2. Update UUIDs

You must update the configuration files with your disk's specific UUIDs.

**Find your UUIDs:**

```bash
lsblk -f
# or
blkid
```

**Update the files:**

1.  `hosts/desktop/hardware-configuration.nix`: Update file system UUIDs.
2.  `hosts/desktop/configuration.nix`: Update the **LUKS encrypted partition UUID**.

> **⚠️ Important:** The LUKS UUID is host-specific. Failing to update this will prevent the system from booting.

### 3. Customize Settings

Edit the following core modules to fit your preferences:

- `modules/core/locale.nix`: Timezone and locale settings.
- `modules/core/users.nix`: Username and user description.
- `modules/core/network.nix`: Hostname and network settings.
- `hosts/desktop/configuration.nix`: Uncomment services/programs as needed.

### 4. Set Up Secure Boot (Lanzaboote)

**Do not** enable Secure Boot in BIOS yet. Perform these steps first:

```bash
# 1. Generate Secure Boot keys
sudo sbctl create-keys

# 2. Build and switch to the new configuration
sudo nixos-rebuild switch --flake .#desktop

# 3. Enroll keys (System must be in BIOS Setup Mode)
sudo sbctl enroll-keys --microsoft

# 4. Verify status
sudo sbctl status
```

_Once verified, you may enable Secure Boot in your BIOS._

### 5. Build & Switch

Apply the configuration to your system:

```bash
# Option A: Switch immediately
sudo nixos-rebuild switch --flake .#desktop

# Option B: Apply on next boot
sudo nixos-rebuild boot --flake .#desktop
```

---

## ➕ Adding New Hosts

To add a second machine (e.g., a laptop):

1.  **Create Directory:**

    ```bash
    mkdir -p hosts/laptop
    ```

2.  **Generate Configs:**

    ```bash
    cp hosts/desktop/configuration.nix hosts/laptop/
    sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
    ```

3.  **Update `flake.nix`:**
    Add the new host entry to the outputs:

    ```nix
    laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/laptop/configuration.nix
        lanzaboote.nixosModules.lanzaboote
      ];
    };
    ```

4.  **Deploy:**
    ```bash
    sudo nixos-rebuild switch --flake .#laptop
    ```

---

## 🛠️ Management & Maintenance

### Updates

```bash
# Update flake inputs (nixpkgs, etc)
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake .#desktop --upgrade
```

### Flatpak Setup

Flatpak requires a one-time repo addition after the first boot:

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

### Useful Commands Cheat Sheet

| Action               | Command                                                                  |
| :------------------- | :----------------------------------------------------------------------- |
| **Check Flake**      | `nix flake show`                                                         |
| **Dry Run**          | `nix flake check`                                                        |
| **List Generations** | `sudo nix-env --list-generations --profile /nix/var/nix/profiles/system` |
| **Rollback**         | `sudo nixos-rebuild switch --rollback`                                   |
| **Garbage Collect**  | `sudo nix-collect-garbage -d`                                            |

---

## ❓ Troubleshooting

| Issue             | Solution                                                                                                                   |
| :---------------- | :------------------------------------------------------------------------------------------------------------------------- |
| **NVIDIA Issues** | Check `nvidia-smi`. If using a very new GPU, try setting `hardware.nvidia.open = true;`.                                   |
| **Secure Boot**   | Verify keys with `sudo sbctl status`. Ensure BIOS is in Setup Mode. Re-enroll with `sudo sbctl enroll-keys --microsoft`.   |
| **LUKS Locked**   | Double-check the UUID in `hosts/<host>/configuration.nix`. Ensure `cryptsetup` is in `boot.initrd.availableKernelModules`. |
| **No Audio**      | Check service: `systemctl --user status pipewire`. Use `pavucontrol` to manage outputs.                                    |
