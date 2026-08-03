#!/bin/bash

echo "Executant-se a $(pwd)"
read -p "Executar realment els canvis (s/n)? " pregunta

if [ "$pregunta" = "s" ]
then
    echo "s'executaran els canvis!"
else
    echo "NO s'executaran els canvis, només es llistarà el que es faria"
fi
read -p "Prem Enter per continuar..."

for filenamesencer in *symbolic.svg
do
    echo "Processant $filenamesencer"
    filename_no_ext="${filenamesencer%.*}"
    echo "Nom d'arxiu sense extensió: $filename_no_ext"
    filename_no_ext_no_symbolic="${filename_no_ext%-symbolic*}"
    if [ -e "$filename_no_ext_no_symbolic.png" ]
    then
        echo "Nom d'arxiu sense symbolic ni extensió: $filename_no_ext_no_symbolic"
        echo
        echo "Operació: esborrar SVG:"
        echo "rm $filenamesencer"
        if [ "$pregunta" = "s" ]
        then
            rm "$filenamesencer"
            echo "rm fet"
        fi
        echo "Operació: crear enllaç"
        echo "ln -s $filename_no_ext_no_symbolic.png $filename_no_ext.png"
        if [ "$pregunta" = "s" ]
        then
            ln -s "$filename_no_ext_no_symbolic.png" "$filename_no_ext.png"
            echo "ln fet"
        fi

    else
        echo "********* No hi ha el corresponent png no simbòlic! ***********"
    fi
    echo
    echo
    echo
    
done
