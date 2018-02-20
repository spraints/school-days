.PHONY: default
default: school-days-left.js

export PATH := node_modules/.bin:$(PATH)

school-days-left.js: src/*.elm
	elm make src/Main.elm --yes --output school-days-left.js
	cp school-days-left.js ~/Downloads/school-days-left.js
	cp index.html ~/Downloads/school-days-left.html

# vim: sw=8 ts=8 noet
