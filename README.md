# hltermpaste.vim - highlight terminal paste

Vim and Neovim plugin to highlight pasted text in a terminal.

When you paste something (like <kbd>Control</kbd> <kbd>Shift</kbd> <kbd>V</kbd>
in many terminal emulators), this plugin detects and highlights the new text.

It is similar to [vim-highlightedyank], but for pasted text.

[vim-highlightedyank]: https://github.com/machakann/vim-highlightedyank

## Demo

[![Demo](https://asciinema.org/a/425363.svg)](https://asciinema.org/a/425363)

## Installation

The plugin is tested in Vim 8.1 and Neovim 0.5.

You can use [Vim packages](https://vimhelp.org/repeat.txt.html#packages) to
install it:

* For Vim:


    ```console
    $ YOUR_PACK_NAME=AnyNameYouWant

    $ cd ~/.vim/pack/$YOUR_PACK_NAME/start

    $ git clone https://github.com/ayosec/hltermpaste.vim.git hltermpaste
    ```

* For Neovim:

    ```console
    $ YOUR_PACK_NAME=AnyNameYouWant

    $ cd ~/.local/share/nvim/site/pack/$YOUR_PACK_NAME/start

    $ git clone https://github.com/ayosec/hltermpaste.vim.git hltermpaste
    ```

If you prefer any other plugin manager, it should work with most of them.
Please open an issue if you find any problem with your preferred plugin
manager.

## How It Works

### Vim

Vim has support for [bracketed paste]. If it is enabled, Vim sets the `paste`
option when the paste starts, and unset it when the paste is finished. This
plugin detects those actions with the [`OptionSet`] event, and tracks the
cursor position before and after the events. Then, it highlights the region
between both positions.

[bracketed paste]: https://vimhelp.org/term.txt.html#xterm-bracketed-paste
[`OptionSet`]: https://vimhelp.org/autocmd.txt.html#OptionSet

### Neovim

In Neovim we only need to use a custom paste handler with [`vim.paste`]. The
handler tracks the cursor position before and after the paste, and then
highlights the region between both positions.

[`vim.paste`]: https://neovim.io/doc/user/lua.html#vim.paste%28%29

## Configuration

### Highlight Duration

To control the duration of the highlight set the value of
`g:hltermpaste_timeout` to a number of milliseconds. By default, it is `500`.

For example, to set the duration to 1 second:

```vim
" Highlight for 1 second
let g:hltermpaste_timeout = 1000
```

### Highlight Color

By default, the pasted text is highlighted as [`IncSearch`]. You can use a
different highlighting group with `g:hltermpaste_match_group`. For example:

[`IncSearch`]: https://vimhelp.org/syntax.txt.html#hl-IncSearch

```vim
let g:hltermpaste_match_group = "DiffAdd"
```

Also, you can define your own colors with a new highlighting group. For example:

```vim
let g:hltermpaste_match_group = "PastedText"

hi def PastedText term=reverse ctermbg=4 guibg=Blue
```

Please see the documentation for [`:highlight`] to see all available options.

[`:highlight`]: https://vimhelp.org/syntax.txt.html#%3Ahighlight

### Disable the Plugin

To disable the plugin, set `g:loaded_hltermpaste` to any value:

```vim
let g:loaded_hltermpaste = 1
```

## Commands

The command `:HighlightTermPasteVisual` creates a visual selection with the
latest pasted text.
