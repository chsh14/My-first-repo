#/bin/bash -e
say "Hello and welcome to this fantastic world of scripting"
sleep 3
say "Please type your name on the screen"
read -p "name :" name
say "Hello $name"
sleep 15
say "Did I say your name correctly $name?"
read -t 5 -p "answer (y/n) :" answer
echo $?
while :
do
	read -t 5 -p "answer (y/n) :" answer
	if [ $? -gt 0 ]
	then
		say "You have to answer me yes or no"
		say "Not saying, by typing it on Terminal"
	else
		break
	fi

done
if [[ $answer == "y" ]]
then	
	say "Nice.. Thanks for appreciating my effort"
else
	say "What about, "; say -v Fred "$name"
fi
