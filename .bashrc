#!/bin/bash
# get's the directory of the script and appends /Source to it, no matter where it's called
DIR=$(dirname "$0")/Source
export PATH="$PATH:$DIR/Documentation"
export PATH="$PATH:$DIR/DotNET"

