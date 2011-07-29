
NAME=qasim
CONFDIR=$(DESTDIR)/etc/$(NAME)
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
	mkdir -p $(CONFDIR)
	for f in `ls conf`; do \
	  cp conf/$$f $(CONFDIR)/$$f ;  \
	done
	#
	mkdir -p $(DOCDIR)/examples
	for f in `ls examples`; do \
	  cat examples/$$f | gzip -f9 > $(DOCDIR)/examples/$$f.gz ; \
	done

.PHONY: destdir
destdir:
	rm -fr destdir
	fakeroot $(MAKE) install DESTDIR=destdir

