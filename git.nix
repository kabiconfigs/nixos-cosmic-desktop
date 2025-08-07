{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName  = "kabiconfigs";
    userEmail = "kabi5346@protonmail.com";
    extraConfig = {
     init.defaultBranch = "main";
     safe.directory = "/etc/nixos";
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
    aliases = {
      gitci = "commit";
      gitco = "checkout";
      gitstat = "status";
    };
  };
}
