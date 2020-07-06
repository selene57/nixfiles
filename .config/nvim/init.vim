" ~/.config/nvim/init.vim
" Selene Hines

" Plugins
call plug#begin('~/.local/share/nvim/plugged')
  Plug 'jiangmiao/auto-pairs'
  Plug 'vim-python/python-syntax'
  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-notes'
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'itchyny/lightline.vim'
call plug#end()

" Features
filetype plugin on

" Mouse
set mouse=a

" Color Scheme
set background=light
colorscheme PaperColor

" Lightline
set noshowmode

let g:lightline = { 'colorscheme': 'PaperColor' }