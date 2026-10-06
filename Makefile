.DEFAULT_GOAL := lint

node_modules: package.json
	npm install

.PHONY: lint
lint: node_modules
	nix shell nixpkgs#luajitPackages.luacheck --command luacheck .

.PHONY: fmt
fmt: node_modules
	node_modules/.bin/stylua .

.PHONY: clean
clean:
	rm -rf node_modules
