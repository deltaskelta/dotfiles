scriptencoding utf-8
" starts a node pricess for debugging, it pairs with a chrome plugin that will
" bring up a console
"let $NVIM_NODE_HOST_DEBUG=1
let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/Users/Jeff/bin/python'
let g:node_host_prog = '/usr/local/bin/neovim-node-host'
let g:ruby_host_prog = '/usr/local/bin/neovim-ruby-host'
let $NVIM_NODE_LOG_FILE='/tmp/nvim-node.log'
let $NVIM_NODE_LOG_LEVEL='error'
let $NVIM_PYTHON_LOG_FILE='/tmp/nvim-python.log'
let $NVIM_PYTHON_LOG_LEVEL='info'

augroup vimplug
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
augroup END

" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'file:///Users/Jeff/dotfiles', {'rtp': 'nvim-deltaskelta', 'do': ':UpdateRemotePlugins'}
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'w0rp/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'xolox/vim-misc'
Plug 'tpope/vim-fugitive'
Plug 'honza/vim-snippets'

Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go'}
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'sebdah/vim-delve', {'for': 'go'}

Plug 'ternjs/tern_for_vim', { 'do': 'yarn install', 'for': 'javascript' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'yarn global add tern', 'for': 'javascript' }
Plug 'Galooshi/vim-import-js', {'for': ['javascript']}
Plug 'pangloss/vim-javascript', {'for': ['javascript', 'javascript.jsx']}
Plug 'mxw/vim-jsx', {'for': ['javascript', 'javascript.jsx']}

Plug 'HerringtonDarkholme/yats'
" 'branch': 'TSDeoplete',
Plug 'mhartington/nvim-typescript', {'do': './install.sh', 'for': ['typescript', 'typescript.tsx']}
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }

Plug 'zchee/deoplete-jedi', { 'for': 'python' }

Plug 'jparise/vim-graphql'

Plug 'xolox/vim-colorscheme-switcher'
Plug 'chriskempson/base16-vim'
Plug 'rakr/vim-one'
Plug 'gosukiwi/vim-atom-dark'
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'ryanoasis/vim-devicons'

call plug#end()

"let g:LanguageClient_serverCommands = {
"    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
"    \ 'typescript.tsx': ['tcp://127.0.0.1:31988'],
"    \ 'python': ['/usr/local/bin/pyls'],
"    \ }

" :call ToggleVerbose() for writing a verbose log im tmp
function! ToggleVerbose()
    if !&verbose
        set verbosefile=/tmp/vim.log
        set verbose=9
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

function! StartProfile()
    :profile start ~/vim-profile.log
    :profile func *
    :profile file *
endfunction

function! StopProfile()
    :profile stop
endfunction

" setting syntax and makeing colors better
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
syntax on
filetype plugin indent on
colorscheme base16-tomorrow-night

" status line is filename and right aligned column number
" hidden makes the buffer hidden when inactvie rather than essentially 'closing' it
" I think there was a reason that this line is after the airline option, but IDK
augroup all
    autocmd BufRead,BufNewFile * setlocal signcolumn=yes
augroup END

" set neovim to have normal vim cursor, guicursor& to restore default
set guicursor=
" make sure I can call stuff defined in my bash_profile
set shellcmdflag=-ic

set number tabstop=4 shiftwidth=4 nowrap noshowmode expandtab termguicolors background=dark hidden shortmess=atT
set lazyredraw mouse=a directory=~/.config/nvim/tmp clipboard=unnamed cursorline
" do not show the scratch preview window when tabbing through completions
set completeopt-=preview laststatus=2
set statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" vim airline ------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='tomorrow'
"let g:airline#extensions#tabline#buffer_idx_mode = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s: '

" called in the startup section after everything has loaded (this is hacky)
function! ChangeColors()
    hi airline_tabmod_unsel guifg=#61afef guibg=#2c323c
endfunction

" this is called to avoid square brackets on icons after refreshing the vimrc
if exists('g:loaded_webdevicons')
	call webdevicons#refresh()
endif
" refresh the .vimrc on a save so vim does not have to be restarted
augroup startup
    autocmd!
    " sourcing the vimrc on save of this file.
    autocmd BufWritePost *.vim so $MYVIMRC | :AirlineRefresh | :call ChangeColors()
    autocmd FileType gitcommit set cc=72 tw=72
    autocmd VimEnter * call ChangeColors()
augroup END

" neosnippets ---------------------------------------------------------------------------

let g:neosnippet#enable_completed_snippet = 1
imap qq <Plug>(neosnippet_expand_or_jump)
let g:neosnippet#snippets_directory='~/.config/nvim/plugged/vim-snippets/snippets,~/dotfiles/vim-snippets'

" auto pairs ----------------------------------------------------------------------------

" do not make the line in the center of the page after pressing enter
let g:AutoPairsCenterLine = 0
let g:AutoPairsMapCR = 1

" tern for vim --------------------------------------------------------------------------
let g:tern_show_signature_in_pum = 1

" deoplete --------------------------------------------------------------------------

let g:deoplete#enable_at_startup = 1

call deoplete#custom#option({
  \ 'smart_case': v:true,
  \ 'profile': v:true,
  \ 'auto_complete_delay': 0,
  \ 'auto_refresh_delay': 20,
  \ })

call deoplete#custom#source(
  \ 'file', 'enable_buffer_path', v:false)

call deoplete#enable_logging('INFO', '/tmp/deoplete.log')

" deoplete-ternjs ----------------------------------------------------------------

" shows type info in the completion, but dont confuse this with flow type info, tern and
" flow serve different purposes https://github.com/ternjs/tern/issues/827
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#case_insensitive = 1

" in order to have tern go through and resolve all of the modules and imports in a webpack
" project, it needs the path to the webpack config. I am usually using create-react-app
" which bundles it in node_modules (path in the project level .tern-project file) If I
" don't want to eject the react-scripts, the references webpack file looks for NODE_ENV
" variable which is unset, this script sets it.
let g:deoplete#sources#ternjs#tern_bin = 'custom-tern' " for tern autocompleting
let g:tern#command = ['custom-tern'] " for running tern commands

" letting tab scroll through the autocomplete list, up to go backwards
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><Up> pumvisible() ? "\<c-p>" : "\<Up>"

" vim fugitive mappings -----------------------------------------------------

nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gl :Git --no-pager log<CR>
" when cvc (git verbose commit) is called from status and there is too much
" diff to see on the screen, a new buffer can be opened to compose the diff
" message while scrolling through the diff.
nnoremap <leader>n :new<CR>:resize -40<CR>
" for looking at diffs from the status window. left window is index, right
" window is the current file. push or get the changes to the other file while
" the curor is on the line. the file must be saved after this
nnoremap <leader>dg :diffget<CR>
nnoremap <leader>dp :diffpush<CR>
" after running arbitraty git commands like :Git log, there is a tab and an
" extra buffer
nnoremap <leader>tc :bdelete!<CR>:tabclose<CR>

" denite settings -----------------------------------------------------------

" set the prompt to a better symbol
call denite#custom#option('default', 'prompt', '❯')

" set some navigation commands
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', 'JJ', '<denite:toggle_insert_mode>', 'noremap')
call denite#custom#map('insert', '<C-d>', '<denite:do_action:delete>', 'noremap')

" file search command shows hidden and ignores !.git and respected .gitignore
call denite#custom#var('file/rec', 'command',
    \['rg', '--follow', '--files', '--hidden', '-g', '!.git'])

" grep command using rg for speed, respected .gitignore
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--iglob', '!yarn.lock'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" let the denite buffer window match by buffer number
call denite#custom#var('buffer', 'date_format', '')
call denite#custom#source('buffer', 'matchers', ['converter/abbr_word', 'matcher/substring'])

" define a custom grep (rg) command that will unignore files I usually don't want to search,
" -uu is the flag that searches everything excpet binary files
call denite#custom#alias('source', 'rg/unignore', 'grep')
call denite#custom#var('rg/unignore', 'command', ['rg'])
call denite#custom#var('rg/unignore', 'default_opts',
    \ ['-iuu', '--vimgrep'])
call denite#custom#var('rg/unignore', 'recursive_opts', [])
call denite#custom#var('rg/unignore', 'pattern_opt', [])
call denite#custom#var('rg/unignore', 'separator', ['--'])
call denite#custom#var('rg/unignore', 'final_opts', [])

nnoremap <leader><Space> :Denite -highlight-matched-range=NONE -highlight-matched-char=NONE file/rec<CR>
nnoremap <leader>` :Denite -highlight-matched-range=NONE -highlight-matched-char=NONE -path=~/ file/rec<CR>
nnoremap <leader><leader> :Denite buffer<CR>
"nnoremap <leader><Space><Space> :Denite grep/ignore:.<CR>
nnoremap <leader><Space><Space> :Denite grep:.<CR>
nnoremap <leader>c :DeniteCursorWord grep:.<CR>

" vim go ---------------------------------------------------------------------

augroup vimgo
    autocmd!
    " this is from the vim-go docs `go-guru-scope` which (I think) sets the scope for
    " go-guru to the current project directory
    autocmd BufRead /Users/Jeff/go/src/*.go
        \  let s:tmp = matchlist(expand('%:p'),
            \ '/Users/Jeff/go/src/\(github.com/user/[^/]\+\)')
        \| if len(s:tmp) > 1 |  exe 'silent :GoGuruScope ' . s:tmp[1] | endif
        \| unlet s:tmp
    autocmd FileType go nmap <leader>ds <Plug>(go-def-split)
    autocmd FileType go nmap <leader>gb <Plug>(go-build)
    autocmd FileType go nmap <leader>dt <Plug>(go-def-tab)
    autocmd FileType go nmap <leader>d <Plug>(go-def)
    autocmd FileType go nmap <leader>gt <Plug>(go-test)
    autocmd FileType go nmap <leader>gl :call GoLinting()<CR>
    autocmd FileType go nmap <leader>gc :GoCoverage<CR><CR>
    autocmd FileType go nmap <leader>gcc :GoCoverageToggle<CR>
    autocmd FileType go nmap <leader>gtf <Plug>(go-test-func)
    autocmd FileType go nmap <leader>gd <Plug>(go-doc)
    autocmd FileType go nmap <leader>gr <Plug>(go-rename)
    autocmd FileType go nmap <leader>da :DlvAddBreakpoint<CR>
    autocmd FileType go nmap <leader>dr :DlvRemoveBreakpoint<CR>
    autocmd FileType go nmap <leader>dt :DlvTest<CR>
    autocmd FileType go set tabstop=4 shiftwidth=4
augroup END

" Highlights
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_fields = 1
let g:go_highlight_operators = 1
let g:go_auto_type_info = 1
let g:go_fmt_autosave = 0
" vim-go uses the location list by default. This clashes with gometalinter through ale
" plugin and erases test output when there are errors. Set vim-go to use quickfix
let g:go_list_type = 'quickfix'
let g:go_list_height = 10
let g:go_list_autoclose = 0

" vim delve -----------------------------------------------------------------------------
let g:delve_new_command = 'new' "make a new window a hirizontal split

" ale ---------------------------------------------------------------------
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_fix_on_save = 1
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_use_global = 1
let g:ale_completion_enabled = 1

" using global prettier because the local one has graphql version conflicts
let g:ale_javascript_prettier_use_global = 1

" for some reason it wasn't finding my project config files with prettier_d
"let g:ale_javascript_prettier_executable = 'prettier_d'
"let g:ale_javascript_prettier_options = '--fallback'
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_keep_list_window_open = 1
let g:ale_list_window_size = 10
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

" I had to hack on the main typescript repo so I adde dthis to not run
" prettier on their code and mess up the formatting
let g:ale_pattern_options = {
  \ 'TypeScript': {'ale_fixers': ['tslint']},
  \ 'nvim-typescript': {'ale_fixers': ['tslint']}
  \}

let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
	\ 'javascript': ['prettier', 'eslint', 'importjs'],
	\ 'graphql': ['prettier'],
	\ 'python': ['autopep8'],
	\ 'go': ['gofmt', 'goimports'],
  \ 'typescript': ['prettier', 'tslint'],
	\}

" gometalinter only checks the file on disk, so it is only run when the file is saved,
" which can be misleading because it seems like it should be running these linters on save
" \ 'go': ['golint', 'go vet', 'go build', 'gometalinter'],
let g:ale_linters = {
   \ 'go': ['gometalinter'],
   \ 'proto': ['protoc-gen-lint'],
   \ 'graphql': ['gqlint'],
   \ 'javascript': ['eslint'],
   \ 'typescript': ['tslint'],
   \ 'vim': ['vint'],
   \}

let g:ale_go_gometalinter_options = '--fast --tests'
let g:ale_go_gometalinter_lint_package = 0

" ReactJS stuff --------------------------------------------------------
" react syntax will work on .js files
let g:javascript_plugin_flow = 1

augroup javascript
    autocmd!
    " setting javascript things.
    " importjs seems to mess with things
    nnoremap <leader>i :ImportJSFix<CR>
    "autocmd BufWritePre *.js :ImportJSFix
    autocmd FileType javascript set tabstop=2 shiftwidth=2 expandtab
augroup END

let g:nvim_typescript#server_path = '/Users/Jeff/typescript/TypeScript/bin/tsserver'
let g:nvim_typescript#diagnostics_enable = 1

augroup typescript
    autocmd!
    " special binary for hacking on the Typescript server
    autocmd FileType typescript,typescript.tsx set omnifunc=TSComplete
    autocmd FileType typescript,typescript.tsx set tabstop=2 shiftwidth=2 expandtab
    autocmd FileType typescript,typescript.tsx nnoremap <buffer><leader>i :TSGetCodeFix<CR>
    autocmd FileType typescript,typescript.tsx nnoremap <buffer><leader>dp :TSDefPreview<CR>
    autocmd FileType typescript,typescript.tsx nnoremap <buffer><leader>d :TSDef<CR>
    autocmd FileType typescript,typescript.tsx nnoremap <buffer><leader>t :TSType<CR>
augroup END

" html files ---------------------------------------------------------------
augroup html
    autocmd!
    autocmd FileType html set tabstop=2 shiftwidth=2 expandtab
augroup END

" nerdtree settings ------------------------------------------------------------

let g:NERDTreeDirArrowExpandable = '  '
let g:NERDTreeDirArrowCollapsible = '  '

nnoremap <leader>[ :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 50
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeAutoDeleteBuffer = 1

augroup nerdtree
    autocmd FileType nerdtree setlocal signcolumn=no modifiable
augroup END

" insert mode mappings ------------------------------------------------------

" maps jj to escape to get out of insert mode
inoremap jj <Esc>
" make Shift + Forward/Back skip by word in insert mode
inoremap <S-Right> <Esc>lwi
inoremap <S-Left> <Esc>bi
" for some reason Shift or Control is not working <Del> if fn+backspace
inoremap <Del> <C-W>
" call the autocomplete semantic completion when needed
inoremap ;; <C-x><C-o>

" terminal mode mappings -----------------------------------------------------

autocmd TermOpen * set bufhidden=hide

" when in the terminal, use the jj commands to get out of insert
tnoremap JJ <C-\><C-n>
" enter a buffer name after file so that the user can rename the terminal
" buffer and keep track of multiple terminals
nnoremap <leader>tn :keepalt file

" normal mode mappings -------------------------------------------------------

" copy the current buffer filepath into the clipboard
nnoremap <leader>cp :let @+ = expand("%:p")<CR>
" open two terminals and let the user name them
nnoremap <leader>sh :terminal<CR>i . ~/.bash_profile<CR><C-\><C-n>:keepalt file
" Reload the file from disk (forced so edits will be lost)
nnoremap <leader>r :edit!<CR>
" open a terminal with a window split and source bash profile
nnoremap <leader>tt :terminal<CR>i . ~/.bash_profile<CR>
" add a space in normal mode
nnoremap <space> i<space><esc>
" call the bufkill plugin commad to delete buffer form list
nnoremap <leader>q :bdelete<CR>
nnoremap <leader>qq :bdelete!<CR>
" delete all buffers
nnoremap <leader>qa :bd *<C-a><CR>
" write file (save)
nnoremap <leader>w :w<CR>
" close the preview window with leader p
nnoremap <leader>p :pclose<CR>
" in normal mode, the arrow keys will move tabs
nnoremap <silent> <Left> :bprevious!<CR>
nnoremap <silent> <Right> :bnext!<CR>
nnoremap <silent> <Down> <C-d>
nnoremap <silent> <Up> <C-u>
" moving windows with option arrow
nnoremap <silent> <c-k> :wincmd k<CR>
nnoremap <silent> <c-l> :wincmd l<CR>
nnoremap <silent> <c-j> :wincmd j<CR>
nnoremap <silent> <c-h> :wincmd h<CR>
" inserting newline without entering insert
nnoremap _ O<Esc>
nnoremap - o<Esc>

" this complements the vim command <S-J> which joins current line to below line, this one breaks the current line in two
nnoremap K i<CR><Esc>
" location list open, close, next, previous wincmd's make it so that the cursor goes back to the main buffer
nnoremap <leader>' :lopen<CR>:wincmd k<CR>
nnoremap <leader>'' :lclose<CR>
nnoremap <leader>; :lnext<CR>
nnoremap <leader>l :lprev<CR>
" jump to the current error
nnoremap <leader>;; :ll<CR>
" quickfix window commands
nnoremap <leader>/ :copen<CR>:wincmd k<CR>
nnoremap <leader>// :cclose<CR>
nnoremap <leader>. :cnext<CR>
nnoremap <leader>, :cprevious<CR>
" jump to quickfix current error number
nnoremap <leader>.. :cc<CR>
" insert the UTC date at the end of the line Sun May 13 13:06:42 UTC 2018
nnoremap <leader>x :r! date -u "+\%Y-\%m-\%d \%H:\%M:\%S.000+00"<CR>k<S-j>h

" VISUAL MODE MAPPINGS ------------------------------------------------

" in visual mode, arrows will move text around
vnoremap <Left> <gv
vnoremap <Right> >gv
vnoremap <Up> :m.-2<CR>gv
vnoremap <Down> :m '>+1<CR>==gv

" quickfix window settings -------------------------------------------------

" This trigger takes advantage of the fact that the quickfix window can be
" easily distinguished by its file-type, qf. The wincmd J command is
" equivalent to the Ctrl+W, Shift+J shortcut telling Vim to move a window to
" the very bottom (see :help :wincmd and :help ^WJ).
augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap cc=
augroup END

" toggle highlighting after search

map  <leader>h :set hls!<CR>
imap <leader>h <ESC>:set hls!<CR>a
vmap <leader>h <ESC>:set hls!<CR>gv

" Highlight the highlight group name under the cursor
map fhi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" HIGHLIGHTING ----------------------------------------------------------------

" link is not working in tmux for some reason on the LineNr and SignColumn
hi LineNr guibg=#2d2d2d
hi SignColumn guibg=#2d2d2d
hi Normal guibg=#212121
hi Comment guifg=#595959
hi VertSplit ctermbg=NONE ctermfg=8 cterm=NONE guibg=NONE guifg=#3a3a3a gui=NONE
hi Visual ctermfg=7 ctermbg=8 guibg=#373737
hi Operator guifg=#E9E9E9
hi Type guifg=#E9E9E9
hi Boolean guifg=#e06c75
hi Search guibg=#61afef
hi ColorColumn guibg=#2b2b2b
" to color the background of the vim-go testing errors
hi ErrorMsg guifg=#cc6666 guibg=NONE
" to color the errors in the gutter
hi Error guibg=NONE guifg=#cc6666
" to change the color of the autocomplete menu
hi Pmenu guifg=#a6a6a6 guibg=#373737
hi PmenuSel guifg=#4d4d4d guibg=#81a2be
" changes the color of the line number that the cursor is on
hi CursorLineNr gui=bold guifg=#81a2be
hi CursorLine guibg=#2d2d2d
" go methods only
hi goMethodCall guifg=#81a2be
hi jsFuncCall guifg=#81a2be
" changes them to stand out more
hi link typescriptCase Keyword
hi link typescriptLabel Keyword
hi link typescriptImport Function
hi typescriptIdentifierName gui=BOLD
hi link jsxTagName Function
hi link jsxCloseString ErrorMsg
hi tsxTagName guifg=#5098c4
hi tsxCloseString guifg=#2974a1
hi link graphqlString graphqlComment
hi link deniteMatchedRange NONE

"
hi DiffChange guifg=#b294bb guibg=#373737
hi DiffText guifg=#8abeb7 gui=bold guibg=#373737
hi DiffAdd guifg=#b5bd68 guibg=#373737
hi DiffDelete gui=bold guifg=#cc6666 guibg=#373737

hi NERDTreeOpenable guifg=#b294bb gui=bold
hi link NERDTreeClosable NERDTreeOpenable
hi NERDTreeDir guifg=#ffffff gui=bold
