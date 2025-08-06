{ config, lib, pkgs, modulesPath, ... }:

{
 networking = {
   hostId = "abcd1234";
   networkmanager.enable = true;
   hostName = "nixos-desktop";
   interfaces.enp4s0f1.ipv4.addresses = [{
     address = "192.168.0.178";
     prefixLength = 24;
    }];
   defaultGateway = "192.168.0.2";
   nameservers = [ "9.9.9.11" "149.112.112.11" ];
  };
}  
