;;; as-anything2.el --- anything config

;; Copyright (C) 2009  aaditya sood

;; Author: aaditya sood <aaditya@kali.sood.webhop.net>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:


(require 'anything-config)
(require 'anything)
(require 'anything-match-plugin)

(setq anything-candidate-number-limit 9)
(setq anything-mp-space-regexp "[\\ ] ")


(setq anything-c-boring-file-regexp
  (rx (or
       ;; Boring directories
       (and "/" (or ".svn" "CVS" "_darcs" ".git") (or "/" eol))
       ;; Boring files
       (and line-start  ".#")
       (and (or ".class" ".la" ".o" ".pyc" "~" ".DS_Store") eol))))

(defvar anything-c-boring-buffer-regexp
  (rx (or 
       ;; because of switch commands (@> "switch commands")
       "tvprog-keyword.txt" "tvprog.html" ".crontab" "+inbox"
       ;; internal use only
       "*windows-tab*"
       ;; caching purpose
       "*refe2x:" "*refe2:" "ri `"
       ;; echo area
       " *Echo Area" " *Minibuf")))

(defun anything-c-skip-boring-buffers (buffers)
  (remove-if (lambda (buf) (and (stringp buf) (string-match anything-c-boring-buffer-regexp buf)))
             buffers))

(defun anything-c-skip-current-buffer (buffers)
  (remove (buffer-name anything-current-buffer) buffers))

(defun anything-sort-sources-by-major-mode (sources)
  (loop for src in sources
        for modes = (anything-attr 'major-mode (symbol-value src))
        if (memq major-mode modes)
        collect src into prior
        else
        collect src into rest
        finally (return (append prior rest))))

(defvar anything-c-source-kill-ring
  '((name . "Kill Ring")
    (candidates . (lambda ()
                    (loop for kill in kill-ring
                          unless (string-match "^[\\s\\t]+$" kill)
                          collect kill)))
    (action . insert)
    (migemo)
    (multiline)))

(defvar anything-type-attribute/command-local
  '((action 
     ("Call interactively" . anything-c-call-interactively-from-string))
    ;; Sort commands according to their usage count.
    (filtered-candidate-transformer . anything-c-adaptive-sort)
    (persistent-action . anything-c-call-interactively-from-string)
    ))

(defvar anything-c-source-occur
  '((name . "Occur")
    (init . (lambda ()
              (setq anything-occur-current-buffer
                    (current-buffer))))
    (candidates . (lambda ()
                    (let ((anything-occur-buffer (get-buffer-create "*Anything Occur*")))
                      (with-current-buffer anything-occur-buffer
                        (occur-mode)
                        (erase-buffer)
                        (let ((count (occur-engine anything-pattern
                                                   (list anything-occur-current-buffer) anything-occur-buffer
                                                   list-matching-lines-default-context-lines case-fold-search
                                                   list-matching-lines-buffer-name-face
                                                   nil list-matching-lines-face
                                                   (not (eq occur-excluded-properties t)))))
                          (when (> count 0)
                            (setq next-error-last-buffer anything-occur-buffer)
                            (cdr (split-string (buffer-string) "\n" t))))))))
    (action . (("Goto line" . (lambda (candidate)
                                (with-current-buffer "*Anything Occur*"
                                  (search-forward candidate))
                                (goto-line (string-to-number candidate) anything-occur-current-buffer)))))
    (requires-pattern . 3)
    (volatile)
    (delayed)))


;;; sources
(setq anything-sources
      (append
       '(anything-c-source-files-in-current-dir
         anything-c-source-buffers
         anything-c-source-recentf
         ;; anything-c-source-file-cache
         anything-c-source-mac-spotlight
         ;;anything-c-source-calculation-result
         )
       '(;; lower priority
         anything-c-source-kill-ring
         anything-c-source-occur
         anything-c-source-complex-command-history
         anything-c-source-info-pages
         anything-c-source-man-pages
         ;;anything-c-source-home-directory
         ;;anything-c-source-emacswiki-pages
         )))

(setq anything-type-attributes
      `((buffer
         (action
          ,@(if pop-up-frames
                '(("Switch to buffer other window" . switch-to-buffer-other-window)
                  ("Switch to buffer" . switch-to-buffer))
                '(("Switch to buffer" . switch-to-buffer)
                  ("Switch to buffer other window" . switch-to-buffer-other-window)
                  ("Switch to buffer other frame" . switch-to-buffer-other-frame)))
          ("Display buffer"   . display-buffer)
          ("Revert buffer" . (lambda (elm)
                               (with-current-buffer elm
                                 (when (buffer-modified-p)
                                   (revert-buffer t t)))))
          ("Kill buffer"      . kill-buffer)))
        (file
         (action
          ,@(if pop-up-frames
                '(("Find file other window" . find-file-other-window)
                  ("Find file" . find-file))
                '(("Find file" . find-file)
                  ("Find file other window" . find-file-other-window)
                  ("Find file other frame" . find-file-other-frame)))
          ("Open dired in file's directory" . anything-c-open-dired)
          ("Delete file" . anything-c-delete-file)
          ("Open file externally" . anything-c-open-file-externally)
          ("Open file with default tool" . anything-c-open-file-with-default-tool))
         (action-transformer . (lambda (actions candidate)
                                 (anything-c-compose
                                  (list actions candidate)
                                  '(anything-c-transform-file-load-el
                                    anything-c-transform-file-browse-url))))
         (candidate-transformer . (lambda (candidates)
                                    (anything-c-compose
                                     (list candidates)
                                     '(anything-c-shadow-boring-files
                                       anything-c-shorten-home-path)))))
        (command (action ("Call interactively" . (lambda (command-name)
                                                   (call-interactively (intern command-name))))
                         ("Describe command" . (lambda (command-name)
                                                 (describe-function (intern command-name))))
                         ("Add command to kill ring" . kill-new)
                         ("Go to command's definition" . (lambda (command-name)
                                                           (find-function
                                                            (intern command-name)))))
                 ;; Sort commands according to their usage count.
                 (filtered-candidate-transformer . anything-c-adaptive-sort))
        (function (action ("Describe function" . (lambda (function-name)
                                                   (describe-function (intern function-name))))
                          ("Add function to kill ring" . kill-new)
                          ("Go to function's definition" . (lambda (function-name)
                                                             (find-function
                                                              (intern function-name)))))
                  (action-transformer . (lambda (actions candidate)
                                          (anything-c-compose
                                           (list actions candidate)
                                           '(anything-c-transform-function-call-interactively))))
                  (candidate-transformer . (lambda (candidates)
                                             (anything-c-compose
                                              (list candidates)
                                              '(anything-c-mark-interactive-functions)))))
        (sexp (action ("Eval s-expression" . (lambda (c)
                                               (eval (read c))))
                      ("Add s-expression to kill ring" . kill-new))
              (action-transformer . (lambda (actions candidate)
                                      (anything-c-compose
                                       (list actions candidate)
                                       '(anything-c-transform-sexp-eval-command-sexp)))))
        (bookmark (action ("Jump to bookmark" . (lambda (candidate)
                                                  (bookmark-jump candidate)
                                                  (anything-update)))
                          ("Delete bookmark" . bookmark-delete)
                          ("Rename bookmark" . bookmark-rename)
                          ("Relocate bookmark" . bookmark-relocate)))))


(defface anything-delicious-tag-face '((t (:foreground "VioletRed4" :weight bold)))
  "Face for w3m bookmarks" :group 'anything)

(defface anything-w3m-bookmarks-face '((t (:foreground "cyan1" :underline t)))
  "Face for w3m bookmarks" :group 'anything)

(defface anything-tv-header '((t (:background "#22083397778B" :foreground "white" :underline t)))
  "Face for source header in the anything buffer." :group 'anything)

(setq anything-header-face 'anything-tv-header)

(defface anything-overlay-face '((t (:background "MediumAquamarine" :underline t)))
  "Face for source header in the anything buffer." :group 'anything)

(setq anything-c-traverse-overlay-face 'anything-overlay-face)

(defface anything-dir-heading '((t (:foreground "Blue" :background "Pink")))
  "*Face used for directory headings in dired buffers."
  :group 'anything)

(defface anything-file-name
    '((t (:foreground "Blue")))
  "*Face used for file names (without suffixes) in dired buffers."
  :group 'anything)

(defface anything-dir-priv
    '((t (:foreground "DarkRed" :background "LightGray")))
  "*Face used for directory privilege indicator (d) in dired buffers."
  :group 'anything)


(global-set-key (kbd "C-<f2>") 'anything)

(provide 'as-anything2)
;;; as-anything2.el ends here
