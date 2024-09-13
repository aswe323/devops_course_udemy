let
    pkgs = import (builtins.fetchTarball {
        url ="https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    }) { config.allowUnfree = true; };
in
        pkgs.mkShell{
	packages = [
		pkgs.vagrant
		pkgs.jdk8
		pkgs.maven
		pkgs.awscli

	];
	env = {
	NIXPKGS_ALLOW_UNFREE=1;
	};
        }
