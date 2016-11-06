#!/bin/bash
version="1.0"
arguments=( "$@" )      #gets all the arguments givven to the script, puts them into an array called "arguments"
required=(vnstat)       #list of dependencies
checkRoot () {                          #check if the script is run as root
    if [ "$(id -u)" != "0" ]; then
            echo "You are not root. Please run this script with "sudo" in front of it"
            exit 1
    fi
}

#a function that checks if a text is an element of the arguments array
containsArgument () {
    local arg="$1"
    if [[ " ${arguments[@]} " =~ " $arg " ]]; then
        return 0
    else
        return 1
    fi
}

dependenciesInstall () {            #checks for required packages and installs them if they are missing
    echo "Checking for prerequisites"
    for i in "${required[@]}"                       #start checking
    do
        echo "Checking for $i"
        if [ $(dpkg-query -W -f='${Status}' $i 2>/dev/null | grep -c "ok installed") -eq 0 ]; then           #asks dpkg wherther the package is install
            echo "$i is not installed, attempting to install it now"
            checkRoot                       #if a package is missing and script is not run as root
            apt-get update && apt-get -y install $i
        fi
    done
}




if containsArgument "--all" || containsArgument "-a" ; then     #checks for "all" or "a" in the arguments array
    dependenciesInstall
    copyFiles
elif containsArgument "--copy" || containsArgument "-c" ; then
    copyFiles
elif containsArgument "--install-dependencies" || containsArgument "-i" ; then
    dependenciesInstall
elif containsArgument "--version" || containsArgument "-v" ; then
    echo setupRouter.sh version $version made by Sobotkama
else
    echo "Incorrect syntax, correct syntax is setupRouter.sh [--all]/[-a]/[--copy]/[-c]/[--install-dependencies]/[-i]/[--version]/[-v]/[--help]/[-h]"      #If no argument is passed, display correct syntax and exit
    exit 1
fi
