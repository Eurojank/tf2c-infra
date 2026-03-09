{
  description = "TF2C Server GCP Image";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { nixpkgs, ... }: let
    debugModulePath = ./debug-local.nix;
    debugModules =
      if builtins.pathExists debugModulePath
      then [ debugModulePath ]
      else [ ];
  in {
    nixosConfigurations.tf2-gcp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules =
        [
          "${nixpkgs}/nixos/modules/virtualisation/google-compute-image.nix"

          ({ pkgs, ... }: {
            networking.hostName = "tf2-server";

            services.openssh = {
              enable = true;
              settings = {
                PasswordAuthentication = false;
                PermitRootLogin = "no";
                UsePAM = false;
              };
            };

            users.users.tf2 = {
              isNormalUser = true;
              createHome = true;
              home = "/home/tf2";
              extraGroups = [ "wheel" ];
              shell = pkgs.bashInteractive;
            };

            boot.kernelModules = [ "gve" ];
            boot.initrd.kernelModules = [ "gve" ];

            system.stateVersion = "25.11";
          })
        ]
        ++ debugModules;
    };
  };
}
