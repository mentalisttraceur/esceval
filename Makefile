CFLAGS ?= -std=c89 -pedantic -O3

c: c/esceval c/escevalid c/escevalenv c/escevalidenv

c/esceval:
	$(CC) $(CFLAGS) -o esceval c/esceval.c
	strip esceval

c/escevalid:
	$(CC) $(CFLAGS) -o escevalid c/escevalid.c
	strip escevalid

c/escevalenv:
	$(CC) $(CFLAGS) -o escevalenv c/escevalenv.c
	strip escevalenv

c/escevalidenv:
	$(CC) $(CFLAGS) -o escevalidenv c/escevalidenv.c
	strip escevalidenv

sh: sh/esceval sh/escevalid sh/escevalenv sh/escevalidenv

sh/esceval:
	cp sh/esceval.sh esceval

sh/escevalid:
	cp sh/escevalid.sh escevalid

sh/escevalenv:
	cp sh/escevalenv.sh escevalenv

sh/escevalidenv:
	cp sh/escevalidenv.sh escevalidenv

clean:
	rm -f esceval escevalid escevalenv escevalidenv
	rm -rf __pycache__

test: clean c
	pytest test.py
