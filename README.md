# Neovim Writing Environment

A document-first Neovim configuration for reading, writing, navigating,
rendering, annotating, and sharing Markdown. It is designed for people who
want a clean editor with strong keyboard workflows, not a programming IDE.

## What this configuration provides

- Markdown syntax highlighting and structural navigation.
- Inline Markdown rendering without changing the source file.
- A hierarchical heading outline for large documents.
- A quick table of contents in Neovim's location list.
- Durable Mole annotation sessions saved beside the document.
- Temporary context packets for Codex, Claude, terminals, or other apps.
- System-clipboard integration for paths and selected text.
- Telescope file and text search.
- Netrw file browsing.
- Spell-checking, wrapping, and distraction-free writing mode.
- Eight selectable colorschemes.
- Which-key discovery menus for the configured mappings.
- Persistent undo history.

This setup intentionally does not include an LSP, code completion, Copilot,
embedded AI chat, debugger, formatter, or language-specific development
tooling. The clipboard request workflow prepares text for an external AI or
other application; it does not launch an AI process or edit files
automatically.

## Requirements

### Required

- macOS or another Unix-like system with a working terminal.
- Neovim 0.12.0 or newer.
- Git, used to bootstrap Lazy.nvim and download plugins.
- `ripgrep` (`rg`), used by Telescope's project text search.
- A C compiler and the Tree-sitter CLI 0.26.1 or newer, used when installing
  or updating the Markdown parsers.

On macOS with Homebrew:

```sh
brew install neovim git ripgrep tree-sitter
xcode-select --install
```

The Xcode Command Line Tools provide the C compiler. If they are already
installed, macOS will report that no installation is necessary.

### Recommended

- A Nerd Font configured in the terminal. Render-markdown and web-devicons
  use symbols that display best with one.
- Visual Studio Code, Cursor, or Neovide if you plan to use the external
  editor shortcuts. These applications are optional.

The configuration uses macOS's built-in `open` command for external apps. The
`<leader>o*` mappings therefore require macOS as written. On Linux or another
platform, replace those mappings with the platform's equivalent opener.

## Installation

### Quick install into the standard Neovim location

The standard configuration path is `$HOME/.config/nvim`. The destination must
not already contain a configuration unless it has been moved aside first.

```sh
mkdir -p "$HOME/.config"
git clone https://github.com/viperbyte7/nvim.git "$HOME/.config/nvim"
nvim
```

If `$HOME/.config/nvim` already exists, preserve it before cloning:

```sh
mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
git clone https://github.com/viperbyte7/nvim.git "$HOME/.config/nvim"
```

Choose a more specific backup name if you already have a backup at that path.

### Development checkout with a symlink

This is useful when you want to edit the configuration as a normal Git
checkout:

```sh
mkdir -p "$HOME/Projects" "$HOME/.config"
git clone https://github.com/viperbyte7/nvim.git "$HOME/Projects/nvim"
ln -s "$HOME/Projects/nvim" "$HOME/.config/nvim"
nvim
```

If the standard path already exists, move it aside before creating the link.

### First launch

On first launch, Lazy.nvim bootstraps itself and installs the plugins pinned
in `lazy-lock.json`. Then install the two Markdown parsers:

```vim
:Lazy sync
:TSInstall markdown markdown_inline
:checkhealth
```

Restart Neovim after the initial installation if a plugin asks for it. The
configuration starts Tree-sitter for Markdown buffers automatically once the
parsers are available.

## Configuration layout

```text
init.lua                     Entry point; sets leader keys and loads modules
lua/config/options.lua       Editor defaults and clipboard behavior
lua/config/lazy.lua          Lazy.nvim bootstrap and global plugin settings
lua/config/autocmds.lua      Markdown-specific editor automation
lua/config/keymaps.lua       Global mappings and temporary context actions
lua/plugins/core.lua         Which-key, Telescope, Tree-sitter, and icons
lua/plugins/markdown.lua     Outline and inline Markdown rendering
lua/plugins/annotations.lua  Mole annotation workflow
lua/plugins/colorschemes.lua Eight installed themes
lua/plugins/writing.lua      Zen mode
lua/utils/context.lua        Context-packet and clipboard implementation
lazy-lock.json               Pinned plugin revisions
.gitignore                   Local and generated-file exclusions
```

The leader key is Space. The local leader key is backslash. Plugin-specific
mappings are kept with their plugin specifications where practical; global
editor and clipboard mappings live in `lua/config/keymaps.lua`.

## Keymap hierarchy

Press Space in Normal mode, or in Visual mode where supported, and wait for
which-key to show the available commands. Unless noted, mappings are Normal
mode mappings.

```text
<leader>a  Annotations (Mole)
  ac        Add concise annotation (Visual mode)
  am        Add multiline annotation (Visual mode)
  as        Start a session beside the current file
  ar        Resume the session beside the current file
  aq        Stop the active session
  aw        Toggle the annotation panel

<leader>c  Colorschemes
  ct        Tokyonight
  co        Onedark
  cc        Catppuccin
  ck        Kanagawa
  cg        Gruvbox
  cr        Rose Pine
  ce        Everforest
  cn        Nightfox
  cs        Choose interactively

<leader>d  Display
  dz        Toggle all line numbers
  dn        Toggle relative numbers
  dv        Toggle visible characters

<leader>m  Markdown
  mo        Toggle the hierarchical Markdown outline
  mt        Toggle the heading table of contents
  mm        Toggle inline Markdown rendering

<leader>o  Open elsewhere
  of        Open with the macOS default application
  ov        Open in Visual Studio Code
  oc        Open in Cursor
  on        Open in Neovide

<leader>p  Project and search
  pv        Open Netrw
  pf        Find files with Telescope
  pg        Search project text with Telescope
  ps        Search text using a prompt
  pl        Open Lazy.nvim

<leader>v  Windows
  vh/vj/vk/vl  Focus left/down/up/right window
  vH/vL     Decrease/increase window width
  vJ/vK     Decrease/increase window height
  v=        Equalize window sizes
  vx        Maximize or restore the current window

<leader>w  Writing
  ws        Toggle spell-checking
  ww        Toggle word wrap
  wz        Toggle Zen mode

<leader>y  Copy and share
  yp        Copy the full file path
  yr        Copy the path relative to Neovim's current directory
  yd        Copy the containing folder
  yc        Copy selected text with a one-line request (Visual mode)
  ym        Copy selected text with a multiline request (Visual mode)
```

Native Visual-mode `y` remains the fastest way to copy only selected text. The
configuration sets `clipboard = "unnamedplus"`, so ordinary yanks use the
system clipboard as well.

### Window controls

For fast window switching, use `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>` to move
left, down, up, and right. For one-chord resizing, use Option/Alt with
`h/j/k/l`:

```text
<M-h>        Decrease width
<M-l>        Increase width
<M-j>        Decrease height
<M-k>        Increase height
```

If the terminal does not pass Option/Alt as Meta, configure its Option key to
send Esc+ or Meta. The leader-based mappings remain available as a fallback:
`<leader>vH/vL` changes width and `<leader>vJ/vK` changes height. `<leader>vx`
temporarily maximizes the current split and restores the prior layout when
pressed again. `<leader>v=` equalizes all window sizes. These shortcuts are
built into this configuration and do not require another plugin.

`<` and `>` are intentionally not remapped globally because they are native
Normal-mode indentation operators (`<<` and `>>`).

Neovim's native equivalents remain available through the Window command:
`<C-w>h/j/k/l` switches focus, `<C-w>=` equalizes windows, and `<C-w>_` or
`<C-w>|` expands the current window vertically or horizontally.

## Markdown workflows

### Inline rendering

Open a Markdown file and press `<leader>mm`. Render-markdown adds visual
formatting for headings, lists, checkboxes, code blocks, tables, quotes,
links, and other Markdown elements while leaving the source text unchanged.
Press the mapping again to return to the normal source view.

This is an in-editor view, not a separate HTML or PDF export. The Markdown
Tree-sitter parsers must be installed for the best results.

### Hierarchical outline

Press `<leader>mo` to open the outline on the right. It is the preferred tool
for navigating large documents because headings can be folded into a readable
hierarchy.

In the outline window:

```text
j / k       Move through headings
Enter       Jump to the heading
o           Jump without leaving focus in the outline
h / l       Fold or unfold a heading
Tab         Toggle the fold under the cursor
Shift-Tab   Toggle all folds
q / Esc     Close the outline
?           Show the outline's available actions
```

The outline opens focused by default. Use `o` when you want to jump to a
heading while keeping the outline active for continued navigation.

### Heading table of contents

Press `<leader>mt` to toggle a quick heading list in the location list. Use
the normal location-list commands, or select an item to jump to it. For
hierarchical browsing and folding, `<leader>mo` is usually more useful.

### Writing controls

- `<leader>ws` toggles spell-checking for the editor.
- `<leader>ww` toggles wrapping.
- `<leader>wz` opens Zen mode with a narrower writing column.

## Mole annotations

Mole is the durable review workflow. It records notes in a Markdown sidecar
next to the source document rather than putting review comments into the
source file.

### Sidecar location

For a source file such as:

```text
/path/to/document.md
```

the annotation file is:

```text
/path/to/document.md.review.md
```

Review sidecars match `*.review.md` in `.gitignore`, so they are local by
default and will not be committed. Remove that ignore rule if review files
should be versioned deliberately.

### Add an annotation

1. Open a named file and select text in Visual mode.
2. Press `<leader>ac` for a concise annotation or `<leader>am` for a
   multiline annotation.
3. If no Mole session is active, the mapping starts one beside the current
   file automatically.
4. Enter the note and confirm it.

The concise Mole input uses `<Enter>` to save and `<Esc>` to cancel. The
multiline editor starts in Insert mode. Press `<Esc>` to enter Normal mode and
use normal motions and basic editing commands. In the expanded editor:

- `<C-Enter>` or `<leader><Enter>` saves the annotation.
- `<Esc>` or `q` in Normal mode cancels it.
- `<Tab>` switches between location and snippet capture modes.

### Location and snippet capture

- **Location mode** saves the file path and line range with the note.
- **Snippet mode** saves the location, note, and a fenced copy of the
  selected text.

This configuration defaults to snippet mode because the copied text remains
available during later review. Location mode creates a smaller sidecar, but
the line reference can become less useful after the source document changes.
Both modes allow concise or multiline notes and both allow the annotation
panel to jump back to the source location.

### Manage a session

- `<leader>as` starts a session beside the current file.
- `<leader>ar` resumes its existing sidecar.
- `<leader>aw` toggles the side panel.
- `<leader>aq` stops the session and writes its final footer.

Mole's equivalent commands are `:MoleStart`, `:MoleResume`, `:MoleToggle`,
and `:MoleStop`. The configuration also provides `:MoleStartHere` and
`:MoleResumeHere`, which always target the current file's sidecar.

## Temporary context requests

The `<leader>y` request actions are intentionally separate from Mole. They do
not read the sidecar, create annotations, or modify the source buffer.

### One-line request

1. Select text in Visual mode.
2. Press `<leader>yc`.
3. Enter a one-line instruction.
4. Press Enter.
5. Paste the resulting packet into Codex, Claude, a terminal, or another
   application.

### Multiline request

1. Select text in Visual mode.
2. Press `<leader>ym`.
3. The floating editor opens in Insert mode.
4. Type or paste a multiline request.
5. Use normal-mode motions and basic editing as needed.
6. Press `<C-Space>` or `<C-Enter>` to copy the packet.
7. Paste it into the destination application.

`<C-Space>` is the Ctrl+leader shortcut for the current configuration because
the leader is Space. `<C-Enter>` is the second confirmation shortcut. Press
`<Esc>` to enter Normal mode; press `<Esc>` again in Normal mode, or `q`, to
cancel the editor.

The generated Markdown packet contains:

- Full file path.
- Project-relative path when a project root can be detected.
- Current working directory and working-directory-relative path.
- Project root and containing folder.
- File type, line range, column range, and selection mode.
- Capture timestamp and whether the source buffer has unsaved changes.
- The request and selected text.

The project root is inferred from the nearest `.git`, `pyproject.toml`,
`package.json`, or `Makefile`. If none is found, the current working directory
is used. The packet is placed in the system clipboard and is not persisted by
Neovim, so paste it into the destination application before replacing it with
another clipboard item.

## Opening files in other applications

The external-application mappings use macOS's `open` command and work whether
the target application is already running or not:

- `<leader>of` opens the file with the default application.
- `<leader>ov` opens it in Visual Studio Code.
- `<leader>oc` opens it in Cursor.
- `<leader>on` opens it in Neovide.

The file must have a saved path. If the application is not installed, macOS
will report that it cannot open the file with that application.

## Plugin inventory

| Plugin | Purpose |
| --- | --- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin installation, lazy loading, and lockfile management. |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Displays available mappings after the leader key. |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | File finding and text search. |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Telescope's required Lua utility dependency. |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Markdown parsing and syntax-aware features. |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | Icons used by Markdown rendering and UI components. |
| [mole.nvim](https://github.com/zion-off/mole.nvim) | Durable file annotations and review sidecars. |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | Mole's popup and floating-window UI dependency. |
| [outline.nvim](https://github.com/hedyhli/outline.nvim) | Hierarchical heading navigation. |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | In-editor Markdown rendering. |
| [zen-mode.nvim](https://github.com/folke/zen-mode.nvim) | Distraction-free writing layout. |

Installed themes:

- Tokyonight
- Onedark
- Catppuccin
- Kanagawa
- Gruvbox
- Rose Pine
- Everforest
- Nightfox

There is deliberately no embedded Codex or other AI plugin. External context
packets keep the editor focused and work with any application that accepts
Markdown from the clipboard.

## Maintenance

Open the Lazy interface with `<leader>pl` or `:Lazy`.

```vim
:Lazy sync       Install missing plugins, update plugins, and clean removed ones
:Lazy install    Install missing plugins only
:Lazy update     Update plugins and the lockfile
:Lazy clean      Remove plugins no longer declared by the configuration
:Lazy restore    Restore plugin revisions from lazy-lock.json
:Lazy check      Check for available updates
:TSUpdate        Update installed Tree-sitter parsers
:checkhealth     Run Neovim and provider health checks
```

After changing plugin declarations, run `:Lazy sync`. After updating
nvim-treesitter, run `:TSUpdate` and reinstall the Markdown parsers if needed.
Review `lazy-lock.json` changes before committing them.

## Troubleshooting

### Plugins did not install

Check that Git can reach GitHub, then run `:Lazy sync`. The Lazy window shows
which plugin failed and usually includes the underlying Git error.

### Markdown rendering or outline is empty

Install the parsers explicitly:

```vim
:TSInstall markdown markdown_inline
```

Then restart Neovim and run `:checkhealth`.

### Icons or rendering symbols look wrong

Install and configure a Nerd Font in the terminal. The editor can still be
used without one, but icons may appear as missing glyphs.

### Clipboard copying does not work

Run `:checkhealth` and verify that Neovim has clipboard provider support. On
macOS, `pbcopy` and `pbpaste` are built in. The configuration's
`clipboard = "unnamedplus"` setting makes native yanks and the request helpers
use the system clipboard.

### An external editor does not open

Confirm that the application is installed and that its registered macOS name
matches the mapping. The configured names are `Visual Studio Code`, `Cursor`,
and `Neovide`.

### Netrw is open and I want to return to the editor

Press `q` in the Netrw window. If the buffer has unsaved changes, save it with
`:update` or discard it deliberately before closing.

### Which-key does not appear

Press and release Space in Normal mode, then wait briefly. In Visual mode,
select text first and press Space. If the menu still does not appear, run
`:checkhealth which-key`.

## Local files and privacy

The repository contains configuration and plugin metadata only. It does not
contain API keys, credentials, or AI service configuration. Mole sidecars may
contain document excerpts and review notes; they are ignored by Git but remain
on the local machine until removed.

## License

This configuration is released under the MIT License. See [LICENSE](LICENSE).
