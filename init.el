;;; ----------------
;;; custom variables
;;; ----------------
(defvar custom-lang "German") ; replace this if necessary 
(defvar home-root (expand-file-name "~"))
(defvar emacs-d "/.emacs.d")

;;  Common Lisp (CL) Implementations
(defvar sbcl-default-path "/usr/local/lib/sbcl-2.3.8/bin/sbcl")
(defvar sbcl-4g-path "/usr/local/lib/sbcl-2.5.7/bin/sbcl")
(defvar ecl-path "/usr/bin/ecl")
(defvar ccl-path (concat home-root "/bin"
                         "/ccl-1.11.5-linuxx86/ccl/lx86cl64"))
(defvar acl-path (concat home-root "/bin"
                         "/AllegroCL/acl11.0express.64/alisp"))
(defvar abcl-path "/usr/bin/abcl")

(defvar cl-default "/usr/bin/sbcl") ; replace, if only one CL implementation is used 
(defvar custom-slime-contribs (concat home-root
                                     emacs-d
                                     "/slime-contribs"))

;;(defvar slime-contribs "/home/jochen/.emacs.d/elpa/slime-20250904.1610/contrib")

;;  Project folders
(defvar cl-projects (concat home-root
                            "/quicklisp/local-projects"))
(defvar js-projects (concat home-root
                            "/src/JavaScript/projects"))

;;; -----------------------
;;; Emacs startup variables
;;; -----------------------
(setq inhibit-startup-screen t)
(setq current-language-environment
      custom-lang) ; CUSTOM-LANG is defined at the top of this file
(setq ispell-program-name "aspell") ; could be ispell as well
(setq ispell-dictionary "de_DE.multi") ; replace this if necessary
(setq calendar-week-start-day 1)
(setq european-calendar-style t)

;;; --------------
;;; Emacs-packages
;;; --------------
(require 'package)
(add-to-list 'package-archives
             ;'("melpa-stable" . "http://stable.melpa.org/packages/") t)
             '("melpa" . "http://melpa.org/packages/") t)
;;(add-to-list 'package-archives
;;             '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(use-package gnu-elpa-keyring-update :ensure t)
(setq package-install-upgrade-built-in t)

;;; ---------------------------------------------
;;; Temporary file directory for Emacs autosaves.
;;; ---------------------------------------------
(defvar user-temporary-file-directory "~/.emacs-autosaves/")
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

;;; ---------------------
;;; Default coding system
;;; ---------------------
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
  ;; Treat clipboard input as UTF-8 string first; compound text next, etc.
      
;;; ----------
;;; Appearance
;;; ----------
(use-package sublime-themes :ensure t
  ;; A selection of Emacs themes
  :config
  (load-theme 'spolsky t)) ; a dark theme

(use-package mode-icons :ensure t
  ;; Icons in the mode bar.
  )

(global-font-lock-mode t) ; Activate font-lock mode (syntax coloring).
(column-number-mode t)    ; Activate column numbering

(add-hook 'text-mode-hook #'auto-fill-mode)
(setq-default fill-column 80) ; Linefeed after 80 characters
(setq font-lock-maximum-decoration t) ; Maximum colors

;;; ---------------
;;; File management
;;; ---------------
(use-package dirvish :ensure t
  ;; Dire is Emacs default filemanager, this is a beautified extension.
  )

(use-package dired-sidebar :ensure t
  ;; Another Dire extension
  :bind
  (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :commands
  (dired-sidebar-toggle-sidebar))

(use-package neotree :ensure t
  ;; A further filemanager in a sidebar, more fancy than dire
  :bind
  (([f8] . neotree-toggle)))

(use-package transient :ensure t
  ;; implements the keyboard-driven “menus” in Magit
  :config
  (setq transient-mark-mode t) ; active (selected) region highlighted
  )

(use-package magit :ensure t
  ;; Emacs frontend for a git client
  )

(use-package projectile :ensure t :defer 1
  ;; a project interaction library
  ;; taken from: https://www.draketo.de/software/emacs-javascript.html
  ;; and from: https://docs.projectile.mx/projectile/usage.html
  :init
  (setq projectile-project-search-path '(((expand-file-name cl-projects)
                                          (expand-file-name js-projects))))
  :bind
  (("\C-c \C-p" . projectile-command-map)
   ;;("\C-c \C-ps" . projectile-ripgrep)
   )
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-sort-order 'modification-time)
  (projectile-mode +1))

;;; -------------
;;; Editing tools
;;; -------------
(setq-default indent-tabs-mode nil) ; tabs deactivated

(use-package ido :ensure t
  ;; Interactively Do Things (suggesting files
  ;; and directories in minibuffer etc.)
  :config                  
  (ido-mode t))

(use-package smex :ensure t
  ;; provides a convenient interface to recently
  ;; and most frequently used commands
  :bind
  (("M-x" . smex)
   ("M-X" . smex-major-mode-commands)
   ("C-c C-c M-x" . execute-extended-command)) ; non-smex M-x
  :config
  (smex-initialize))

(use-package which-key :ensure t
  ;; displays available keybindings in a pop-up window
  ;; when typing a prefix key (included since Emacs 30.1)
  :config
  (which-key-mode +1))

(use-package paredit :ensure t
  ;; automatically balances parentheses
  :config
  (setq show-paren-delay 0)
  (show-paren-mode t)
  :hook
  ((emacs-lisp-mode eval-expression-minibuffer-setup
    ielm-mode lisp-mode lisp-interaction-mode
    scheme-mode slime-repl-mode) . enable-paredit-mode))

(autoload 'enable-paredit-mode "paredit"
   "Turn on pseudo-structural editing of Lisp code." t)

(use-package rainbow-delimiters :ensure t
  ;; highlights delimiters such as parentheses, brackets or braces
  ;; according to their depth. Each successive level is highlighted
  ;; in a different color. 
  :hook
  ((emacs-lisp-mode eval-expression-minibuffer-setup
    ielm-mode lisp-mode lisp-interaction-mode
    scheme-mode slime-repl-mode) . rainbow-delimiters-mode)
  :config
  (set-face-foreground 'rainbow-delimiters-depth-1-face
                       "#fff")  ; white
  (set-face-foreground 'rainbow-delimiters-depth-2-face
                       "#f00")  ; red
  (set-face-foreground 'rainbow-delimiters-depth-3-face
                       "#0ff")  ; aquamarine
  (set-face-foreground 'rainbow-delimiters-depth-4-face
                       "#ff0")  ; yellow
  (set-face-foreground 'rainbow-delimiters-depth-5-face
                       "#6693f5")  ; cornflower
  (set-face-foreground 'rainbow-delimiters-depth-6-face
                       "#f0f")  ; foxia
  (set-face-foreground 'rainbow-delimiters-depth-7-face
                       "#af0")  ; bright green
  (set-face-foreground 'rainbow-delimiters-depth-8-face
                       "#c6c")  ; magenta
  (set-face-foreground 'rainbow-delimiters-depth-9-face
                       "#fff"))  ; white

(use-package auto-complete :ensure t
  ;; an intelligent auto-completion extension
  )

(use-package irony :ensure t
  ;; clang based completion for C and C++,
  ;; on the fly syntax checking and more
  :hook ((c++-mode c-mode objc-mode) . irony-mode))

(use-package company :ensure t
  ;; COMplete ANYthing, a text and code completion framework
  :hook (prog-mode . company-mode))

(use-package company-irony :ensure t
  ;; company-mode asynchronous completion backend for
  ;; the C, C++ and Objective-C languages.
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package markdown-mode :ensure t)

(setq auto-mode-alist (cons '("\\.xsd$" . xml-mode) auto-mode-alist))

;;; -----------
;;; Common Lisp
;;; -----------
(setq inferior-lisp-program cl-default) ; CL-DEFAULT is a custom variable
(setq byte-compile-warnings '(cl-functions)) ; Get rid of the message
                                            ;; "cl is deprecated"

(use-package slime :ensure t
  ;; Superior Lisp Interaction Mode (for) Emacs
  ;; Quasi a remote control for a running *Common* Lisp session
  :load-path custom-slime-contribs
  :load-path cl-default
  :bind
  (("\C-c \C-c" . slime-compile-defun)
   ("\C-cs" . slime-selector))
  :hook
  (slime-repl-mode . set-slime-repl-return)
  :config
  ;;(setq slime-lisp-implementations
          ;; if this variable is set, it is possible to load
          ;; and switch between the following Common Lisp
          ;; implementations with the chosen names.
          ;; The names are defined at the beginning of this file.
          ;; If used, CL-DEFAULT should be set to "".
  ;;        '((sbcl-default ((expand-file-name sbcl-default-path)
  ;;                         "--noinform" "--no-linedit")
  ;;                        :coding-system utf-8-unix)
  ;;          (sbcl-4g ((expand-file-name sbcl-4g-path)
  ;;                    "--noinform" "--no-linedit")
  ;;                    :coding-system utf-8-unix)
  ;;          (ecl ((expand-file-name ecl-path)) :coding-system utf-8-unix)
  ;;    	    (ccl ((expand-file-name ccl-path))
  ;;                :coding-system utf-8-unix)
  ;;          (acl ((expand-file-name acl-path)))))
   ;;       (abcl (expand-file-name abcl-path))))
  ;;(slime-setup '(slime-company slime-banner))
   (setq slime-contribs '(slime-fancy slime-asdf slime-sprof slime-mdot-fu
                          slime-compiler-notes-tree slime-hyperdoc
                          slime-indentation slime-repl slime-repl-ansi-color)) 
   (setq slime-net-coding-system 'utf-8-unix)
   (setq slime-startup-animation nil)
   (setq slime-auto-select-connection 'always)
   (setq slime-kill-without-query-p t)
   (setq slime-description-autofocus t) 
   (setq slime-fuzzy-explanation "")
   (setq slime-asdf-collect-notes t)
   (setq slime-inhibit-pipelining nil)
   (setq slime-load-failed-fasl 'always)
   (setq slime-export-symbol-representation-auto t)
   (setq lisp-indent-function 'common-lisp-indent-function)
   (setq lisp-loop-indent-subclauses nil)
   (setq lisp-loop-indent-forms-like-keywords t)
   (setq lisp-lambda-list-keyword-parameter-alignment t))

(use-package slime-company :ensure t
  ;; Slime integration of company-mode
  :after
  (slime company)
  :config
  (setq slime-company-completion 'fuzzy
        slime-company-after-completion 'slime-company-just-one-space)
  (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
  (setq slime-when-complete-filename-expand t)
  (setq slime-repl-history-remove-duplicates t)
  (setq slime-repl-history-trim-whitespaces t)
  (defun set-slime-repl-return ()
    (define-key slime-repl-mode-map
                (kbd "RET") 'slime-repl-return-at-end)
    (define-key slime-repl-mode-map
                (kbd "<return>") 'slime-repl-return-at-end))
  (defun slime-repl-return-at-end ()
    (interactive)
    (if (<= (point-max) (point))
        (slime-repl-return)
        (slime-repl-newline-and-indent))))

(use-package ac-slime :ensure t
  ;; Integrate Slime and auto-complete
  :hook
  ((slime-mode set-up-slime-ac slime-repl-mode) . set-up-slime-ac)
  :config
  (add-to-list 'ac-modes 'slime-repl-mode))

(load
 ;; Integrate the Common Lisp library manager Quicklisp in Slime
 (expand-file-name "~/quicklisp/slime-helper.el"))
(load
 ;; Integrate the online reference to ANSI Common Lisp
 (expand-file-name "~/quicklisp/clhs-use-local.el") t)

(use-package cl-lib :ensure t) ; Common Lisp extension for elisp
(setq first  #'car     ; alternatives in elisp for 
      second #'cadr    ; the traditional Lisp list
      third  #'caddr   ; operations that return the
      fourth #'cadddr  ; respective list element,
      rest   #'cdr)    ; or a list's tail.
(use-package elisp-slime-nav :ensure t)

;;; ----------
;;; JavaScript (cf. https://www.draketo.de/software/emacs-javascript.html)
;;; ----------
(use-package js2-mode :ensure t :defer 20
  :mode
  (("\\.js\\'" . js2-mode))
  :custom
  (js2-include-node-externs t)
  (js2-global-externs '("customElements"))
  (js2-highlight-level 3)
  (js2r-prefer-let-over-var t)
  (js2r-prefered-quote-type 2)
  (js-indent-align-list-continuation t)
  (global-auto-highlight-symbol-mode t)
  :config
  (setq js-indent-level 2)
  ;; patch in basic private field support
  (advice-add #'js2-identifier-start-p
            :after-until
            (lambda (c) (eq c ?#))))

(use-package json-mode :ensure t :defer 20
  :custom
  (json-reformat:indent-width 2)
  :mode (("\\.bowerrc$"     . json-mode)
         ("\\.jshintrc$"    . json-mode)
         ("\\.json_schema$" . json-mode)
         ("\\.json\\'" . json-mode))
  :bind (:package json-mode-map
         :map json-mode-map
         ("C-c <tab>" . json-mode-beautify)))


(use-package js2-refactor :ensure t :defer 30
  :config
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (js2r-add-keybindings-with-prefix "C-c C-m"))

;; Highlight TODO, FIXME, ... in any programming mode
(use-package fic-mode :ensure t
  :hook (prog-mode . fic-mode))

(use-package flymake-eslint :ensure t :defer 10
  :custom
  ;; add glasses-mode to bolden capitals in CamelCase here. Could also
  ;; be done elsewhere.
  (glasses-face (quote bold))
  (glasses-original-separator "")
  (glasses-separate-capital-groups t)
  (glasses-separate-parentheses-p nil)
  (glasses-separator "")
  :config
  (add-hook 'js-mode-hook
            (lambda ()
              (flymake-eslint-enable)
              (flymake-mode -1)
              (flycheck-mode 1)
              (glasses-mode 1)))
  (add-hook 'js2-mode-hook
            (lambda ()
              (flymake-eslint-enable)
              (flymake-mode -1)
              (flycheck-mode 1)
              (glasses-mode 1)))
  (custom-set-variables
   '(help-at-pt-timer-delay 0.3)
   '(help-at-pt-display-when-idle '(flymake-overlay))))

(use-package flymake-diagnostic-at-point :ensure t :defer 20
  :config
  (flymake-diagnostic-at-point-mode t))

(use-package tern :ensure t :defer 30
  :if (locate-file "tern" exec-path)
  :hook (js2-mode . tern-mode))

(use-package json-mode :ensure t :defer 20
  :custom
  (json-reformat:indent-width 2)
  :mode (("\\.bowerrc$"     . json-mode)
         ("\\.jshintrc$"    . json-mode)
         ("\\.json_schema$" . json-mode)
         ("\\.json\\'" . json-mode))
  :bind (:package json-mode-map
  :map json-mode-map
  ("C-c <tab>" . json-mode-beautify)))

;; (use-package company-tern :ensure t :defer 30
;;   :config
;;   (add-to-list 'company-backends 'company-tern)
;;   (define-key tern-mode-keymap (kbd "M-.") nil)
;;   (define-key tern-mode-keymap (kbd "M-,") nil))

(use-package js2-refactor :ensure t :defer 30
  :config
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (js2r-add-keybindings-with-prefix "C-c C-m"))
;; context menu for keybindings

(use-package discover :ensure t :defer 30
  :config
  (global-discover-mode 1))

(use-package skewer-mode :ensure t
  ;; Live browser JavaScript, CSS, and HTML interaction
  ;; Run server with: M-x run-skewer
  ;; Run REPL with: M-x skewer-repl
  )


;;; -----
;;; LaTeX
;;; -----
;; (setq-default TeX-master nil)
;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq TeX-PDF-mode t)
;; (setq TeX-save-query nil)
;; (setq reftex-plug-into-AUCTeX t)
;; (setq font-latex-fontify-script nil)
;; (setq latex-run-command "pdflatex")
;; (setq tex-dvi-view-command
;;       "(f=*; pdflatex \"${f%.dvi}.tex\" && open \"${f%.dvi}.pdf\")")
;; (add-hook 'LaTeX-mode-hook 'visual-line-mode)
;; ;(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
;; (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;; (add-hook 'LaTeX-mode-hook 'flyspell-buffer)
;; (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)


(defun my-LaTeX-mode-hook ()
  (auto-fill-mode t)
  (set-fill-column 80))
(add-hook 'LaTeX-mode-hook 'my-LaTeX-mode-hook)
(setq latex-run-command "pdflatex")
(setq +latex-viewers '(evince))


;;; ------------------------------
;;; Start Emacs as Common Lisp IDE
;;; ------------------------------
(cd "~/quicklisp/local-projects")
(slime)
(neotree)
(other-window 1)
(tool-bar-mode -1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(help-at-pt-display-when-idle '(flymake-overlay) nil (help-at-pt))
 '(help-at-pt-timer-delay 0.3)
 '(package-selected-packages
   '(ac-slime agda2-mode company-irony dired-sidebar dirvish discover
     elisp-slime-nav fic-mode flymake-diagnostic-at-point flymake-eslint
     gnu-elpa-keyring-update js2-refactor json-mode magit markdown-mode
     mode-icons neotree paredit projectile rainbow-delimiters skewer-mode
     slime-company smex sublime-themes tern)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))
