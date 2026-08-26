# Neovim writing environment

A clean, document-first Neovim configuration for Markdown reading, writing,
annotation, navigation, and optional Codex-assisted review.

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
  aa        Annotate visual selection
  as/ar     Start/resume beside current file
  aq/aw     Stop/toggle panel

<leader>c  Colorschemes
  ct/co/cc  Tokyonight / Onedark / Catppuccin
  ck/cg     Kanagawa / Gruvbox
  cr/ce/cn  Rose Pine / Everforest / Nightfox
  cs        Choose interactively

<leader>g  Codex / AI
  gg        Toggle Codex terminal
  gf        Add current file
  gs        Send visual selection
  gr        Review Markdown and its .review.md sidecar
  gc/gx     Continue / stop session

<leader>m  Markdown
  mm        Toggle inline rendering
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

<leader>y  Copy paths
  yp/yr/yd  Full / relative / containing folder
```

## Annotation workflow

Open a Markdown file, press `<leader>as`, visually select text and press
`<leader>aa`. Mole stores the review beside the source as:

```text
document.md.review.md
```

Review files are intentionally ignored by Git. Press `<leader>gr` to give
Codex both the Markdown file and its annotation sidecar. Codex remains the
source of truth for its own conversation and approval workflow.

## Codex

The optional [`codex.nvim`](https://github.com/nwiizo/codex.nvim) integration
uses the Codex CLI terminal backend. It requires Neovim 0.12+ and `codex` on
`PATH`; no API key is stored in this repository. Run `:CodexHealth` if the
integration needs diagnosis.

## Installation

Clone this repository as `~/.config/nvim`, or use it directly as the Neovim
configuration directory. Start Neovim and Lazy.nvim will install the pinned
plugins. Markdown parsers are installed by running `:TSInstall markdown
markdown_inline` if they are not already present.
