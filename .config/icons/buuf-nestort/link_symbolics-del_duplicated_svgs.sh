#!/bin/bash

# This script does the following:
#   scan all icon_name-symbolic.svg
#       if there is no icon_name-symbolic.png
#           create one linking to the non-symbolic
#           remove the symbolic svg
#   scan for all svgs
#       if there is a png with the same name, remove the SVG
#   It doesn't remove svg that don't have a corresponding png (these svgs are there while the theme is not yet complete, so I can see I need to create an icon. Yes, it's ugly to publish a theme like that, sorry)

#   You can use it in "dry mode", where it prompts what it would do, but without actually doing it

# So far you need to cd to an icon directory (i.e. cd apps) and then run it from there (i.e. ../link_symbolics_del_duplicated_svgs.sh)
# ideally it would scan all the directories and do its thing in each of them.

showHelp () {
    
    echo "Usage: $(basename "$0") option"
    echo "It admits just one parameter. Options:"
    echo -e "\t --help: display help"
    echo -e "\t --dry-run: do not actually do the changes, just prompt them"
}

showErrorUsage () {
# shows an error message (paramter 1) and then calls showHelp
    echo $1
    showHelp
}



if [ $# -gt 1 ]
then
    showErrorUsage "Error: you can only enter one parameter"
    exit 1
fi

dryRun=false

if [ $# -eq 1 ]
then
    case $1 in
        --help)
            showHelp
            exit 0
        ;;
        --dry-run)
            dryRun=true
        ;;
        *)
            showErrorUsage "Error: unknown parameter"
            exit 1
        ;;
    esac
fi
        
if ! $dryRun
then
    read -p "Do you really want to remove the files and apply the changes (y/n)? " question
    
    if [ "$question" = "y" ]
    then
        echo "changes will be applied!"
    else
        echo "NO changes will by applied, running in dry mode"
        dryRun=true
    fi
fi
read -p "Press Enter to continue..."


# ------------------- To review below here, it's an old version!!!

# scan all *symbolic.svg, and for each of them:
#   if there is no icon_name-symbolic.png and there is icon_name
#       create one linking to the non-symbolic
#

echo -e "1st step: creating -symbolic PNGs where there is a -symbolic SVG and a mathing non-symbolic PNG \n\n"

for filename_full in *symbolic.svg
do
    echo -e "\n ------ Processing $filename_full --------"
    filename_no_ext="${filename_full%.*}"
    echo "file name without extension: $filename_no_ext"
    filename_no_ext_no_symbolic="${filename_no_ext%-symbolic*}"
    if [ -e "$filename_no_ext_no_symbolic.png" ]
    then
        echo "Found a symbolic SVG and a matching PNG:"
        echo "Filename without extension nor '-symbolic': $filename_no_ext_no_symbolic"

        if [ ! -e $filename_no_ext.png ]
        then
            echo "Operation: create symbolic link"
            echo "ln -s $filename_no_ext_no_symbolic.png $filename_no_ext.png"
            if ! $dryRun
            then
                ln -s "$filename_no_ext_no_symbolic.png" "$filename_no_ext.png"
                echo "link created"
            else
                echo "running in dry mode, link not created"
            fi
        else 
            echo "There is already a -symbolic PNG for this icon, so nothing to do in this step"
        fi

    else
        echo "No matching $filename_no_ext_no_symbolic.png found, so nothing to do. This is an icon yet to be created, and $filename_full is a placeholder to remember."
    fi
done
echo -e "\n\n\n1st step finished! \n\n\n"

# scan all *.svg, and for each:
#   if there is a matching filename.png then remove the svg


echo -e "2nd step: removing all SVGs that have an exact matching PNG"

for filename_full in *.svg
do
    echo -e "\n ------- Processing $filename_full -------------"
    filename_no_ext="${filename_full%.*}"
    echo "file name without extension: $filename_no_ext"
    if [ -e $filename_no_ext.png ]
    then
        echo "Found $filename_no_ext.png matching $filename_full"
        echo "Operation: remove SVG:"
        echo "rm $filename_full"
        if ! $dryRun
        then
            rm "$filename_full"
            echo "file removed"
        else
            echo "running in dry mode, file not removed"
        fi        
    else
        echo "No matching $filename_no_ext.png found, so nothing to do. This is an icon yet to be created, and $filename_full is a placeholder to remember."
    fi
done
echo -e "\n\n2nd step finished! \n\n"


