#!/bin/bash
# This file will create abc and tools folder,set permissions, and add headers in the corresponding files required for IC-9981 as mentioned in the Confluence page.
# if the folders already exists and also the files in that folders, the script will assume all the permissions are already set
# User needs to give IP name as argument [example:  ./createJenkinsJobFolders.sh PantherTimingEngine]

Dirabc='abc'
Dirtools='tools'
DirbuildServer='buildserver'
filetmp='tmp'
fileDoConfig='DoConfig'
fileIpJobs='IpJobs'
xmlHeader='<design>
<info>
  <project>LodeRunner</project>
  <projectnumber>4377</projectnumber>
  <N_ConfigStyle>1.1</N_ConfigStyle>
</info>
<VersionControl
  System   = "SubVersion"
  Revision = "$Revision$"
  URL      = "$HeadURL$"
  Date     = "$Date$"
  Author   = "$Author$"
/>
<dependencies>
</dependencies>'
toolsxmlHeader='<?xml version="1.0" encoding="UTF-8"?>
<ipjobs project="%s" svnheader="$Header$">'
replacementstring=$1


create_folders (){
    if [ -z "$1" ]; #the z argument checks for empty string
    then
        echo "No argument supplied, supply IP name as argument"       
        exit 1
    fi
   cd $VC_WORKSPACE/ip/$1
    if [ $? -eq 0 ]; then
         echo OK
     else
         exit 1
     fi
   pwd
   if [ ! -d "$Dirabc" ]; #if abc directory doesnt exist
   then
     echo "$Dirabc doesnt exist, creating one now"   
     svn mkdir $Dirabc 
     svn commit $Dirabc -m "Creating the dir abc" # Control will enter here if $DIRECTORY doesn't exist.
     svn up
     cd $Dirabc
     if [ $? -eq 0 ]; then
         echo OK
     else
         exit 1
     fi
     if [ -f "$fileDoConfig" ];  #if DoConfig file exists
     then
        echo "$fileDoConfig found."
        svn ps svn:executable on $fileDoConfig
        svn commit $fileDoConfig -m "Setting the executable property"
     else
        echo "$fileDoConfig not found,creating one now"
        touch $fileDoConfig        
	    echo "#!/bin/sh -e
Note: sh must have the -e parameter to return error codes from DoConfig.pl
\$VC_WORKSPACE/methodology/DesignKit/scripts/VersionControl/DoConfig/DoConfig.pl \$*" > $fileDoConfig 
        svn add $fileDoConfig                         
        svn commit $fileDoConfig -m "adding DoConfig"
        svn ps svn:executable on $fileDoConfig
        svn commit $fileDoConfig -m "Setting the executable property"
     fi
     if [ -f "$1.xml" ]; #if the IP.XML file exists
     then
        echo "$1.xml found."
        echo "Assuming the keyword property is already set"
     else #if IP.XML doesn't exists
        echo "$1.xml not found, creating one now" 
        touch $1.xml
        echo "$xmlHeader"> $1.xml
        svn add $1.xml 
        svn commit $1.xml -m "adding $1.xml"                               
        svn ps svn:keywords 'Author Date Revision HeadURL Id Header' $1.xml
        svn commit $1.xml -m "setting property keyword on $1.xml" 
     fi
   else #if abc directory already exists
     echo "the $Dirabc  directory already exist for this IP"
     svn info $Dirabc 1>/dev/null 2>&1
     if [ $? -eq 0 ]; then
         echo "folder exists on the repo"
     else
         echo "folder doesnt exists on the repo commiting now"
         svn add $Dirabc
         svn commit $Dirabc -m "Creating directory $Dirabc"
     fi
     cd $Dirabc
     if [ -f "$fileDoConfig" ];  #if DoConfig file exists
     then
        echo "$fileDoConfig found."
        svn ps svn:executable on $fileDoConfig
        svn commit $fileDoConfig -m "Setting the executable property"
     else
        echo "$fileDoConfig not found."
        touch $fileDoConfig
        echo "#!/bin/sh -e                                                                                           
Note: sh must have the -e parameter to return error codes from DoConfig.pl
\$VC_WORKSPACE/methodology/DesignKit/scripts/VersionControl/DoConfig/DoConfig.pl \$*" > $fileDoConfig  
        svn add $fileDoConfig                         
        svn commit $fileDoConfig -m "adding DoConfig" 
        svn ps svn:executable on $fileDoConfig
        svn commit $fileDoConfig -m "Setting the executable property"
     fi
     if [ -f "$1.xml" ];
     then
        echo "$1.xml found."
        echo "Assuming the keyword property is already set"
     else
        echo "$1.xml not found, creating one now." 
        touch $1.xml
        echo "$xmlHeader"> $1.xml
        svn add $1.xml 
        svn commit $1.xml -m "adding $1.xml"                               
        svn ps svn:keywords 'Author Date Revision HeadURL Id Header' $1.xml
        svn commit $1.xml -m "adding $1.xml"
     fi
   fi
   cd ..
   pwd
   svn up      #update the WS
   if [ ! -d "$Dirtools" ]; #if tools directory doesnt exist
   then
     echo "$Dirtools doesnt exist, creating one now"  
     svn mkdir $Dirtools 
     svn commit $Dirtools -m "Creating the dir tools" # Control will enter here if $DIRECTORY doesn't exist.
     svn up
     cd $Dirtools
     if [ ! -d "$DirbuildServer" ]; #if buildserver directory doesnt exist
     then
         echo "$DirbuildServer doesnt exist, creating one now"  
         svn mkdir $DirbuildServer
         svn commit $DirbuildServer -m "Creating the dir buildserver" # Control will enter here if $DIRECTORY doesn't exist.
         svn up
         cd $DirbuildServer
         if [ $? -eq 0 ]; then      #sanity check for the buildserver directory.
             echo OK
         else
             exit 1
         fi
         if [ -f "$fileIpJobs.sh" ];  #if IpJobs.sh file exists
         then
            echo "$fileIpJobs.sh found."
            svn ps svn:executable on $fileIpJobs.sh 
            svn commit $fileIpJobs.sh -m "Setting the executable property"
         else
            echo "$fileIpJobs.sh not found,creating one now"
            touch $fileIpJobs.sh        
            echo "#!/bin/sh -e
\$VC_WORKSPACE/methodology/DesignKit/scripts/buildserver/IpJobs/IpJobs.py \$*" > $fileIpJobs.sh 
            svn add $fileIpJobs.sh                         
            svn commit $fileIpJobs.sh -m "adding $fileIpJobs.sh"
            svn ps svn:executable on $fileIpJobs.sh 
            svn commit $fileIpJobs.sh -m "Setting the executable property"
         fi
         if [ -f "$1.xml" ]; #if the IP.XML file exists
         then
            echo "$1.xml found."
            echo "Assuming the keyword property is already set"
         else #if IP.XML doesn't exists
            echo "$1.xml not found, creating one now" 
            touch $1.xml                    
            printf -v toolsxmlHeader "$toolsxmlHeader" "$replacementstring" ## string_replace variable_name  "$placeholder_string(replaces only %s in the string)"  "replacement string":w 
            echo "$toolsxmlHeader" > $1.xml 
            svn add $1.xml 
            svn commit $1.xml -m "adding $1.xml" 
            svn ps svn:keywords 'Author Date Revision HeadURL Id Header' $1.xml
            svn commit $1.xml -m "setting property keyword on $1.xml"    
         fi
     else #if buildserver directory already exist
         echo "$DirbuildServer already exists"
         svn info $DirbuildServer 1>/dev/null 2>&1 # discard the STDOUT generated by the svn info command and send the errors to STDOUT
         if [ $? -eq 0 ]; # check if the last command resulted in error or not 
         then
            echo "folder exists on the repo"
         else
            echo "folder doesnt exists on the repo commiting now"
            svn add $DirbuildServer
            svn commit $DirbuildServer -m "Creating directory $DirbuildServer"
         fi
         cd $DirbuildServer
         if [ $? -eq 0 ]; 
         then
             echo OK
         else
             exit 1
         fi
         if [ -f "$fileIpJobs.sh" ];  #if IpJobs.sh file exists
         then
            echo "$fileIpJobs.sh found."
            svn ps svn:executable on $fileIpJobs.sh 
            svn commit $fileIpJobs.sh -m "Setting the executable property"
         else
            echo "$fileIpJobs.sh not found,creating one now"
            touch $fileIpJobs.sh        
            echo "#!/bin/sh -e
\$VC_WORKSPACE/methodology/DesignKit/scripts/buildserver/IpJobs/IpJobs.py \$*" > $fileIpJobs.sh 
            svn add $fileIpJobs.sh                         
            svn commit $fileIpJobs.sh -m "adding $fileIpJobs.sh"
            svn ps svn:executable on $fileIpJobs.sh 
            svn commit $fileIpJobs.sh -m "Setting the executable property"
         fi
         if [ -f "$1.xml" ]; #if the IP.XML file exists
         then
            echo "$1.xml found."
            echo "Assuming the keyword property is already set"
         else #if IP.XML doesn't exists
            echo "$1.xml not found, creating one now" 
            touch $1.xml        
            printf -v toolsxmlHeader "$toolsxmlHeader" "$replacementstring" ## string_replace variable_name  "$placeholder_string(replaces only %s in the string)"  "replacement string":w 
            echo "$toolsxmlHeader" > $1.xml 
            svn add $1.xml 
            svn commit $1.xml -m "adding $1.xml" 
            svn ps svn:keywords 'Author Date Revision HeadURL Id Header' $1.xml
            svn commit $1.xml -m "setting property keyword on $1.xml"  
         fi
     fi
   else #if tools  directory already exists 
     echo "the $Dirtools  directory already exist for this IP"
     svn info $Dirtools 1>/dev/null 2>&1
     if [ $? -eq 0 ]; then
            echo "folder exists on the repo"
     else
            echo "folder doesnt exists on the repo commiting now"
            svn add $Dirtools
            svn commit $Dirtools -m "Creating directory $Dirtools"
     fi
     cd $Dirtools                           
     if [ ! -d "$DirbuildServer" ]; #if buildserver directory doesnt exist
     then
         echo "$DirbuildServer doesnt exist, creating one now"  
         svn mkdir $DirbuildServer 
         svn commit $DirbuildServer -m "Creating the directory $DirbuildServer " # Control will enter here if $DIRECTORY doesn't exist.
         svn up
         cd $DirbuildServer
         if [ $? -eq 0 ]; then
             echo OK
         else
             exit 1
         fi
         if [ -f "$fileIpJobs.sh" ];  #if IpJobs.sh file exists
         then
            echo "$fileIpJobs.sh found."
            svn ps svn:executable  on $fileIpJobs.sh 
            svn commit $fileIpJobs.sh -m "Setting the executable property"
         else
            echo "$fileIpJobs.sh not found,creating one now"
            touch $fileIpJobs.sh        
            echo "#!/bin/sh -e
\$VC_WORKSPACE/methodology/DesignKit/scripts/buildserver/IpJobs/IpJobs.py \$*" > $fileIpJobs.sh 
            svn add $fileIpJobs.sh                         
            svn commit $fileIpJobs.sh -m "adding $fileIpJobs.sh"
            svn ps svn:executable on $fileIpJobs.sh 
            svn commit $fileIpJobs.sh -m "Setting the executable property"
         fi
         if [ -f "$1.xml" ]; #if the IP.XML file exists
         then
            echo "$1.xml found."            
            echo "Assuming the keyword property is already set"
         else #if IP.XML doesn't exists
            echo "$1.xml not found, creating one now" 
            touch $1.xml        
            printf -v toolsxmlHeader "$toolsxmlHeader" "$replacementstring" ## string_replace variable_name  "$placeholder_string(replaces only %s in the string)"  "replacement string":w 
            echo "$toolsxmlHeader" > $1.xml 
            svn add $1.xml 
            svn commit $1.xml -m "adding $1.xml" 
            svn ps svn:keywords 'Author Date Revision HeadURL Id Header' $1.xml
            svn commit $1.xml -m "setting property keyword on $1.xml"  
         fi
     else #if buildserver directory already exist
         echo "$DirbuildServer already exists"
         cd $DirbuildServer
         if [ -f "$fileIpJobs.sh" ];  #if IpJobs.sh file exists
         then
            echo "$fileIpJobs.sh found."
            svn ps svn:executable on $fileIpJobs.sh 
            svn commit $fileIpJobs.sh -m "Setting the executable property"
         else
            echo "$fileIpJobs.sh not found,creating one now"
            touch $fileIpJobs.sh        
            echo "#!/bin/sh -e
\$VC_WORKSPACE/methodology/DesignKit/scripts/buildserver/IpJobs/IpJobs.py \$*" > $fileIpJobs.sh 
            svn add $fileIpJobs.sh                         
            svn commit $fileIpJobs.sh -m "adding $fileIpJobs.sh"
            svn ps svn:executable on $fileIpJobs.sh 
            svn commit $fileIpJobs.sh -m "Setting the executable property"
         fi
         if [ -f "$1.xml" ]; #if the IP.XML file exists
         then
            echo "$1.xml found."
            echo "assuming the keyword property is already set"
         else #if IP.XML doesn't exists
            echo "$1.xml not found, creating one now" 
            touch $1.xml        
            printf -v toolsxmlHeader "$toolsxmlHeader" "$replacementstring" ## string_replace variable_name  "$placeholder_string(replaces only %s in the string)"  "replacement string":w 
            echo "$toolsxmlHeader" > $1.xml 
            svn add $1.xml 
            svn commit $1.xml -m "adding $1.xml" 
            svn ps svn:keywords 'Author Date Revision HeadURL Id Header' $1.xml
            svn commit $1.xml -m "setting property keyword on $1.xml"  
         fi
     fi
   fi
}

create_folders $1


