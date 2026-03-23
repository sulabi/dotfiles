#!/bin/bash

if ! command -v stow &> /dev/null; then
	echo "Install stow first";
	exit
fi

stow -vD --target=$HOME .
