{ ... }:

{
  services.libinput = {
    enable = true;
    touchpad = {
      disableWhileTyping = true;
    };
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech PRO X 2 SE]
    MatchName=Logitech PRO X 2 SE
    ModelBouncingKeys=1

    [Glorious Model O]
    MatchName=Glorious Model O
    ModelBouncingKeys=1

    [Endgame Gear HS Dongle]
    MatchName=*Endgame Gear*
    ModelBouncingKeys=1
  '';

  environment.etc."libinput/plugins/00-disable-debounce.lua".text = ''
    libinput:register({1})

    libinput:connect("new-evdev-device", function(device)
      device:disable_feature("button-debouncing")
    end)
  '';
}
