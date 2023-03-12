" Quality of Life
set si nu rnu so=10 " smartindent, number, relativenumber, scrolloff
map <Space> <nop>
map + <nop>
map - <nop>

" Highlighting
filetype plugin indent on
syntax on
set is hls " incsearch, hlsearch
nohls
map <silent>Q :<C-u>nohls<CR>

" Inserting empty lines
nnoremap <expr>ä "mz"..v:count1.."@='o<C-v><Esc>0\"_D'<CR>`z"
nnoremap <expr>Ä "mz"..v:count1.."@='O<C-v><Esc>0\"_D'<CR>`z"

" Yank
nnoremap Y y$
vnoremap Y <nop>
nnoremap <expr><silent><Space>y ':<C-u>let @z=@"<CR>'..v:count1..'"+y'
nnoremap <expr><silent><Space>Y ':<C-u>let @z=@"<CR>'..v:count1..'"+y$'
vnoremap <Space>y :<C-u>let @z=@"<CR>gv"+y

" Delete
vnoremap D <nop>
nnoremap <expr><silent><Space>d ':<C-u>let @z=@"<CR>'..v:count1..'"+d'
nnoremap <expr><silent><Space>D ':<C-u>let @z=@"<CR>'..v:count1..'"+D'
vnoremap <Space>d :<C-u>let @z=@"<CR>gv"+d
nnoremap -d "_d
nnoremap -D "_D
vnoremap -d "_d
nnoremap x "_x
nnoremap X "_X
vnoremap x <nop>
vnoremap X <nop>

" Change
vnoremap C <nop>
nnoremap <expr><silent><Space>c ':<C-u>let @z=@"<CR>'..v:count1..'"+c'
nnoremap <expr><silent><Space>C ':<C-u>let @z=@"<CR>'..v:count1..'"+C'
vnoremap <Space>c :<C-u>let @z=@"<CR>gv"+c
nnoremap -c "_c
nnoremap -C "_C
vnoremap -c "_c

" Substitute
nnoremap S <nop>
vnoremap s <nop>
vnoremap S <nop>

" Paste
vnoremap P <nop>
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>p "+p
vnoremap -p "_dP
vnoremap -<Space>p "_d"+P
vnoremap <Space>-p "_d"+P

" Restore unnamed register
" Normal, Visual and Operator Mode
noremap <silent><Space><Space> :<C-u>let @"=@z<CR>

" Replace
nnoremap <F2> :<C-u>%s/<C-r><C-w>//g<Left><Left>
vnoremap <F2> "zy:%s/<C-r>z//g<Left><Left>
nnoremap S :<C-u>%s//g<Left><Left>
vnoremap S :s//g<Left><Left>

" Search
nnoremap + /<C-r><C-w><CR>
vnoremap + "zy/<C-r>z<CR>

" Scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
vnoremap <C-d> <C-d>zz
vnoremap <C-u> <C-u>zz

" Joining lines
nnoremap J @='mzJ`z'<CR>
nnoremap gJ @='mzgJ`z'<CR>
nnoremap <Space>J J
nnoremap <Space>gJ gJ
nnoremap g<Space>J gJ
