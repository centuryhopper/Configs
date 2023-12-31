#!/usr/bin/env python3

import subprocess, os

lines = ''
os.chdir("~/.ssh/")

with open('tmp.txt', 'r') as file:
    lines = file.readlines()

for line in lines:
    if '=' in line:
        key, value = line.strip().split('=')
        key = key.strip()
        value = value.split(';')[0].strip()
        command = f'set -x {key}="{value}"'
        subprocess.run(command, shell=True)
