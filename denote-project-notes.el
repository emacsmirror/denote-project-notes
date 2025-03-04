;;; denote-project-notes.el --- Link Denote notes to a project  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Samuel W. Flint <swflint@samuelwflint.com>

;; Author: Samuel W. Flint <swflint@samuelwflint.com>
;; SPDX-License-Identifier: GPL-3.0-or-later
;; Homepage: https://git.sr.ht/~swflint/denote-project-notes
;; Version: 1.0.0
;; Keywords: convenience
;; Package-Requires: ((emacs "28.1") (denote "3.0.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides some simple linkage between Denote notes and
;; projects.  It does so by providing two buffer/directory-local
;; variables that can be set through a provided command
;; (`denote-project-notes-set-identifier').  The notes can then be
;; displayed using `denote-project-notes-show'.  It is recomended to
;; bind one or both of these commands to a convenient key.
;;
;; The primary variable to select notes is
;; `denote-project-notes-identifier', whish should be set to a Denote
;; identifier that can be found in
;; `denote-project-notes-denote-directory' (a Denote silo).
;;
;; Display can be customized using either `display-buffer-alist' (the
;; default), or through `denote-project-notes-display-action' (a
;; `display-buffer' action).
;;
;;;; Errors and Patches
;;
;; If you find an error, or have a patch to improve this package,
;; please send an email to ~swflint/emacs-utilities@lists.sr.ht.


;;; Code:

(require 'denote)
(require 'project)


;;; Configuration

(defgroup denote-project-notes ()
  "Link to Denote notes from within a project (broadly defined)."
  :group 'denote
  :group 'project
  :link '(url-link :tag "Homepage" "https://git.sr.ht/~swflint/denote-project-notes")
  :link '(emacs-library-link :tag "Library Source" "denote-project-notes.el"))

(defcustom denote-project-notes-identifier nil
  "Denote identifier for project notes.

If nil, no notes will be associated with the project."
  :group 'denote-project-notes
  :type '(choice (const :tag "No notes." nil)
                 (string :tag "Denote Identifier"))
  :local t
  :safe #'string-or-null-p)

(defcustom denote-project-notes-denote-directory denote-directory
  "Location of Denote silo for project notes.

This defaults to the load-time value of the variable `denote-directory',
but can be set otherwise."
  :group 'denote-project-notes
  :type 'directory
  :local t
  :safe #'directory-name-p)

(defcustom denote-project-notes-display-action nil
  "How project notes should be displayed.

If nil, `display-buffer-alist' will be used.  Otherwise, this value
should be a valid ACTION for `display-buffer', which see."
  :group 'denote-project-notes
  :type `(choice (const :tag  "Fall-back on display-buffer-alist" nil)
                 (alist :key-type (choice :tag "Condition"
                                          regexp
                                          (function :tag "Matcher function"))
                        :value-type ,display-buffer--action-custom-type))
  :risky t)


;;; User Interface

(defun denote-project-notes-set-identifier (identifier directory)
  "Set the current project's note IDENTIFIER, in DIRECTORY.

Prompt for DIRECTORY if the prefix argument is used."
  (interactive
   (let* ((denote-directory (if current-prefix-arg
                                (read-directory-name "Denote Silo: " denote-project-notes-denote-directory)
                              denote-project-notes-denote-directory))
          (filename (denote-file-prompt nil "Project notes file" nil))
          (identifier (denote-retrieve-filename-identifier filename))
          (dir-locals-path (or (locate-dominating-file (buffer-file-name) dir-locals-file)
                               (and (project-current)
                                    (file-name-concat (project-root (project-current)) dir-locals-file)))))
     (list identifier denote-directory)))
  (add-dir-local-variable nil 'denote-project-notes-identifier identifier dir-locals-path)
  (unless (string= (expand-file-name directory)
                   (expand-file-name denote-project-notes-denote-directory))
    (add-dir-local-variable nil 'denote-project-notes-denote-directory directory dir-locals-path)))

(defun denote-project-notes-show ()
  "Show the current project's notes.

The current project's notes are determined by:

 - `denote-project-notes-identifier', notes file identifier
 - `denote-project-notes-denote-directory', Denote silo

The notes are displayed using `display-buffer', following
`denote-project-notes-display-action' (if non-nil)."
  (interactive)
  (when-let* ((denote-directory denote-project-notes-denote-directory)
              (identifier denote-project-notes-identifier)
              (filename (car (denote-directory-files identifier)))
              (buffer (or (get-file-buffer filename)
                          (find-file-noselect filename))))
    (if denote-project-notes-display-action
        (display-buffer buffer denote-project-notes-display-action)
      (display-buffer buffer))))

(provide 'denote-project-notes)
;;; denote-project-notes.el ends here
