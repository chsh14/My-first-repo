all:sanity_check vim_setup git_status

sanity_check:
	echo "Performing Sanity Check for the home directory"
	ls ~ > /dev/null
	ls ~/.vimrc > /dev/null  
	#if [ $$? -gt 0 ]; then echo "The directory doesnt exist"; else echo "The home directory is accessible OK!"; fi     
	   


vim_setup:
	mv -f ~/.vimrc ~/.vimrc_original &>/dev/null 
	cp .vimrc ~/
	mv -f ~/.vim ~/.vim_original &>/dev/null 
	cp .vim ~/

clean_original:
	rm -rf ~/.vimrc_original
	rm -rf ~/.vim_original

revert:
	echo "Reverting the last mv and cp operation"
	mv -f ~/.vimrc_original ~/.vimrc &>/dev/null 
	mv -f ~/.vim_original ~/.vim &>/dev/null 

git_status:
	echo "Checking the status of the git fetch. "
	git pull 
	git push 
	git fetch

	
	



	


	
