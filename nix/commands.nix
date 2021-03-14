{ pkgs, unstable, ... }:
  let
    bash    = "${pkgs.bash}/bin/bash";
    figlet  = "${pkgs.figlet}/bin/figlet";
    lolcat  = "${pkgs.lolcat}/bin/lolcat";
    mix     = "${unstable.elixir}/bin/mix";

    cmd = description: script:
      { inherit description;
        inherit script;
      };

    command = {name, script, description ? "<No description given>"}:
      let
        package =
          pkgs.writeScriptBin name ''
            #!${bash}
            echo "⚙️  Running ${name}..."
            ${script}
          '';

        bin = "${package}/bin/${name}";
      in
         { package     = package;
           description = description;
           bin         = bin;
         };

    commands = defs:
      let
        names =
          builtins.attrNames defs;

        helper =
          let
            lengths = map builtins.stringLength names;
            maxLen  = builtins.foldl' (acc: x: if x > acc then x else acc) 0 lengths;
            maxPad  =
              let
                go = acc:
                  if builtins.stringLength acc >= maxLen
                  then acc
                  else go (" " + acc);
              in
                go "";

            folder = acc: name:
              let
                nameLen = builtins.stringLength name;
                padLen  = maxLen - nameLen;
                padding = builtins.substring 0 padLen maxPad;
              in
                acc + " && echo '${name} ${padding}| ${(builtins.getAttr name defs).description}'";

            lines =
              builtins.foldl' folder "echo ''" names;

          in
            pkgs.writeScriptBin "helpme" ''
              #!${pkgs.stdenv.shell}
              ${pkgs.figlet}/bin/figlet "Commands" | ${pkgs.lolcat}/bin/lolcat
              ${toString lines}
            '';

        mapper = name:
          let
            element =
              builtins.getAttr name defs;

            task = command {
              inherit name;
              description = element.description;
              script      = element.script;
            };
          in
            task.package;

        packages =
          map mapper names;

      in
        [helper] ++ packages;

  in
    commands {
      quality = cmd "Run all tests, linters, and so on" "MIX_ENV=test ${mix} quality";
    }
