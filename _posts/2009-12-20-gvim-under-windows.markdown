---
layout: post
title: gvim under Windows
summary:
    In an effort to bring the stuff from my old
    "blog" back to liff, I ported some articles,
    including this one about how to make gvim
    behave nicely under Windows.
tag: '{{'
---

I ported this from my old blog. So it's a bit older already

----

I just started working at a new place and I have to use Windows there.

So first thing I did was get gvim of course... :-)
A true enthusiast never uses notepad (after all, my fingers would instantly melt...)

Unfortunately, with standard settings, gvim behaves really stupid, so here's some tricks to
make it play more smoothly. I'll update them as I find more quirks ;-)

{% highlight vim %}
autocmd GUIEnter * simalt ~X  " makes gvim start maximized all the time

" restores some of the standard behaviour, e.g. how mouse and visual mode behave
behave xterm
set selectmode=

set backspace=2  " removes the issue where backspace doesn't delete linefeeds

" enables syntax highlighting
filetype on
syntax enable

set nocompatible " disable old vi stuff

" tell it how many spaces are a tab when indenting
set tabstop=4
set softtabstop=4
set shiftwidth=4

set expandtab    " and to actually use spaces instead of tabs

" let vim do indentation
set autoindent
set smartindent

" show line numbers and 'statusbar'
set number
set ruler

set showmatch    " highlight matching braces
set incsearch    " immidiately show matches from searches
set nowrap       " don't wrap long lines

" do folding with {{ page.tag }}{1 like tags
set foldenable
set foldmethod=marker

" always map F1 to Escape (i hit that around 3 times a minute...)
imap <F1> <ESC>
nmap <F1> <ESC>
vmap <F1> <ESC>

" use F2 to toggle paste mode
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O><F2>i
set pastetoggle=<F2>

" use F3 to toggle shiftwidth between 4 and 2
nnoremap <expr> <F3> (&sw =~ "4$") ? ":set shiftwidth=2<cr>:set tabstop=2<cr>:set softtabstop=2<cr>" : ":set shiftwidth=4<cr>:set tabstop=4<cr>:set softtabstop=4<cr>"
imap <F3> <C-O><F3>
{% endhighlight %}

That's a pretty neat basic setup already...
Here's some more convenience stuff I like to use:

{% highlight vim %}
" here's a longer one: autocompletion with Ctrl+Space
" don't auto-insert first item, show menu even with only one entry
set completeopt=longest,menuone
" make completion a bit nicer
" j and k to move in the menu
inoremap <expr> j pumvisible() ? "\\<lt>down>" : "j"
inoremap <expr> k pumvisible() ? "\<lt>up>" : "k"
" <space> . : , ( and <tab> all apply the selected word
inoremap <expr> <space> pumvisible() ? "\<lt>c-y> " : "\<lt>space>"
inoremap <expr> . pumvisible() ? "\<lt>c-y>." : "."
inoremap <expr> : pumvisible() ? "\<lt>c-y>:" : ":"
inoremap <expr> , pumvisible() ? "\<lt>c-y>," : ","
inoremap <expr> ( pumvisible() ? "\<lt>c-y>(" : "("
inoremap <expr> <tab> pumvisible() ? "\<lt>c-y>" : "\<lt>tab>"
" starts autocompletion if there is something to complete or does nothing
function InsertCompleteWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return ""
  else
    return "\<c-p>\<down>"
  endif
endfunction
" make c-SPACE the autocomplete key
inoremap <expr> <Nul> pumvisible() ? "\<c-e>" : "\<c-g>u<c-r>=InsertCompleteWrapper()<cr>"

" use bn, bp to go to the next/previous buffer, bd to delete the buffer
nmap bn :bn!<cr>
nmap bp :bp!<cr>
nmap bd :bd<cr>
{% endhighlight %}

