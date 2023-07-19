CFLAGS ?= -std=c89 -pedantic -O3

c: c/esceval c/escevalcheck c/escevalenv c/escevalcheckenv

c/esceval:
	$(CC) $(CFLAGS) -o esceval c/esceval.c
	strip esceval

c/escevalcheck:
	$(CC) $(CFLAGS) -o escevalcheck c/escevalcheck.c
	strip escevalcheck

c/escevalenv:
	$(CC) $(CFLAGS) -o escevalenv c/escevalenv.c
	strip escevalenv

c/escevalcheckenv:
	$(CC) $(CFLAGS) -o escevalcheckenv c/escevalcheckenv.c
	strip escevalcheckenv

sh: sh/esceval sh/escevalcheck sh/escevalenv sh/escevalcheckenv

sh/esceval:
	cp sh/esceval.sh esceval

sh/escevalcheck:
	cp sh/escevalcheck.sh escevalcheck

sh/escevalenv:
	cp sh/escevalenv.sh escevalenv

sh/escevalcheckenv:
	cp sh/escevalcheckenv.sh escevalcheckenv

clean:
	rm -f esceval escevalcheck escevalenv escevalcheckenv
	rm -rf __pycache__

test: clean c
	pytest test.py
