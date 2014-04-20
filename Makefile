
NAME=qasim
DESTDIR=/usr/local
DEV_DESTDIR=tmp
CONFDIR=$(DESTDIR)/etc
BINDIR=$(DESTDIR)/usr/bin
MANDIR=$(DESTDIR)/usr/share/man
DOCDIR=$(DESTDIR)/usr/share/doc
SHAREDIR=$(DESTDIR)/usr/share

RUBYVERSION=1.8
RDOC=rdoc$(RUBYVERSION)

all: \
	build \
	install

clean: \
	clean-ui \
	clean-qrc \
	clean-bin \
	clean-lib \
	clean-data \
	clean-doc

build: \
	build-ui \
	build-qrc \
	build-bin \
	build-lib \
	build-data
	
doc: build-doc

install: \
	install-ui \
	install-qrc \
	install-bin \
	install-lib \
	install-data

## DOC SECTION

.PHONY: build-doc

clean-doc: 
	rm -fr doc

build-doc: clean-doc
	$(RDOC) \
		--promiscuous \
		--inline-source \
		--line-numbers \
		-o doc lib/$(NAME)/ \
		bin/
	# --diagram

install-doc:
	#          # install documentation
	rm -fr $(DOCDIR)/$(NAME)
	mkdir -p $(DOCDIR)/$(NAME)
	cp -a doc $(DOCDIR)/$(NAME)


## QRC -> QRC_RB SECTION

QRC_FILES=$(wildcard lib/$(NAME)/*.qrc)
RBQRC_FILES=$(patsubst %.qrc,%_qrc.rb,$(QRC_FILES))

clean-qrc:
	rm -f $(RBQRC_FILES)

build-qrc: $(RBQRC_FILES)
	echo $(RBQRC_FILES)

install-qrc: $(RBQRC_FILES)
	# FIXME install qrc
	
%_qrc.rb: %.qrc
	rbrcc $< -o $@

## UI -> UI_RB SECTION

UI_FILES=$(wildcard lib/$(NAME)/ui/*.ui)
RBUI_FILES=$(patsubst %.ui,%_ui.rb,$(UI_FILES))

clean-ui: 
	rm -f $(RBUI_FILES)

build-ui: $(RBUI_FILES)
	echo $(RBUI_FILES)

install-ui: $(RBUI_FILES)
	# FIXME install

%_ui.rb: %.ui
	bundle exec rbuic4 $< -o $@
	sed -e '/^module Ui/,/^end  # module Ui/d' \
		-i $@


## BINARY SECTION

clean-bin:
	# make no sense in ruby

build-bin:

install-bin: 
	mkdir -p $(BINDIR)
	for binfile in bin/*.rb ; do \
		BINFILE=`basename $$binfile |sed -e 's/.rb$$//'`; \
		install -D -o root -g root -m 755 $$binfile $(BINDIR)/$$BINFILE; \
		sed -i -e 's|^QASIM_INCLUDE_DIR.*|QASIM_INCLUDE_DIR = "$(SHAREDIR)/$(NAME)/lib"|' $(BINDIR)/$$BINFILE; \
		sed -i -e 's|^QASIM_DATA_DIR.*|QASIM_DATA_DIR = "$(SHAREDIR)/$(NAME)"|' $(BINDIR)/$$BINFILE; \
	done
	#install -D -o root -g root -m 755 $(CURDIR)/bin/$(NAME)-gui.rb $(BINDIR)/$(NAME)-gui

## LIB SECTION

clean-lib:

build-lib:

install-lib:
	IFS="" find lib -name '*.rb' | while read libfile ; do \
		install -D -o root -g root -m 644 $$libfile $(SHAREDIR)/$(NAME)/$$libfile; \
	done


## DATA SECTION

clean-data:

build-data:

install-data:
	## Install man pages
	# mkdir -p $(MANDIR)/man1
	# cat $(NAME).1 | gzip > $(MANDIR)/man1/$(NAME).1.gz
	#
	## Install icons
	mkdir -p $(SHAREDIR)/$(NAME)/icons
	install -D -o root -g root -m 644 $(CURDIR)/data/icons/$(NAME).svg \
		$(SHAREDIR)/$(NAME)/icons/$(NAME).svg
	#
	## Install completion file
	# install -D -o root -g root -m 644 $(CURDIR)/$(NAME).completion $(DESTDIR)/etc/bash_completion.d/$(NAME)
	#
	## Install configuration files
	mkdir -p $(CONFDIR)/xdg/autostart
	install -D -o root -g root -m 644 $(CURDIR)/conf/$(NAME).desktop \
		$(CONFDIR)/xdg/autostart/$(NAME).desktop
	install -D -o root -g root -m 644 $(CURDIR)/conf/$(NAME).desktop \
		$(SHAREDIR)/applications/$(NAME).desktop
	mkdir -p $(CONFDIR)/$(NAME)
	install -D -o root -g root -m 644 $(CURDIR)/conf/config \
		$(CONFDIR)/$(NAME)/config
	install -D -o root -g root -m 644 $(CURDIR)/conf/default.map \
		$(CONFDIR)/$(NAME)/default.map
	# 
	# Install examples
	mkdir -p $(DOCDIR)/$(NAME)/examples
	for f in `ls examples`; do \
	  cat examples/$$f | gzip -f9 > $(DOCDIR)/$(NAME)/examples/$$f.gz ; \
	done


## OTHER

.PHONY: destdir
dev-install:
	rm -fr $(DEV_DESTDIR)
	fakeroot $(MAKE) install DESTDIR=$(DEV_DESTDIR)

