{ ... }:

{
  imports = [ ./graphical ];

  arch = "broadwell";

  environment.variables = {
    "QT_SCALE_FACTOR" = "1";
  };
}
