{ pkgs, device, ... }:

let
  groupConfig =
    if device != "macbook" then { users.users.clamt.extraGroups = [ "adbusers" ]; } else { };
in

{
  environment.systemPackages =
    with pkgs;
    [
      android-tools
      jdk17
    ]
    ++ (if device != "macbook" then [ android-studio ] else [ ]);
}
// groupConfig
