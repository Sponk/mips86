#!/bin/bash

djtgcfg enum
djtgcfg init -d Basys2
djtgcfg prog -d Basys2 --index $1 --file $2

