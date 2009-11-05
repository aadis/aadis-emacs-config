(defun company-sql--grab-symbol ()
  (let ((symbol (company-grab-symbol)))
    (when symbol
      (cons symbol
            (save-excursion
              (let ((pos (point)))
                (goto-char (- (point) (length symbol)))
                (while (eq (char-before) ?.)
                  (goto-char (1- (point)))
                  (skip-syntax-backward "w_"))
                (- pos (point))))))))

(defun company-sql (command &optional arg &rest ignored)
  "A `company-mode' completion back-end for sql."
  (interactive (list 'interactive))
  (case command
    ('interactive (company-begin-backend 'company-sql))
    ('prefix (and (derived-mode-p 'sql-interactive-mode)
                  (not (company-in-string-or-comment))
                  (company-sql--grab-symbol)))
    ('candidates (sql-mysql-complete-command-company arg))))


;;; completion functions
(defun sql-mysql-complete-command-company (opt)
  (when opt
    (all-completions (upcase opt) sql-mysql-command-alist))
          )

(defun sql-mysql-complete-comopt ()
  (let ((opt (comint-match-partial-filename))
        (cmd (upcase (save-excursion
                       (comint-bol nil)
                       (skip-chars-forward " \t")
                       (current-word)))))
    (when opt
      (let ((success (let ((comint-completion-addsuffix nil))
                       (comint-dynamic-simple-complete
                        (upcase opt)
                        (assoc cmd sql-mysql-command-option-alist)))))
        (when success
          (upcase-region (save-excursion (backward-word) (point))
                         (point))
          (if (and (memq success '(sole shortest))
                   comint-completion-addsuffix)
              (insert " ")))
        success))))

(add-to-list 'company-backends 'company-sql)

(provide 'as-sql-company)
