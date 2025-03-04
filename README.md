<!--
SPDX-FileCopyrightText: Copyright (C) 2025 Samuel W. Flint <swflint@samuelwflint.com>

SPDX-License-Identifier: GFDL-1.3-or-later
-->

# Denote Journal Capture [![Not Yet on MELPA](https://melpa.org/packages/denote-project-notes-badge.svg)](https://melpa.org/#/denote-project-notes) [![REUSE status](https://api.reuse.software/badge/git.sr.ht/~swflint/denote-project-notes)](https://api.reuse.software/info/git.sr.ht/~swflint/denote-project-notes)

This package provides some simple linkage between Denote notes and projects.
It does so by providing two buffer/directory-local variables that can be set through a provided command (`denote-project-notes-set-identifier`).
The notes can then be displayed using `denote-project-notes-show`.
It is recomended to bind one or both of these commands to a convenient key.

The primary variable to select notes is `denote-project-notes-identifier`, whish should be set to a Denote identifier that can be found in `denote-project-notes-denote-directory` (a Denote silo).

Display can be customized using either `display-buffer-alist` (the default), or through `denote-project-notes-display-action` (a `display-buffer` action).

## Errors and Patches

If you find an error, or have a patch to improve this package, please send an email to `~swflint/emacs-utilities@lists.sr.ht`.
