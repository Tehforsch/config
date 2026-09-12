{
  lib,
  pkgs,
  ...
}: let
  projects = [
    {
      name = "config";
      path = "/home/toni/projects/config";
    }
  ];
  projectPaths = map (project: project.path) projects;
  projectShares =
    map (project: {
      proto = "virtiofs";
      tag = "project-${project.name}";
      source = project.path;
      mountPoint = project.path;
    })
    projects;
  agentbox = pkgs.writeShellApplication {
    name = "agentbox";
    runtimeInputs = with pkgs; [
      coreutils
      openssh
      systemd
    ];
    text = ''
      ssh_options=(
        -o ConnectTimeout=1
        -o LogLevel=ERROR
        -o StrictHostKeyChecking=no
        -o UserKnownHostsFile=/dev/null
      )

      if [[ "''${1:-}" == "--stop" ]]; then
        exec sudo systemctl stop microvm@agentbox.service
      fi

      sudo systemctl start microvm@agentbox.service

      connected=false
      for _ in $(seq 1 150); do
        if ssh "''${ssh_options[@]}" -l toni vsock/42 true 2>/dev/null; then
          connected=true
          break
        fi
        sleep 0.2
      done

      if [[ "$connected" != true ]]; then
        systemctl status --no-pager microvm@agentbox.service || true
        exit 1
      fi

      case "''${1:-}" in
        --login)
          exec ssh -t "''${ssh_options[@]}" -l toni vsock/42 "codex login --device-auth"
          ;;
        --shell)
          exec ssh -t "''${ssh_options[@]}" -l toni vsock/42
          ;;
        --*)
          echo "usage: agentbox [--login|--shell|--stop|PROJECT_DIRECTORY]" >&2
          exit 2
          ;;
      esac

      directory=$(realpath "''${1:-.}")
      allowed=false
      project_paths=(${lib.escapeShellArgs projectPaths})
      for project in "''${project_paths[@]}"; do
        case "$directory" in
          "$project"|"$project"/*)
            allowed=true
            break
            ;;
        esac
      done

      if [[ "$allowed" != true ]]; then
        echo "$directory is not mounted in agentbox" >&2
        exit 1
      fi

      printf -v quoted_directory %q "$directory"
      exec ssh -t "''${ssh_options[@]}" -l toni vsock/42 \
        "cd -- $quoted_directory && exec codex --dangerously-bypass-approvals-and-sandbox"
    '';
  };
in {
  hardware.ksm.enable = lib.mkForce false;

  environment.systemPackages = [agentbox];

  microvm.vms.agentbox = {
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

      networking.hostName = "agentbox";

      users.users.toni = {
        isNormalUser = true;
        uid = 1000;
        createHome = true;
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBljzjzlraj+tA8veF0DHj2+beJUvCQAGgOx2btJm9tF toni"
        ];
      };

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      environment.systemPackages = with pkgs; [
        cargo
        clang
        codex
        rustc
      ];

      microvm = {
        hypervisor = "qemu";
        vcpu = 8;
        mem = 8192;
        storeOnDisk = true;

        interfaces = [
          {
            type = "user";
            id = "agent-net";
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
            label = "agent-home";
            mountPoint = "/home";
            size = 16384;
          }
          {
            image = "nix-store-overlay.img";
            label = "agent-nix-rw";
            mountPoint = config.microvm.writableStoreOverlay;
            size = 32768;
          }
        ];

        shares = projectShares;
      };
    };
  };

  systemd.services."microvm@agentbox".serviceConfig = {
    MemoryMax = "12G";
    CPUQuota = "800%";
    TasksMax = 4096;
  };
}
