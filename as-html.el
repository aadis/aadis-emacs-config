
;;html coding stuff

;;nxhtml is kickass
(when (file-exists-p "~/src/emacs/libs/nxhtml/autostart.el") 
  (load "~/src/emacs/libs/nxhtml/autostart"))

(add-to-list 'auto-mode-alist '("\\.mako\\'" . mako-nxhtml-mumamo-mode))

(when (fboundp 'js2-mode)
  (setq auto-mode-alist (cons '("\\.js$" . js2-mode) auto-mode-alist))
  (setq auto-mode-alist (cons '("\\.js\\'$" . js2-mode) auto-mode-alist)))

(provide 'as-html)
