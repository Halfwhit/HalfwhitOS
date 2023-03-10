#! /bin/bash

echo
echo "Welcome to HalfwhitOS, this script will install and configure the system to specification, and may ask for sudo password at times."
echo

# Install XOrg, as well as git(+openssh) and vim
sudo pacman -Sy xorg git vim openssh networkmanager

# Clone and install the paru repository, and then let paru manage it's self.
while true; do
	echo
	read -r -p "Do you wish to bootstrap paru? [y/n] " answer
	echo
	case $answer in
		[Yy]* ) git clone https://aur.archlinux.org/paru; cd paru; makepkg -si; cd ..; rm -rf paru; paru -S devtools asp bat; paru -S paru parui-git; echo; echo "Paru ready to use."; echo; break;;
		[Nn]* ) break;;
		* ) echo; echo "Please answer Y or N."; echo;;
	esac
done

# Setup lemurs and qtile (+configs)
paru -S xsel xclip lemurs-git qtile pacwall-git hsetroot alacritty python-setuptools pycritty picom
sudo mkdir /etc/lemurs/wms; sudo cp ./etc-configs/lemurs-qtile /etc/lemurs/wms/qtile 
sudo systemctl enable lemurs.service
# configs
mkdir ~/.config
cp -r ./configs/* ~/.config
systemctl --user enable pacwall-watch-packages.path
systemctl --user enable pacwall-watch-updates.timer

# First round of software installs
paru -S topgrade-bin btop neovim neovide dunst github-cli
paru -S fish fisher starship nerd-fonts-complete-starship
paru -S fd ripgrep exa
paru -S librewolf-bin librewolf-firefox-shim librewolf-extension-bitwarden librewolf-ublock-origin 
paru -S transmission-cli transmission-gtk
paru -S libreoffice-fresh libreoffice-fresh-en-gb
paru -S irssi perl-libwww

#Setup virtualisation
paru -S qemu-full libvirt dnsmasq podman podman-tui cockpit cockpit-machines cockpit-packagekit cockpit-podman virt-manager distrobox fuse-overlayfs
sudo systemctl enable --now libvirtd.service
sudo systemctl enable --now cockpit.socket
sudo usermod -aG libvirt $USER
sudo virsh net-autostart default

# doom-emacs
paru -S emacs-nativecomp
git clone --depth 1 --single-branch https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
