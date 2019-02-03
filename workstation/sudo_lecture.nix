{ ... }:

{
  security.sudo.extraConfig = ''
    Defaults    lecture = always
    Defaults    lecture_file = /run/current-system/etc/sudo_lecture
  '';

  environment.etc."sudo_lecture" = {
    text = ''
      [1m     [32m"Bee" careful    [34m__
             [32mwith sudo!    [34m// \
                           \\_/ [33m//
         [35m'''-.._.-'''-.._.. [33m-(||)(')
                           ''''[0m
    '';
    mode = "444";
  };
}
