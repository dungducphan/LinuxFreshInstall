#!/bin/bash

function install_buildtools() {
	sudo apt update
	sudo apt install build_essential cmake ninja-build git vim
}

function install_chrome() {
	sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' 
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
	sudo apt update
	sudo apt install google-chrome-stable 	
}

function install_zsh() {
	sudo apt install -y zsh wget curl
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
	sed -i 's/plugins=(git)/plugins=(extract git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
}

function install_starship_prompt() {
	curl -sS https://starship.rs/install.sh | sh
	echo '# Starship Prompt' >> ~/.zshrc
	echo 'eval "$(starship init zsh)"' >> ~/.zshrc
	echo ' ' >> ~/.zshrc 
}

function install_nerdfonts() {
	mkdir -p ~/.local/share/fonts
	cd ~/.local/share/fonts; wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
	cd ~/.local/share/fonts; wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraMono.zip
	cd ~/.local/share/fonts; wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip
	cd ~/.local/share/fonts; wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/NerdFontsSymbolsOnly.zip
	cd ~/.local/share/fonts; extract ./*.zip; fc-cache -fv
}


function install_colorscheme() {
	bash -c  "$(wget -qO- https://git.io/vQgMr)"
}

function install_github_desktop() {
	wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
	sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
	sudo apt update && sudo apt install github-desktop
}

# --------------------------------------------------------------------------------------------------------

# Build Tools
if ! command -v gcc &> /dev/null
then
	echo "Build tools could not be found. Running installation..."
	install_buildtools
fi

# Google Chrome
if ! command -v google-chrome &> /dev/null
then
    echo "Google Chrome could not be found. Running installation..."
    install_chrome
fi

# ZSH suites
if ! command -v zsh &> /dev/null
then
    echo "zsh could not be found. Running installation..."
    install_zsh
fi

# NerdFonts
fc-list -q "FiraCode Nerd Font Mono" && 
	{
		echo "NerdFonts are found. Exitting..."; 
	} || {
		echo "NerdFonts are NOT found. Running installation..."; 
		install_nerdfonts 
	}

# Starship Prompt
if ! command -v starship &> /dev/null
then
	echo "Starship Prompt could not be found. Running installation..."
	install_starship_prompt
fi

# Colorschemes
read -p "Do you want to install a new Terminal Colorscheme [Y/N]? " -n 1 -r 
echo    # (optional) move to a new line 
if [[ $REPLY =~ ^[Yy]$ ]] 
then 
	install_colorscheme 
fi


# GitHub Desktop
if ! command -v github-desktop &> /dev/null
then
	echo "GitHub desktop could not be found. Running installation..."
	install_github_desktop
fi

