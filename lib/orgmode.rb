# encoding: UTF-8
module Nanoc::Filters

  class OrgModeHtml < Nanoc::Filter
    identifier :org_mode_html
    type :text => :text

    require 'systemu'
    def run(content, params = {})
      # Run command
      elisp_code = %{
(progn
  (find-file-read-only "content#{item.identifier.to_s}")
  (setq org-html-postamble nil)
  (add-to-list 'load-path "E:/dropbox/Apps/emacs-24.5/.emacs.d/vender/")
 (custom-set-faces
 '(default                      ((t (:foreground "#ffffff" :background "black"))))
 '(font-lock-builtin-face       ((t (:foreground "#ff0000"))))
 '(font-lock-comment-face       ((t (:bold t :foreground "#333300"))))
 '(font-lock-constant-face      ((t (:foreground "magenta"))))
 '(font-lock-function-name-face ((t (:bold t :foreground "Blue"))))
 '(font-lock-keyword-face       ((t (:foreground "yellow3"))))
 '(font-lock-string-face        ((t (:foreground "light blue"))))
 '(font-lock-type-face    ((t (:foreground "green"))))
 '(font-lock-variable-name-face ((t (:foreground "cyan" :bold t))))
 '(font-lock-warning-face       ((t (:foreground "red" :weight bold)))))
  (setq htmlize-use-rgb-map 'force)

(defun org-font-lock-ensure ()
  (font-lock-fontify-buffer))
  (org-html-export-as-html)

  (message "%s" (buffer-string)))
}

      cmd = ['emacs', '-q', '--batch','--eval', elisp_code]
      #cmd = ['echo hi']

      stdout = ''
      stderr = ''
      status = systemu(cmd,
                       'stdout' => stdout,
                       'stderr' => stderr)
      #sto,ste,st = Open3.capture3("emacs -Q --batch  --eval '#{elisp_code}'");

      # Show errors
      #unless status.success?
        #$stderr.puts stderr
        #raise "Emacs org-mode filter failed with status #{status}"
      #end

      # Get result
      body = /<body>.*<\/body>/m.match(stderr)
      #puts(body)
      body[0].force_encoding("GBK").encode("UTF-8")
    end
  end

end
