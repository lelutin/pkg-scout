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

To remove all built files and residues, use the following in the top directory:

    $ make clean

When developing
---------------

When working on modifications for the packaging, it is useful to have a work
copy set up. To assemble the *source* + *debian* directories under the
build/*distro_version* directory, Use the dev-*name* target (where *name* is
the name of the distribution version you'll be working on):

    $ make dev-testing

You can then 'cd' to the build/*distro_version* directory (in this example,
build/testing) and hack away your modifications.

While working in this directory, you can use the Makefile that is automatically
copied by the dev-*distro_version* target. To build the .dsc + .changes files,
use the 'dsc' target and to build the .deb package, use the 'deb' target. To
build them all, use the default target ('all'). To upload the currently built
package, use the 'upload' target. Finally, to remove files that were created by
the build process, use the 'clean' target:

    $ make
    $ make dsc
    $ make deb
    $ make upload
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

Organizing pakage contents
==========================

The directories at the first level that are either named 'common' or have the
name of a distribution version represent the contents of the debian directory
for each package.

While putting up together the build directory for a distibution version, the
makefile first copies all of the files under the *common* directory. It then
copies all the content of the version specific directory over what is already
there. So you can think of directories named after a distribution version like
the overrides on the common files.

For example, say you have the following structure:

    common
     | compat
     | control
     | copyright
     | pycompat
     | rules
     | watch

    dapper
     | changelog
     | control

    hardy
     | changelog

This means that in the end result, the *debian* directory for Ubuntu Dapper
will have 5 files from common (compat, copyright, pycompat, rules and watch)
and two files from the *dapper* directory (changelog and control). Also, the
*debian* directory for Ubuntu Hardy will have all files from common plus the
changelog file from the *hardy* directory.

This mechanism lets you centralize files that shouldn't differ from one package
to the other, like the *copyright* file while having the flexibility to
override files that can differ like the *control* file.
