{ config, inputs, lib, pkgs, ... }:

let
  foo = "bar";
  masterAddress = "127.0.0.1";
in {
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = masterAddress;
    easyCerts = true;
    addons.dns.enable = true;

  };

}
