;;; as-sql.el --- sql stuff

;;; Code:

(defun sql-make-smart-buffer-name ()
  "Return a string that can be used to rename a SQLi buffer.

This is used to set `sql-alternate-buffer-name' within
`sql-interactive-mode'."
  (or (and (boundp 'sql-name) sql-name)
      (concat (if (not(string= "" sql-server))
                  (concat
                   (or (and (string-match "[0-9.]+" sql-server) sql-server)
                       (car (split-string sql-server "\\.")))
                   "/"))
              sql-database)))

(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (setq sql-alternate-buffer-name (sql-make-smart-buffer-name))
            (sql-rename-buffer)))

(setq sql-connection-alist
      '((epsilon
         (sql-product 'mysql)
         (sql-server "localhost")
         (sql-user "epsilon")
         (sql-password "epsilon")
         (sql-database "epsilon")
         (sql-port 3306))
        (epsilon-test
         (sql-product 'mysql)
         (sql-server "localhost")
         (sql-user "epsilon")
         (sql-password "epsilon")
         (sql-database "epsilon_test"))))

(defun sql-connect-preset (name)
  "Connect to a predefined SQL connection listed in `sql-connection-alist'"
  (eval `(let ,(cdr (assoc name sql-connection-alist))
    (flet ((sql-get-login (&rest what)))
      (sql-product-interactive sql-product)))))

(setq 
 sql-database "epsilon"
 sql-product 'mysql
 sql-server "localhost"
 sql-user "epsilon"
 sql-password "epsilon")

(defun sql-epsilon ()
  (interactive)
  (sql-connect-preset 'epsilon))

(defun sql-epsilon-test ()
  (interactive)
  (sql-connect-preset 'epsilon-test))

(provide 'as-sql)
;;; as-sql.el ends here
