{
  description = "Add a Taskwarrior task as a prerequisite before another";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in {
          default = pkgs.writeShellApplication {
            name = "task-add-before";
            runtimeInputs = [ pkgs.jq pkgs.taskwarrior2 ];
            text = builtins.readFile ./task-add-before;
          };
        });

      overlays.default = final: prev: {
        task-add-before = self.packages.${prev.system}.default;
      };
    };
}
