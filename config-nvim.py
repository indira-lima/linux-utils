#!/usr/bin/env python3
#
# Script for configuring python evironments for NeoVim
# Made with ♥️ by @indira-lima

import sys
import subprocess

def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

install('pynvim')
install('black')
install('flake8')
