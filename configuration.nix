# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
  [ # Include the results of the hardware scan.
    #./hardware-configuration.nix
  ];
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-connections
    yelp
    ]) ++ (with pkgs.gnome; [
    gnome-maps
    gnome-calendar
    gnome-contacts
    gedit # text editor
    epiphany # web browser
    geary # email reader
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    ]);
    programs.geary.enable = false;

    # Configure keymap in X11
    services.xserver = {
      layout = "de";
      xkbVariant = "";
    };

    # Configure console keymap
    console.keyMap = "de";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.b_demharter = {
      isNormalUser = true;
      description = "Benedikt Demharter";
      extraGroups = ["adm" "networkmanager" "wheel" "sudo"];
      packages = with pkgs; [
      firefox thunderbird bitwarden vscode tor-browser-bundle-bin wine 
      wesnoth libreoffice krita drawing texworks texlive.combined.scheme-full
      chromium zoom ntfs3g
      ];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
    #zsh
    zsh oh-my-zsh zsh-you-should-use zsh-z zsh-autosuggestions zsh-syntax-highlighting
    #other
    nano vim wget git gcc appimage-run jdk zlib curl php cmake pdftk fwupd parted curl libgccjit gcc gmp gnumake ncurses toybox xz
    #haskell
    ghc ormolu   
     ];

    #zsh
    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh;
    programs.zsh = {
      enable = true;
      shellAliases = {
        #rebuild nixos
        nixup = "sudo nixos-rebuild switch";

        #git aliases
        # Aktuelle Änderungen (gestaged und nicht gestaged) in Stash speichern
        gsts="git stash save";
        # Änderungen anzeigen (nicht anwenden!), die sich durch Anwendung des letzten Stash-Eintrag ergeben würden
        gstP="git stash show -p";
        # Änderungen des letzten Stash-Eintrags vornehmen; Stash-Eintrag löschen (sofern es keine Konflikte gibt)
        gstp="git stash pop";
        # Letzten Stash-Eintrag löschen
        gstd="git stash drop";
        # Letzten Commit rückgängig machen, Änderungen behalten -- gut in Kombination mit glog, gs, gds, gdh, gsts, gstP, und gstp ;-)
        grsh="git reset --soft HEAD^";
        # Füge für den nächsten Commit vorgemerkte Änderungen zum *letzten* Commit hinzu
        a2c="git commit --amend --no-edit";
        # Ändere die Commit-Message des letzten Commits
        clc="git commit --amend";
        # Zeige die letzten 10 Commits an
        glog="git --no-pager log -10 --oneline --decorate --graph";
        # Zeige Inhalt an, der sich durch den letzten Commit geändert hat
        gdh="git diff HEAD^";
        # Zeige Inhalt an, der sich gegenüber dem letzten Commit geändert hat
        gh="git diff HEAD";
        # Zeige aktuellen Status an
        gs="git status";
        # Zeige geänderten Inhalt an, der für den nächsten Commit vorgemerkt ("gestaged") ist
        gds="git diff --cached";
        # In anderen Branch wechseln
        gc="git checkout";
        # Neuen Branch erstellen
        gcb="git checkout -b";
      };
      histSize = 10000;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "wd" ];
        theme = "robbyrussell";
        };
      autosuggestions = {
        enable=true;
        strategy=["match_prev_cmd"];
      };
    };

  programs.zsh.syntaxHighlighting.enable=true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
}
