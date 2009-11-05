;;Custom file for me
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


;; Always indent using spaces, never tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;;use recursive edits: useful
(setq 
 case-fold-search t
 comint-completion-autolist t
 comint-input-ignoredups t
   comint-prompt-read-only t
   compilation-context-lines 3
   compilation-scroll-output t
   compilation-skip-threshold 1
   compilation-skip-visited t
   completion-ignored-extensions (quote (".svn/" "CVS/" ".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".dvi" ".fmt" ".tfm" ".pdf" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".fasl" ".ufsl" ".fsl" ".dxl" ".pfsl" ".dfsl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo" ".class"))
   eshell-save-history-on-exit t
   file-cache-completion-ignore-case t
   file-cache-filter-regexps (quote ("~$" "\\.o$" "\\.exe$" "\\.a$" "\\.elc$" ",v$" "\\.output$" "\\.$" "#$" "\\.class$" "\\.svn-base$" "\\.svn" "\\.jar$" "\\.git$" ))
   file-cache-ignore-case t
   generic-extras-enable-list (quote (alias-generic-mode apache-conf-generic-mode apache-log-generic-mode bat-generic-mode etc-fstab-generic-mode etc-modules-conf-generic-mode etc-passwd-generic-mode etc-services-generic-mode fvwm-generic-mode hosts-generic-mode inetd-conf-generic-mode ini-generic-mode java-manifest-generic-mode java-properties-generic-mode javascript-generic-mode mailagent-rules-generic-mode mailrc-generic-mode named-boot-generic-mode named-database-generic-mode prototype-generic-mode rc-generic-mode resolve-conf-generic-mode samba-generic-mode show-tabs-generic-mode vrml-generic-mode x-resource-generic-mode))
   comment-multi-line t
   completion-ignore-case t          ;Do case-insensitive completion.
   enable-recursive-minibuffers t    ;Allow recursion using minibuf.
   inhibit-startup-message t         ;I've read it already.
   require-final-newline t           ;Always append a newline.
   scroll-step 1
   tab-stop-list '(4 8 12 16 20 24 28 32 36)
   auto-save-directory-fallback "~/.saves"
   backup-by-copying t                          ; don't clobber symlinks
   backup-directory-alist '(("." . "~/.saves")) ; don't litter my fs tree
   column-number-mode t              ; show columns, not just lines
   max-lisp-eval-depth 1000
   max-specpdl-size 2000
   next-error-highlight 3
   next-error-highlight-no-select t
   nxml-slash-auto-complete-flag t
   paren-sexp-mode t
   partial-completion-mode t
   read-file-name-completion-ignore-case t
   recentf-exclude (quote (".semantic.cache"))
   recentf-max-menu-items 15
   recentf-max-saved-items 30
   save-place t
   scroll-conservatively 10000
   scroll-preserve-screen-position t
   semanticdb-global-mode t
   show-paren-style (quote expression)
   size-indication-mode t
   sql-electric-stuff (quote semicolon)
   sql-input-ring-file-name "~/.mysql.history"
   sql-password "appszen"
   sql-pop-to-buffer-after-send-region t
   sql-product (quote mysql)
   sql-user "appszen"
   truncate-partial-width-windows nil
   )



(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(color-theme-legal-frame-parameters "\\(color\\|mode\\|font\\)$")
 '(column-number-mode t)
 '(comint-move-point-for-output (quote all))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-source-path (quote (("/Users/aaditya/src/id/proto/src" "proto-src") ("/Users/aaditya/src/id/proto/src/id/vaitarna" "proto-vaitarna") ("/Users/aaditya/src/id/proto/bin" "proto-bin"))))
 '(espresso-enabled-frameworks (quote (javascript mochikit prototype dojo extjs merrillpress)))
 '(filesets-data (quote (("py-files" (:tree "~/src/id/proto/src/id/vaitarna" "^.+\\.py$")) ("js-files" (:tree "~/src/id/proto/src/id/vaitarna/vaitarna/public/js" "^.+\\.js$")) ("css-files" (:tree "~/src/id/proto/src/id/vaitarna/vaitarna/public/css" "^.+\\.css$")) ("templates" (:tree "~/src/id/proto/src/id/vaitarna/vaitarna/templates" "^.+\\.suffix$")))))
 '(flymake-log-level 0)
 '(frame-background-mode (quote light))
 '(gdb-many-windows t)
 '(ido-default-buffer-method (quote selected-window))
 '(ido-default-file-method (quote selected-window))
 '(ido-enable-prefix nil)
 '(ido-enable-regexp t)
 '(ido-enable-tramp-completion nil)
 '(ido-file-extensions-order (quote (".py .js .mako .css .html")))
 '(ido-ignore-directories (quote ("\\`CVS/" "\\`\\.\\./" "\\`\\./" "\\`/sudo:")))
 '(ido-max-window-height 3)
 '(ido-rotate-file-list-default t)
 '(ido-separator " | ")
 '(ido-show-dot-for-dired nil)
 '(js2-basic-offset 4)
 '(js2-highlight-level 3)
 '(js2-indent-on-enter-key t)
 '(mlinks-active-links nil)
 '(mlinks-link nil)
 '(mumamo-set-major-mode-delay 0.7)
 '(ns-extended-platform-support-mode t)
 '(nxhtml-default-encoding (quote utf-8))
 '(nxhtml-global-minor-mode nil)
 '(nxhtml-skip-welcome t)
 '(nxml-bind-meta-tab-to-complete-flag t)
 '(nxml-slash-auto-complete-flag t t)
 '(ropemacs-guess-project t)
 '(semanticdb-project-roots (quote ("~/src/id/proto/src/id/vaitarna" "~/src/id/proto/src" "~/src/id/proto/bin" "~/src/id/proto/")))
 '(set-mark-command-repeat-pop t)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(sql-electric-stuff (quote semicolon) t)
 '(tramp-auto-save-directory "~/.saves/tramp")
 '(tramp-default-method "rsync")
 '(transient-mark-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "red" :foreground "red"))))
 '(font-lock-comment-face ((t (:foreground "Firebrick" :slant italic :weight light :height 0.9 :family "Lucida Grande"))))
 '(mlinks-link ((t nil)))
 '(mumamo-border-face ((t (:slant italic :weight bold))))
 '(org-done ((t (:foreground "ForestGreen" :strike-through "black" :weight bold))))
 '(show-paren-match ((t (:background "gray87" :slant normal))))
 '(visible-mark-face ((t (:overline "yellow" :underline "yellow"))))
 '(which-func ((((class color) (min-colors 88) (background dark)) (:foreground "green")))))
