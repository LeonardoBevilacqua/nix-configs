# NixOS installation guide

## References

- How to Install NixOS From Scratch | Flakes + Home Manager Full Guide - Tony, BTW
    - [Youtube video](https://youtu.be/2QjzI5dXwDY?si=PW6P9-xWzCwb1y4V)
    - [Guide](https://tonybtw.com/tutorial/nixos-from-scratch/)
- NixOS official installation guide
    - [Installation](https://nixos.org/manual/nixos/stable/index.html#ch-installation)
    - [Manual installation](https://nixos.org/manual/nixos/stable/#sec-installation-manual)
    - [Networking in the installer](https://nixos.org/manual/nixos/stable/#sec-installation-manual-networking)
- [Complete Guide to Disk Partitioning in Linux for Maximum Performance (2025)](https://cavecreekcoffee.com/linux-guides/complete-guide-to-disk-partitioning-in-linux-for-maximum-performance-2025/)

## 0. Starting the live cd

When booting the live cd, if the font size is to small, we can use `setfont -d` to double the font size.

## 1. Checking network

- The boot process should have the networking services running. This will be required by the installer.
- For Wi-Fi, thought `NetworkManager`, use the `nmtui` program or disable the `NetworkManager` with `systemctl stop NetworkManager` to configure manually.

### 1.1. Installation from a different machine (Optional)

We can continue with installation from a different machine, connecting with ssh. To do it we need to:
- Copy our ssh key to either `/home/nixos/.shh/authorized_keys` or `/root/.ssh/authorized_keys`.

## 2. Formatting the drive

- Make sure to switch into sudo with `sudo -i`;
- Use `lsblk` to list the all available blocks of the devices:
    - Should look for `/dev/sdX` or `/dev/vdX`, representing out target driver. The `sdX` represent a traditional physical disk while `vdX` represents a virtual disk.
    - Use `lsblk -f` to list with `filesystem` and label information.
    - We can later include the disc path, with `lsblk /dev/sdX` to only show one, in case of multiple disks.
- There are some tools manage the partitions like `cfdisk`, `fdisk` or `parted`:
    - The "Manual installation" and "Complete Guide to Disk Partitioning in Linux for Maximum Performance (2025)" explains how to do it with `parted` while "How to Install NixOS From Scratch" explains how to do it with `cfdisk`. For this guide, `cfdisk` will be documented.

### 2.1. Setting up the partition scheme with `cfdisk`

For this guide, we'll separate the `/root` and `/home` partitions. If we want to have both in the same partition, we can use the remaining space as `Linux filesystem`.

- Use `cfdisk /dev/sdX` to start the program;
- Select the `gpt labels`. The GUID Partition Table (GPT) partitioning is the modern standard, recommended for must Linux installations;
    - If the disk is not empty, this selection could not show up. Use `cfdisk --zero /dev/sdX` to force a zero partition scheme.
- Set up 1GB for the "`/boot` partition", with the type `EFI System`. Recommended use `FAT32 filesystem` or `ext4 filesystem`.;
    - In this guide we will use `systemd-boot`, which requires `FAT32 filesystem`.
- Set up 8GB or more, based on RAM, for the "Swap partition" with the type `Linux swap`;
- Set up 30-50GB for the "`/root` partition", with the type `Linux filesystem` or `Linux root (x86-64)`. Recommended use `ext4 filesystem`;
- Set up the remaining space for the "`/home` partition", with the type `Linux filesystem` or `Linux home`. Recommended use `ext4 filesystem` or `XFS` for large files, recommended for media servers or big data processing.

Use `lsblk` again to confirm the partitions.

## 3. Format the partitions

- Use `mkfs.fat -F 32 -n boot /dev/sdX1` to format the boot partition;
    - Or `sudo mkfs.ext4 -L boot /dev/sdX1` with not required a `FAT32 filesystem`.
- Use `mkswap -L swap /dev/sdX2` to format the swap partition;
- Use `mkfs.ext4 -L root /dev/sdX3` to format the root partition;
- Use `mkfs.ext4 -L home /dev/sdX4` to format the home partition.

If using one partition for both root and home, use `mkfs.ext4 -L nixos /dev/sdX3`.

## 4. Mounting the partitions

- Use `mount /dev/sdX3 /mnt` to mount the root partition;
- Use `mount --mkdir /dev/sdX1 /mnt/boot` to create a directory, if needed, and mount the boot partition;
- Use `mount --mkdir /dev/sdX4 /mnt/home` to create a directory, if needed, and mount the home partition;
- Use `swapon /dev/sdX2` to enable the swap.

Use `lsblk` again to confirm the mount points.

## 5. Initial NixOS Configuration

For this configuration we will include flakes and home manager.

- Use `nixos-generate-config --root /mnt` to generated the `hadware-configuration.nix` and `configuration.nix`;
- Use `cd /mnt/etc/nixos` to access the folder of the generated files.
- Use `touch flake.nix home.nix` to create the flakes file along with home manager. **NOTE:** those configuration should be moved to this repository when stable, for now we are going to keep clean and separated.
- `flake.nix`:
```nix
{
  description = "Desktop, nickname Bluesun, NixOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.bluesun = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.leonardo = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
```
- `configuration.nix`
```nix
{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bluesun";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles"; # update

  # use cosmic and sway
  # services.displayManager.ly.enable = true;
  # services.xserver = {
  #   enable = true;
  #   autoRepeatDelay = 200;
  #   autoRepeatInterval = 35;
  #   windowManager.qtile.enable = true;
  # };

  users.users.leonardo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    alacritty
    git
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05";

}
```
- `home.nix`
```nix
{ config, pkgs, ... }:

{
  home.username = "leonardo";
  home.homeDirectory = "/home/leonardo";
  programs.git.enable = true;
  home.stateVersion = "26.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };
}
```

### 5.1. Install

- Use `nixos-install --flake /mnt/etc/nixos#bluesun`;
- Use `nixos-enter --root /mnt -c 'passwd leonardo'` to create the user;
- Reboot the system.

### 5.2. Post install notes

- During the installation, the `/boot` partition was formatted as `ext4` while we were trying to install `systemd-boot`. This caused an error, since it requires a `FAT32 filesystem`. To fix the issue:
    - Used `umount /mnt/boot` to unmount the boot partition;
    - Used `mkfs.fat -F 32 -n boot /dev/sdX1` to reformatted to `FAT32`;
    - Used `mount /dev/sdX1 /mnt/boot` to mount the boot partition again;
    - Used `nixos-generate-config --root /mnt` to regenerate the `hadware-configuration.nix`.
