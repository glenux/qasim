
NAME=qasim
CONFDIR=$(DESTDIR)/etc
BINDIR=$(DESTDIR)/usr/bin
MANDIR=$(DESTDIR)/usr/share/man
DOCDIR=$(DESTDIR)/usr/share/doc/$(NAME)

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


install:
	mkdir -p $(BINDIR)
	mkdir -p $(MANDIR)/man1
	install -D -o root -g root -m 755 $(CURDIR)/bin/$(NAME)-gui.rb $(BINDIR)/$(NAME)-gui
	#cat $(NAME).1 | gzip > $(MANDIR)/man1/$(NAME).1.gz
	## Install completion file
	# install -D -o root -g root -m 644 $(CURDIR)/$(NAME).completion $(DESTDIR)/etc/bash_completion.d/$(NAME)
	#
	#
	# Install configuration files
	mkdir -p $(CONFDIR)/xdg/autostart
	install -D -o root -g root -m 644 $(CURDIR)/conf/autostart/$(NAME).desktop \
		$(CONFDIR)/xdg/autostart/$(NAME).desktop
	mkdir -p $(CONFDIR)/$(NAME)
	install -D -o root -g root -m 644 $(CURDIR)/conf/config \
		$(CONFDIR)/$(NAME)/config
	install -D -o root -g root -m 644 $(CURDIR)/conf/default.map \
		$(CONFDIR)/$(NAME)/default.map
	#
	mkdir -p $(DOCDIR)/examples
	for f in `ls examples`; do \
	  cat examples/$$f | gzip -f9 > $(DOCDIR)/examples/$$f.gz ; \
	done

.PHONY: destdir
destdir:
	rm -fr destdir
	fakeroot $(MAKE) install DESTDIR=destdir

