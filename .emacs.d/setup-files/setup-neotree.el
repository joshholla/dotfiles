;; ;; Time-stamp: <2018-05-26 13:41:25 joshuaholla>

;; ;; Neotree: a tree layout file explorer for Emacs
;; ;; https://github.com/jaypei/emacs-neotree
;; (use-package neotree :defer t
;;   :config
;;   ((setq neo-window-width 35
;;          neo-autorefresh t
;;          neo-show-hidden-files t
;;          neo-confirm-change-root t
;;          neo-smart-open t
;;          neo-toggle-window-keep-p t))
;;          ;; projectile-switch-project-action 'neotree-projectile-action
;;          ;; neo-theme (if window-system 'icons 'nerd)) ; 'classic, 'nerd, 'ascii,
;;                                         ; 'arrow
;;   :bind
;;   (:map global-map
;;         ("C-c n" . neotree-toggle)
;;         ("C-c s t" . neotree-find)))

;; (use-package all-the-icons)

;; (provide 'setup-neotree)

;; neotree: A emacs tree plugin like NerdTree for Vim
;; https://github.com/jaypei/emacs-neotree
(use-package neotree
  :bind
  (("C-c >" . modi/find-file-next-in-dir)
   ("C-c <" . modi/find-file-prev-in-dir)
   ("C-c n" . neotree-toggle))

  :init
  ;; Every time when the neotree window is opened, it will try to find current
  ;; file and jump to node.
  (setq-default neo-smart-open t)
  ;; Do not allow neotree to be the only open window
  (setq-default neo-dont-be-alone t)

  :config
  ;; add all-the-icons support for neotree
;;  (setq neo-theme (if (display-graphic-p) 'icons 'nerd))

  (setq neo-window-width 35)
  ;; show VC status in neotree
  (setq neo-vc-integration '(face char))

  (defun modi/neotree-go-up-dir ()
    (interactive)
    (goto-char (point-min))
    (neotree-change-root))

  ;; http://emacs.stackexchange.com/a/12156/115
  (defun modi/find-file-next-in-dir (&optional prev)
    "Open the next file in the directory.
When PREV is non-nil, open the previous file in the directory."
    (interactive "P")
    (let ((neo-init-state (neo-global--window-exists-p)))
      (if (null neo-init-state)
          (neotree-show))
      (neo-global--select-window)
      (if (if prev
              (neotree-previous-line)
            (neotree-next-line))
          (progn
            (neo-buffer--execute nil
                                 (quote neo-open-file)
                                 (lambda (full-path &optional arg)
                                   (message "Reached dir: %s/" full-path)
                                   (if prev
                                       (neotree-next-line)
                                     (neotree-previous-line)))))
        (progn
          (if prev
              (message "You are already on the first file in the directory.")
            (message "You are already on the last file in the directory."))))
      (if (null neo-init-state)
          (neotree-hide))))

  (defun modi/find-file-prev-in-dir ()
    "Open the next file in the directory."
    (interactive)
    (modi/find-file-next-in-dir :prev))

  (bind-keys
   :map neotree-mode-map
   ("^" . modi/neotree-go-up-dir)
   ("C" . neotree-change-root)
   ("c" . neotree-create-node)
   ("+" . neotree-create-node)
   ("d" . neotree-delete-node)
   ("r" . neotree-rename-node)))

(use-package all-the-icons)

(provide 'setup-neotree)
