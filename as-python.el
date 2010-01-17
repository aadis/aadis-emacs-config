;;;_ Python specific stuff
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

;; (when (require-try 'python-mode)
;;   ;; (require 'pycomplete)

;;   ;; (when (require 'pymacs)

;;   ;;   (autoload 'pymacs-load "pymacs" nil t)
;;   ;;   (autoload 'pymacs-eval "pymacs" nil t)
;;   ;;   (autoload 'pymacs-apply "pymacs")
;;   ;;   (autoload 'pymacs-call "pymacs"))


;;   (add-hook 'python-mode-hook
;;             '(lambda () (progn
;;                           (eldoc-mode 1)
;;                           (which-function-mode t)
;;                           (delete (assoc 'which-func-mode mode-line-format) mode-line-format)
;;                           (setq which-func-header-line-format
;;                                 '(which-func-mode
;;                                   ("" which-func-format)))
;;                           (defadvice which-func-ff-hook (after header-line activate)
;;                             (when which-func-mode
;;                               (delete (assoc 'which-func-mode mode-line-format) mode-line-format)
;;                               (setq header-line-format which-func-header-line-format)))
;;                           (set-variable 'py-indent-offset 4)
;;                           ;; (make-variable-buffer-local 'yas/trigger-key)
;;                           ;; (make-variable-buffer-local 'yas/next-field-key)
;;                           ;; (setq yas/trigger-key (kbd "<C-tab>"))
;;                           ;; (setq yas/next-field-key (kbd "<tab>"))

;;                           (auto-revert-mode 1)
;;                           (set-variable 'py-smart-indentation nil)
;;                           (set-variable 'indent-tabs-mode nil))))

;;   ;; Load these key bindings for python shell
;;   (define-key py-shell-map (kbd "M-p") 'comint-previous-matching-input-from-input)
;;   (define-key py-shell-map (kbd "M-n") 'comint-next-matching-input-from-input)
;;   (define-key py-shell-map (kbd "C-M-n") 'comint-next-input)
;;   (define-key py-shell-map (kbd "C-M-p") 'comint-previous-input)
;;   (define-key py-shell-map "\C-w" 'comint-kill-region)
;;   (define-key py-shell-map [C-S-backspace] 'comint-kill-whole-line)
    
;;   (define-key py-mode-map (kbd "M-f") 'py-forward-into-nomenclature)
;;   (define-key py-mode-map (kbd "M-b") 'py-backward-into-nomenclature)

;;   (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;;   (setq interpreter-mode-alist (cons '("python" . python-mode) interpreter-mode-alist))
  
;;   (setq ipython-command "psh")
;;   (require-try 'ipython)
;;   (setq py-python-command-args '("-pylab" "-colors" "Linux")))

;; (when (load "flymake" t)
;;   (defun flymake-pylint-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "epylint" (list local-file))))
;;   (require-try 'flymake-cursor)
  
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pylint-init))
;;   (add-hook 'python-mode-hook
;;             '(lambda () (flymake-mode t))))
               
               
;; ;;;_. Return should newline and indent
;; (add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-m" 'newline-and-indent)))

;;pymacs is useful
;; (when (and (require-try 'pymacs) t)
;;   (when (condition-case err  (pymacs-load "ropemacs" "rope-")
;;           (error
;;            (progn (message "loading rope failed") nil)))
;;     (setq ropemacs-enable-autoimport t)

;;     ;;try out company
;;     (require-try  'company)
    
;;     (add-hook 'python-mode-hook
;;               (lambda ()
;;                 (ropemacs-mode t)
;;                 (company-mode t)))))


;; (yas/define 'python-mode "getp" "${1:name}=getp(\"$1\",request.params,default=${2:None})$0")
;; (yas/define 'python-mode "gpj" "${1:name}=getp(\"$1\",request.params,default=$1)$0")
;; (yas/define 'python-mode "gpi" "${1:name}=getp(\"$1\",request.params,int,default=$1)$0")
;; (yas/define 'python-mode "sq" "Session.query(${1:object}).$0")
;; (yas/define 'python-mode "rt" "redirect_to(controller=\"${1:controller}\",action=\"${2:action}\",id=${3:None})$0")
;; (yas/define 'python-mode "url" "h.url_for(controller=\"${1:controller}\",action=\"${2:action}\",id=${3:None})$0")
;; (yas/define 'python-mode "murl" "\\${h.url_for(controller=\"${1:controller}\",action=\"${2:action}\",id=${3:None})$0}")
;; (yas/define 'python-mode "lg" "log.${1:debug}(\"$0\")" "add a logging statement")
;; (yas/define 'python-mode "sr" "Session.rollback()$0" "Session rollback")
;; (yas/define 'python-mode "sb" "Session.begin()$0" "Session begin")
;; (yas/define 'python-mode "sc" "Session.commit()$0" "Session commit")
;; (yas/define 'python-mode "idp" "id=getp(\"id\",request.params,int,default=id)$0" "id getp")

;; (yas/define 'python-mode "index" "c.${1:task}s=Session.query(${1:$(capitalize text)})$0
;; return render('/$1/index.html')")

;; (yas/define 'python-mode "edit" "
;; Session.begin()
;; ${1:task}s=Session.query(${1:$(capitalize text)})
;; $0
;; Session.add($1)
;; Session.commit()")

;; (yas/define 'python-mode "ifnotid" "$>if not $1:
;; $>log.error(\"$1 is required\")$0
;; $>$0redirect_to(controller='$4',action='${5:index}',id=None)
;; ")

;; (yas/define 'python-mode "idqjson" "$>${1:obj}=Session.query(${2:obj2}).get(${3:id})
;; $>if not $1:
;; $>log.error(\"No $2 with id: %s\" % $3)
;; $>return {'replyCode':300,'replyText':\"No $2 with id: %s\" % $3, 'data':None}")

;; (yas/define 'python-mode "ifnoto" "$>if not $1:
;; $>log.error(\"No $2 with id:%s\" % ${3:id})
;; $>$0redirect_to(controller='$4',action='${5:index}',id=None)
;; $>return {'replyCode':300,'replyText':\"No $2 with id: %s\" % $3, 'data':None}
;; ")

;; (yas/define 'python-mode "jsonret" "$>return {'replyCode':${1:201},'replyText':'${2:Ok}', 'data':${3:None}}")

;; (yas/define 'python-mode "json" "$>return {'replyCode':${1:201},'replyText':'${2:Ok}', 'data':${3:None}}")


;;somehow ropemacs-mode gets added to this list, remove (since we added it manually)
;;(setq python-mode-hook (remove* 'ropemacs-mode python-mode-hook))

(setq python-shell-input-prompt-1-regexp "^In \\[[0-9]+\\]: *"
      python-shell-input-prompt-2-regexp "^   [.][.][.]+: *")

(ansi-color-for-comint-mode-on)

(setq python-python-command "psh")

(provide 'as-python)
