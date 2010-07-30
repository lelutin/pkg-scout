#!/bin/bash
echo $(head -1 $1/debian/changelog | sed -e "s/^.*($2//" -e 's/).*$//')
