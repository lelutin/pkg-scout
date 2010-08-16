#DISTROS := unstable testing stable maverick lucid karmic jaunty hardy
DISTROS := maverick lucid karmic jaunty hardy
PROJECT := scout

LATEST_ARCHIVE:=$(shell ./find-latest-archive.sh)
VERSION := $(patsubst v%.tar.gz,%,$(LATEST_ARCHIVE))
SOURCE_V := $(PROJECT)-$(VERSION)
ARCHV := $(subst -,_,$(SOURCE_V)).orig.tar.gz

.PHONY: all
all: $(DISTROS)

.PHONY: $(DISTROS)
.SECONDEXPANSION:
$(DISTROS): dev-$$@
	$(MAKE) -C build/$@

.PHONY: dev-*
dev-%: build/%/Makefile build/_PROJECT_ build/_VERSION_ build/_SOURCE_V_ \
	build/%/$(SOURCE_V)/debian/changelog
	

.PRECIOUS: build/%/Makefile
build/%/Makefile: Makefile.stage2
	mkdir -p build/$*
	cp -f Makefile.stage2 build/$*/Makefile

# Static variable passing renders the Makefile.stage2 autonomous
.PRECIOUS: build/_PROJECT_ build/_VERSION_ build/_SOURCE_V_
build/_PROJECT_:
	mkdir -p build
	echo $(PROJECT) > $@

build/_VERSION_:
	mkdir -p build
	echo $(VERSION) > $@

build/_SOURCE_V_:
	mkdir -p build
	echo $(SOURCE_V) > $@

.PRECIOUS: build/%/$(SOURCE_V)/debian/changelog
build/%/$(SOURCE_V)/debian/changelog: %/changelog $(ARCHV)
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

.PHONY: clean clean-all
clean:
	rm -rf tmp build
	rm -f $(LATEST_ARCHIVE)

clean-all: clean
	rm -f $(ARCHV)

.PHONY: prep prep-*
prep: $(patsubst %,prep-%,$(DISTROS))

prep-%:
	sudo DIST=$* pbuilder update

.PHONY: upload upload-*
upload: $(patsubst %,upload-%,$(DISTROS))

upload-%: build/%/Makefile
	$(MAKE) -C build/$* upload

.PHONY: apply-*
apply-%:
	@[ -d "build/$*/$(PROJECT)-$(VERSION)/debian" ] || (echo "ERROR: build/$*/$(PROJECT)-$(VERSION)/debian directory not present. nothing to apply." && exit 1)
	cp -r build/$*/$(PROJECT)-$(VERSION)/debian/* $*/
	for i in common/*; do j=$$(basename $$i); if `diff -qbur $$i $*/$$j`; then rm $*/$$j; fi; done
