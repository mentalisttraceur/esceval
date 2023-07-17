c: c/esceval c/escevalid c/escevalenv c/escevalidenv

c/esceval:
	gcc -std=c89 -pedantic -fPIE -Os -o esceval c/esceval.c
	strip esceval

c/escevalid:
	gcc -std=c89 -pedantic -fPIE -Os -o escevalid c/escevalid.c
	strip escevalid

c/escevalenv:
	gcc -std=c89 -pedantic -fPIE -Os -o escevalenv c/escevalenv.c
	strip escevalenv

c/escevalidenv:
	gcc -std=c89 -pedantic -fPIE -Os -o escevalidenv c/escevalidenv.c
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
