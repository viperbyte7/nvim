# Neovim writing environment

A clean, document-first Neovim configuration for Markdown reading, writing,
annotation, navigation, and portable context sharing.

## Design

This is an editor and writing environment, not a programming IDE. It keeps
the configuration modular and avoids LSP, completion, Copilot, and language
tooling. Lazy.nvim manages plugins and `lazy-lock.json` pins their revisions.

## Layout

- `lua/config/` contains options, startup, autocmds, and global mappings.
- `lua/plugins/` contains one focused Lazy specification per feature.
- `lua/utils/` contains small reusable helpers.

## Keymap tree

The leader key is Space. Press Space and wait for which-key to see the live
menu.

```text
<leader>a  Annotations (Mole)
  ac        Concise annotation
  am        Multiline annotation
  as/ar     Start/resume beside current file
  aq/aw     Stop/toggle panel

<leader>c  Colorschemes
  ct/co/cc  Tokyonight / Onedark / Catppuccin
  ck/cg     Kanagawa / Gruvbox
  cr/ce/cn  Rose Pine / Everforest / Nightfox
  cs        Choose interactively

<leader>d  Display
  dn        Toggle relative numbers
  dz        Toggle all line numbers
  dv        Toggle visible characters

<leader>m  Markdown
  mm        Toggle inline rendering
  mo        Toggle hierarchical Markdown outline
  mt        Toggle heading table of contents

<leader>o  Open elsewhere
  of/ov/oc  Default app / VS Code / Cursor
  on        Neovide

<leader>p  Project / search
  pv        Netrw
  pf/pg/ps  Find files / project search / search prompt
  pl        Lazy

<leader>w  Writing
  ws/ww/wz  Spell / wrap / Zen mode

<leader>y  Copy / share
  yp/yr/yd  Full / relative / containing folder
  yc        Copy selected text and a one-line request
  ym        Copy selected text and a multiline request
```

## Annotation workflow

Open a Markdown file and visually select text. Press `<leader>ac` or
`<leader>am` to add a concise or multiline Mole annotation; the session starts
or resumes automatically. Mole stores the review beside the source as:

```text
document.md.review.md
```

Review files are intentionally ignored by Git. The `<leader>yc` context action
does not read or write Mole. It is a temporary request packet for Codex,
Claude, a terminal, or any other application.

`<leader>yc` prompts for a one-line request, while `<leader>ym` opens a
multiline request editor. The multiline editor is a temporary normal Neovim
scratch buffer: start in Insert mode, press `<Esc>` to use Normal-mode motions
and basic editing commands, then use `<C-Space>` or `<C-Enter>` to copy.
Press `<Esc>` again in Normal mode, or `q`, to cancel. Both actions copy a
Markdown payload containing the full path, relative path, line and column
range, timestamp, file type, modified-buffer status, selected text, and
request. Paste it into Codex, Claude, a terminal, or any other application.
Neovim does not start an AI process or make edits automatically.

## Installation

Clone this repository as `~/.config/nvim`, or use it directly as the Neovim
configuration directory. Start Neovim and Lazy.nvim will install the pinned
plugins. Markdown parsers are installed by running `:TSInstall markdown
markdown_inline` if they are not already present.
