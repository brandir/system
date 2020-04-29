;; .emacs <elrond@<rivendell>, created 04/29/2020
;; Time-stamp: <>

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq user-full-name "A.Friend)
(setq user-login-name "elrond")
(setq system-name "rivendell")
(setq frame-title-format (concat user-login-name "@" system-name))
(setq european-calendar-style 't)
;; (diary)

(display-battery-mode 1)

;; skip initial logo
(setq inhibit-startup-message t)

(setq column-number-mode t)
(setq line-number-mode t)

;; (setq-default tab-width 4)

;; display date and time in status bar
(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

;; automatic timestamps
(setq
 time-stamp-active t
 time-stamp-line-limit 10
 time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S (%u@%h) %f")

(add-hook 'write-file-hooks 'time-stamp)

(setq display-time-default-load-average 2)

;; (menu-bar-mode -1)
;; (tool-bar-mode -1

(global-set-key [f1] 'goto-line)
(global-set-key [f2] 'what-line)

(defun up-fast ()
  (interactive) (scroll-up 8))
(defun down-fast ()
  (interactive) (scroll-down 8))

(global-set-key [f3] 'down-fast)
(global-set-key [f4] 'up-fast)

(global-set-key (kbd "<home>") 'beginning-of-buffer)
(global-set-key (kbd "<end>") 'end-of-buffer)

;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (go-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
