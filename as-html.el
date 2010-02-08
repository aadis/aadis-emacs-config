
;;html coding stuff

;;(autoload #'espresso-mode "espresso" "Start espresso-mode" t)

;;nxhtml is kickass
(when (file-exists-p "~/src/emacs/libs/nxhtml/autostart.el") 
  (load "~/src/emacs/libs/nxhtml/autostart"))

(add-to-list 'auto-mode-alist '("\\.mako\\'" . nxhtml-mode))
;;(add-to-list 'auto-mode-alist '("\\.html\\'" . mako-html-mumamo-mode))

(provide 'as-html)
