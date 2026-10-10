# Bluesun

Desktop used for development and entertainment.

## TODO

- [ ] Refactor sway specialisation:
    - [x] Move to own file;
    - [ ] Fix bleeding packages (heroic).
- [ ] Add plymouth.
- [x] Fix `leodev` user losing password.
- [x] Fix warnings:
    - `evaluation warning: leodev profile: The option 'qt.platformTheme' has been renamed to 'qt.platformTheme.name'.`
    - `evaluation warning: leodev profile: The value 'gnome' for option 'qt.platformTheme' is deprecated. Use 'adwaita' instead.`
- [ ] Update DNS server.

## History

- 2026-08-24:
    - the nvidia legacy driver 580.142 and Linux kernel 7.2.7 had the conflict, `error: implicit declaration of function 'strncpy'`, see [build failure: linuxkernel.packages.linux_7_2.nvidia_x11](https://github.com/nixos/nixpkgs/issues/554125). To resolve this i had to manually set the `hardware.nvidia.package` using the `config.boot.kernelpackages.nvidiapackages.mkdriver`:
    ```nix
    hardware.nvidia.package = config.boot.kernelpackages.nvidiapackages.mkdriver {
        version = "595.91.07";
        sha256_64bit = "sha256-yipijdjlb6grze4eec+3vn11nzbxsa9a+yabiwleyxm=";
        sha256_aarch64 = "sha256-fqkn7onfxttexyu2mqxorrk362epxq3bz88hhkyqzwq=";
        opensha256 = "sha256-ob8epd+qn/wywxspifpxeoazljqb6i1syrov3a8l71k=";
        settingssha256 = "sha256-qzt8cw1luuzgp9duje3hn/0ngiayqhurj+bqpsxlj5w=";
        persistencedsha256 = "sha256-3jqbanmkwxvcxv9q8ahkas6vzm/jjlsuilc2t7et0u0=";
    };
    ```
    - this was fixed with [\[backport release-26.05\] linuxpackages.nvidiapackages.legacy_580: 580.173.02 -> 580.178.04](https://github.com/nixos/nixpkgs/pull/563993) but I'll keep the current `mkdriver` version for now since has no conflict with the system and is newer than the current one from nixos-26.05, `595.91.03 > 595.71.05`.
- 2026-10-06:
    - the `specialisation.sway.config` was migrated from the `default.nix` to `sway-configuration.nix`. This change requires the creating of new flakes part module and pass the module in the `specialArgs` from `configuration.nix`:
    ```nix
        specialArgs = {
            inherit inputs;
            swayDesktopModule = config.flake.modules.nixos.sway-desktop;
        };
    ```
