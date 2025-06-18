{ config, pkgs, lib, ... }:
{
  imports = [];
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      golang.go
      james-yu.latex-workshop
      bierner.markdown-mermaid
      # bpruitt-goddard.mermaid-markdown-syntax-highlighting
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
    ];
  };
}
