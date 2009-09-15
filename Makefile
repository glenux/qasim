
CONFDIR=$(DESTDIR)/etc/sshfs-mapper
BINDIR=$(DESTDIR)/usr/bin
MANDIR=$(DESTDIR)/usr/share/man
DOCDIR=$(DESTDIR)/usr/share/doc/sshfs-mapper

all:
	racc -v -o mapparser.rb mapparser.y
	cat mapparser.output

clean:
	rm -f mapparser.rb

install:
	mkdir -p $(BINDIR)
	mkdir -p $(MANDIR)/man1
	install -D -o root -g root -m 755 $(CURDIR)/sshfs-mapper $(BINDIR)/
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
