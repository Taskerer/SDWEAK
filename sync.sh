#!/bin/bash

rm -f SDWEAK.zip
wget https://github.com/Taskerer/SDWEAK/releases/latest/download/SDWEAK.zip
rm -rf SDWEAK
unzip SDWEAK.zip
cd SDWEAK

sudo steamos-readonly disable
sudo --preserve-env=HOME ./install.sh
