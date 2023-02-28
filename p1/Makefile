all: clean
		elm make src/Main.elm --output main.js
		mkdir build
		cp -f main.js build/main.js
		cp -f src/index.html .
clean:
	rm -rf build/
	rm -rf main.js
	rm -rf index.html
