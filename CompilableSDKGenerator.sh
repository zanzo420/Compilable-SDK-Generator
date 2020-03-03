#!/bin/bash
curDIR=`pwd -W`
configDir="Config"
baseDir="Config/files"
inputDir="INPUT/SDK"
outputDir="OUTPUT"
includeDir="OUTPUT/include"
sourceDir="OUTPUT/source"

oifs=$IFS # backup the Original IFS.
IFS=$'\n'

# create arrays of all required files from .txt files
IncludeFiles=( $(< Config/lists/includes.txt) )	# Header Files
SourceFiles=( $(< Config/lists/sources.txt) )	# Source Files
BaseFiles=( $(< Config/lists/basefiles.txt) )	# Other Files
ProjFiles=( $(< Config/lists/files.txt) )		# VS Project/Solution Files
# Load up out command-line ui elements from .txt files
uiBanner=( $(< Config/ui/banner.txt) )
uiHeader=( $(< Config/ui/header.txt) )
uiFooter=( $(< Config/ui/footer.txt) )
uiHelp=( $(< Config/ui/help.txt) )
uiConfirm=( $(< Config/ui/confirm.txt) )
uiIncFiles=( $(< Config/ui/incfiles.txt) )
uiSrcFiles=( $(< Config/ui/srcfiles.txt) )
uiAddFiles=( $(< Config/ui/genfiles.txt) )
uiVSFiles=( $(< Config/ui/vsfiles.txt) )
uiDone=( $(< Config/ui/done.txt) )
uiDone2=( $(< Config/ui/goodbye.txt) )

IFS=$oifs # restore the original IFS.

function showBanner() {
# DISPLAY UI HEADER
for i in "${uiBanner[@]}"
do
	echo -e "\e[0;31m$i\e[0m"
done
}
function showIncFiles() {
for i in "${uiIncFiles[@]}"
do
	echo -e "\e[0;32m$i\e[0m"
done
}
function showSrcFiles() {
for i in "${uiSrcFiles[@]}"
do
	echo -e "\e[0;32m$i\e[0m"
done
}
function showAddFiles() {
for i in "${uiAddFiles[@]}"
do
	echo -e "\e[0;32m$i\e[0m"
done
}
function showVSFiles() {
for i in "${uiVSFiles[@]}"
do
	echo -e "\e[0;32m$i\e[0m"
done
}
function showfooter() {
# show footer ui
for i in "${uiFooter[@]}"
do	
	echo "$i" 
done
}
function showHeader() {
# show header ui
for i in "${uiHeader[@]}"
do	
	echo "$i" 
done
}
function showDone() {
# show header ui
for i in "${uiDone[@]}"
do	
	echo "$i" 
done
}
function showDone2() {
# show header ui
for i in "${uiDone2[@]}"
do	
	echo "$i" 
done
}
function showhelp() {
# show help ui
echo -e "     +--\e[0;32mINSTRUCTIONS\e[0m---------------------------------------------------------+"
for h in "${uiHelp[@]}"
do	
	echo -e "$h" 
done
echo -e "     +----------------------------------------------------------------\e[0;31mzH4x\e[0m---+"
}

function generate() {
# Move all required files from the SDK to the "OUTPUT" directory...
showIncFiles && sleep 1
echo "
[Compilable SDK Generator] Pulling all required Header files (.hpp) from full SDK..."
for i in "${IncludeFiles[@]}"						# Move "Header Files" to "include" output folder.
do
	echo "Adding \"$i\""
	mv -f -v "$inputDir/$i" "$includeDir/$i"
done
showSrcFiles && sleep 1
echo "
[Compilable SDK Generator] Pulling all required Source files (.cpp) from full SDK..."
for s in "${SourceFiles[@]}"						# Move "Source Files" to "source" output folder.
do
	echo "Adding \"$s\""
	mv -f -v "$inputDir/$s" "$sourceDir/$s"
done
showAddFiles && sleep 1
sleep 1
# Move all other pre-generated files from the "Config" directory...
echo "
[Compilable SDK Generator] Generating all additional required files..."
for b in "${BaseFiles[@]}"							# Move "Other Files" to "include" output folder.
do
	echo "Generating \"$b\""
	mv -f -v "$baseDir/$b" "$includeDir/$b"
	sleep 0.2
done
showVSFiles && sleep 1
echo "
[Compilable SDK Generator] Creating Visual Studio Project & Solution files..."
for p in "${ProjFiles[@]}"							# Move "Visual Studio Files" to "OUTPUT" directory.
do
	echo "Generating \"$p\""
	mv -f -v "$baseDir/$p" "$outputDir/$p"
	sleep 0.2
done

showfooter && sleep 1
echo "+---------------------------------------------------------------------------------+
|                      COMPILABLE SDK GENERATION COMPLETE!                        |
+---------------------------------------------------------------------------------+"
echo "'-› Generated SDK Location: \"$curDIR$outputDir/\"
"
showDone
sleep 5 && ask_user
}

# ############################### ############################### ##################################
function ask_user() {    
echo "+---------------------------------------------------------------------------------+"
echo -e "|                             \e[0;32mGenerate Compilable SDK?\e[0m                            |
|                                                                                 |
+---------------+---------------+----------------+----------------+---------------+
                |    \e[0;32m1.) YES\e[0m    |    \e[0;33m2.) HELP\e[0m    |    \e[0;31m3.) QUIT\e[0m    |
                +---------------+----------------+----------------+\n"
read -e -p "Select 1: " choice

if [ "$choice" == "1" ]; then
    generate
elif [ "$choice" == "2" ]; then
	showhelp && sleep 3 && ask_user
elif [ "$choice" == "3" ]; then
    clear && showDone2 && sleep 3 && exit 0
else
    echo "Please select 1, 2, or 3." && sleep 3
    clear && ask_user
fi
}
####################
showBanner
# Promt User
ask_user

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
