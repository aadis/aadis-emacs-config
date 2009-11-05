;;;_ emacs packages to be loaded
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


;;;_. ido mode
;;ido is the kitchen sink of selecting things (buffers, files,...)
(when (require-try 'ido)
  (ido-mode 1)
  (setq ido-enable-flex-matching t))

;;(setq read-buffer-function 'ido-read-buffer)
(add-hook 'ido-make-buffer-list-hook 'ido-summary-buffers-to-end)

(add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
(add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)
(defun ido-sort-mtime ()
  (setq ido-temp-list
        (sort ido-temp-list 
              (lambda (a b)
                (let ((ta (nth 5 (file-attributes (concat ido-current-directory a))))
                      (tb (nth 5 (file-attributes (concat ido-current-directory b)))))
                  (if (= (nth 0 ta) (nth 0 tb))
                      (> (nth 1 ta) (nth 1 tb))
                    (> (nth 0 ta) (nth 0 tb)))))))
  (ido-to-end  ;; move . files to end (again)
   (delq nil (mapcar
              (lambda (x) (if (and (not (string-equal x ".")) (string-equal (substring x 0 1) ".")) x))
              ido-temp-list))))

;;auto revert all files
(global-auto-revert-mode t)

;;(require 'midnight)

(setq-default yas/trigger-key (kbd "<C-tab>"))
(setq yas/trigger-key (kbd "<C-tab>"))
(setq-default yas/next-field-key (kbd "<tab>"))
(setq yas/next-field-key (kbd "<tab>"))
(require 'dropdown-list)
(setq yas/text-popup-function
      #'yas/dropdown-list-popup-for-template)
(setq yas/window-system-popup-function
      #'yas/dropdown-list-popup-for-template)

;;yasnippet requires cl
(require 'cl) 

;;(require 'yasnippet)
;;(yas/initialize)
;;(yas/load-directory "~/src/emacs/libs/yas-snippets/yasnippet-0.5.6")

;;(setq yas/text-popup-function
;;      #'yas/dropdown-list-popup-for-template)
;;(setq yas/window-system-popup-function
;;      #'yas/dropdown-list-popup-for-template)

;;;_. windmove
;;use Shift+arrow keys to move between windows
(setq windmove-wrap-around t)
(when (require-try 'windmove) 
  (windmove-default-keybindings))

;; (when (require 'recentf)
;;   (recentf-mode t))

;;;_. uniquify helps in same file names
(require 'uniquify)
(setq-default uniquify-buffer-name-style 'forward)

;;;_. generic-x has more modes
(require-try 'generic-x)

;;;_. visible mark mode
(when (require-try 'visible-mark)
  (global-visible-mark-mode 1))

;; (when (require-try 'mic-paren)
;;   (paren-activate))

;;;_. dabbrev expand
;; (when (require-try 'dabbrev-expand-multiple)
;;   (setq dabbrev-expand-multiple-select-keys '("a" "s" "d" "f" "g"))
;;   (global-set-key "\M-/" 'dabbrev-expand-multiple))

;; (when (require-try 'nav)
;;   (global-set-key (kbd "<f5>") 'nav))

;; ;;;_. ledger
;; (when (require-try 'ledger)
;;   ;; use my own indentation
;;   (setq ledger-enforce-indentation t)

;;   (defun ledger ()
;;     "A quick shortcut to `find-file' the default ledger file"
;;     (interactive)
;;     (let ( (l "~/Documents/finance/mine.dat") )
;;       (if l
;; 	  (find-file l)
;; 	(error "Environment variable LEDGER_FILE is not defined")))))

;; (require-try 'ledger-indent)


(provide 'as-packages)
