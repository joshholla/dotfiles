;;; setup-recentf.el -*- lexical-binding: t; -*-
;; Time-stamp: <2018-12-17 21:20:25 csraghunandan>

;; Copyright (C) 2016-2018 Chakravarthy Raghunandan
;; Author: Chakravarthy Raghunandan <rnraghunandan@gmail.com>

;; view the list recently opened files
(use-package recentf :defer 1
  :ensure nil
  :config
  (setq recentf-max-menu-items 300)
  (setq recentf-max-saved-items 300)
  (setq recentf-exclude
   '("/elpa/" ;; ignore all files in elpa directory
     "recentf" ;; remove the recentf load file
     ".*?autoloads.el$"
     "treemacs-persist"
     "company-statistics-cache.el" ;; ignore company cache file
     "/intero/" ;; ignore script files generated by intero
     "/journal/" ;; ignore daily journal files
     ".gitignore" ;; ignore `.gitignore' files in projects
     "/tmp/" ;; ignore temporary files
     "NEWS" ;; don't include the NEWS file for recentf
     "bookmarks"  "bmk-bmenu" ;; ignore bookmarks file in .emacs.d
     "loaddefs.el"
     "^/\\(?:ssh\\|su\\|sudo\\)?:" ;; ignore tramp/ssh files
     ))
  (recentf-mode))

(provide 'setup-recentf)