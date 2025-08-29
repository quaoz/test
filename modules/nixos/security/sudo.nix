{
  security.sudo-rs = {
    # use sudo-rs
    enable = true;

    # only allow members of the wheel group to execute sudo
    execWheelOnly = true;
  };
}
