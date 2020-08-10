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
	mkdir -p /etc/safecoin-seeder
	cp contrib/init/safecoin-seeder.service /etc/safecoin-seeder/
	ln -s /etc/safecoin-seeder/safecoin-seeder.service /etc/systemd/system/
	ln -s /etc/safecoin-seeder/safecoin-seeder.service /etc/systemd/system/multi-user.target.wants/

	systemctl daemon-reload
	systemctl stop systemd-resolved
	systemctl start safecoin-seeder
	systemctl start systemd-resolved
	
.PHONY: uninstall
uninstall:
	systemctl stop safecoin-seeder
	
	rm -f $(DESTDIR)$(PREFIX)/bin/dnsseed
	rm -r /etc/safecoin-seeder
	rm /etc/systemd/system/multi-user.target.wants/safecoin-seeder.service
	rm /etc/systemd/system/safecoin-seeder.service
	
	systemctl daemon-reload
	systemctl restart systemd-resolved