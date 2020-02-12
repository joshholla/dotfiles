
;; EIN: For dealing with the Jupyter Notebooks in Emacs.
;; https://github.com/millejoh/emacs-ipython-notebook
(use-package ein :defer t
  :config
  (setq ein:completion-backend 'ein:use-ac-jedi-backend)
  )

(provide 'setup-ein)
