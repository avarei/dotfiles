{ pkgs, ... }:
{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;

      # Create docker alias
      dockerCompat = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman-tui
    podman-compose
  ];

  # virtualisation.oci-containers = {
  #   backend = "podman";
  #   containers = {
  #     "jellyfin" = {
  #       
  #     };
  #   };
  # };
}
