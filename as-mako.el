;;; as-mako.el --- mako mode stuff

;; Copyright (C) 2008  aaditya sood

;; Author: aaditya sood <aaditya@kali.sood.webhop.net>
;;; Code:

(yas/define 'nxhtml-mode "fef.text" "    <tr>
      <td>${1:$(capitalize text)}</td>
      <td>\\${h.text('${1:field}',value=${2:$(get-register (string-to-char \"p\"))}.$1,maxlength=${3:255})}</td>
    </tr>
$0")

(yas/define 'nxhtml-mode "fef.select" "    <tr>
      <td>${1:$(capitalize text)}</td>
      <td>\\${fns.${1:field}_select(${2:c.}$1,'$1',${3:$(get-register (string-to-char \"p\"))}.$1)}</td>
    </tr>
$0")

(yas/define 'nxhtml-mode "fef.if" "    <tr>
      <td>${2:$(capitalize text)}</td>
      <td>\\
      %if ${1:$(get-register (string-to-char \"p\"))}${2:field}:
      \\${${3:$(get-register (string-to-char \"p\"))}$2}\\
      %endif\\
      </td>
    </tr>
$0")

(yas/define 'nxhtml-mode "fef.link" "\\${fns.${1:task}_link($0.$1)}")


(yas/define 'nxhtml-mode "fef.root" "
    <tr>
      <td>\\${h.link_to('${1:$(capitalize text)}s',url=h.url_for('${1:task}_$1s'))}</td>
      <td>\\${h.link_to('Add',url=h.url_for('$1_$1s/new'))}</td>
    </tr>
")

(yas/define 'nxhtml-mode "trrow" "<tr>
$><td>
$><label for=\"${1:id}\" class=\"required\">$2</label>
$></td>
$><td>
$><input type=\"text\" value=\"\${$3}\" name=\"$1\" id=\"$1\"/>
$></td>
$></tr>")

(yas/define 'nxhtml-mode "form" "\\${h.form(h.url_for(controller=\"${1:controller}\", action=\"${2:action}\", id=${3:c..id}), method=\"post\", name=\"$4\")}$0")
(yas/define 'nxhtml-mode "url" "\\${h.url_for(controller=\"${1:controller}\",action=\"${2:action}\",id=${3:None})}$0")
(yas/define 'javascript-mode "url" "\\${h.url_for(controller=\"${1:controller}\",action=\"${2:action}\",id=${3:None})}$0")

(yas/define 'nxhtml-mode "incyuijs" "\\${fns.yui_include('$0')}")
(yas/define 'nxhtml-mode "incjs" "\\${h.javascript_link('/js/$0.js')}")
(yas/define 'nxhtml-mode "incyuicss" "\\${fns.yui_css('$0')}")
(yas/define 'nxhtml-mode "inccss" "\\${h.stylesheet_link('/css/$0.css'))}")



(setq auto-mode-alist (cons '("\\.mako$" . mako-nxhtml-mumamo-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.mako\\'$" . mako-nxhtml-mumamo-mode) auto-mode-alist))



(provide 'as-mako)
;;; as-mako.el ends here
