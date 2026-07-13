" kitty.vim — Vim colorscheme matching ~/.config/kitty/kitty.conf
" Palette: bg #1B1B1B, fg #FFFFFF, red #FF5F5F, green #008067,
"          orange #FF9000, blue #61AFEF, magenta #C678DD, cyan #56B6C2
" Works in truecolor (termguicolors) and 256-color terminals.

set background=dark
hi clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'kitty'

" --- helper -----------------------------------------------------------------
function! s:hi(group, guifg, guibg, ctermfg, ctermbg, attr) abort
  let l:cmd = 'hi ' . a:group
  let l:cmd .= ' guifg=' . a:guifg . ' guibg=' . a:guibg
  let l:cmd .= ' ctermfg=' . a:ctermfg . ' ctermbg=' . a:ctermbg
  let l:cmd .= ' gui=' . a:attr . ' cterm=' . a:attr
  execute l:cmd
endfunction

" --- palette ----------------------------------------------------------------
let s:bg      = '#1B1B1B'
let s:fg      = '#FFFFFF'
let s:red     = '#FF5F5F'
let s:green   = '#008067'
let s:orange  = '#FF9000'
let s:blue    = '#61AFEF'
let s:magenta = '#C678DD'
let s:cyan    = '#56B6C2'
let s:grey    = '#6B6B6B'
let s:line    = '#262626'
let s:sel     = '#333333'

let s:c_bg      = '234'
let s:c_fg      = '231'
let s:c_red     = '203'
let s:c_green   = '29'
let s:c_orange  = '208'
let s:c_blue    = '75'
let s:c_magenta = '176'
let s:c_cyan    = '73'
let s:c_grey    = '242'
let s:c_line    = '235'
let s:c_sel     = '236'

" --- UI ---------------------------------------------------------------------
call s:hi('Normal',       s:fg,    s:bg,   s:c_fg,    s:c_bg,   'NONE')
call s:hi('LineNr',       s:grey,  s:bg,   s:c_grey,  s:c_bg,   'NONE')
call s:hi('CursorLineNr', s:orange,s:line, s:c_orange,s:c_line, 'bold')
call s:hi('CursorLine',   'NONE',  s:line, 'NONE',    s:c_line, 'NONE')
call s:hi('CursorColumn', 'NONE',  s:line, 'NONE',    s:c_line, 'NONE')
call s:hi('ColorColumn',  'NONE',  s:line, 'NONE',    s:c_line, 'NONE')
call s:hi('Visual',       'NONE',  s:sel,  'NONE',    s:c_sel,  'NONE')
call s:hi('StatusLine',   s:fg,    s:line, s:c_fg,    s:c_line, 'bold')
call s:hi('StatusLineNC', s:grey,  s:line, s:c_grey,  s:c_line, 'NONE')
call s:hi('VertSplit',    s:line,  s:bg,   s:c_line,  s:c_bg,   'NONE')
call s:hi('Pmenu',        s:fg,    s:line, s:c_fg,    s:c_line, 'NONE')
call s:hi('PmenuSel',     s:bg,    s:green,s:c_bg,    s:c_green,'bold')
call s:hi('Search',       s:bg,    s:orange,s:c_bg,   s:c_orange,'NONE')
call s:hi('IncSearch',    s:bg,    s:red,  s:c_bg,    s:c_red,  'NONE')
call s:hi('MatchParen',   s:orange,s:sel,  s:c_orange,s:c_sel,  'bold')
call s:hi('Folded',       s:grey,  s:line, s:c_grey,  s:c_line, 'NONE')
call s:hi('SignColumn',   s:fg,    s:bg,   s:c_fg,    s:c_bg,   'NONE')
call s:hi('WildMenu',     s:bg,    s:orange,s:c_bg,   s:c_orange,'bold')
call s:hi('Directory',    s:green, s:bg,   s:c_green, s:c_bg,   'bold')
call s:hi('Title',        s:orange,s:bg,   s:c_orange,s:c_bg,   'bold')
call s:hi('NonText',      s:grey,  s:bg,   s:c_grey,  s:c_bg,   'NONE')
call s:hi('SpecialKey',   s:grey,  s:bg,   s:c_grey,  s:c_bg,   'NONE')
call s:hi('ErrorMsg',     s:red,   s:bg,   s:c_red,   s:c_bg,   'bold')
call s:hi('WarningMsg',   s:orange,s:bg,   s:c_orange,s:c_bg,   'bold')

" --- syntax -----------------------------------------------------------------
call s:hi('Comment',    s:grey,    s:bg, s:c_grey,    s:c_bg, 'italic')
call s:hi('Constant',   s:cyan,    s:bg, s:c_cyan,    s:c_bg, 'NONE')
call s:hi('String',     s:green,   s:bg, s:c_green,   s:c_bg, 'NONE')
call s:hi('Character',  s:green,   s:bg, s:c_green,   s:c_bg, 'NONE')
call s:hi('Number',     s:orange,  s:bg, s:c_orange,  s:c_bg, 'NONE')
call s:hi('Boolean',    s:orange,  s:bg, s:c_orange,  s:c_bg, 'NONE')
call s:hi('Float',      s:orange,  s:bg, s:c_orange,  s:c_bg, 'NONE')
call s:hi('Identifier', s:red,     s:bg, s:c_red,     s:c_bg, 'NONE')
call s:hi('Function',   s:blue,    s:bg, s:c_blue,    s:c_bg, 'NONE')
call s:hi('Statement',  s:magenta, s:bg, s:c_magenta, s:c_bg, 'bold')
call s:hi('Conditional',s:magenta, s:bg, s:c_magenta, s:c_bg, 'bold')
call s:hi('Repeat',     s:magenta, s:bg, s:c_magenta, s:c_bg, 'bold')
call s:hi('Keyword',    s:magenta, s:bg, s:c_magenta, s:c_bg, 'bold')
call s:hi('Operator',   s:fg,      s:bg, s:c_fg,      s:c_bg, 'NONE')
call s:hi('PreProc',    s:orange,  s:bg, s:c_orange,  s:c_bg, 'NONE')
call s:hi('Include',    s:orange,  s:bg, s:c_orange,  s:c_bg, 'NONE')
call s:hi('Define',     s:orange,  s:bg, s:c_orange,  s:c_bg, 'NONE')
call s:hi('Macro',      s:orange,  s:bg, s:c_orange,  s:c_bg, 'NONE')
call s:hi('Type',       s:cyan,    s:bg, s:c_cyan,    s:c_bg, 'NONE')
call s:hi('StorageClass',s:cyan,   s:bg, s:c_cyan,    s:c_bg, 'NONE')
call s:hi('Structure',  s:cyan,    s:bg, s:c_cyan,    s:c_bg, 'NONE')
call s:hi('Special',    s:cyan,    s:bg, s:c_cyan,    s:c_bg, 'NONE')
call s:hi('Todo',       s:orange,  s:line, s:c_orange,s:c_line,'bold')
call s:hi('Error',      s:red,     s:bg, s:c_red,     s:c_bg, 'bold')
call s:hi('Underlined', s:blue,    s:bg, s:c_blue,    s:c_bg, 'underline')

" --- diff -------------------------------------------------------------------
call s:hi('DiffAdd',    s:green,  s:bg, s:c_green,  s:c_bg, 'NONE')
call s:hi('DiffChange', s:orange, s:bg, s:c_orange, s:c_bg, 'NONE')
call s:hi('DiffDelete', s:red,    s:bg, s:c_red,    s:c_bg, 'NONE')
call s:hi('DiffText',   s:orange, s:line,s:c_orange,s:c_line,'bold')

delfunction s:hi
