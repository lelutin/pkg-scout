#!/bin/bash
wget -q -O - http://githubredir.debian.net/github/lelutin/scout | grep "v[0-9.]\+.tar.gz" | tail -1 | sed -e "s/^.*scout\///" -e "s/\.tar\.gz.*$/.tar.gz/"
