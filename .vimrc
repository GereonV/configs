" Quality of Life
set si nu rnu so=10 " smartindent, number, relativenumber scrolloff
map <Space> <nop>

" Highlighting
filetype plugin indent on
syntax on
set is hls " incsearch, hlsearch
nohls
map Q :nohls<Enter>

" Insert Mode
"" inoremap { {}<Esc>i
"" inoremap ( ()<Esc>i
"" inoremap [ []<Esc>i
"" inoremap " ""<Esc>i
"" inoremap ' ''<Esc>i
"" inoremap ` ``<Esc>i

" Normal Mode
nnoremap Y y$
nnoremap S s$
nnoremap <Space>Y "+y$
nnoremap <Space>S "+s$
nnoremap <Space>D "+D
nnoremap <Space>C "+C
nnoremap <Space>P "+P
nnoremap <F2> :%s/<C-r><C-w>//g<Left><Left>
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzz
nnoremap N Nzz
nnoremap ä o<Esc>k
nnoremap Ä O<Esc>j
nnoremap J mzJ`z
nnoremap <Space>J J

" Visual Mode
vnoremap S "_s
vnoremap D "_d
vnoremap C "_c
vnoremap P "_dP

" Normal + Visual Mode
nnoremap <C-s> :s/<C-r><C-w>//g<Left><Left>
vnoremap <C-s> :s//g<Left><Left>
nnoremap <Space>y "+y
vnoremap <Space>y "+y
nnoremap <Space>s "+s
vnoremap <Space>s "+s
nnoremap <Space>d "+d
vnoremap <Space>d "+d
nnoremap <Space>c "+c
vnoremap <Space>c "+c
nnoremap <Space>p "+p
vnoremap <Space>p "+p
