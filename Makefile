.DEFAULT_GOAL := lint

node_modules: package.json
	npm install

.luarocks: nvim-config.rockspec
	luarocks install --tree .luarocks --only-deps nvim-config.rockspec

.PHONY: lint
lint: node_modules
	nix shell nixpkgs#luajitPackages.luacheck --command luacheck .

.PHONY: fmt
fmt: node_modules
	node_modules/.bin/stylua .

.PHONY: test
test: .luarocks
	.luarocks/bin/busted

.PHONY: clean
clean:
	rm -rf node_modules .luarocks
