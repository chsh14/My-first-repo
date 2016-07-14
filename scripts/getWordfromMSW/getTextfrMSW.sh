#!/bin/bash -e

IFS=$(echo -en "\n\b"); # Line seperator = \n Field Seperator = \b (Back Space) 


## Variables for the -msw swich ########
pathToSearch="$VC_WORKSPACE/ip/"
## Type of docs to parse
fileToSearch1="DD*.doc"
fileToSearch2="DD*.docx"
fileToSearch3="Description*.doc*"
## Location to Save
directoryToSave="$VC_WORKSPACE/parsed_Docs"
extractedSectionDir="$VC_WORKSPACE/parsed_Docs/ExtractedSections"
## Global Variables 
FILELIST=""
SectionToSearch="Critical Integration"
NextSec="" ; # Contains end point for the data to extract
FirstSec=""; # Contains the start point for the data to extract
extractstring="" : # Contains the textfile name
newName="${extractstring}.txt"
finalOutput=$VC_WORKSPACE/"$SectionToSearch.txt"

########################################

### Variables for the -file switch ##########
fileName="SDC.txt"
folderPath="syn"
folderToBegin="$VC_WORKSPACE/ip/"
concatOut="$VC_WORKSPACE/$fileName"


usageScript() {
 echo " Following things I can perform...
       -----------------------------------------------------------------------------------
		1) ./getTextfrMSW -msw       --> Extracts Section you specify from all the .doc && .docx files
		2) ./getTextfrMSW -file     --> Extracts Section you specify from \$VC_WORKSPACE
    	3) ./getTextfrMSW -bug        --> Report a Bug to owner (Technically impossible)
       ---------------------------------------------------------------------------------"
}


check_VC_WORKSPACE () {
  printCust "Checking your '\$VC_WORKSPACE' variable..."
  _vc=`eval echo $VC_WORKSPACE`
  if [ ! -d "$_vc" -o "$_vc" == "" ]; then
    echo "ERROR - You have not set a correct VC_WORKSPACE"
    echo "        Please correct this before trying again"
    echo ""
    exit 1
  fi
 unset _vc

}

printCust () {
 
 echo "----------------------------------------------------------"
 printf "%s\n" "$1"
 echo "----------------------------------------------------------"


} 

errCust () {

  echo "----------------------------------------------------------"
  printf "In \"${FUNCNAME[1]}\" funct.  ERROR : %s\n      : %s\n" "$1" "$2"   
  echo "----------------------------------------------------------"	  

}


checkFiles () {
	printCust "Finding Files ($fileToSearch1 | $fileToSearch2 | $fileToSearch3) in $pathToSearch..."
	findFiles $pathToSearch
	if [ ! -d $directoryToSave ]; then
		mkdir -p $directoryToSave
	fi
	for F in ${FILELIST[@]}; do
		printCust "Now Parsing $F... "
		if [ $(echo $F | grep '\.doc$' ) ]; then
			if [ $(echo $F | grep '\$') ]; then
				continue
			else						
				ConvertDoc2txt $F
				CheckSection $directoryToSave/$newName	
			fi
		elif [ $(echo $F | grep '\.docx$') ]; then
			if [ $(echo $F | grep '\$') ]; then
				continue
			else
				ConvertDocx2txt $F
				CheckSection $directoryToSave/$newName
			fi
		else
			errCust "Cannot Determine the type of DOC"
			exit 1
		fi
	done  			 			
}


processFiles () {
	printCust "Processing Converted Files now..."
	if [ -d  $extractedSectionDir ]; then
		rm -rf $extractedSectionDir
		rm -rf $finalOutput
	fi	
	findFiles $directoryToSave
	if [ ! -d $extractedSectionDir ]; then
		mkdir -p $extractedSectionDir
		touch $finalOutput
	fi	
	for F in ${FILELIST[@]}; do
		printCust "###################################################################"
		printCust "Parsing Section in $F... "
		if [ $(echo $F | grep '\.doc\.txt$' ) ]; then
			if [ $(echo $F | grep '\$') ]; then
				continue
			else
				ExtractDocName $F
				ExtractNextSectionDoc $F
				ExtractContent "$F" "$FirstSec" "$NextSec" "$newName" 
			fi
		elif [ $(echo $F | grep '\.docx\.txt$') ]; then
			if [ $(echo $F | grep '\$') ]; then
				continue
			else
				ExtractDocName $F
				ExtractNextSectionDocx $F
				ExtractContent "$F" "$FirstSec" "$NextSec" "$newName" 
			fi
		else
			errCust "Cannot Determine the type of DOC"
			continue
			#exit 1
		fi	
	done
	printCust "Results are here --->  $finalOutput!"	
}

findFiles () {
	OLDIFS=$IFS
	IFS=$(echo -en "\n\b"); # Line seperator = \n Field Seperator = \b (Back Space)
	FILELIST=($(find -L $1 -type f -iname "*$fileToSearch1*" -or -iname "*$fileToSearch2*" -or -iname "*$fileToSearch3*" \( ! -regex '.*/\.svn/.*' \) | grep -v '\.git')) 
	printCust "Total number of files:  ${#FILELIST[@]}"
	echo "${FILELIST[*]}"
	printCust "Following are the files I found for you.. Proceed [y/n]? ";read answer	
	if [ ${answer:0:1} == "y" ]; then
		echo "OK Proceeding..."
	else
		echo "Didnt like my Output ?"
		exit 1
	fi
}


ConvertDoc2txt () {
	pushd antiword > /dev/null ;
	if [ $? -ne 0 ] ; then 
		errCust "antiword directory doesnt exist!"
		exit 1
	fi
	printCust "Converting & Saving $1 --> $directoryToSave/$newName"
	antiword $1 >  $directoryToSave/$newName
	popd > /dev/null
}

ConvertDocx2txt () {
	pushd docx2txt > /dev/null ;
	if [ $? -ne 0 ] ; then 
		errCust "docx2txt directory doesnt exist!"
		exit 1
	fi
	#extractstring=$(ExtractDocName $1)
	printCust "Converting & Saving $1 --> $directoryToSave/$newName"
	perl docx2txt.pl $1 $directoryToSave/$newName
	popd > /dev/null
}


CheckSection () {
	#echo "Hi, There \"$USER\"!"
	echo "Checking for Section : $SectionToSearch"
	#read -p "For which Section would you like me to extract text ?" SectionToSearch
	if [ $(cat $1 | grep -c "$SectionToSearch") -eq 2 ]; then
		printCust "$1 : Contains $SectionToSearch section"
	else
		printCust "$1 : Doesnt contain $SectionToSearch section twice, Removing file"
		rm -rf $1
	fi
}

ExtractNextSectionDocx () {
	printCust "Extracting Next Section from $1"
	while read -r p || [[ -n "$p" ]]; do
		if [[ "$foundSectionInTOC" -eq 1 && ! -z "$p" ]]; then
			foundSectionInTOC=0
			echo "$p"
			NextSec=$(echo "$p" | sed -r "s/	/\n/g" | awk '$0 ~ /^[[:alpha:]]/' ); # Have tab characters in the TOC
			echo "Extracted : $NextSec"
		elif [[ "$foundSection" -eq 1 && "$p" =~ .*${NextSec}.*[^0-9]*$ ]]; then
			 foundSection=0
 			 echo "Next Section : $p"
 			 NextSec=$(echo -e "$p")
 		#else
 			#	echo "Why here ?"
		fi				
		if [[ "$p" =~ .*${SectionToSearch}.*[0-9]$  ]]; then
			foundSectionInTOC=1
			echo "$p"
		elif [[ "$p" =~ ^[0-9S\ \	].*${SectionToSearch}.*[^0-9]*$ ]]; then
			echo "$p"
			foundSection=1
			FirstSec=$(echo -e "$p")
		fi 
			
		#if [[ "$foundSection" -eq 1 && "$p" =~ .*Verification ]]; then
			#	echo "$p"
			#foundSection=0
		#fi
	done < $1		
}


ExtractNextSectionDoc () {
	printCust "Extracting Next Section from $1"
	
	while read -r p || [[ -n "$p" ]]; do
		if [[ "$foundSectionInTOC" -eq 1 && ! -z "$p" ]]; then
			foundSectionInTOC=0
			NextSec=$(echo "$p" | sed -r "s/\  /\n/g" | awk '$0 ~ /^[[:alpha:]]/' ); # Have space characters in the TOC
			echo "Extracted : $NextSec"
		elif [[ "$foundSection" -eq 1 && "$p" =~ .*${NextSec}.*[^0-9]*$ ]]; then
			 foundSection=0
 			 echo "Next Section : $p"
 			 NextSec=$(echo -e "$p")
 		#else
 			#	echo "Why here ?"
		fi
		if [[ "$p" =~ .*${SectionToSearch}.*[0-9]$  ]]; then
			foundSectionInTOC=1
			echo "$p"
		elif [[ "$p" =~ ^[0-9S\ \	].*${SectionToSearch}.*[^0-9]*$ ]]; then
			echo "$p"
			foundSection=1
			FirstSec=$(echo -e "$p")
		#else 
			#	echo "Why not here?"
		fi 
	done < $1	
}


#ExtractContent () {
#	printCust "Main Section $SectionToSearch, Next Section: $2, Doc Name : $3"
#	printCust "In $3" >>  $finalOutput
#	while read -r p || [[ -n "$p" ]]; do
#		if [[ "$p" =~ ^[0-9S\ \	].*${SectionToSearch}[^\t].*$  ]]; then
#			foundSection=1
#			echo "$p"
#			Section1=$(echo "$p")
#		elif [[ "$foundSection" -eq 1 && "$p" =~ .*${2}.*[^0-9]\ *$ ]]; then
#			foundSection=0
#			echo "$p"
#			Section2=$(echo "$p")
#			#awk "/$Section1/ {p=1}; p; /$Section2/ {p=0}" $1 | tee $extractedSectionDir/"${3}_extracted.txt"
#			awk "/$Section1/ {p=1}; p; /$Section2/ {p=0}" $1 >>  $finalOutput
#		else
#			errCust "Nothing found to extract Data from!" >>  $finalOutput
#		fi		
#	done < $1
#}

ExtractContent () {
	printCust "Extracting Content from Doc : $4"
	printCust "Between First Section : $2 , Next Section $3"
	printCust "In $4" >>  $finalOutput
	awk "/$2/ {p=1}; p; /$3/ {p=0}" $1 >>  $finalOutput
}



ExtractDocName () {
		if [[ "$1" =~  .*/(.*\.doc[x]*$) ]]; then
			extractstring=${BASH_REMATCH[1]}
			echo "$extractstring"
			newName="${extractstring}.txt"
		elif [[ "$1" =~  .*/(.*\.doc[x]*\.txt$) ]]; then
			newName=${BASH_REMATCH[1]}
		else
			errCust "  : Cannot extract the File name from Path"
			#exit 1
		fi 				
		#return $extractstring	
}


ExtractFilesFromWS () {
	if [ -f "$concatOut" ]; then
		rm -rf $concatOut
	fi
	printCust "Searching for $fileName in $folderToBegin*/$folderPath/*"
	FindResult=$(find -L $folderToBegin \( -type f -name "$fileName" -and -path "*/$folderPath/*" \) \( ! -regex '.*/\.svn/.*' \) | grep -v '\.git')
	printCust "Total number of files:  ${#FindResult[@]}"
	echo "${FindResult[*]}"
	for F in ${FindResult[@]}; do
		printCust "In $F" >> $concatOut
		cat $F >> $concatOut
	done
	printCust "Results are here --->  $concatOut!"
}

if [ "$#" -eq 1 ]; then
	printCust "SomeOne looks interseted atleast!"
	sleep 2
	check_VC_WORKSPACE
    if [[ "${1:0:4}" == "-bug" ]]; then
        echo "So you would like to report a bug to chsh? "; sleep 2 
        echo "I highly doubt your findings... "
        echo "Anyways.. type in the error message"
        read -p "Here :" message
        echo "$message" | mail -s "Bug reporting for create_ip.sh script" chsh@nordicsemi.no
        printCust "Done..Thanks"; exit 0		
	elif [[ "${1:0:4}" == "-msw" ]]; then
		printCust "Would You like to extract section other than  [Default : $SectionToSearch] [y/n]?"; read -p "Answer:" Answer
		if [ "${Answer:0:1}" == "y" ]; then
			read -p "Please Enter Section Name:" section
			SectionToSearch="$section"
			finalOutput=$VC_WORKSPACE/"$SectionToSearch.txt"
		else
			echo "Very Well Then, Parsing $SectionToSearch"
		fi
		#checkFiles
		processFiles		
	elif [[ "${1:0:5}" == "-file" ]]; then
		ExtractFilesFromWS
	else
		usageScript 		
	fi
	printCust "Have an awesome day (Weather looks good ?)!"
else
	printCust "Good Day $USER!"
	usageScript
fi
		



#cd $directoryToSave
#ExtractNextSectionDoc 