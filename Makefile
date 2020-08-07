CXXFLAGS = -O3 -g0 -march=native
LDFLAGS = $(CXXFLAGS)

dnsseed: dns.o bitcoin.o netbase.o protocol.o db.o main.o util.o
	g++ -pthread $(LDFLAGS) -o dnsseed dns.o bitcoin.o netbase.o protocol.o db.o main.o util.o -lcrypto

%.o: %.cpp *.h
	g++ -std=c++11 -pthread $(CXXFLAGS) -Wall -Wno-unused -Wno-sign-compare -Wno-reorder -Wno-comment -c -o $@ $<

.PHONY: clean
clean:
	rm -f dnsseed *.o

PREFIX = /usr/local

.PHONY: install
install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp dnsseed $(DESTDIR)$(PREFIX)/bin

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dnsseed