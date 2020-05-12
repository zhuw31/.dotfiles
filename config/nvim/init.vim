set nocompatible
call plug#begin('~/.local/share/nvim/plugged')
" other
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
" completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" syntax
Plug 'othree/html5.vim'
Plug 'herringtondarkholme/yats.vim'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'digitaltoad/vim-pug'
" theme
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'mhartington/oceanic-next'
call plug#end()

let mapleader = ' '

filetype plugin indent on
syntax on
set termguicolors
colorscheme gruvbox
set background=dark
set noswapfile                 " 禁止生成临时文件
set nowrap
set confirm                    " 在处理未保存或只读文件的时候，弹出确认
set noshowmode                 " 已经有 lightline 了，无须显示命令
set pumheight=10
set autoindent
set relativenumber
set list
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set scrolloff=5
set ignorecase                 " 搜索忽略大小写
set hlsearch                   " 搜索逐字符高亮
set incsearch
set smartcase
set splitright
set clipboard+=unnamedplus     " use system clipboard
" navigate in vim
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
nnoremap H <C-w>10>
nnoremap L <C-w>10<
nnoremap <silent> <LEADER><SPACE> :noh<CR>
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
" file operaion
nnoremap <LEADER>w :w<CR>
nnoremap <LEADER>q :q<CR>
inoremap jk <Esc>
" open vimrc
nnoremap <silent> <LEADER>rc :tabe ~/.config/nvim/init.vim<CR>
nnoremap <silent> <LEADER>re :so %<CR>:noh<CR>
" work with coc-pairs for inserting new line and indent properly
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use <tab> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <tab> could be remapped by other vim plugin, try `:verbose imap <tab>`.
if exists('*complete_info')
  inoremap <expr> <tab> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<tab>"
else
  inoremap <expr> <tab> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Make <tab> used for trigger completion, completion confirm, snippet expand and jump like VSCode.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" FZF
let g:fzf_command_prefix = 'Fzf'
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <LEADER>rg :FzfRg!<SPACE>

" coc_extensions
let g:coc_global_extensions = ['coc-emmet', 'coc-eslint', 'coc-git', 'coc-go', 'coc-css', 'coc-json', 'coc-lists', 'coc-python', 'coc-pairs', 'coc-prettier', 'coc-snippets', 'coc-tsserver', 'coc-vimlsp', 'coc-yaml']
" lightline
let g:lightline = {
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'git', 'gitfilechange', 'cocstatus', 'filename', 'method' ]
  \   ],
  \   'right':[
  \     [ 'diagnostic' ],
  \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
  \   ],
  \ },
  \ 'component_function': {
  \   'git': 'LightlineGitStatus',
  \   'gitfilechange': 'LightlineGitFileChange',
  \   'cocstatus': 'coc#status'
  \ }
\ }

function! LightlineGitStatus() abort
  let git_status = get(g:, 'coc_git_status', '')
  " return git_status
  return winwidth(0) > 120 ? git_status : ''
endfunction

function! LightlineGitFileChange() abort
  let git_status = get(b:, 'coc_git_status', '')
  " return git_status
  return winwidth(0) > 120 ? git_status : ''
endfunction

autocmd bufnewfile,bufread *.ts set filetype=typescript.tsx
autocmd bufnewfile,bufread *.js set filetype=javascript.jsx
autocmd User CocStatusChange,CocDiagnosticChange,CocGitStatusChange call lightline#update()
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')           " function signature"

" if hidden is not set, TextEdit might fail.
set hidden
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=100
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gm <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

autocmd FileType json syntax match Comment +\/\/.\+$+

" Using CocList
" Show all diagnostics
nnoremap <silent> <LEADER>cd  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <LEADER>ce  :<C-u>CocList extensions<cr>

" open help file in right window
autocmd FileType help wincmd L