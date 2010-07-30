How to use
==========

First of all, make sure the values for the variables are right (See
configuration section below). Then, update any file in subdirectories named
after the distribution versions that you need to modify. Make sure to create
all the pbuilder environments that are necessary. If they already exist on your
computer, update them with either "prep" for all distribution versions or
"prep-*name*" for a specific distribution version name:

    $ make prep
    $ make prep-jaunty

To build all packages, simply call:

    $ make

To build only a subset of the distribution version, specify them as make
targets:

    $ make maverick lucid

To upload packages to Launchpad, either use the "upload" target for all
packages, or "upload-*name*" for a specific distribution version name:

    $ make upload
    $ make upload-karmic upload-hardy

To remove all built files and residues, use:

    $ make clean

Configuration
=============

If any detail changes for the project, or if you'd like to use this makefile
system for another project, here are the values you can adjust.

Makefile
--------

The names of the distribution versions that the "all" target builds are set in
the DISTROS variable:

    DISTROS := unstable lucid

The project name is set in the PROJECT variable:

    PROJECT := scout

Makefile.stage2
---------------

The repositories where packages are pushed are set in UB_REPOS_URL and
DEB_REPOS_URL for Ubuntu and Debian, respectively:

    UB_REPOS_URL := ppa:your-name/ppa-name
    DEB_REPOS_URL := some_url
