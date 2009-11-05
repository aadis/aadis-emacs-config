;;; as-anything.el --- anything config

;; Copyright (C) 2008  aaditya sood

;; Author: aaditya sood <aaditya@sood.net.in>
;; Keywords: matching, convenience, local

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

;;wait 0.25s before matching
(setq anything-idle-delay 0.25)
(setq anything-input-idle-delay 0.2)

(setq anything-candidate-number-limit 5)
(setq anything-mp-space-regexp "[\\ ] ")

(add-hook 'anything-after-persistent-action-hook 'which-func-update)

(require 'anything-match-plugin)
(require 'anything-complete)
(anything-read-string-mode nil)

(defun anything-c-skip-opened-files (files)
  (set-difference files
                  (mapcan (lambda (file) (list file (abbreviate-file-name file)))
                          (delq nil (mapcar #'buffer-file-name (buffer-list))))
                  :test #'string=))

(add-to-list 'anything-c-source-file-cache '(candidate-transformer . anything-c-skip-opened-files))
(add-to-list 'anything-c-source-file-cache '(requires-pattern))

;; (setq anything-c-boring-file-regexp
;;   (rx (or
;;        ;; Boring directories
;;        (and "/" (or ".svn" "CVS" "_darcs" ".git") (or "/" eol))
;;        ;; Boring files
;;        (and line-start  ".#")
;;        (and (or ".class" ".la" ".o" ".pyc" "~" ".DS_Store") eol))))

;; (defvar anything-c-boring-buffer-regexp
;;   (rx (or 
;;        ;; because of switch commands (@> "switch commands")
;;        "tvprog-keyword.txt" "tvprog.html" ".crontab" "+inbox"
;;        ;; internal use only
;;        "*windows-tab*"
;;        ;; caching purpose
;;        "*refe2x:" "*refe2:" "ri `"
;;        ;; echo area
;;        " *Echo Area" " *Minibuf")))

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

(defvar anything-c-source-colors
  '((name . "Colors")
    (init . (lambda () (unless (anything-candidate-buffer)
                         (save-window-excursion (list-colors-display))
                         (anything-candidate-buffer (get-buffer "*Colors*")))))
    (candidates-in-buffer)
    (get-line . buffer-substring)
    (requires-pattern . 3)
    (candidate-number-limit . 9999)))

(defvar anything-c-source-faces
  '((name . "Faces")
    (init . (lambda () (unless (anything-candidate-buffer)
                         (save-window-excursion (list-faces-display))
                         (anything-candidate-buffer (get-buffer "*Faces*")))))
    (action . (lambda (line)
                (with-new-window
                 (customize-face (intern (car (split-string line)))))))
    (candidates-in-buffer)
    (get-line . buffer-substring)
    (requires-pattern . 3)
    (candidate-number-limit . 9999)))

(defvar anything-type-attribute/command-local
  '((action 
     ("Call interactively" . anything-c-call-interactively-from-string))
    ;; Sort commands according to their usage count.
    (filtered-candidate-transformer . anything-c-adaptive-sort)
    (persistent-action . anything-c-call-interactively-from-string)
    ))

(setq anything-type-attributes
      `((buffer
         (action
          ("Switch to Buffer (next curwin)" . win-switch-to-buffer)
          ("Switch to buffer" . switch-to-buffer)
          ("Switch to buffer other window" . switch-to-buffer-other-window)
          ("Kill buffer"      . kill-buffer)
          ("Switch to buffer other frame" . switch-to-buffer-other-frame)
          ("Display buffer"   . display-buffer))
         (candidate-transformer . (lambda (candidates)
                                    (anything-c-compose
                                     (list candidates)
                                     '(anything-c-skip-boring-buffers
                                       anything-c-skip-current-buffer))))
         (persistent-action . switch-to-buffer))
        (file
         (action
          ("Find file" . find-file)
          ("Find file other window" . find-file-other-window)
          ("Delete File" . anything-c-delete-file)
          ("Find file other frame" . find-file-other-frame)
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
                                     '(anything-c-skip-boring-files
                                       anything-c-shorten-home-path))))
         (persistent-action . find-file))
        (command-ext (action ("Call Interactively (new window)"
                              . (lambda (command-name)
                                  (with-new-window (anything-c-call-interactively-from-string command-name))))
                             ("Call interactively" . anything-c-call-interactively-from-string)
                             ("Describe command" . alcs-describe-function)
                             ("Add command to kill ring" . kill-new)
                             ("Go to command's definition" . alcs-find))
                     ;; Sort commands according to their usage count.
                     (filtered-candidate-transformer . anything-c-adaptive-sort)
                     (persistent-action . anything-c-call-interactively-from-string)
                     )
        (command-local  ,@anything-type-attribute/command-local)
        (command  ,@anything-type-attribute/command-local)
        (function (action ("Describe function" . alcs-describe-function)
                          ("Add function to kill ring" . kill-new)
                          ("Go to function's definition" . alcs-find-function))
                  (action-transformer . (lambda (actions candidate)
                                          (anything-c-compose
                                           (list actions candidate)
                                           '(anything-c-transform-function-call-interactively)))))
        (sexp (action ("Eval s-expression" . (lambda (c)
                                               (eval (read c))))
                      ("Add s-expression to kill ring" . kill-new))
              (action-transformer . (lambda (actions candidate)
                                      (anything-c-compose
                                       (list actions candidate)
                                       '(anything-c-transform-sexp-eval-command-sexp)))))
        (escript (action ("Eval it" . anything-c-action-escript-eval)))
        (line (display-to-real . anything-c-display-to-real-line)
              (action ("Go to Line" . anything-c-action-line-goto)))
        (file-line (display-to-real . anything-c-display-to-real-file-line)
                   (action ("Go to (next curwin)"
                            . (lambda (file-line)
                                (with-new-window (anything-c-action-file-line-goto file-line))))
                           ("Go to" . anything-c-action-file-line-goto))
                   (action-transformer
                    . (lambda (actions sel)
                        (if (anything-attr-defined 'no-new-window)
                            (cdr actions)
                          actions)))
                   (persistent-action . anything-c-action-file-line-goto))
        (apropos-function
         (persistent-action . alcs-describe-function)
         (action
          ("Find Function (next window)"
           . (lambda (f) (with-new-window (alcs-find-function f))))
          ("Find Function" . alcs-find-function)
          ("Describe Function" . alcs-describe-function)
          ))
        (apropos-variable
         (persistent-action . alcs-describe-variable)
         (action
          ("Find Variable (next window)"
           . (lambda (v) (with-new-window (alcs-find-variable v))))
          ("Find Variable" . alcs-find-variable)
          ("Describe Variable" . alcs-describe-variable)))
        (complete-function
         (action . ac-insert)
         (persistent-action . alcs-describe-function))
        (complete-variable
         (action . ac-insert)
         (persistent-action . alcs-describe-variable))
        (complete
         (candidates-in-buffer . ac-candidates-in-buffer)
         (action . ac-insert))
        ,@anything-type-attributes
        ))

;;; sources
(setq anything-sources
      (append
       '(anything-c-source-emacs-variable-at-point
         anything-c-source-emacs-function-at-point
         anything-c-source-files-in-current-dir
         anything-c-source-recentf
         anything-c-source-file-cache
         anything-c-source-buffers
         anything-c-source-mac-spotlight
         ;; anything-c-source-elinit
         anything-c-source-calculation-result
         )
       (anything-sort-sources-by-major-mode
        '(;; major-mode oriented sources
          ;; anything-c-source-refe2x
          ;; anything-c-source-ri
          ;; anything-c-source-find-library
          ;; anything-c-source-rubylib-18
          ;; anything-c-source-rubylib-19
          ;; anything-c-source-call-seq-ruby18
          ;; anything-c-source-call-seq-ruby19
          ;; anything-c-source-ruby18-source
          ;; anything-c-source-ruby19-source
          ;;anything-c-source-apropos-emacs-commands
          ;;anything-c-source-apropos-emacs-functions
          ;;anything-c-source-apropos-emacs-variables
          ;;anything-c-source-mysql-manual
          ))
       '(;; lower priority
         anything-c-source-complex-command-history
         anything-c-source-info-pages
         ;;anything-c-source-man-pages
         ;;anything-c-source-extended-command-history
         anything-c-source-faces
         anything-c-source-colors
         anything-c-source-kill-ring
         ;;anything-c-source-home-directory
         ;; anything-c-source-emacswiki-pages
         )))

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

 
(global-set-key (kbd "H-SPC") 'anything)
(global-set-key (kbd "<C-f1>") 'anything)

(provide 'as-anything)
;;; as-anything.el ends here
