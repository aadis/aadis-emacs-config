;;anything config


(require 'anything-config)
(require-try 'anything-match-plugin)
(require 'anything-complete)
(require 'anything-traverse)

;;new sources 

(defvar anything-bookmark-regions-alist nil)
(defvar anything-c-source-bookmark-regions
  '((name . "Bookmark Regions")
    (init . (lambda ()
              (condition-case nil
              (setq anything-bookmark-regions-alist
                    (bookmark-region-alist-only))
                (error nil))))
    (candidates . anything-c-bookmark-region-setup-alist)
    (action . (("Goto Bookmark" . (lambda (elm)
                                    (let ((bmk (car (split-string elm " => "))))
                                      (bookmark-jump bmk))))))))

(defun anything-c-bookmark-region-setup-alist ()
  (loop for i in anything-bookmark-regions-alist
     for b = (car i)
     collect (concat
                 b
                 " => "
                 (bookmark-get-buffer-name b))))

;;sources list
(setq anything-sources
      (list anything-c-source-buffers+
            anything-c-source-bookmarks-local
            anything-c-source-bookmarks-su
            anything-c-source-bookmarks-ssh
            ;;anything-c-source-eev-anchor
            ;anything-c-source-qapplied-patchs
            ;anything-c-source-qunapplied-patchs
            anything-c-source-files-in-current-dir+
            anything-c-source-recentf
            anything-c-source-info-pages
            ;;anything-c-source-info-cl
            ;;anything-c-source-info-elisp
            anything-c-source-man-pages
            anything-c-source-mac-spotlight
            ;;anything-c-source-locate
            anything-c-source-emacs-commands
            ;anything-c-source-emacs-functions-with-abbrevs
            anything-c-source-imenu
            anything-c-source-org-headline
            ;;anything-c-source-semantic
            ;anything-c-source-complex-command-history
            ;;anything-c-source-bbdb
            anything-c-source-calculation-result
            anything-c-source-emacs-process
            ;anything-c-source-faces
            anything-c-source-customize-face
            anything-c-source-colors
            anything-c-source-kill-ring
            anything-c-source-global-mark-ring
            anything-c-source-mark-ring
            anything-c-source-register
            anything-c-source-bookmark-regions
            anything-c-source-traverse-occur
))




;; key bindings 

(global-set-key (kbd "C-M-y") #'(lambda ()
                                      (interactive)
                                      (if current-prefix-arg
                                          (anything-global-mark-ring)
                                          (anything-mark-ring))))
(global-set-key (kbd "H-<SPC>") 'anything)


(defun anything-tv-show-traverse-only ()
  (interactive)
  (anything-set-source-filter '("Traverse Occur")))
(define-key anything-map "T" 'anything-tv-show-traverse-only)

(defun anything-file-in-current-dir ()
  (interactive)
  (anything 'anything-c-source-files-in-current-dir+))

(global-set-key (kbd "C-x C-d") 'anything-file-in-current-dir)

(setq anything-c-files-in-current-tree-ignore-files '(".elc$" ".pyc$" ".DS_Store$"
                                                      ".orig$" ".rej$"
                                                      "ANYTHING-TAG-FILE"))

(global-set-key (kbd "C-c C-d") 'anything-files-in-current-tree)

;; Automatically collect symbols by 150 secs
(anything-lisp-complete-symbol-set-timer 300)
(setq anything-c-traverse-fontify-buffer t)
(setq anything-scroll-amount 1)

(setq anything-input-idle-delay 0.6)
(setq anything-idle-delay 1.3)
(setq anything-candidate-number-limit 13)
(setq anything-c-bookmarks-face1 'diredp-dir-priv)
(setq anything-c-buffers-face1 'diredp-dir-priv)

(setq anything-quick-update t)

(setq anything-candidate-separator (propertize (make-string 42 ?-)
                                               'face 'traverse-match-face))



(provide 'as-anything)
