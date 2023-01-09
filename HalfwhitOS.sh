#! /bin/bash

echo "\nWelcome to HalfwhitOS, this script will install and configure the system to specification, and may ask for sudo password at times.\n"

# Install XOrg, as well as git(+openssh) and vim
sudo pacman -Sy xorg git vim openssh networkmanager

# Clone and install the paru repository, and then let paru manage it's self.
while true; do
	read -r -p "\nDo you wish to bootstrap paru? \n" answer
	case $answer in
		[Yy]* ) git clone https://aur.archlinux.org/paru; cd paru; makepkg -si; cd ..; rm -rf paru; paru -S devtools asp bat; paru -S paru parui-git; echo "\nparu ready to use.\n"; break;;
		[Nn]* ) break;;
		* ) echo "\nPlease answer Y or N.\n";;
	esac
done

# Setup lemurs and qtile (+configs)
paru -S xsel xclip lemurs-git qtile pacwall-git hsetroot alacritty python-setuptools pycritty
sudo mkdir /etc/lemurs/wms; sudo cp ./etc-configs/lemurs-qtile /etc/lemurs/wms/qtile 
sudo systemctl enable lemurs.service
# configs
mkdir ~/.config
cp -r ./configs/* ~/.config
systemctl --user enable pacwall-watch-packages.path
systemctl --user enable pacwall-watch-updates.timer

# First round of software installs
paru -S topgrade btop neovim neovide dunst github-cli
paru -S fish fisher starship nerd-fonts-complete-starship
paru -S fd ripgrep exa
paru -S librewolf-bin librewolf-firefox-shim librewolf-extension-bitwarden librewolf-ublock-origin 
paru -S transmission-cli transmission-gtk
paru -S libreoffice-fresh libreoffice-fresh-en-gb
paru -S irssi perl-libwww

#Setup virtualisation
paru -S qemu-full libvirt dnsmasq podman podman-tui cockpit cockpit-machines cockpit-packagekit cockpit-podman virt-manager
sudo systemctl enable --now cockpit.socket

# doom-emacs
