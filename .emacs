;; CEDET
(load-file "~/.emacs.d/vendor/cedet-1.0pre7/common/cedet.el")
(global-ede-mode 1)                      ; Enable the Project management system
(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
(global-srecode-minor-mode 1)            ; Enable template insertion menu

(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;; package.el
(add-to-list 'load-path "~/.emacs.d/elpa/")
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)



;; (add-to-list 'load-path "~/.emacs.d/vendor/coffee-mode")
;; (require 'coffee-mode)

;; (add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
;; (add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

(setq-default tab-width 4)

;; tab width for coffee
(defun coffee-custom ()
  "coffee-mode-hook"
  (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook
		  '(lambda() (coffee-custom)))

;; tab width for javascript
;; (defun js-custom ()
;;   "javascript-mode-hook"
;;   (set (make-local-variable 'tab-width) 2))

;; (add-hook 'javascript-mode-hook
;; 		  '(lambda() (js-custom)))

;; prevent emacs from spewing buffer files everywhere.
(custom-set-variables
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/")))))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; set up MIT scheme
(setq scheme-program-name
      "/Applications/MIT:GNU-Scheme.app/Contents/Resources/mit-scheme")
(require 'xscheme)


;; ;; rudel
;; (load-file "$HOME/Programming/rudel/rudel-loaddefs.el")

;; Share clipboard with OSX
;; http://blog.lathi.net/articles/2007/11/07/sharing-the-mac-clipboard-with-emacs
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil)) 
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; Indicate empty lines
(setq-default indicate-empty-lines t)

;; Whitespace!
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; Indicate trailing whitespace
(setq-default show-trailing-whitespace t)

;; Tabs are evil
(setq-default indent-tabs-mode nil)

;; Clear out the shell.  http://www.emacswiki.org/emacs/ShellMode#toc11
(defun clear-shell ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

;; Count words. http://www.emacswiki.org/emacs/WordCount
(defun count-words (start end)
  "Print number of words in the region."
  (interactive "r")
  (defun wc ()
    (save-excursion
      (save-restriction
        (narrow-to-region start end)
        (goto-char (point-min))
        (count-matches "\\sw+"))))
  (message (concat "The current region contains "
                   (number-to-string (wc))
                   " words.")))

(defalias 'word-count 'count-words)

;; Flymake js init http://lapin-bleu.net/riviera/?p=191
(when (load "flymake" t)
  (defun flymake-jslint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "jslint" (list local-file))))

  (setq flymake-err-line-patterns
	(cons '("Error:\\([[:digit:]]+\\):\\([[:digit:]]+\\):\\(.*\\)$"
		nil 1 2 3)
	      flymake-err-line-patterns))

  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.js\\'" flymake-jslint-init))

  (require 'flymake-cursor)
)

(add-hook 'js2-mode-hook
          (lambda ()
            (flymake-mode 1)))
;;            (define-key js-mode-map "\C-c\C-n" 'flymake-goto-next-error)))

;; (defun js-custom ()
;;   "javascript-mode-hook"
;;   (set (make-local-variable 'tab-width) 2))


;; (set (make-local-variable 'js-expr-indent-offset) 2)



;; Fixing js indent to handle vars properly.
;; http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
;; (defun fix-js-var-indent ()
;;   (interactive)
;;   (save-restriction
;;     (widen)
;;     (let* ((inhibit-point-motion-hooks t)
;;            (parse-status (save-excursion (syntax-ppss (point-at-bol))))
;;            (offset (- (current-column) (current-indentation)))
;;            (indentation (js--proper-indentation parse-status))
;;            node)

;;       (save-excursion

;;         ;; consecutive declarations in a var statement are nice if
;;         ;; properly aligned, i.e:
;;         ;;
;;         ;; var foo = "bar",
;;         ;;     bar = "foo";
;;         (setq node (js2-node-at-point))
;;         (when (and node
;;                    (= js-NAME (js2-node-type node))
;;                    (= js-VAR (js2-node-type (js-node-parent node))))
;;           (setq indentation (+ 4 indentation))))

;;       (indent-line-to indentation)
;;       (when (> offset 0) (forward-char offset)))))

;; (defun my-js-mode-hook ()
;;   (set (make-local-variable 'indent-line-function) 'fix-js-var-indent)
;;   (message "My JS hook"))

;; (add-hook 'js-mode-hook 'my-js-mode-hook)

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
