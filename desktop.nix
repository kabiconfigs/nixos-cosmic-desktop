{ config, pkgs, ... }:
{

 environment.variables.AMD_VULKAN_ICD = "RADV";

 hardware = {
  amdgpu.initrd.enable = true;
  graphics.enable = true;
  graphics.enable32Bit = true;
 };

  systemd.tmpfiles.rules = 
  let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
       ];
     };
    in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card1", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="high"
  '';
}
