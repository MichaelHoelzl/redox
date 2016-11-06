#! /bin/bash

##########################################################
# This function is simply a banner to introduce the script
##########################################################
banner()
{	
	echo "|------------------------------------------|"
	echo "|----- Welcome to the redox bootstrap -----|"
	echo "|------------------------------------------|"
}

###############################################################################
# This function takes care of installing all dependencies for building redox on
# Mac OSX
# @params:	$1 the emulator to install, virtualbox or qemu
###############################################################################
osx()
{
	echo "Detected OSX!"
	if [ ! -z "$(which brew)" ]; then
		echo "Homebrew detected! Now updating..."
		brew update
		if [ -z "$(which git)" ]; then
			echo "Now installing git..."
			brew install git
		fi
		if [ "$1" == "qemu" ]; then
			if [ -z "$(which qemu-system-i386)" ]; then
				echo "Installing qemu..."
				brew install qemu
			else
				echo "QEMU already installed!"
			fi
		else
			if [ -z "$(which virtualbox)" ]; then
				echo "Now installing virtualbox..."
				brew cask install virtualbox
			else
				echo "Virtualbox already installed!"
			fi
		fi
	else
		echo "Homebrew does not appear to be installed! Would you like me to install it?"
		echo "*WARNING* this install involves a curl | sh style command"
		printf "(Y/n): "
		read -r installit
		if [ "$installit" == "Y" ]; then
			ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		else
			echo "Will not install, now exiting..."
			exit
		fi
	fi
	echo "Running Redox setup script..."
	brew tap homebrew/versions
	brew install gcc49
	brew tap nashenas88/gcc_cross_compilers
	brew install nashenas88/gcc_cross_compilers/i386-elf-binutils nashenas88/gcc_cross_compilers/i386-elf-gcc nasm pkg-config
	brew install Caskroom/cask/osxfuse
}

###############################################################################
# This function takes care of installing all dependencies for building redox on
# Arch linux
# @params:	$1 the emulator to install, virtualbox or qemu
###############################################################################
archLinux()
{
	echo "Detected Arch Linux"
	echo "Updating system..."
	sudo pacman -Syu

	if [ -z "$(which nasm)" ]; then
		echo "Installing nasm..."
		sudo pacman -S nasm
	fi

	if [ -z "$(which git)" ]; then
		echo "Installing git..."
		sudo pacman -S git
	fi

	if [ "$1" == "qemu" ]; then
		if [ -z "$(which qemu-system-i386)" ]; then
			echo "Installing QEMU..."
			sudo pacman -S qemu
		else
			echo "QEMU already installed!"
		fi
	fi

	echo "Installing fuse..."
	sudo pacman -S fuse
}

###############################################################################
# This function takes care of installing all dependencies for building redox on
# debian based linux
# @params:	$1 the emulator to install, virtualbox or qemu
# 		$2 the package manager to use	
###############################################################################
ubuntu()
{
	echo "Detected Ubuntu/Debian"
	echo "Updating system..."
	sudo "$2" update
	echo "Installing required packages..."
	sudo "$2" install build-essential libc6-dev-i386 nasm curl file git libfuse-dev
	if [ "$1" == "qemu" ]; then
		if [ -z "$(which qemu-system-i386)" ]; then
			echo "Installing QEMU..."
			sudo "$2" install qemu-system-x86 qemu-kvm
		else
			echo "QEMU already installed!"
		fi
	else
		if [ -z "$(which virtualbox)" ]; then
			echo "Installing Virtualbox..."
			sudo "$2" install virtualbox
		else
			echo "Virtualbox already installed!"
		fi
	fi
}

###############################################################################
# This function takes care of installing all dependencies for building redox on
# fedora linux
# @params:	$1 the emulator to install, virtualbox or qemu
###############################################################################
fedora()
{
	echo "Detected Fedora"
	if [ -z "$(which git)" ]; then
		echo "Installing git..."
		sudo dnf install git-all
	fi
	if [ "$1" == "qemu" ]; then
		if [ -z "$(which qemu-system-i386)" ]; then
			echo "Installing QEMU..."
			sudo dnf install qemu-system-x86 qemu-kvm
		else
			echo "QEMU already installed!"
		fi
	else
		if [ -z "$(which virtualbox)" ]; then
			echo "Installing virtualbox..."
			sudo dnf install virtualbox
		else
			echo "Virtualbox already installed!"
		fi
	fi
	echo "Installing necessary build tools..."
	sudo dnf install gcc gcc-c++ glibc-devel.i686 nasm make fuse-devel
}

###############################################################################
# This function takes care of installing all dependencies for building redox on
# *suse linux
# @params:	$1 the emulator to install, virtualbox or qemu
###############################################################################
suse()
{
	echo "Detected a suse"
	if [ -z "$(which git)" ]; then
		echo "Installing git..."
		zypper install git
	fi
	if [ "$1" == "qemu" ]; then
		if [ -z "$(which qemu-system-i386)" ]; then
			echo "Installing QEMU..."
			sudo zypper install qemu-x86 qemu-kvm
		else
			echo "QEMU already installed!"
		fi
	else
		if [ -z "$(which virtualbox)" ]; then
			echo "Please install Virtualbox and re-run this script,"
			echo "or run with -e qemu"
			exit
		else
			echo "Virtualbox already installed!"
		fi
	fi
	echo "Installing necessary build tools..."
	sudo zypper install gcc gcc-c++ glibc-devel-32bit nasm make libfuse
}

##############################################################################
# This function takes care of installing all dependencies for builing redox on
# gentoo linux
# @params:	$1 the emulator to install, virtualbox or qemu
##############################################################################
gentoo()
{
	echo "Detected Gentoo Linux"
	if [ -z "$(which nasm)" ]; then
		echo "Installing nasm..."
		sudo emerge dev-lang/nasm
	fi
	if [ -z "$(which git)" ]; then
		echo "Installing git..."
		sudo emerge dev-vcs/git
	fi
	echo "Installing fuse..."
	sudo emerge sys-fs/fuse
	if [ "$2" == "qemu" ]; then
		if [ -z "$(which qemu-system-i386)" ]; then
			echo "Please install QEMU and re-run this script"
			echo "Step1. Add QEMU_SOFTMMU_TARGETS=\"i386\" to /etc/portage/make.conf"
			echo "Step2. Execute \"sudo emerge app-emulation/qemu\""
		else
			echo "QEMU already installed!"
		fi
	fi
}

##############################################################################
# This function takes care of installing all dependencies for builing redox on
# SolusOS
# @params:	$1 the emulator to install, virtualbox or qemu
##############################################################################
solus()
{
	echo "Detected SolusOS"
	if [ -z "$(which nasm)" ]; then
		echo "Installing nasm..."
		sudo eopkg it nasm
	fi
	if [ -z "$(which git)" ]; then
		echo "Installing git..."
		sudo eopkg it git
	fi
	echo "Installing fuse..."
	sudo eopkg it fuse-devel
	if [ "$1" == "qemu" ]; then
		if [ -z "$(which qemu-system-i386)" ]; then
			sudo eopkg it qemu
		else
			echo "QEMU already installed!"
		fi
	else
		if [ -z "$(which virtualbox)" ]; then
			echo "Please install Virtualbox and re-run this script,"
			echo "or run with -e qemu"
			exit
		else
			echo "Virtualbox already installed!"
		fi
	fi
}

######################################################################
# This function outlines the different options available for bootstrap
######################################################################
usage()
{
	echo "------------------------"
	echo "|Redox bootstrap script|"
	echo "------------------------"
	echo "Usage: ./bootstrap.sh"
	echo "OPTIONS:"
	echo
	echo "   -h,--help      Show this prompt"
	echo "   -u [branch]    Update git repo and update rust"
	echo "                  If blank defaults to master"
	echo "   -s             Check the status of the current travis build"
	echo "   -e [emulator]  Install specific emulator, virtualbox or qemu"
	echo "   -p [package    Choose an Ubuntu package manager, apt-fast or"
	echo "       manager]   aptitude"
	echo "EXAMPLES:"
	echo
	echo "./bootstrap.sh -b buddy -e qemu"
	exit
}

####################################################################################
# This function takes care of everything associated to rust, and the version manager
# That controls it, it can install rustup and uninstall multirust as well as making 
# sure that the correct version of rustc is selected by rustup
####################################################################################
rustInstall() {
	# Check to see if multirust is installed, we don't want it messing with rustup
	# In the future we can probably remove this but I believe it's good to have for now
	if [ -e /usr/local/lib/rustlib/uninstall.sh ] ; then
		echo "It appears that multirust is installed on your system."
		echo "This tool has been deprecated by the maintainer, and will cause issues."
		echo "This script can remove multirust from your system if you wish."
		printf "Uninstall multirust (y/N):"
		read multirust
		if echo "$multirust" | grep -iq "^y" ;then
			sudo /usr/local/lib/rustlib/uninstall.sh	
		else
			echo "Please manually uninstall multirust and any other versions of rust, then re-run bootstrap."
			exit
		fi
	else
		echo "Old multirust not installed, you are good to go."
	fi
	# If rustup is not installed we should offer to install it for them	
	if [ -z "$(which rustup)" ]; then
		echo "You do not have rustup installed."
		echo "We HIGHLY reccomend using rustup."
		echo "Would you like to install it now?"
		echo "*WARNING* this involves a 'curl | sh' style command"
		printf "(y/N): "
		read rustup
		if echo "$rustup" | grep -iq "^y" ;then
			#install rustup
			curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly
			# You have to add the rustup variables to the $PATH	
			echo "export PATH=\"\$HOME/.cargo/bin:\$PATH\"" >> ~/.bashrc
			# source the variables so that we can execute rustup commands in the current shell
			source ~/.cargo/env	
			rustup default nightly
		else
			echo "Rustup will not be installed!"
		fi
	fi	
	# 	
	if [ -z "$(which rustc)" ]; then
		echo "Rust is not installed"
		echo "Please either run the script again, accepting rustup install"
		echo "or install rustc nightly manually (not reccomended) via:"
		echo "\#curl -sSf https://static.rust-lang.org/rustup.sh | sh -s -- --channel=nightly"
		exit 
	fi
	# If the system has rustup installed then update rustc to the latest nightly
	if hash 2>/dev/null rustup; then
		rustup update nightly
		rustup default nightly
	fi
	# Check to make sure that the default rustc is the nightly
	if echo "$(rustc --version)" | grep -viq "nightly" ;then
		echo "It appears that you have rust installed, but it"
		echo "is not the nightly version, please either install"
		echo "the nightly manually (not reccomended) or run this"
		echo "script again, accepting the multirust install"
		echo
	else
		echo "Your rust install looks good!"
		echo
	fi
}

####################################################################
# This function gets the current build status from travis and prints 
# a message to the user
####################################################################
statusCheck() {
	for i in $(echo "$(curl -sf https://api.travis-ci.org/repositories/redox-os/redox.json)" | tr "," "\n")
	do
		if echo "$i" | grep -iq "last_build_status" ;then
			if echo "$i" | grep -iq "0" ;then
				echo
				echo "********************************************"
				echo "Travis reports that the last build succeded!"
				echo "Looks like you are good to go!"
				echo "********************************************"
			elif echo "$i" | grep -iq "null" ;then
				echo
				echo "******************************************************************"	
				echo "The Travis build did not finish, this is an error with its config."
				echo "I cannot reliably determine whether the build is succeding or not."
				echo "Consider checking for and maybe opening an issue on github"
				echo "******************************************************************"
			else
				echo
				echo "**************************************************"
				echo "Travis reports that the last build *FAILED* :("
				echo "Might want to check out the issues before building"
				echo "**************************************************"
			fi
		fi
	done
}

###########################################################################
# This function is the main logic for the bootstrap; it clones the git repo
# then it installs the rust version manager and the latest version of rustc
###########################################################################
boot()
{
	echo "Cloning github repo..."
	git clone https://github.com/redox-os/redox.git --origin upstream --recursive	
	rustInstall
	echo "Cleaning up..."
	rm bootstrap.sh
	echo
	echo "---------------------------------------"
	echo "Well it looks like you are ready to go!"
	echo "---------------------------------------"
	statusCheck
	echo "Run the following commands to build redox:"
	echo "cd redox"
	echo "make all"
	echo "make virtualbox or qemu"
	echo
	echo "      Good luck!"

	exit
}

if [ "$1" == "-h" ]; then
	usage
elif [ "$1" == "-u" ]; then
	git pull upstream master
	git submodule update --recursive --init
	rustup update nightly
	exit
elif [ "$1" == "-s" ]; then
	statusCheck
	exit
fi

emulator="qemu"
defpackman="apt-get"
while getopts ":e:p:" opt
do
	case "$opt" in
		e) emulator="$OPTARG";;
		p) defpackman="$OPTARG";;
		\?) echo "I don't know what to do with that option, try -h for help"; exit;;
	esac
done

banner
if [ "Darwin" == "$(uname -s)" ]; then
	osx "$emulator"
else
	# Here we will user package managers to determine which operating system the user is using	
	# Arch linux
	if hash 2>/dev/null pacman; then
		archLinux "$emulator"
	fi
	# Debian or any derivative of it
	if hash 2>/dev/null apt-get; then
		ubuntu "$emulator" "$defpackman"
	fi
	# Fedora
	if hash 2>/dev/null dnf; then
		fedora "$emulator"
	fi
	# Suse and derivatives
	if hash 2>/dev/null zypper; then
		suse "$emulator"
	fi
	# Gentoo
	if hash 2>/dev/null emerge; then
		gentoo "$emulator"
 	fi
	# SolusOS
	if hash 2>/dev/null eopkg; then
		solus "$emulator"
	fi
fi
boot