" set background=light
" colorscheme onehalflight
set background=dark
colorscheme onehalfdark

"===============================================================================

set nu mouse=a tabstop=8 noexpandtab shiftwidth=4 textwidth=0 linebreak ai
set relativenumber
set formatoptions+=cro shortmess-=S termguicolors updatetime=100 tw=0
" (an asterisk in the beginning of each line of a multi-line comment in c)
" note the +, I want the opposite behavior of:
" https://www.reddit.com/r/vim/comments/9kz5rk/format_of_c_comments/

" let $PAGER=''
runtime! ftplugin/man.vim

" Fixing typos on the fly (credit: Gilles Castel)
" setlocal spell
set spelllang=en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

nnoremap <F2> :set relativenumber!<CR>
nnoremap <F3> :noh<CR>

nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

map Y y$
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap 0 g0
nnoremap gj j
nnoremap gk k
nnoremap g$ $
nnoremap g0 0
vnoremap j gj
vnoremap k gk
vnoremap $ g$
vnoremap 0 g0
vnoremap gj j
vnoremap gk k
vnoremap g$ $
vnoremap g0 0

" Remove any mapping from the space key in normal mode (to use as leader)
nnoremap <SPACE> <Nop>
let mapleader = " "

nnoremap <Right> gt
nnoremap <Left> gT
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <Leader>l gt
nnoremap <Leader>h gT

nnoremap <F1> <Esc>
inoremap <F1> <Esc>
vnoremap <F1> <Esc>
xnoremap <F1> <Esc>
snoremap <F1> <Esc>
cnoremap <F1> <Esc>

vnoremap <C-c> "+y

tmap <C-h> <C-W><C-h>
tmap <C-l> <C-W><C-l>
tmap <C-j> <C-W><C-j>
tmap <C-k> <C-W><C-k>

" From https://vi.stackexchange.com/a/10666:
autocmd filetype c      nnoremap <buffer> <F5> :w <bar> !clear; gcc -O3 -Wall % -o %:r<CR>
autocmd filetype c      nnoremap <buffer> <C-F5> :w <bar> !clear; gcc -Wall -ggdb3 % -o %:r<CR>
autocmd filetype cpp    nnoremap <buffer> <F5> :w <bar> !clear; g++ -std=c++23 -O3 -Wall % -o %:r<CR>
autocmd filetype cpp    nnoremap <buffer> <C-F5> :w <bar> !clear; g++ -std=c++23 -Wall % -g3 -ggdb3 -o %:r<CR>
autocmd filetype python nnoremap <buffer> <F5> :w <bar> !clear; python %<CR>

autocmd Filetype c          setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 nolinebreak nospell
autocmd Filetype cuda       setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 nolinebreak nospell
autocmd Filetype cpp        setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 nolinebreak nospell
autocmd Filetype asm        setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8 nolinebreak nospell
autocmd Filetype python     setlocal tabstop=4 shiftwidth=4 softtabstop=4 nolinebreak nospell
autocmd Filetype html       setlocal expandtab textwidth=80 nospell
autocmd Filetype css        setlocal expandtab textwidth=80 nospell
autocmd Filetype xml        setlocal textwidth=80 nospell
autocmd Filetype json       setlocal nolinebreak nospell
autocmd Filetype tex        setlocal expandtab linebreak spell textwidth=80 tabstop=4 softtabstop=4
autocmd Filetype make       setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 nolinebreak nospell
autocmd Filetype arduino    setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 nolinebreak nospell
autocmd Filetype haskell    setlocal tabstop=4 shiftwidth=4 softtabstop=4 nolinebreak nospell
autocmd Filetype javascript setlocal textwidth=80 nospell

" For tmux, forgot what it does:
if &term =~ "screen"
    let &t_BE = "\e[?2004h"
    let &t_BD = "\e[?2004l"
    exec "set t_PS=\e[200~"
    exec "set t_PE=\e[201~"
endif

" if has("autocmd")
"   augroup templates
"     autocmd BufNewFile *.cpp 0r ~/.vim/templates/skeleton.cpp | $d
"   augroup END
" endif

" m and T to hide GVim menu and toolbar:
" set guifont=JetBrains\ Mono\ 16 guioptions-=m guioptions-=T
set guifont=JetBrains\ Mono\ 14
" r to hide GVim scrollbar:
" set guioptions-=r

" (no plugins required) debugging inside vim:
let g:termdebug_wide = 1

" To disable syntax highlighting of errors:
let g:vim_json_warnings = 0

" vim-plug
"===============================================================================

call plug#begin()

" Copilot:
Plug 'github/copilot.vim'

" Orgmode:
Plug 'jceb/vim-orgmode'
    " dependency:
    Plug 'tpope/vim-speeddating'

" For LaTeX:
Plug 'lervag/vimtex'
	" See :h vimtex_compiler_latexmk
	let g:vimtex_compiler_latexmk = {
	    \ 'aux_dir': '.aux',
	    \ 'options' : [
	    \   '-pdf',
	    \   '-shell-escape',
	    \   '-verbose',
	    \   '-file-line-error',
	    \   '-synctex=1',
	    \   '-interaction=nonstopmode',
	    \ ],
	    \}

	filetype plugin indent on
	syntax enable
	let g:vimtex_view_method = 'sioyek'
	let maplocalleader = " "
	let g:tex_flavor = 'latex'
	" From https://github.com/lervag/vimtex/issues/513#issuecomment-328444047
	" (see also ":h g:tex_fast"):
	let g:tex_fast = ""
	" This disables highlighting of 'begin' and 'end' tags:
	let g:vimtex_matchparen_enabled = 0
	let g:vimtex_quickfix_open_on_warning = 0

" To make LaTeX, VimTeX, Evince work in harmony:
Plug 'peterbjorgensen/sved'

" For table of contents etc.:
Plug 'preservim/vim-markdown'
	let g:vim_markdown_folding_disabled = 1

" Emmet:
Plug 'mattn/emmet-vim'

" Better C++ syntax highlighting:
Plug 'octol/vim-cpp-enhanced-highlight'
	" Enable highlighting of member variables, class declarations, POSIX
	" functions:
	let g:cpp_class_scope_highlight = 1
	let g:cpp_member_variable_highlight = 1
	let g:cpp_class_decl_highlight = 1
	let g:cpp_posix_standard = 1

Plug 'vim-scripts/TagHighlight'

" Commenting:
Plug 'tpope/vim-commentary'
	autocmd FileType cpp,c setlocal commentstring=//\ %s

" Snippets:
Plug 'sirver/ultisnips'
	let g:UltiSnipsExpandTrigger = '<tab>'
	let g:UltiSnipsJumpForwardTrigger = '<tab>'
	let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" Vim syntax highlighting for .kbd files, used by KMonad.
Plug 'kmonad/kmonad-vim'

" For :Goyo (zen mode bs):
Plug 'junegunn/goyo.vim'

" For IDE like jump-to-definition:
Plug 'pechorin/any-jump.vim'

" Blueprint support:
Plug 'https://gitlab.com/gabmus/vim-blueprint'

" Fancy statusline:
Plug 'itchyny/lightline.vim'
	set laststatus=2
	let g:lightline = {
		  \ 'colorscheme': 'one',
		  \ 'active': {
		  \   'right': [ [ 'lineinfo' ],
		  \              [ 'percent' ],
		  \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
		  \ },
		  \ 'component': {
		  \   'charvaluehex': '0x%B',
		  \   'lineinfo': '%l:%-2v'
		  \ },
		  \ }
	function! LightlineFileformat()
	  return winwidth(0) > 70 ? &fileformat : ''
	endfunction

	function! LightlineFiletype()
	  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
	endfunction

" Debugging:
" Plug 'puremourning/vimspector'

" Arduino:
" Plug 'stevearc/vim-arduino'
" 	nnoremap <buffer> <leader>aa <cmd>ArduinoAttach<CR>
" 	nnoremap <buffer> <leader>av <cmd>ArduinoVerify<CR>
" 	nnoremap <buffer> <leader>au <cmd>ArduinoUpload<CR>
" 	nnoremap <buffer> <leader>aus <cmd>ArduinoUploadAndSerial<CR>
" 	nnoremap <buffer> <leader>as <cmd>ArduinoSerial<CR>
" 	nnoremap <buffer> <leader>ab <cmd>ArduinoChooseBoard<CR>
" 	nnoremap <buffer> <leader>ap <cmd>ArduinoChooseProgrammer<CR>
" " let g:arduino_use_slime = 1

call plug#end()
