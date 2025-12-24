{
  options,
  lib,
  nvf,
  ...
}: {
  options.dotfiles.nvf.autoImport = lib.mkOption {
    description = ''
      Whether to import nvf automatically for every home-manager user.

      This only works if you are using `home-manager.users.«name»` within
      your NixOS configuration, rather than running Home Manager independently.
    '';
    type = lib.types.bool;
    default = true;
    example = false;
  };

  config = lib.optionalAttrs (options ? home-manager) {
    home-manager.sharedModules = [
      nvf.homeManagerModules.default
    ];
  };
}
