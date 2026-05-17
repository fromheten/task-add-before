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
          default =
            let
              script = pkgs.writeScriptBin "task-add-before" (builtins.readFile ./task-add-before);
            in
            pkgs.symlinkJoin {
              name = "task-add-before";
              paths = [ script ];
              buildInputs = [ pkgs.makeWrapper ];
              postBuild = ''
                wrapProgram $out/bin/task-add-before \
                  --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.jq pkgs.taskwarrior2 ]}
              '';
            };
        });

      overlays.default = final: prev: {
        task-add-before = self.packages.${prev.system}.default;
      };
    };
}
