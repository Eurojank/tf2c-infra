{
  description = "TF2C Server GCP Image";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.tf2-gcp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/virtualisation/google-compute-image.nix"
        
        ({ pkgs, modulesPath, ... }: {
          networking.hostName = "tf2-server";
          
          services.openssh.enable = true;

          nixpkgs.config.allowUnfree = true;

          hardware.graphics.enable32Bit = true;


          environment.systemPackages = with pkgs; [
            git
            vim
            tmux
            screen
          ];
         
          system.stateVersion = "25.11";
        })
      ];
    };
  };
}
