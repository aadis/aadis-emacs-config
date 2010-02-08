
(require-try 'js2-mode)
;;other modes set it in the beginning, take them out

;;this is for mozrepl
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)

(defun mozrepl-custom-setup ()
  (moz-minor-mode 1))

;;patch mozrepl into js2-mode
(add-hook 'js2-mode-hook 'mozrepl-custom-setup)

;;live update html in Firefox from buffer
(require 'moz)
(require 'json)
 
(defun moz-update (&rest ignored)
  "Update the remote mozrepl instance"
  (interactive)
  (comint-send-string (inferior-moz-process)
    (concat "content.document.body.innerHTML="
             (json-encode (buffer-string)) ";")))
 
(defun moz-enable-auto-update ()
  "Automatically the remote mozrepl when this buffer changes"
  (interactive)
  (add-hook 'after-change-functions 'moz-update t t))
 
(defun moz-disable-auto-update ()
  "Disable automatic mozrepl updates"
  (interactive)
  (remove-hook 'after-change-functions 'moz-update t))

(setq auto-mode-alist (remove-file-name-assocs "\\.js\\'"))
(add-to-list 'auto-mode-alist  '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist  '("\\.js\\'" . js2-mode))

;;; Used to work for firefox upto 3.0 Stopped with 3.5
(global-set-key (kbd "C-x p")
                (lambda ()
                  (interactive)
                  (comint-send-string (inferior-moz-process)
                                      "gBrowser.selectedBrowser.reloadWithFlags(gBrowser.selectedBrowser.webNavigation.LOAD_FLAGS_BYPASS_CACHE);")))
(global-set-key (kbd "C-c r")
                (lambda ()
                  (interactive)
                  (comint-send-string (inferior-moz-process)
                                      "repl.home = function() { return this.enter(content.wrappedJSObject); };")))

(setq mozrepl-enter-content "repl.enter(content.wrappedJSObject)")

(provide 'as-js)
