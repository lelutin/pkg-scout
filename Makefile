#DISTROS := unstable testing stable maverick lucid karmic jaunty hardy
DISTROS := maverick lucid karmic jaunty hardy
PROJECT := scout

LATEST_ARCHIVE:=$(shell ./find-latest-archive.sh)
VERSION := $(patsubst v%.tar.gz,%,$(LATEST_ARCHIVE))
SOURCE_V := $(PROJECT)-$(VERSION)
ARCHV := $(subst -,_,$(SOURCE_V)).orig.tar.gz

export DISTROS PROJECT VERSION SOURCE_V

.PHONY: all
all: $(DISTROS)

.PHONY: $(DISTROS)
.SECONDEXPANSION:
$(DISTROS): build/$$@/$(SOURCE_V)/debian/changelog build/$$@/Makefile
	DISTRO=$@ $(MAKE) -C build/$@ $@

build/%/Makefile: Makefile.stage2
	cp -f Makefile.stage2 build/$*/Makefile

build/%/$(SOURCE_V)/debian/changelog: $$*/changelog $(ARCHV)
	mkdir -p build/$*
	cd build/$* && tar -xf ../../$(ARCHV)
	mkdir -p build/$*/$(SOURCE_V)/debian
	cp -r common/* build/$*/$(SOURCE_V)/debian/
	cp -r $*/* build/$*/$(SOURCE_V)/debian/

$(ARCHV):
	wget -O $(LATEST_ARCHIVE) http://githubredir.debian.net/github/lelutin/scout/$(LATEST_ARCHIVE)
	rm -rf tmp
	mkdir tmp
	tar xf $(LATEST_ARCHIVE) -C tmp/
	mv tmp/* tmp/$(SOURCE_V)
	cd tmp && tar czf ../$(ARCHV) $(SOURCE_V)

.PHONY: clean
clean:
	rm -rf tmp build
	rm -f *.tar.gz

.PHONY: prep
prep: $(patsubst %,prep-%,$(DISTROS))

.PHONY: prep-*
prep-%:
	sudo DIST=$* pbuilder update

.PHONY: upload
upload: $(patsubst %,upload-%,$(DISTROS))

.PHONY: upload-*
upload-%: build/$$*/Makefile
	$(MAKE) -C build/$* upload-$*
