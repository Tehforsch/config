{
  lib,
  ...
}: {
  hardware.ksm.enable = lib.mkForce false;

  security.sudo.extraRules = [
    {
      users = ["toni"];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start microvm@abox.service";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop microvm@abox.service";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  microvm.vms.abox = {
    autostart = false;
    pkgs = null;

    config = {
      config,
      pkgs,
      ...
    }: {
      imports = [
        ./basic.nix
        ./packages/basic.nix
      ];

      networking.hostName = "abox";

      users.users.toni = {
        isNormalUser = true;
        uid = 1000;
        createHome = true;
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBljzjzlraj+tA8veF0DHj2+beJUvCQAGgOx2btJm9tF toni"
        ];
      };

      systemd.tmpfiles.rules = ["d /home/toni 0700 toni users -"];

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      environment.systemPackages = [pkgs.codex];

      microvm = {
        hypervisor = "qemu";
        vcpu = 8;
        mem = 8192;
        storeOnDisk = true;

        interfaces = [
          {
            type = "user";
            id = "abox-net";
            mac = "02:00:00:00:00:42";
          }
        ];

        vsock = {
          cid = 42;
          ssh.enable = true;
        };

        writableStoreOverlay = "/nix/.rw-store";
        preStart = ''
          ${pkgs.coreutils}/bin/rm -f nix-store-overlay.img
        '';

        volumes = [
          {
            image = "home.img";
            label = "abox-home";
            mountPoint = "/home";
            size = 16384;
          }
          {
            image = "nix-store-overlay.img";
            label = "abox-nix-rw";
            mountPoint = config.microvm.writableStoreOverlay;
            size = 32768;
          }
        ];

        shares = [
          {
            proto = "virtiofs";
            tag = "projects";
            source = "/home/toni/projects";
            mountPoint = "/home/toni/projects";
          }
        ];
      };
    };
  };

  systemd.services."microvm@abox".serviceConfig = {
    MemoryMax = "12G";
    CPUQuota = "800%";
    TasksMax = 4096;
  };
}
