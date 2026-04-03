{pkgs, ...}: {
  services.ollama = with pkgs; {
    enable = true;
    package = pkgs.ollama-vulkan;
  };
}
