{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.config.allowUnfree = true;

  # Verify the ESP mount point in hardware-configuration.nix.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "HP";
  networking.networkmanager.enable = true;
  zramSwap.enable = true;
  time.timeZone = "Asia/Riyadh";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.Mohannad.isNormalUser = true;
  users.users.Mohannad.extraGroups = [ "wheel" "networkmanager" "video" ];

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  services.xserver.xkb.layout = "us,ara";
  services.xserver.xkb.options = "grp:alt_shift_toggle";

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  hardware.nvidia.open = false;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.prime.offload.enable = true;
  hardware.nvidia.prime.offload.enableOffloadCmd = true;

  # Verify both addresses with lspci before applying.
  hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";

  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "none+openbox";
  services.xserver.windowManager.openbox.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.thunar.enable = true;

  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-color-emoji
  ];

  environment.systemPackages = with pkgs; [
    nano
    vim
    git
    wget
    htop
    pciutils
    mesa-demos

    picom
    obconf
    tint2
    rofi

    waybar
    hyprpaper
    hypridle
    hyprlock
    fuzzel
    foot

    alacritty
    yazi
    pavucontrol
    brightnessctl
    networkmanagerapplet
    polkit_gnome
    dunst

    brave-origin
    # helium
    quickshell
    zed-editor
    qt6.qtdeclarative

    feh
    wmctrl
    xdotool
  ];

  # Startup for the X11 session. Hyprland startup is configured separately.
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.tint2}/bin/tint2 &
    ${pkgs.picom}/bin/picom &
    ${pkgs.networkmanagerapplet}/bin/nm-applet &
    ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
    ${pkgs.dunst}/bin/dunst &
    ${pkgs.alacritty}/bin/alacritty &
  '';

  # Preserve the original installation's stateVersion.
  system.stateVersion = "26.05";
}
