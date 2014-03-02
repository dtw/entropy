# This is a Makefile for entropy

INSTALL=/bin/install -c
RM=/bin/rm
DESTDIR=
BINDIR=/usr/bin
MANDIR=/usr/man

install:
	$(INSTALL) -m 755 entropy.rb $(DESTDIR)/$(BINDIR)/entropy
	$(INSTALL) -m 644 entropy.man $(DESTDIR)/$(MANDIR)/man1/entropy.1    

clean:
	$(RM) $(DESTDIR)/$(BINDIR)/entropy
	$(RM) $(DESTDIR)/$(MANDIR)/man1/entropy.1

# vim:set ts=2 sw=2 noet:
