;;;_ things to change the emacs ui
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


;;;_ better file diff
(defun diff-buffer-with-associated-file ()
  "View the differences between BUFFER and its associated file.
This requires the external program \"diff\" to be in your `exec-path'. 
Returns nil if no differences found, 't otherwise."
  (interactive)
  (let ((buf-filename buffer-file-name)
        (buffer (current-buffer)))
    (unless buf-filename
      (error "Buffer %s has no associated file" buffer))
    (let ((diff-buf (get-buffer-create
                     (concat "*Assoc file diff: "
                             (buffer-name)
                             "*"))))
      (with-current-buffer diff-buf
        (setq buffer-read-only nil)
        (erase-buffer))
      (let ((tempfile (make-temp-file "buffer-to-file-diff-")))
        (unwind-protect
            (progn
              (print (append
                        (when (and (boundp 'ediff-custom-diff-options)
                                   (stringp ediff-custom-diff-options))
                          (list ediff-custom-diff-options))
                        (list buf-filename tempfile)) t)
              (with-current-buffer buffer
                (write-region (point-min) (point-max) tempfile nil 'nomessage))
              (if (zerop
                   (apply #'call-process "diff" nil diff-buf nil
                          (append
                           (when (and (boundp 'ediff-custom-diff-options)
                                      (stringp ediff-custom-diff-options))
                             (list ediff-custom-diff-options))
                           (list buf-filename tempfile))))
                  (progn
                    (message "No differences found")
                    nil)
                (progn
                  (with-current-buffer diff-buf
                    (goto-char (point-min))
                    (if (fboundp 'diff-mode)
                        (diff-mode)
                      (fundamental-mode)))
                  (display-buffer diff-buf)
                  t)))
          (when (file-exists-p tempfile)
            (delete-file tempfile)))))))

;;;_. diff buffer with current file
(global-set-key (kbd "C-c d") '(lambda () (interactive) (diff-buffer-with-associated-file)))

;;;_. check for unsaved changes for killing
(defun as/context-kill (arg)
  "Kill buffer, taking gnuclient into account."
  (interactive "p")
  (when (and (buffer-modified-p)
	    buffer-file-name
	    (not (string-match "\\*.*\\*" (buffer-name)))
	    ;; erc buffers will be automatically saved
	    (not (eq major-mode 'erc-mode))
	    (= 1 arg))
   (let ((differences 't))
   (when (file-exists-p buffer-file-name)
     (setq differences (diff-buffer-with-associated-file)))
   (let ((debug-on-error nil))
       (error (if differences 
		  "Buffer has unsaved changes"
		"Buffer has unsaved changes, but no differences wrt. the file")))))
  (if (and (boundp 'gnuserv-minor-mode)
	    gnuserv-minor-mode)
     (gnuserv-edit)
   (set-buffer-modified-p nil)
   (kill-buffer (current-buffer)))) 
(global-set-key (kbd "C-x k") 'as/context-kill)

;;; tidy up diffs when closing the file
(defun kill-associated-diff-buf ()
  (let ((buf (get-buffer (concat "*Assoc file diff: "
			    (buffer-name)
 			    "*"))))
   (when (bufferp buf)
     (kill-buffer buf))))

(add-hook 'kill-buffer-hook 'kill-associated-diff-buf) 

;;;_. diff auto-refine minor mode
(define-minor-mode diff-auto-refine
  "Automatically highlight changes in detail as the user visits hunks"
  :group 'diff-mode :init-value nil :lighter " Auto-Refine"
  (when diff-auto-refine
    (condition-case-no-debug nil (diff-refine-hunk) (error nil))))

;;;_. Misc settings
;;update time stamps when saving files
(add-hook 'write-file-hooks 'time-stamp)

;; make scripts executable
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;;don't stop on finding an error
(setq debug-on-error nil)

;;enable useful commands
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'erase-buffer 'disabled nil)

;;useless mode
(put 'overwrite-mode 'disabled t)

;;do not beep!
(setq visible-bell t)

;;faster M-x 
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;;preserve ownership of files
(setq backup-by-copying-when-mismatch t)

;; I want unicode!
(setq default-buffer-file-coding-system 'utf-8)

;;i hate the blinking cursor
(setq blink-cursor-mode nil)

;;do things in text mode
(setq text-mode-hook 'turn-on-auto-fill)
(setq default-major-mode 'text-mode)

;;auto-insert-mode is useful
(auto-insert-mode t)

;; Always indent using spaces, never tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;;don’t echo passwords when communicating with interactive programs
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;;let longlines show breaks
(setq longlines-show-effect (propertize "¶\n" 'face 'escape-glyph))

;;really really get rid of the bell
(defun as/dont-ring-bell ()
  "don't do anything"
  )
(setq ring-bell-function 'as/dont-ring-bell)

;;do not iconify
(when window-system
  (global-unset-key "\C-z"))

;;let me do damage with a single keystroke!
(fset 'yes-or-no-p 'y-or-n-p)

;;use dired-x
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")))          ; This also sets `N' to read man pages.

;;click on URLs in manual pages
(add-hook 'Man-mode-hook 'goto-address)

;;i prefer zap-up-to-char
(when (require-try 'misc)
  (global-set-key (kbd "M-z") 'zap-up-to-char))

;;use bar cursor for all frames
(setq initial-frame-alist
      (cons '(cursor-type . bar)
            (copy-alist initial-frame-alist)))
(setq default-frame-alist
      (cons '(cursor-type . bar)
            (copy-alist default-frame-alist)))

;;use auto compression
(auto-compression-mode 1)

;;use yasnippet with hippie expand
(require 'cl)
(require 'hippie-exp)

(setq hippie-expand-try-functions-list
      '(yas/hippie-try-expand
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name
        try-complete-lisp-symbol))

;;eeg is pretty funky for git
;;(require 'egg)
(require 'magit)

(add-to-list 'load-path "~/src/emacs/libs/mo-git-blame")
(autoload 'mo-git-blame-file "mo-git-blame" nil t)
(autoload 'mo-git-blame-current "mo-git-blame" nil t)


;;use eproject for opening related files
;; (require 'eproject)

;; (define-project-type pylons (generic)
;;   (look-for "development.ini")
;;   :relevant-files ("\\.py$" "\\.html$" "\\.mako$" "\\.js$" "\\.css"))


;;don't use auto-fill inside minibuffer
(add-hook 'minibuffer-setup-hook 
          (lambda () (interactive) (auto-fill-mode -1)))

;; temp buffers resize to their text size
(when (fboundp 'temp-buffer-resize-mode)
  (temp-buffer-resize-mode t))

;;;_. ediff
;;reuse the selected frame
;;(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;;use horizontally split
(setq ediff-split-window-function 'split-window-horizontally)

;;;_. file-cache convenience functions
;;;filecache makes looksups very fast
(defun file-cache-save-cache-to-file (file)
  "Save contents of `file-cache-alist' to FILE.
For later retrieval using `file-cache-read-cache-from-file'"
  (interactive "FFile: ")
  (with-temp-file (expand-file-name file)
    (prin1 file-cache-alist (current-buffer))))

(defun file-cache-read-cache-from-file (file)
  "Clear `file-cache-alist' and read cache from FILE.
The file cache can be saved to a file using
`file-cache-save-cache-to-file'."
  (interactive "fFile: ")
  (file-cache-clear-cache)
  (let ((buf (find-file-noselect file)))
    (setq file-cache-alist (read buf))
    (kill-buffer buf)))

(defun as/save-merge-filecache ()
  "save the file cache for merge tree"
  (interactive)
  (file-cache-save-cache-to-file "~/.emacs.d/merge.filecache"))

(defun as/read-merge-filecache ()
  "save the file cache for merge tree"
  (interactive)
  (file-cache-read-cache-from-file "~/.emacs.d/merge.filecache"))

(require 'filecache)

(when (file-exists-p "~/.emacs.d/merge.filecache")
  (as/read-merge-filecache))

;; Use regex searches by default.
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-\M-s" 'isearch-forward)
(global-set-key "\C-\M-r" 'isearch-backward)
 
;; File finding
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)

(when (fboundp 'magit-status) (global-set-key (kbd "C-x g") 'magit-status))

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))

;; Align your code in a pretty way.
(global-set-key (kbd "C-x \\") 'align-regexp)

;; Jump to a definition in the current file. (This is awesome.)
(defun ido-goto-symbol ()
  "Update the imenu index and then use ido to select a symbol to navigate to."
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols (symbol-list)
                       (when (listp symbol-list)
                         (dolist (symbol symbol-list)
                           (let ((name nil) (position nil))
                             (cond
                              ((and (listp symbol) (imenu--subalist-p symbol))
                               (addsymbols symbol))
                              
                              ((listp symbol)
                               (setq name (car symbol))
                               (setq position (cdr symbol)))
                              
                              ((stringp symbol)
                               (setq name symbol)
                               (setq position (get-text-property 1 'org-imenu-marker symbol))))
                             
                             (unless (or (null position) (null name))
                               (add-to-list 'symbol-names name)
                               (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    (let* ((selected-symbol (ido-completing-read "Symbol? " symbol-names))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (goto-char position))))
(global-set-key "\C-x\C-i" 'ido-goto-symbol)

;; ;;need elscreen
;; (add-to-list 'load-path (expand-file-name "~/src/local/emacs/apel-10.7"))
;; (when (require-try 'elscreen)
;;   (global-set-key (kbd "<C-tab>") 'elscreen-toggle)
;;   (global-set-key (kbd "C-z C-z") 'elscreen-toggle)
;;   (global-set-key [(control shift right)] 'elscreen-next)
;;   (global-set-key [(control shift left)] 'elscreen-previous)
;;   (require-try 'elscreen-color-theme))

;;(require-try 'tabbar)

;;(require-try 'as-color-theme)
;;(when (require-try 'as-color-theme)
;;  (color-theme-inkpot))

;; (when (require-try 'color-theme)
;;   (color-theme-initialize)
;;   (color-theme-high-contrast))

(global-set-key (kbd "M-+") 'text-scale-adjust)
(global-set-key (kbd "M--") 'text-scale-adjust)
(global-set-key (kbd "M-0") 'text-scale-adjust)

;; (require 'browse-kill-ring)
;; (global-set-key (kbd "C-c k") 'browse-kill-ring)
;; (browse-kill-ring-default-keybindings)

(defun toggle-current-window-dedication ()
 (interactive)
 (let* ((window    (selected-window))
        (dedicated (window-dedicated-p window)))
   (set-window-dedicated-p window (not dedicated))
   (message "Window %sdedicated to %s"
            (if dedicated "no longer " "")
            (buffer-name))))
(global-set-key (kbd "<f6>") 'toggle-current-window-dedication)

;;window configs are pretty important
(winner-mode t)

(font-lock-add-keywords 'emacs-lisp-mode
      '(("(\\|)" . 'paren-face)))
 
(font-lock-add-keywords 'scheme-mode
      '(("(\\|)" . 'paren-face)))

(defface paren-face
   '((((class color) (background dark))
      (:foreground "grey60"))
     (((class color) (background light))
      (:foreground "grey15")))
   "Face used to dim parentheses."
   :group 'starter-kit-faces)
;;;_. end

(setq show-paren-match '((:background "gray5" :slant normal)))

(defface
  show-paren-match 
  '((:background "gray5" :slant normal))
  "Face used for parent matching"
  :group 'starter-kit-frame)

(require 'ibuffer)
(setq ibuffer-default-sorting-mode 'major-mode)
(setq ibuffer-always-show-last-buffer t)
(setq ibuffer-view-ibuffer t)
(global-set-key  (kbd "C-x C-b") 'ibuffer-other-window)

;;try out company for a few days
(setq company-begin-commands '(self-insert-command))
(setq company-idle-delay 0.2)

(autoload 'company-mode "company" nil t)

;;our sql completion
(require 'as-sql-company)

(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)

(setq-default ac-sources '(ac-source-words-in-same-mode-buffers))
(add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols)))
(add-hook 'auto-complete-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-filename)))
(global-auto-complete-mode t)
(set-face-background 'ac-candidate-face "lightgray")
(set-face-underline 'ac-candidate-face "darkgray")
(set-face-background 'ac-selection-face "steelblue")
(define-key ac-completing-map "\M-n" 'ac-next)
(define-key ac-completing-map "\M-p" 'ac-previous)
(setq ac-auto-start 2)
(setq ac-dwim t)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

(require 'ac-anything)
(define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-anything)

(provide 'as-ui)

