# SSH Key für die Konfiguration nach /etc/ssh/ssh_host_ed25519_key kopieren
# # cd /etc/nixos/secrets 
# # agenix -e xyz.age 

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./files/files.nix
      "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/modules/age.nix"
    ];

  nixpkgs.overlays = [ (import ./firefox-overlay.nix) ];

  age.secrets.passwordFile.file = secrets/passwordFile.age;
  age.secrets.wireguard-privateKey.file = secrets/wireguard-privateKey.age;

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.devices = [
    "nodev"
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl88xxau-aircrack
  ];

  fileSystems."/debian_homeserver/opt" = {
    device = "${pkgs.sshfs}/bin/sshfs#root@DebianHomeserver:/opt/";
    fsType = "fuse";
    options = [ "defaults,allow_other,_netdev,reconnect,delay_connect,ConnectTimeout=5,ServerAliveInterval=5" ];
  };

  fileSystems."/nl/user" = {
    device = "${pkgs.sshfs}/bin/sshfs#user@nl:/home/user";
    fsType = "fuse";
    options = [ "defaults,allow_other,_netdev,reconnect,delay_connect,ConnectTimeout=5,ServerAliveInterval=5" ];
  };

  fileSystems."/mnt/NAS" = {
    device = "//nas.hai.internal/Daten";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      other_opts = "uid=1000,gid=100,file_mode=0660,dir_mode=0770";
    in ["${automount_opts},${other_opts},credentials=/etc/samba/smb-secrets"];
  };

  networking.hostName = "nixos-ux490ua"; # Define your hostname.
  networking.hosts = {
    "192.168.2.30" = [ "nas.hai.internal" "nas" ];
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.utf8";
    LC_IDENTIFICATION = "de_DE.utf8";
    LC_MEASUREMENT = "de_DE.utf8";
    LC_MONETARY = "de_DE.utf8";
    LC_NAME = "de_DE.utf8";
    LC_NUMERIC = "de_DE.utf8";
    LC_PAPER = "de_DE.utf8";
    LC_TELEPHONE = "de_DE.utf8";
    LC_TIME = "de_DE.utf8";
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.yubikey-agent.enable = true;
  services.pcscd.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  console.keyMap = "de";

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.pki.certificates = [
    "-----BEGIN CERTIFICATE-----
MIID3DCCAsSgAwIBAgIBADANBgkqhkiG9w0BAQsFADBrMQswCQYDVQQGEwJERTEM
MAoGA1UECAwDTlJXMQwwCgYDVQQHDANXSUwxCzAJBgNVBAoMAklUMSIwIAYJKoZI
hvcNAQkBFhNub3JlcGx5QGV4YW1wbGUub3JnMQ8wDQYDVQQDDAZoYWktY2EwHhcN
MjEwNTEwMDU1MzIwWhcNMzEwNTA4MDU1MzIwWjBrMQswCQYDVQQGEwJERTEMMAoG
A1UECAwDTlJXMQwwCgYDVQQHDANXSUwxCzAJBgNVBAoMAklUMSIwIAYJKoZIhvcN
AQkBFhNub3JlcGx5QGV4YW1wbGUub3JnMQ8wDQYDVQQDDAZoYWktY2EwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC5H8P4bUaQXojOsbuk90LR7RpzTnR2
UMFIU4rjOt6DLrsRa8eIB/SV87d3fNqJHTZgDQUMEOc9L/s3DavED4ySuV1arrkN
2YLV9nBLFM6Gcrb0Mtqg7Q8lSh5RumP/6DXjEu80gT8NXhGmlWgy7nmhmB52VMfn
T3m1RZVtiMk4HzpOuCz64As2NvMx0Yx0okqem2bkAwJyOplxWhqMF04Lx0v3tBNn
Loc0ExmMOh7HAZau6+r8hmRifuxXyqPTcpsz68THMyiVuvCe5sDz+Ftvxan3Mzmb
sb2fNa7yKmyll9B71Lp16cyhyDQPfwjzgXbpo0bqknksFO4a27uct8zHAgMBAAGj
gYowgYcwNwYJYIZIAYb4QgENBCoWKE9QTnNlbnNlIEdlbmVyYXRlZCBDZXJ0aWZp
Y2F0ZSBBdXRob3JpdHkwHQYDVR0OBBYEFK+3nr5jV8KG5BoJOGxU+B46TyfwMB8G
A1UdIwQYMBaAFK+3nr5jV8KG5BoJOGxU+B46TyfwMAwGA1UdEwQFMAMBAf8wDQYJ
KoZIhvcNAQELBQADggEBAIrcxB0MfuVWCP5CVaHRgw4CVxCvasWOv3j60kIxpN5j
YxMIm3N36QN5LRT3u0+A3d9wGC7uLvpYSEqIwi/hjKnL/wTMGFFFJFCfbLavMNt+
SXKOiCmpTWC3HanSHfKkhMEd+JvdO6QEh8dUmcr/Ny0O9baWhN++su2rgPNGtGWG
xKfVO9IbxUJcUe9nuIyI33d6hDcUMk55P6LrDH2pc1/e8rGcwVQAomidSwOUxRUk
pbvzpdzSEvDP3lP60iMPfAsSIp8SwYKppBNOSEm4VeiblqS1Q7V4HnNa/t3/aRQ/
B7XnqjYYN05lAQi1/X1lChU5I+z8HebQAR2THGGPK9k=
-----END CERTIFICATE-----
"
  ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver.libinput.enable = true;

  users.mutableUsers = false;
  
  users.groups.ubuntuusers = {
    gid = 1000;
    members = [ "user" "rslsync" ];
  };

  users.users.rslsync = {
    extraGroups = [ "users" ];
  };

  users.users.user = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "networkmanager" "wheel" "lxd" "vboxusers" "rslsync" "kvm" "libvirtd"];
    passwordFile = config.age.secrets.passwordFile.path;
    shell = "/run/current-system/sw/bin/bash";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYq5oYSD9f4WIj44eAtGLL7bigg7hK14eZs18AHIsSV8sUnEbwsVJy0+tWE6uBMuxqEskglrzHe6+7PC6IE2fNvpPHFHLR5SE/MG6dAIbRR9xnBZnyEFl6EVVLb3gArpqVscouOR7AxojKyEJ2y6ep3oDPb9FJIf8jsqaBEnAGwtYZZK666l1Y+ZDIVWmYH26FEDJnZqC3vfzvQm1wxFHJI2XYn7q8ZkYUji1gi8DxDprM+C+IVPGUQ37j4QGI2exftpFSdpZRu1HSZa1h8/PDd1MXtEqH6gBR5O67UP3pWmZ/Eh7Az/npblX+Bs4QT1hkOrSupY4Vy/DG6MEmtSCsweSQkx0KVYXuaJ1kMt8V8wjix372bJFqZ+Q7SIDnjCqsuXObgP3DX3dyYZcYlFnGtQWj1TSubYERwi8YlfUAqnP6WzaSFg9imHy8+ddGbdRGO2Rw1opGvP4RsUXQz3bFbufo0wFkKRgLn5XZBotO1AgwOTVnZNTOm7Z0Hk2cSIU= andre@p330tiny"
    ];
    packages = with pkgs; [
      fira
      thunderbird
      keepassxc
      resilio-sync
      tdesktop
      kopia
      sublime4
      python311.pkgs.urllib3
    ];
  };

  systemd.user.services.dconf-overrides = {
    script = ''
      /run/current-system/sw/bin/dconf load / </etc/nixos/misc/dconf_dump
    '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  systemd.user.services.firefox-prefs-overrides = {
    path = with pkgs; [ nix ];
    script = ''
      /etc/nixos/misc/scripts/firefox_set_user_prefs.py /etc/nixos/misc/user.js
    '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  nixpkgs.config.allowUnfree = true;
  
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  services.mullvad-vpn.enable = true;

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/pkgs/agenix.nix" {})
    wget
    bat
    delta
    ncdu
    cifs-utils
    gcc
    ifmetric
    cargo
    rustc
    git
    gnome.gedit
    virt-manager
    libvirt
    gnome.gnome-terminal
    gnome.dconf-editor
    gnome.gnome-tweaks
    chrome-gnome-shell
    dig
    fd
    libheif
    gdk-pixbuf
    sshfs
    latest.firefox-nightly-bin
    gthumb
    iodine
    q
    starship
    gnomeExtensions.dash-to-dock
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.wifi-qrcode
  ];

  environment.shellAliases = {
    l = "ls -l --color";
    ll = "ls -la --color";
    yubissh = "export SSH_AUTH_SOCK=\"\${XDG_RUNTIME_DIR}/yubikey-agent/yubikey-agent.sock\"";
  };

  programs.mtr.enable = true;
  
  programs.gnupg.agent = {
   enable = true;
   enableSSHSupport = true;
  };
  
  programs.gnome-terminal.enable = true;
  
  programs.nano.nanorc = "
    set nowrap
    set tabstospaces
    set tabsize 2
  ";

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  services.resilio = {
    enable = true;
    httpListenPort = 8888;
    httpListenAddr = "127.0.0.1";
    enableWebUI = true;
  };

  services.resolved.enable = true;
  services.resolved.extraConfig = "
    [Resolve]
    DNS=45.90.28.0#2adec1.dns1.nextdns.io
    DNS=2a07:a8c0::#2adec1.dns1.nextdns.io
    DNS=45.90.30.0#2adec1.dns2.nextdns.io
    DNS=2a07:a8c1::#2adec1.dns2.nextdns.io
    DNSOverTLS=yes
  ";

  services.gnome.gnome-browser-connector.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];

  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = false;
      address = [ "192.168.192.30/32" ];
      privateKeyFile = config.age.secrets.wireguard-privateKey.path;
      postUp = ''
        ${pkgs.ifmetric}/bin/ifmetric wg0 1000
      '';
      peers = [
        {
          publicKey = "ozBVrEf8edPg1AnLDCOQhFowNDNs2bLGU8Ji06dNIU4=";
          allowedIPs = [ "192.168.2.0/24" "192.168.192.0/24" ];
          endpoint = "debian4.debinux.de:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
