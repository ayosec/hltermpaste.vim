# hltermpaste.vim - highlight terminal paste

Vim plugin to highlight pasted text in a terminal.

This plugin is similar to [vim-highlightedyank](https://github.com/machakann/vim-highlightedyank), but instead of highlighting yanked text, it highlights text when it is pasted.

## Demo

[![Demo](https://asciinema.org/a/425363.svg)](https://asciinema.org/a/425363)

## Installation

Using [Vim packages](https://vimhelp.org/repeat.txt.html#packages):

```console
$ YOUR_PACK_NAME=AnyNameYouWant

$ cd ~/.vim/pack/$YOUR_PACK_NAME/start

$ git clone https://github.com/ayosec/hltermpaste.vim hltermpaste
```

## How It Works

Vim has support for [bracketed paste](https://vimhelp.org/term.txt.html#xterm-bracketed-paste). If it is enabled, Vim sets the `paste` option before to receive the pasted text, and unset it when the paste is finished. This plugin detects those actions with the [`OptionSet`](https://vimhelp.org/autocmd.txt.html#OptionSet) event, and track the cursor position before and after the events. Then, it highlights the region between both positions.

## Configuration

### Highlight Duration

To control the duration of the highlight set the value of `g:hltermpaste_timeout` to a number of milliseconds. By default, it is `500`.

```vim
" Highlight for 1 second
let g:hltermpaste_timeout = 1000
```

### Highlight Color

By default, the pasted text is highlighted as [`IncSearch`](https://vimhelp.org/syntax.txt.html#hl-IncSearch). You can use a different highlighting group with `g:hltermpaste_match_group`. For example:

```vim
let g:hltermpaste_match_group = "DiffAdd"
```

Also, you can define your own colors with a new highlighting group. For example:

```vim
hi def PastedText term=reverse ctermbg=4 guibg=Blue

let g:hltermpaste_match_group = "PastedText"
```

### Disable the Plugin

To disable the plugin, set `g:loaded_hltermpaste` to any value:

```vim
let g:loaded_hltermpaste = 1
```

## Commands

The command `:HighlightTermPasteVisual` creates a visual selection with the latest pasted text.
