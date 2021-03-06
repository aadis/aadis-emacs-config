;;;_ my mac specific settings
;; contains display related thingies as well
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


;;;_. font, frame size
(defun as/set-frame-sane ()
  "set frame params to a sane default"
  (interactive)
  (modify-all-frames-parameters '(
                                  (font . "-apple-Consolas-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1")
                                  (width . 200)
                                  (height . 65)
                                  (left . 0)
                                  (top . 19))))

(set-default-font "-apple-Consolas-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;;set immediately
(as/set-frame-sane)
;;(ns-set-background-alpha 0.97)

(setq ns-pop-up-frames nil)

(setq ns-command-modifier 'meta)
(setq ns-function-modifier 'hyper)

;;_. Cmd-` on mac should switch frames even if cmd is mapped to meta
(global-set-key (kbd "M-`") 'other-frame)


;;;_. load my color theme
;; (when (and (require-try 'as-color-theme) (fboundp 'color-theme-vivid-chalk))
;;   (color-theme-vivid-chalk))

(defun output-to-growl (msg)
  (let ((fname (make-temp-file "/tmp/growlXXXXXX")))
    (with-temp-file fname
      (setq coding-system-for-write 'utf-16)
      (insert (format "tell application \"GrowlHelperApp\"
     notify with name \"Emacs Notification\" title \"Emacs alert\" \
       description «data utxt%s» as Unicode text \
       application name \"Emacs\"
   end tell"  (osd-text-to-utf-16-hex msg))))
    (shell-command (format "osascript %s" fname))
    (delete-file fname)))

(defun osd-text-to-utf-16-hex (text)
  (let* ((utext (encode-coding-string text 'utf-16))
         (ltext (string-to-list utext)))
    (apply #'concat
     (mapcar (lambda (x) (format "%02x" x)) ltext))))


(provide 'as-mac)

