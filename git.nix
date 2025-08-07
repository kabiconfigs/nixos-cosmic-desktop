{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName  = "kabiconfigs";
    userEmail = "kabi5346@protonmail.com";
    extraConfig = {
     init.defaultBranch = "main";
     safe.directory = "/etc/nixos";
    };
  };
}
