{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
    };
    kernelModules = ["kvm-intel"];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        extraEntries = {
          "windows.conf" = ''
            title Windows
            efi /EFI/Microsoft/Boot/bootmgfw.efi
          '';
        };
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "resume_offset=41463808"
    ];
    resumeDevice = "/dev/disk/by-label/NIXROOT";
  };

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  networking.hostName = "desktop";

  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    os-prober
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-label/NIXGAMES";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
