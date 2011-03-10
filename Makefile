
CONFDIR=$(DESTDIR)/etc/sshfs-mapper
BINDIR=$(DESTDIR)/usr/bin
MANDIR=$(DESTDIR)/usr/share/man
DOCDIR=$(DESTDIR)/usr/share/doc/sshfs-mapper

RUBYVERSION=1.8
RDOC=rdoc$(RUBYVERSION)

all:
	$(MAKE) -C sshfs-mapper

clean:
	$(MAKE) -C sshfs-mapper clean

doc: build-doc

.PHONY: build-doc

build-doc:
	rm -fr doc
	$(RDOC) \
		--promiscuous \
		--inline-source \
		--line-numbers \
		-o doc sshfs-mapper/ \
		sshfs-mapper.rb
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
	install -D -o root -g root -m 755 $(CURDIR)/sshfs-mapper.sh $(BINDIR)/sshfs-mapper
	cat sshfs-mapper.1 | gzip > $(MANDIR)/man1/sshfs-mapper.1.gz
	install -D -o root -g root -m 644 $(CURDIR)/sshfs-mapper.completion $(DESTDIR)/etc/bash_completion.d/sshfs-mapper
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
