# Makefile for GFALIST (c) Peter Backes
# Last modified by Markus Hoffmann 2014,2016

DISTRIB = ons
LIBNO=0.01
RELEASE=1

CC = gcc
# Cross-Compiler fuer MS WINDOWS
WINCC=i586-mingw32msvc-gcc
# Cross-Compiler fuer ATARI ST TOS
TOSCC=m68k-atari-mint-gcc

CFLAGS = -g3 -O2 -Wall 
LFLAGS = -L.

# Directories
prefix=/usr
exec_prefix=${prefix}
BINDIR=${exec_prefix}/bin
MANDIR=${prefix}/share/man

# Precious targets
PRECIOUS = version.h
TARGETS = libsky.a gfalist

SKY_ARC = libsky.a(sky.o) libsky.a(tables.o)
SKY_OBJS = sky.o tables.o

GFALIST_OBJS = gfalist.o charset.o

OBJS = $(SKY_OBJS) $(GFALIST_OBJS)

# Headerfiles which should be added to the distribution
HSRC=charset.h  sky.h  tables.h
CSRC= $(OBJS:.o=.c) 
BINDIST= gfalist


TRASH = core ons.spec.OLD

all: $(PRECIOUS) $(TARGETS)

libsky.a: $(SKY_OBJS)
	$(AR) rcv $@ $?
	ranlib $@

# Updating on a per file basis: 
#libsky.a: $(SKY_ARCH) $(SKY_OBJS)
#	ranlib $@
#(%.o): %.o
#	$(AR) rcv $@ $<

# Updating with intermediate files:
#libsky.a: $(SKY_ARCH)
#	ranlib $@
#(%.o): %.c
#	$(CC) $(CFLAGS) -c $< -o $*.o
#	$(AR) rcv $@ $*.o
#	rm $*.o

gfalist: $(GFALIST_OBJS)
	$(CC) $(LFLAGS) $+ -o $@ -lsky
gfalist.exe: $(CSRC)
	$(WINCC)  $+ -o $@ 
gfalist.ttp: $(CSRC)
	$(TOSCC)  $+ -o $@ 

version.h: HISTORY verextr.sh $(SKY_OBJS)
	sh verextr.sh -g $< $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TRASH)

realclean: clean
	rm -f $(TARGETS) gfalist.exe gfalist.ttp gfalist_$(LIBNO)-$(RELEASE)_*.deb

clobber: realclean
	rm -f $(PRECIOUS)

dist: MANIFEST HISTORY packdist.sh
	sh packdist.sh -t $(DISTRIB) -m $< -v HISTORY,version.h -s ons.spec ck md


# For the debin package (created with checkinstall)

# Documentation files to be packed into the .deb file:
DEBDOC = README COPYING HISTORY 
doc-pak : $(DEBDOC)
	mkdir $@
	cp $(DEBDOC) $@/

install : gfalist gfalist.1
	install -s -m 755 gfalist $(BINDIR)/
	install -m 644 gfalist.1 $(MANDIR)/man1/gfalist.1

uninstall :
	rm -f $(BINDIR)/gfalist 
	rm -f $(MANDIR)/man1/gfalist.1


deb :	$(BINDIST) doc-pak
	sudo checkinstall -D --pkgname gfalist --pkgversion $(LIBNO) \
	--pkgrelease $(RELEASE)  \
	--maintainer kollo@users.sourceforge.net \
        --backup  \
	--pkggroup interpreters   \
	--pkglicense GPL --strip=yes --stripso=yes --reset-uids 
	rm -rf backup-*.tgz doc-pak

rpms: dist
	sh packdist.sh -t $(DISTRIB) -v HISTORY,version.h mr

ons.spec: README HISTORY packdist.sh
	sh packdist.sh -a README -v HISTORY,version.h -t $(DISTRIB) -s ons.spec fs

#DEPEND
gfalist: libsky.a
sky.o: sky.c sky.h tables.h
gfalist.o: gfalist.c $(HSRC) version.h

