{ config, pkgs, lib, inputs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;

    plugins = with inputs.hyprland-plugins.packages."${pkgs.system}"; [
      borders-plus-plus
    ];

    settings = {
      "$mod" = "SUPER";
      bind = [ "$mod, F, exec, firefox" ];

      "plugin:borders-plus-plus" = {
        add_borders = 1; # 0 - 9

        # you can add up to 9 borders
        "col.border_1" = "rgb(ffffff)";
        "col.border_2" = "rgb(2222ff)";

        # -1 means "default" as in the one defined in general:border_size
        border_size_1 = 10;
        border_size_2 = -1;

        natural_rounding = "yes";
      };
    };
  };
}
