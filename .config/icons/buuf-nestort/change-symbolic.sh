#!/bin/bash
#
echo "eliminates svg symbolic icon and links a symbolic png to the original"
echo "it does not check for anything, be sure to do it right!"
echo "It executes this:"
echo rm $1-symbolic.svg
echo ln -s $1.png $1-symbolic.png

rm $1-symbolic.svg
ln -s $1.png $1-symbolic.png
