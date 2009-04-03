
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
	mkdir -p $(DOCDIR)/examples
	cp sshfs-mapper $(BINDIR)/
	cat sshfs-mapper.1 | gzip > $(MANDIR)/man1/sshfs-mapper.1.gz
	for f in `ls conf`; do \
	  cat conf/$$f | gzip -f9 > $(DOCDIR)/examples/$$f.gz ; \
	done
