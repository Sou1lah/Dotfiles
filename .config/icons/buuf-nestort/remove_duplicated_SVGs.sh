#!/bin/bash

echo "Running in directory $(pwd)"
read -p "Do you really want to execute the changes (y/n)? " pregunta

if [ "$pregunta" = "y" ]
then
    echo "Changes will be executed"
else
    echo "Changes will NOT be executed; doing a dry run, that is, the script will only show what it would have done if you had answered yes"
fi
read -p "Press Enter to continue..."

for filenamesencer in *.svg
do
    echo "Processing $filenamesencer"
    filename_no_ext="${filenamesencer%.*}"
    echo "Filename without extension: $filename_no_ext"
    filename_png="$filename_no_ext.png"
    if [ -e "$filename_png" ]
    then
        echo "Located an SVG which has also a matching PNG: $filenamesencer and $filename_png"
        echo
        echo "Operation: delete SVG:"
        echo "rm $filenamesencer"
        if [ "$pregunta" = "s" ]
        then
            rm "$filenamesencer"
            echo "rm done"
        fi
    else
        echo "***** There is no matching PNG file, therefore leaving the SVG in place..."
    fi
    echo
    echo
    echo
    
done
