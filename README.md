# homeassistant addon cups airprint
CUPS addon with working Avahi in reflector mode. **Kudos to Grzegorz Zajac for the [original implementation](https://github.com/zajac-grzegorz/homeassistant-addon-cups-airprint)!**

Tested with Home Assistant version **2024.4.3**

CUPS administrator login: **print**, password: **print** (can be changed in the Dockerfile)

Configuration data is stored in **/data/cups** folder

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fm1cx%2Fhomeassistant-addon-cups-airprint)

## Support for HP printer which `requires proprietary plugin`
In case you find out during adding the printer in CUPS that the driver has `requires proprietary plugin` annotation, here are the extra steps to be performed before you add the printer to make it work:
1. Access the terminal of the addon's Docker container with root rights. I recommend the following approach:
   1. Install [Advanced SSH & Web Terminal](https://github.com/hassio-addons/addon-ssh) from `Home Assistant Community Add-ons` (not to be mistaken with `Terminal & SSH` official addon)
   2. In the `Configuration` tab of the `Advanced SSH & Web Terminal` addon fill in the `username` and `password` configuration properties with your HASS credentials. Press `Save`. (Be careful, every card has it's own `Save`!)
   3. In the `Info` tab of `Advanced SSH & Web Terminal` addon disable `Protection mode` to allow root access
   4. Still in `Info` tab, press `Open Web UI` which will open terminal
   5. In the terminal, lets find the container name of the addon:
      ```
      docker ps | grep cupsik
      ```
   6. Now, lets enter the container using the name obtained:
      ```
      docker exec -it $(docker ps -f name=<container-name> -q) bash
      ```
2. In the addons container terminal, first we need to switch to non-root user. By default, it's named `print`:
   ```
   su - print
   ```
4. Now, we need to set some password for the `root` user as it's not set by default and `hp-setup` won't like that. Add password using:
      ```
      sudo passwd root
      ```
5. Finally, let's execute `hp-setup` to accept the license and download the required proprietary plugin:
   ```
   hp-setup -i
   ```
6. Proceed through the steps, in most cases it's right to just follow the default answers. When the installer prompts for superuser/root password, provide the one set in step 4.
7. At the end, installer will ask you if you want to print a test page. If you choose to, don't be worried if it fails - it should work fine in CUPS anyway.
8. Now go to CUPS Administration panel (`http://<ip-of-hass-pc>:631/printers`). Your printer should have already been added by the installer. Try to print the test page. Voila!
