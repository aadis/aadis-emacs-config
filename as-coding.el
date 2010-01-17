;;;_ Coding support stuff

;; Copyright (C) 2008  aaditya sood

;; Author: aaditya sood <aaditya@sood.net.in>

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

;;; Code:

;;;_. compile libs
(require-try 'compile-)
(require-try 'compile)
(require-try 'compile+)

;;;_. regex tools is da bomb
(require-try 'regex-tool)

(require 'comint)

(setq comint-completion-autolist t	;list possibilities on partial completion
      comint-completion-recexact nil	;use shortest compl. if characters cannot be added       
      ;; how many history items are stored in comint-buffers (e.g. py-shell)
      ;; use the HISTSIZE environment variable that shells use (if  avail.)
      ;; (default is 32)
      comint-input-ring-size (string-to-number (or (getenv "HISTSIZE") "100")))

(global-set-key (kbd "C-+") 'toggle-hiding)
(global-set-key (kbd "C-\\") 'toggle-selective-display)

(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)
(add-hook 'python-mode-hook     'hs-minor-mode)
(add-hook 'html-mode-hook       'hs-minor-mode)
(add-hook 'nxhtml-mode-hook     'hs-minor-mode)

;;;_. completion in sql mode
(when (require-try 'sql-completion)
  (setq sql-interactive-mode-hook
	(lambda ()
	  (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
	  (toggle-truncate-lines)
	  (sql-mysql-completion-init))))

(add-hook 'comint-mode-hook
          (lambda ()
            (message "setting my comint keys")
            (define-key comint-mode-map (kbd "M-p") 'comint-previous-matching-input-from-input)
            (define-key comint-mode-map (kbd "M-n") 'comint-next-matching-input-from-input)
            (define-key comint-mode-map (kbd "C-M-n") 'comint-next-input)
            (define-key comint-mode-map (kbd "C-M-p") 'comint-previous-input)
            (define-key comint-mode-map "\C-w" 'comint-kill-region)
            (define-key comint-mode-map [C-S-backspace] 'comint-kill-whole-line)))

;;;_. guess offset for each file
(require-try 'guess-offset)

;;;_. functions to run on compilation buffer
;;; Customize compilation
(defun compile-check-delete (buf str)
  (interactive)
  (if (and (string= str "finished\n") (string= (buffer-name buf) "*compilation*"))
      (progn
        (message "Compilation Finished Successfully")
        (delete-other-windows))))

;;longlines is especially useful for compilation buffers with long error strings
;;add to compilation-finish-functions if needed
(defun as/compilation-long-lines (buf msg)
  "set longlines mode for *compilation* buffer, and wrap lines for use with ecb"
  (interactive)
  (save-excursion
    (set-buffer buf)
    (set (make-local-variable 'longlines-auto-wrap) t)
    (longlines-mode t)))

(defun as/clean-java-compile-buffer (buf msg)
  "replace fully qualified class names with just the class name"
  (interactive)
  (if (and (string= msg "finished\n") (string= (buffer-name buf) "*compilation*"))
      (let ((regexp "\\([a-z0-9_]+\\.\\)\\{2,\\}")
            (case-fold-search nil))
        (save-excursion
          (set-buffer buf)
          (setq buffer-read-only nil)
          (goto-char (point-min)) 
          (while (re-search-forward regexp nil t)
            (replace-match " " nil nil))))))

;;;uncomment if needed
(setq compilation-finish-functions '(compile-check-delete))

;;;_. I like using dwim without transient-mark-mode
(defun as/comment-dwim (arg)
  "Wrap comment-dwim without using transient-mark-mode"
  (interactive "*P")
  (let ((transient-mark-mode t))
    (comment-dwim arg)))

(global-set-key (kbd "M-;") 'as/comment-dwim)
(global-set-key "\M-j" 'pop-to-mark-command)
(global-set-key "\C-z" 'multi-occur)

(global-set-key (kbd "RET") 'newline-and-indent)

;;;_. lets use paredit for lispy stuff
(when (require-try 'paredit)
  (autoload 'paredit-mode "paredit" 
    "Minor mode for pseudo-structurally editing Lisp code." t)

  (add-hook 'emacs-lisp-mode-hook (lambda () (paredit-mode +1))))

(add-hook 'css-mode-hook (lambda () (css-color-mode t)))

(setq as/open-file-list '("/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/lib/*.py"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/config/*.py"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/public/js/*.js"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/public/css/*.css"
                          "/Users/aaditya/src/id/proto/src/id/db/schema.py"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/*.mako"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/creds/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/group/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/group/*.mako"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/instance/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/entity/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/entity/*.mako"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/login/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/machine/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/reports/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/reports/*.mako"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/root/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/run/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/task/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/task/*.mako"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/template/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/user/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/workflow/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/templates/*.html"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/controllers/wizard/*.py"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/controllers/wizard/create/*.py"
                          "/Users/aaditya/src/id/proto/src/id/vaitarna/vaitarna/controllers/*.py"
                          ))


(defun as/open-proj-files ()
  (interactive)
  (let ((default-dir "/Users/aaditya/src/id/proto/")
        (find-file-wildcards t))
    (setq auto-mode-alist (cons '("\\.mako$" . mako-nxhtml-mumamo-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.html$" . mako-nxhtml-mumamo-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.mako\\'$" . mako-nxhtml-mumamo-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.js$" . js2-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.js\\'$" . js2-mode) auto-mode-alist))
    (map 'list (lambda (f) (find-file f t)) as/open-file-list)
    ))

;;;_. python stuff
(require-try 'as-python)

(defvar smart-tab-completion-functions 
  '((emacs-lisp-mode lisp-complete-symbol) 
    (lisp-mode slime-complete-symbol) 
    (python-mode py-complete) 
    (sql-interactive-mode comint-dynamic-complete)
    (text-mode dabbrev-completion)) 
  "List of major modes in which to use a mode specific completion 
  function.")

(defun get-completion-function() 
  "Get a completion function according to current major mode." 
  (let ((completion-function 
         (second (assq major-mode smart-tab-completion-functions)))) 
    (if (null completion-function) 
        'dabbrev-completion 
      completion-function))) 

(defun smart-tab-must-expand (&optional prefix)
  "If PREFIX is \\[universal-argument], answers no.
Otherwise, analyses point position and answers."
  (unless (or (consp prefix)
              mark-active)
    (looking-at "\\_>")))

(defun smart-indent ()
  "Indents region if mark is active, or current line otherwise."
  (interactive)
  (if mark-active
      (indent-region (region-beginning)
                     (region-end))
    (indent-for-tab-command)))

(defun smart-tab (prefix) 
  "Needs `transient-mark-mode' to be on. This smart tab is
  minibuffer compliant: it acts as usual in the minibuffer.
 
In all other buffers: if PREFIX is \\[universal-argument], calls
`smart-indent'. Else if point is at the end of a symbol, expands
it. Else calls `smart-indent'."
  (interactive "P")
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (smart-tab-must-expand prefix) t)
        (let ((dabbrev-case-fold-search t)
              (dabbrev-case-replace nil))
          (funcall (get-completion-function))))
    (smart-indent)))

(provide 'as-coding)
