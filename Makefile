
NAME=qasim
CONFDIR=$(DESTDIR)/etc
BINDIR=$(DESTDIR)/usr/bin
MANDIR=$(DESTDIR)/usr/share/man
DOCDIR=$(DESTDIR)/usr/share/doc/$(NAME)
SHAREDIR=$(DESTDIR)/usr/share/$(NAME)

RUBYVERSION=1.8
RDOC=rdoc$(RUBYVERSION)

all:
	$(MAKE) -C $(NAME)

clean:
	$(MAKE) -C $(NAME) clean

doc: build-doc

.PHONY: build-doc

build-doc:
	rm -fr doc
	$(RDOC) \
		--promiscuous \
		--inline-source \
		--line-numbers \
		-o doc $(NAME)/ \
		bin/
	# --diagram
	#

install-doc:
	#          # install documentation
	rm -fr $(DOCDIR)
	mkdir -p $(DOCDIR)
	cp -a doc $(DOCDIR)


install: install-bin install-lib install-data

install-bin: 
	mkdir -p $(BINDIR)
	for binfile in bin/*.rb ; do \
		BINFILE=`basename $$binfile |sed -e 's/.rb$$//'`; \
		install -D -o root -g root -m 755 $$binfile $(BINDIR)/$$BINFILE; \
		sed -i -e 's|^QASIM_INCLUDE_DIR.*|QASIM_INCLUDE_DIR = "/usr/share/$(NAME)"|' $(BINDIR)/$$BINFILE; \
	done
	#install -D -o root -g root -m 755 $(CURDIR)/bin/$(NAME)-gui.rb $(BINDIR)/$(NAME)-gui

install-lib:
	for libfile in $(NAME)/*.rb ; do \
		install -D -o root -g root -m 644 $$libfile $(SHAREDIR)/$$libfile; \
	done

install-data:
	## Install man pages
	# mkdir -p $(MANDIR)/man1
	# cat $(NAME).1 | gzip > $(MANDIR)/man1/$(NAME).1.gz
	#
	## Install icons
	mkdir -p $(SHAREDIR)/icons
	install -D -o root -g root -m 644 $(CURDIR)/icons/$(NAME).svg \
		$(SHAREDIR)/icons/$(NAME).svg
	#
	## Install completion file
	# install -D -o root -g root -m 644 $(CURDIR)/$(NAME).completion $(DESTDIR)/etc/bash_completion.d/$(NAME)
	#
	## Install configuration files
	mkdir -p $(CONFDIR)/xdg/autostart
	install -D -o root -g root -m 644 $(CURDIR)/conf/autostart/$(NAME).desktop \
		$(CONFDIR)/xdg/autostart/$(NAME).desktop
	mkdir -p $(CONFDIR)/$(NAME)
	install -D -o root -g root -m 644 $(CURDIR)/conf/config \
		$(CONFDIR)/$(NAME)/config
	install -D -o root -g root -m 644 $(CURDIR)/conf/default.map \
		$(CONFDIR)/$(NAME)/default.map
	# 
	# Install examples
	mkdir -p $(DOCDIR)/examples
	for f in `ls examples`; do \
	  cat examples/$$f | gzip -f9 > $(DOCDIR)/examples/$$f.gz ; \
	done

.PHONY: destdir
destdir:
	rm -fr destdir
	fakeroot $(MAKE) install DESTDIR=destdir

