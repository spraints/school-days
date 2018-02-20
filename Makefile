.PHONY: default
default: index.html

export PATH := node_modules/.bin:$(PATH)

index.html: src/*.elm
	elm make src/Main.elm --yes --output index.html
