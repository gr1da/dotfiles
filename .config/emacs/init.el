(setq-default fill-column 100
              indent-tabs-mode nil
              column-number-mode t)

(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   '(((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "Zathura")
     (output-html "xdg-open")))
 '(custom-enabled-themes '(wombat))
 '(electric-pair-mode t)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-selected-packages
   '(lsp-dart helm-lsp company flycheck lsp-ui lsp-mode evil haskell-mode dap-mode which-key
              evil-collection ccls auctex)))

(package-initialize)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'default-frame-alist '(font . "Fira Code-12"))

(setq evil-want-keybinding nil)
(require 'evil)
(evil-mode 1)
(evil-collection-init)

(setq TeX-auto-save t
      TeX-parse-self t)

(require 'lsp-mode)
(setq ccls-executable "/usr/bin/ccls")
(require 'ccls)

(mapc (lambda (hook)
        (add-hook hook 'lsp))
      '(c-mode-hook c++-mode-hook))

(require 'which-key)
(which-key-mode)
