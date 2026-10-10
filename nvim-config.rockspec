package = 'nvim-config'
version = 'dev-1'

source = {
    url = 'git+https://github.com/Propfend/nvim-config',
}

description = {
    summary = 'Neovim configuration',
    license = 'MIT',
}

dependencies = {
    'lua >= 5.1',
    'busted',
    'nlua',
}

build = {
    type = 'builtin',
    modules = {},
}
