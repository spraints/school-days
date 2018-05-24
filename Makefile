SHARE_JS = ~/Downloads/school-days-left.js
SHARE_HTML = ~/Downloads/school-days-left.html

# Build the elm stuff
.PHONY: compile
compile: school-days-left.js

# Compile and copy the result to ~/Downloads, which is
# shared between my VM and host.
.PHONY: share
share: $(SHARE_JS) $(SHARE_HTML)

export PATH := node_modules/.bin:$(PATH)

school-days-left.js: src/*.elm
	env PATH=$(PATH) elm make src/Main.elm --yes --output school-days-left.js

$(SHARE_JS): school-days-left.js
	cp school-days-left.js ~/Downloads/school-days-left.js

$(SHARE_HTML): index.html
	cp index.html ~/Downloads/school-days-left.html

# vim: sw=8 ts=8 noet
