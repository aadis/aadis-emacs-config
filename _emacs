;;;_ my main .emacs config file
;;for Emacs22.1 on OS X. 
;;Released under the GPL

;;;_. never recompile .emacs by hand
(defun autocompile nil
  "compile itself if ~/.emacs"
  (interactive)
  (require 'bytecomp)
  (if (string= (buffer-file-name) (expand-file-name (concat default-directory ".emacs")))
      (byte-compile-file (buffer-file-name))))
(add-hook 'after-save-hook 'autocompile)

;;;_. turn off tool-bar asap
;; (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'tool-bar-mode) 
  (tool-bar-mode -1))
(transient-mark-mode -1)

(setq frame-title-format '(:eval (if (buffer-file-name) (replace-regexp-in-string (getenv "HOME") "~" (buffer-file-name))  "%b")))

;; (add-hook 'window-configuration-change-hook
;; 	  (lambda ()
;;         (setq frame-title-format (replace-regexp-in-string (concat "/Users/" user-login-name) "~" (or buffer-file-name "%b")))))

;;;_. require-try needs to come first
;; avoids having to modify this file when i use emacs somewhere where i don't
;; have particular extensions
(defun require-try (&rest args)
  "require symbols, load-library strings, fail silently if some aren't
   available"
  (let (lib)
    (condition-case err
        (mapc (lambda (e)
                (setq lib e)
                (cond
                 ((stringp e) (load-library e))
                 ((symbolp e) (require e)))) args)
      (file-error
       (progn (message "Couldn't load extension: %s: %S" lib err) nil)))))

;;;_. my personal elisp stuff live here
(add-to-list 'load-path (expand-file-name "~/src/emacs"))


;;;_. my elisp libraries live here
(add-to-list 'load-path (expand-file-name "~/src/emacs/libs"))
(add-to-list 'load-path (expand-file-name "~/src/emacs/libs/python-mode"))
(add-to-list 'load-path (expand-file-name "~/src/emacs/libs/magit"))
(add-to-list 'load-path (expand-file-name "~/src/emacs/libs/w3m"))
;;(add-to-list 'load-path (expand-file-name "~/src/emacs/libs/color-theme"))
(add-to-list 'load-path (expand-file-name "~/src/emacs/libs/elib"))
(add-to-list 'load-path (expand-file-name "~/src/emacs/libs/org-6.28e/lisp"))
(add-to-list 'load-path (expand-file-name "~/src/emacs/libs/yasnippet-0.5.10"))
;;(add-to-list 'load-path (expand-file-name "~/src/emacs/libs/nxhtml/util/company-mode"))
;;(add-to-list 'load-path (expand-file-name "~/src/emacs/libs/auctex"))

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

(message "Loading Custom")

;;;_. my own custom file
(when (file-exists-p "~/src/emacs/as-custom.el")
  (setq custom-file "~/src/emacs/as-custom.el")
  (load custom-file)
)
;;;_. Load my elisp settings

;;load session first so other things can override it
;; (when (require-try 'session) 
;;   (session-initialize))

;;require my wombat theme
;;(require-try 'color-theme-wombat)

;;mac specific thingies
(require-try 'as-mac)

;;generic packages I use
(require-try 'as-packages)

;;ui changes: keybindings et al
(require-try 'as-ui)

;;coding related support
(require-try 'as-coding)


;;sql stuff
(require-try 'as-sql)

;;javascript stuff
(require-try 'as-js)

;;html suff
(require-try 'as-html)

;;mako templates
;;(require-try 'as-mako)

;;anything is kickass: quicksilver for emacs
(require-try 'as-anything2)

;;my org mode setup
(require-try 'as-org)

;;reset font if possible
(if (fboundp 'as/set-frame-sane)
    (as/set-frame-sane))

(transient-mark-mode -1)

(if window-system
    (require-try 'w3m-load))

(message "All Korrect!")


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
