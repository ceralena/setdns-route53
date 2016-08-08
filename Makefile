all: # nothing to build

install:
	mkdir -p $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/etc
	mkdir -p $(DESTDIR)/etc/systemd/system
	cp bin/setdns-route53.sh $(DESTDIR)/usr/bin/setdns-route53
	cp etc/setdns-config $(DESTDIR)/etc/setdns-route53
	cp systemd/setdns-route53.service $(DESTDIR)/etc/systemd/system/
	cp systemd/setdns-route53.timer $(DESTDIR)/etc/systemd/system/
