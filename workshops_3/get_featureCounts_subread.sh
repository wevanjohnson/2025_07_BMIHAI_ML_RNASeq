#!/bin/bash

# Path to be added
SUBREAD_PATH="/projects/community/classes/bmihai_camp/apps/subread-2.0.3-Linux-x86_64/bin"

# Check if the path is already in .bashrc
if ! grep -Fxq "export PATH=\$PATH:$SUBREAD_PATH" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Add Subread (featureCounts) to PATH" >> ~/.bashrc
    echo "export PATH=\$PATH:$SUBREAD_PATH" >> ~/.bashrc
    echo "Subread path added to ~/.bashrc."
else
    echo "Subread path already present in ~/.bashrc."
fi

source ~/.bashrc