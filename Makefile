all:

sanity_check:
	cd ~
	if [ $? -gt 0 ]; 
	then
		echo "The directory doesnt exist"
	else
		echo "The home directory is accessible OK!"
	fi



vim_setup:
	mv -f ~/.vimrc ~/.vimrc_original &>/dev/null 
	cp .vimrc ~/
	mv -f ~/.vim ~/.vim_original &>/dev/null 
	cp .vim ~/

clean_original:
	rm -rf ~/.vimrc_original
	rm -rf ~/.vim_original

revert:



	


	
