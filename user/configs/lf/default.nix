{pkgs, ...}: let
  previewer = pkgs.writeShellScriptBin "pv.sh" ''
    file=$1
    w=$2
    h=$3
    x=$4
    y=$5

    if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
    # ''${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
    ${pkgs.chafa}/bin/chafa -f kitty "$file"
    exit 1
    fi

    ${pkgs.pistol}/bin/pistol "$file"
  '';

  cleaner = pkgs.writeShellScriptBin "clean.sh" ''
    ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
  '';
in {
  xdg.configFile."lf/icons".source = ./icons;

  programs.lf = {
    enable = true;

    settings = {
      drawbox = true;
      icons = true;
      ignorecase = true;
      preview = true;

      #image previewer
      cleaner = "${cleaner}/bin/clean.sh";
      previewer = "${previewer}/bin/pv.sh";
    };
  };
}
