{ config, inputs, lib, pkgs, ... }:

let
  foo = "bar";
  kubeMasterIP = "192.168.48.232";
  kubeMasterHostname = "server.local";
  kubeMasterAPIServerPort = 6443;
in {
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
    kubernetes-helm
  ];

  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = kubeMasterIP;
    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
    easyCerts = true;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };
    addons.dns.enable = true;

  };

}
