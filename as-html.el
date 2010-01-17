
;;html coding stuff

(autoload #'espresso-mode "espresso" "Start espresso-mode" t)

;;nxhtml is kickass
(when (file-exists-p "~/src/emacs/libs/nxhtml/autostart.el") 
  (load "~/src/emacs/libs/nxhtml/autostart")
  (require 'company-nxml)
  (require 'company-css)
  (require 'company-keywords))

(add-to-list 'auto-mode-alist '("\\.mako\\'" . mako-nxhtml-mumamo-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . mako-html-mumamo-mode))

(when (fboundp 'js2-mode)
  (setq auto-mode-alist (cons '("\\.js$" . js2-mode) auto-mode-alist))
  (setq auto-mode-alist (cons '("\\.js\\'$" . js2-mode) auto-mode-alist)))

(provide 'as-html)
