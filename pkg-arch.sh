#!/bin/bash
line=$(grep Architecture: $1/debian/control)
echo $(echo $line | sed -e 's/^Architecture: //')
