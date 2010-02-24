;;; as-gnus.el --- gnus config for aaditya sood

;; Copyright (C) 2009  Aaditya Sood

;; Author: Aaditya Sood <aaditya@kali.local>
;; Keywords: mail

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

;;; Commentary:

;; 

;;; Code:

(setq gnus-select-method
      '(nnimap "Mail"
	       (nnimap-address "localhost")
	       (nnimap-stream network)
	       (nnimap-authenticator login)))

(setq user-mail-address "aaditya@gmail.com")
(setq gnus-ignored-from-addresses '("aaditya" "aaditya@gmail.com" "aaditya@sood.net.in" ".*@sood.net.in" "a@ideadevice.com" "aaditya@hcoop.net"))

;;mail splitting

;; (setq nnmail-split-methods
;;       '(("mail.list.pylons" "^To:.*pylons-discuss@googlegroups.com")
;;         ("mail.list.bynari" "^To:.*icbeta@bynari.net")
;;         ("mail.list.hcoop" "^To:.*hcoop-help@lists.hcoop.net")
;;         ("mail.list.hcoop" "^To:.*hcoop-sysadmin@lists.hcoop.net")
;;         ("mail.list.hcoop" "^To:.*hcoop-discuss@lists.hcoop.net")))

;; (setq nnmail-split-methods 'nnmail-split-fancy)

;; (setq nnmail-split-fancy '(|
;;                            (: gnus-group-split-fancy "id.INBOX" t "id.INBOX")
;;                            (: gnus-group-split-fancy "INBOX" t "INBOX")
;;                            (: gnus-group-split-fancy "hcoop" t "hcoop")
;;                            "mail.misc")) 

(setq nnmail-crosspost nil)

 (setq gnus-parameter-to-list-alist
          '(("mail.list.pylons" . "pylons-discuss@googlegroups.com")
            ("mail.list.bynari.beta" . "icbeta@bynari.net")
            ("mail.list.commits" . "commits@ideadevice.com")
            ("mail.list.hcoop" . "hcoop-help@lists.hcoop.net")
            ("mail.list.hcoop" . "hcoop-sysadmin@lists.hcoop.net")
            ("mail.list.hcoop" . "hcoop-discuss@lists.hcoop.net")))

(setq gnus-total-expirable-newsgroups
          (regexp-opt '("mail.list.hcoop"
                        "mail.list.pylons"
                        "mail.list.bugs"
                        "mail.list.commits"
                        "mail.list.crash")))

(add-hook 'message-sent-hook 'gnus-score-followup-thread)
(setf nnmail-resplit-incoming t)

(setq nnmail-split-methods 'nnmail-split-fancy
      nnmail-split-fancy
      `(| (from "redmine@tools.ideadevice.com" "mail.list.bugs")
          (to "pylons-discuss@googlegroups.com" "mail.list.pylons")
          (to "RainbowResidency@yahoogroups.com" "mail.list.misc")
          (to "icbeta@bynari.net" "mail.list.bynari.beta")
          (from "vip@bynari.net" "mail.list.bynari")
          (to "commits@ideadevice.com" "mail.list.commits")
          ("subject" "Cron <aaditya@mire> .*" "mail.list.hcoop")
          (to "hcoop-help@lists.hcoop.net" "mail.list.hcoop")
          (to "hcoop-sysadmin@lists.hcoop.net" "mail.list.hcoop")
          (to "hcoop-discuss@lists.hcoop.net" "mail.list.hcoop")
          (to "a@ideadevice.com" "id.INBOX")
          (to ".*@sood.net.in" "hcoop")
          (to "aaditya@hcoop.net" "hcoop")
          (to "aaditya.*@gmail.com" "INBOX")
          "mail.leftover"))

(gnus-demon-add-handler 'gnus-demon-scan-news 2 t) ; this does a call to gnus-group-get-new-news

;;(require 'bbdb)
;;(setq bbdb/send-auto-create-p t)
;;(setq bbdb/send-prompt-for-create-p t)

(require-try 'gnus-hardsort)



;; Useful for searching os x address book( which syncs with my iphone)
(require 'external-abook)
;;(setq external-abook-command "contacts -lf '%%e\t%%n' %s")
(setq external-abook-command "contacts -lSf '%%e\t\"%%n\"' '%s'")

(eval-after-load "message" 
  '(progn 
     (add-to-list 'message-mode-hook 
                  '(lambda ()
                     (define-key message-mode-map "\C-c\t" 'external-abook-try-expand)))))

;;stripes
;; the color of the stripes is obtained by dimming the frame background color
(defvar stripe-intensity 12
  "*intensity of the shade. Used to compute the color of the stripes.
     0 means no shading of the background color, nil means gray80")

;; a command that computes the rgb code of the shaded background color
;; (defun shade-color (intensity)
;;   "print the #rgb color of the background, dimmed according to intensity"
;;   (interactive "nIntensity of the shade : ")
;;   (apply 'format "#%02x%02x%02x" 
;;          (mapcar (lambda (x)
;;                    (if (> (lsh x -8) intensity)
;;                        (- (lsh x -8) intensity)
;;                      0))
;;                  (color-values (cdr (assoc 'background-color (frame-parameters)))))))

;; ;; ;; the command that actually puts the stripes in the current buffer
;; (defun stripe-alternate ()
;;   "stripes all down the current buffer"
;;   (interactive)
;;   ;; compute the color of the stripes from the value of stripe-intensity
;;   (if stripe-intensity 
;;       (setq stripe-overlay-face (shade-color stripe-intensity))
;;     (setq stripe-overlay-face "gray80"))
;;   ;; put the overlay in the current buffer
;;   (save-excursion
;;     (goto-char (point-min))
;;     (let (stripe-overlay)
;;       (while (not (eobp))
;;         (forward-line)
;;         (setq stripe-overlay 
;;               (make-overlay (line-beginning-position)
;;                             (line-beginning-position 2)))
;;         (overlay-put stripe-overlay 'face (list :background stripe-overlay-face))
;;         (overlay-put stripe-overlay 'priority -1)
;;         (forward-line)))))

;; ;; activate the stripes for the mail buffers only
;; (add-hook 'gnus-summary-prepare-hook (lambda ()
;;                                        (with-current-buffer gnus-summary-buffer 
;;                                          (unless (gnus-news-group-p gnus-newsgroup-name)   
;;                                            (stripe-alternate)))))                          


;;use subjects for threading
(setq gnus-summary-thread-gathering-function 'gnus-gather-threads-by-subject)
(setq gnus-summary-gather-subject-limit 'fuzzy)

(setq gnus-topic-line-format "%i[ %u&topic-line; ] %v\n")

;; this corresponds to a topic line format of "%n %A"
(defun gnus-user-format-function-topic-line (dummy)
  (let ((topic-face (if (zerop total-number-of-articles)
                        'my-gnus-topic-empty-face
                      'my-gnus-topic-face)))
    (propertize
     (format "%s %d" name total-number-of-articles)
     'face topic-face)))

(setq gnus-summary-line-format "%U%R%z %(%&user-date;  %-15,15f %* %B%s%)\n"
      gnus-user-date-format-alist '((t . "%d.%m.%Y %H:%M"))
      gnus-sum-thread-tree-false-root ""
      gnus-sum-thread-tree-indent " "
      gnus-sum-thread-tree-root ""
      gnus-sum-thread-tree-leaf-with-other "├► "
      gnus-sum-thread-tree-single-leaf "╰► "
      gnus-sum-thread-tree-vertical "│")

(add-hook 'gnus-summary-mode-hook 'my-setup-hl-line)
(add-hook 'gnus-group-mode-hook 'my-setup-hl-line)

(defun my-setup-hl-line ()
  (hl-line-mode 1)
  (setq cursor-type nil) ; Comment this out, if you want the cursor to
                                        ; stay visible.
  )

;;html emails
;; (when (require-try 'w3m)
;;   (setq mm-inline-text-html-renderer 'mm-inline-text-html-render-with-w3m
;;         w3m-display-inline-image t
;;         gnus-article-wash-function 'gnus-article-wash-html-with-w3m))

;; ;;show html email in external browser
;; ;;(setq mm-text-html-renderer nil)
;; (defun wicked/gnus-article-show-html ()
;;   "Show the current message as HTML mail."
;;   (interactive)
;;   (let ((mm-automatic-display (cons "text/html" mm-automatic-display)))
;;     (gnus-summary-show-article)))
;; (define-key gnus-article-mode-map "WH" 'wicked/gnus-article-show-html)

;;adaptive scoring
(setq gnus-use-adaptive-scoring t)
(setq gnus-default-adaptive-score-alist
      '((gnus-unread-mark)
        (gnus-ticked-mark (from 5) (subject 5))       
        (gnus-read-mark (from 1) (subject 1))
        (gnus-killed-mark (from -1) (subject -5))
        (gnus-catchup-mark (from -1) (subject -1))))
(add-hook 'message-sent-hook 'gnus-score-followup-article)

;;posting styles
(setq gnus-posting-styles
       '((".*"    ; Matches all groups of messages
          (address "aaditya@gmail.com")
          (signature "/A\nhttp://sood.net.in."))
         ("hcoop.*"
          (address "aaditya@sood.net.in")
          (signature "/A\nhttp://sood.net.in."))
         ("id.*"
          (address "a@ideadevice.com")
          (signature "aaditya sood\nhttp://www.ideadevice.com"))))


;; (gnus-add-configuration
;;  '(article
;;    (horizontal 1.0
;; 	       (vertical 35
;; 			 (group 1.0))
;; 	       (vertical 1.0
;; 			 (summary 0.25 point)
;; 			 (article 1.0)))))
;; (gnus-add-configuration
;;  '(summary
;;    (horizontal 1.0
;; 	       (vertical 35
;; 			 (group 1.0))
;; 	       (vertical 1.0
;; 			 (summary 1.0 point)))))

(require 'gnus-propfont)
(add-hook 'gnus-article-prepare-hook 'gpf-add-faces)

(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 "a@ideadevice.com" nil)
        ("smtp.gmail.com" 587 "aaditya@gmail.com" nil)
        ("deleuze.hcoop.net" 465 "aaditya" nil))
      smtpmail-auth-credentials
      (expand-file-name "~/.authinfo")
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      starttls-use-gnutls t)

;; Available SMTP accounts.
;;load from private file
(require 'as-gnus-private)

(setq gnus-group-line-format
      "%M\%S\%p\%P\%m\%5y/\%-5t: %(%-40,40g%) %2,2~(cut 6)d.%2,2~(cut 4)d.%4,4~(cut 0)d %2,2~(cut 9)d:%2,2~(cut 11)d %O\n")

;; Default smtpmail.el configurations.
 (require 'smtpmail)
 (setq send-mail-function 'smtpmail-send-it
       message-send-mail-function 'smtpmail-send-it
       mail-from-style nil
       user-full-name "aaditya sood"
       smtpmail-debug-info nil
       smtpmail-debug-verb t)

 (defun set-smtp-plain (server port user password)
   "Set related SMTP variables for supplied parameters."
   (setq smtpmail-smtp-server server
         smtpmail-smtp-service port)
   (message "Setting SMTP server to `%s:%s'."
            server port))

 (defun set-smtp-ssl (server port user password)
   "Set related SMTP and SSL variables for supplied parameters."
   (setq starttls-use-gnutls t
         starttls-gnutls-program "gnutls-cli"
         starttls-extra-arguments nil
         smtpmail-smtp-server server
         smtpmail-smtp-service port
         smtpmail-auth-credentials (list (list server port user password)))
   (message
    "Setting SMTP server to `%s:%s' (SSL enabled)."
    server port))

 (defun change-smtp ()
   "Change the SMTP server according to the current from line."
   (save-excursion
     (loop with from = (save-restriction
                         (message-narrow-to-headers)
                         (message-fetch-field "from"))
           for (acc-type address . auth-spec) in smtp-accounts
           when (and (string-match address from) (message "%s %s " address from))
           do (cond
               ((eql acc-type 'plain)
                (return (apply 'set-smtp-plain auth-spec)))
               ((eql acc-type 'ssl)
                (return (apply 'set-smtp-ssl auth-spec)))
               (t
                (return (apply 'set-smtp-ssl auth-spec))))
           finally (error "Cannot infer SMTP information."))))

(add-hook 'message-send-hook 'change-smtp)
(add-hook 'message-header-setup-hook 'change-smtp)

(require 'ispell)
(require 'flyspell)
(setq ispell-program-name "aspell")
(add-hook 'message-mode-hook
          (lambda () (flyspell-mode 1)))

;; smtp send information
(require 'smtpmail)

(gnus-compile)

(provide 'as-gnus)
;;; as-gnus.el ends here
