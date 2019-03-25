;;;;;;;;;;;;;;;;;;;;;;;;;;;Packages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

;; Hello There look over!
;; Here!
(setq package-list '(evil
		     magit
		     helm
		     tuareg
		     org
		     auto-complete
		     jedi
		     epc
		     projectile
		     which-key
		     ein
		     cython-mode
		     js-format
		     web-beautify
		     exec-path-from-shell
		     rjsx-mode
		     markdown-mode
		     go-mode
		     multi-term
		     origami
		     auctex
		     auto-complete-auctex
		     multiple-cursors
		     nov
		     flycheck
		     flycheck-pos-tip
		     elfeed
		     yasnippet
		     yasnippet-snippets
		     pdf-tools
		     exwm
		     smex
		     minimap
		     protobuf-mode
		     mu4e-alert
		     telephone-line
		     apache-modeo
		     color-theme-sanityinc-tomorrow
		     color-theme-modern))

(dolist (pkg package-list)
  (unless (package-installed-p pkg)
    (condition-case nil
	(package-install pkg)
      (error
       (package-refresh-contents)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Packages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; General ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq inhibit-startup-screen t)
(global-linum-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("usr/local/bin")))
(electric-pair-mode t)
(tool-bar-mode -1)
(global-set-key (kbd "M-[") 'insert-pair)
(global-set-key (kbd "M-{") 'insert-pair)
(global-set-key (kbd "M-\"") 'insert-pair)
(global-set-key (kbd "M-\'") 'insert-pair)
(global-set-key (kbd "C-x M-e") (lambda () (interactive)(find-file "~/.emacs.d/init.el")))
(global-set-key (kbd "C-x M-z") (lambda () (interactive)(find-file "~/.zshrc")))
(add-to-list 'load-path "~/.emacs.d/el")
(windmove-default-keybindings)
(show-paren-mode 1)
(defun update-emacsd ()
  ;;; Stage, commit and push ~/.emacs.d
  (interactive)
  (let (
	(commit_msg (read-string "Please enter commit message:" nil nil "Update emacs.d"))
	)
    (shell-command (concat "cd ~/.emacs.d && git add -A && git commit -m \"" commit_msg "\" && git push"))
    )
  )

(global-set-key (kbd "C-c M-e") 'update-emacsd)

(global-set-key (kbd "<C-up>") 'shrink-window)
(global-set-key (kbd "<C-down>") 'enlarge-window)
(global-set-key (kbd "<C-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-right>") 'enlarge-window-horizontally)

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

(setenv "GOPATH" (expand-file-name "~/go"))

(set-face-attribute 'default nil :height 95)

(defun disable-all-themes ()
  "disable all active themes."
  (dolist (i custom-enabled-themes)
    (disable-theme i)))

(defadvice load-theme (before disable-themes-first activate)
  (disable-all-themes))

(setq-default tab-width 4)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End General ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Yasnippet ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'yasnippet)
(setq yas-snippet-dirs
      (append yas-snippet-dirs
	      '("~/.emacs.d/snippets")))
(yas-global-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Yasnippet ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Themes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'color-theme-sanityinc-tomorrow)
;; (load-theme 'sanityinc-tomorrow-night t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Themes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Helm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'helm)
(helm-mode)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Helm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Projectile ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'projectile)
(projectile-global-mode)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Projectile ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Auto-Complete ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'auto-complete-config)
(ac-config-default)
(setq ac-show-menu-immediately-on-auto-complete t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Auto-Complete ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Which-Key ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'which-key)
(which-key-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Which-Key ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Jedi ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'jedi)
(add-to-list 'ac-sources 'ac-source-jedi-direct)
(add-hook 'python-mode-hook 'jedi:setup)
(defvar jedi-config:with-virtualenv "~/.py35")
;; Variables to help find the project root
(defvar jedi-config:vcs-root-sentinel ".git")
(defvar jedi-config:python-modudle-sentinel "__init__.py")

(defun get-project-root (buf repo-type init-file)
  (vc-find-root (expand-file-name (buffer-file-name buf)) repo-type))

(defvar jedi-config:find-root-function 'get-project-root)

;; And call this on initialization
(defun current-buffer-project-root ()
  (funcall jedi-config:find-root-function
	   (current-buffer)
	   jedi-config:vcs-root-sentinel
	   jedi-config:python-modudle-sentinel))

(defun jedi-config:setup-server-args()
  ;; Helper macro
  (defmacro add-args (arg-list arg-name arg-value)
    `(setq ,arg-list (append ,arg-list (list ,arg-name ,arg-value))))
  
  (let ((project-root (current-buffer-project-root)))

    ;; Variable for this buffer only
    (make-local-variable 'jedi:server-args)
   
    ;; And set our variables
    (when project-root
      (add-args jedi:server-args "--sys-path" project-root))
    (when jedi-config:with-virtualenv
      (add-args jedi:server-args "--virtual-env"
		jedi-config:with-virtualenv))))

(add-hook 'python-mode-hook
	  'jedi-config:setup-server-args)

(defun jedi-config:setup-keys ()
  (local-set-key (kbd "M-.") 'jedi:goto-definition)
  (local-set-key (kbd "M-,") 'jedi:goto-definition-pop-marker)
  (local-set-key (kbd "M-?") 'jedi:show-doc)
  (local-set-key (kbd "M-/") 'jedi:get-in-function-call))

(add-hook 'python-mode-hook 'jedi-config:setup-keys)

(setq jedi:get-in-function-call-delay 1000000)
(setq jedi:complete-on-dot t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Jedi ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; EIN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ein)
(require 'ein-notebook)
(require 'ein-subpackages)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End EIN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; JS-format ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'js-format)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End JS-format ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Exec-path-from-shell ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Exec-path-from-shell ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Javascript ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq js-indent-level 2)
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Javascript ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Org Mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'org)
(add-hook 'org-mode-hook (lambda () (org-indent-mode t)))
(add-hook 'org-mode-hook (lambda () (auto-fill-mode t)))
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Org Mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Brown Stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq tramp-default-method "ssh")
(defun connect-browncs (path)
  (dired (concatenate 'string "/ssh:txiaotin@ssh.cs.brown.edu" path)))

(defun open-browncs-cs1660 ()
  (connect-browncs ":~/course/1660"))

(defun open-browncs-cs1380 ()
  (connect-browncs ":~/course/1380"))

(global-set-key (kbd "C-x C-1 1") (lambda () (interactive) (open-browncs-cs1660)))
(global-set-key (kbd "C-x C-1 2") (lambda () (interactive) (open-browncs-cs1380)))

(global-set-key (kbd "C-x C-1 3") (lambda () (interactive) (dired "~/Dropbox/Brown/Course/1380")))
(global-set-key (kbd "C-x C-1 4") (lambda () (interactive) (dired "~/Dropbox/Brown/Course/1660")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Brown Stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Origami ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'origami)
(defun origami-config:setup-keys ()
  (local-set-key (kbd "C-x <") 'origami-close-node)
  (local-set-key (kbd "C-x >") 'origami-open-node))

(add-hook 'origami-mode-hook 'origami-config:setup-keys)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Origami ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Multi Term ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'multi-term)
(setq multi-term-program "/bin/zsh")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Multi Term ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Multiple Cursors ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'multiple-cursors)
(global-set-key (kbd "C-c m c") 'mc/edit-lines)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Multiple Cursors ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Nov ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'nov)
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Nov ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Go ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'go-mode)
(setenv "GOPATH" "/home/xttjsn/go")
(setenv "PATH" (concat (getenv "PATH") ":" "/home/xttjsn/go/bin"))
(require 'go-rename)
(require 'go-guru)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Go ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Flycheck ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'flycheck)
(global-flycheck-mode)
(flycheck-pos-tip-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Flycheck ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; skips 'vendor' directories and sets GO15VENDOREXPERIMENT=1
(setq flycheck-gometalinter-vendor t)
;; only show errors
(setq flycheck-gometalinter-errors-only t)
;; only run fast linters
(setq flycheck-gometalinter-fast t)
;; use in tests files
(setq flycheck-gometalinter-test t)
;; disable linters
(setq flycheck-gometalinter-disable-linters '("gotype" "gocyclo"))
;; Only enable selected linters
(setq flycheck-gometalinter-disable-all t)
(setq flycheck-gometalinter-enable-linters '("golint"))
;; Set different deadline (default: 5s)
(setq flycheck-gometalinter-deadline "10s")
;; Use a gometalinter configuration file (default: nil)
;; (setq flycheck-gometalinter-config "/path/to/gometalinter-config.json")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Go ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Elfeed ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'elfeed)
(setq elfeed-feeds
      '("http://www.50ply.com/atom.xml"
	"http://possiblywrong.wordpress.com/feed/"
	"http://www.devrand.org/feeds/posts/default"
	"https://tuxdigital.com/feed/thisweekinlinux-ogg"
	"https://pinecast.com/feed/emacscast"
	"https://emacsel.com/ogg.xml"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Elfeed ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Workgroups ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'workgroups)
(workgroups-mode 1)
(wg-load "~/.emacs.d/workgroups/main_workgroups")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Workgroups ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Pdf-tools ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'pdf-tools)
(pdf-tools-install)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Pdf-tools ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Window split ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))
(global-set-key (kbd "C-x |") 'toggle-window-split)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Window split ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Buffer-move ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Buffer-move ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; EXWM ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'exwm)
;; (require 'exwm-config)
;; (exwm-config-default)

;; (require 'exwm-randr)

;; ;;; My desktop machine is named "core"
;; (when (string= (system-name) "core")
;;   (setq exwm-randr-workspace-output-plist '(0 "HDMI-1" 1 "DVI-D-0"))
;;   (add-hook 'exwm-randr-screen-change-hook
;; 	  (lambda ()
;; 	    (start-process-shell-command
;; 	     "xrandr" nil "xrandr --output DVI-D-0 --rotate left --output HDMI-1 --left-of DVI-D-0 --auto"))))

;; (system-name)
;; (when (string= (system-name) "xttjsn-Surface-Book-2")
;;   (add-hook 'exwm-randr-screen-change-hook
;; 	    (lambda ()
;; 	      (start-process-shell-command
;; 	       "xrandr" nil "xrandr --output eDP-1 --mode 3000x2000 --dpi 192 --preferred"))))

;; (require 'exwm-systemtray)
;; (exwm-systemtray-enable)

;; (exwm-randr-enable)
;; (exwm-enable)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End EXWM ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SMEX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'smex)
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End SMEX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Latex ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'pdf-view)
(add-hook 'pdf-view-mode-hook
	  (lambda ()
	    (linum-mode -1)))

(add-hook 'LaTeX-mode-hook
	  (lambda ()
	    (auto-fill-mode 1)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Latex ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Minimap ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'minimap)
(setq minimap-window-location 'right)
(setq minimap-width-fraction 0.1)
(setq minimap-minimum-width 15)
(global-set-key (kbd "<f7>") 'minimap-mode)
(set-face-background 'minimap-active-region-background "dim gray")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Minimap ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Mu4e ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'mu4e)
(setq mu4e-contexts
 `( ,(make-mu4e-context
     :name "Brown"
     :match-func (lambda (msg) (when msg
				 (string-prefix-p "/Brown" (mu4e-message-field msg :maildir))))
     :vars '(
	     (mu4e-trash-folder . "/Brown/[Gmail].Trash")
	     (mu4e-sent-folder . "/Brown/[Gmail].Sent Mail")
	     (mu4e-drafts-folder . "/Brown/[Gmail].Drafts")
	     ))
    ,(make-mu4e-context
      :name "Xttjsn"
      :match-func (lambda (msg) (when msg
				  (string-prefix-p "/Xttjsn" (mu4e-message-field msg :maildir))))
      :vars '(
	      (mu4e-trash-folder . "/Xttjsn/[Gmail].Trash")
	      (mu4e-sent-folder . "/Xttjsn/[Gmail].Sent Mail")
	      (mu4e-drafts-folder . "/Xttjsn/[Gmail].Drafts")
	      ))
    ,(make-mu4e-context
      :name "Jasontang736"
      :match-func (lambda (msg) (when msg
				  (string-prefix-p "/Jasontang736" (mu4e-message-field msg :maildir))))
      :vars '(
	      (mu4e-trash-folder . "/Jasontang736/[Gmail].Trash")
	      (mu4e-sent-folder . "/Jasontang736/[Gmail].Sent Mail")
	      (mu4e-drafts-folder . "/Jasontang736/[Gmail].Drafts")
	      ))
    ))

(require 'mu4e-alert)
(setq mu4e-alert-interesting-mail-query
      (concat
       "flag:unread maildir:/Brown/INBOX "
       "OR "
       "flag:unread maildir:/Xttjsn/INBOX "
       "OR "
       "flag:unread maildir:/Jasontang736/INBOX"
       ))
(mu4e-alert-enable-mode-line-display)
(defun gjstein-refresh-mu4e-alert-mode-line ()
  (interactive)
  (mu4e~proc-kill)
  (mu4e-alert-enable-mode-line-display)
  )
(run-with-timer 0 60 'gjstein-refresh-mu4e-alert-mode-line)

;; I have my "default" parameters from Gmail
(setq mu4e-sent-folder "/Users/xttjsn/Maildir/sent"
      ;; mu4e-sent-messages-behavior 'delete ;; Unsure how this should be configured
      mu4e-drafts-folder "/Users/xttjsn/Maildir/drafts"
      user-mail-address "xttjsn@gmail.com"
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

;; Now I set a list of 
(defvar my-mu4e-account-alist
  '(("Brown"
     (mu4e-sent-folder "/Brown/sent")
     (user-mail-address "tang_xiaoting@brown.edu")
     (smtpmail-smtp-user "tang_xiaoting@brown.edu")
     (smtpmail-local-domain "gmail.com")
     (smtpmail-default-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-service 587)
     )
    ;; Include any other accounts here ...
    ("Xttjsn"
     (mu4e-sent-folder "/Xttjsn/sent")
     (user-mail-address "xttjsn@gmail.com")
     (smtpmail-smtp-user "xttjsn@gmail.com")
     (smtpmail-local-domain "gmail.com")
     (smtpmail-default-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-service 587)
     )
    ("Jasontang736"
     (mu4e-sent-folder "/Jasontang736/sent")
     (user-mail-address "jasontang736@gmail.com")
     (smtpmail-smtp-user "jasontang736@gmail.com")
     (smtpmail-local-domain "gmail.com")
     (smtpmail-default-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-service 587)
     )    
    ))

(defun my-mu4e-set-account ()
  "Set the account for composing a message.
   This function is taken from: 
     https://www.djcbsoftware.nl/code/mu/mu4e/Multiple-accounts.html"
  (let* ((account
    (if mu4e-compose-parent-message
        (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
    (string-match "/\\(.*?\\)/" maildir)
    (match-string 1 maildir))
      (completing-read (format "Compose with account: (%s) "
             (mapconcat #'(lambda (var) (car var))
            my-mu4e-account-alist "/"))
           (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
           nil t nil nil (caar my-mu4e-account-alist))))
   (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
  (mapc #'(lambda (var)
      (set (car var) (cadr var)))
        account-vars)
      (error "No email account found"))))
(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)


(require 'gnus-dired)
;; make the `gnus-dired-mail-buffers' function also work on
;; message-mode derived modes, such as mu4e-compose-mode
(defun gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
        (set-buffer buffer)
        (when (and (derived-mode-p 'message-mode)
                (null message-sent-message-via))
          (push (buffer-name buffer) buffers))))
    (nreverse buffers)))

(setq gnus-dired-mail-mode 'mu4e-user-agent)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Mu4e ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; conf-unix-mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (add-to-list 'auto-mode-alist '("\\.service\\'" . conf-unix-mode))
 (add-to-list 'auto-mode-alist '("\\.timer\\'" . conf-unix-mode))
 (add-to-list 'auto-mode-alist '("\\.target\\'" . conf-unix-mode))
 (add-to-list 'auto-mode-alist '("\\.mount\\'" . conf-unix-mode))
 (add-to-list 'auto-mode-alist '("\\.automount\\'" . conf-unix-mode))
 (add-to-list 'auto-mode-alist '("\\.slice\\'" . conf-unix-mode))
 (add-to-list 'auto-mode-alist '("\\.socket\\'" . conf-unix-mode))
 (add-to-list 'auto-mode-alist '("\\.path\\'" . conf-unix-mode))
 (add-to-list 'auto-mode-alist '("\\.netdev\\'" . conf-unix-mode))
 (add-to-list 'auto-mode-alist '("\\.network\\'" . conf-unix-mode))
 (add-to-list 'auto-mode-alist '("\\.link\\'" . conf-unix-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End conf-unix-mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Mode-Line ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'telephone-line)
(setq telephone-line-lhs
      '((evil   . (telephone-line-evil-tag-segment))
        (accent . (telephone-line-vc-segment
                   telephone-line-erc-modified-channels-segment
                   telephone-line-process-segment))
        (nil    . (telephone-line-minor-mode-segment
                   telephone-line-buffer-segment))))
(setq telephone-line-rhs
      '((nil    . (telephone-line-misc-info-segment))
        (accent . (telephone-line-major-mode-segment))
        (evil   . (telephone-line-airline-position-segment))))
(telephone-line-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Mode-Line ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; More Color Themes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Please set your themes directory to 'custom-theme-load-path
(add-to-list 'custom-theme-load-path
             (file-name-as-directory "/home/xttjsn/.emacs.d/replace-colorthemes"))

;; load your favorite theme
(require 'color-theme-modern)
;; (load-theme 'aalto-dark t t)
;; (enable-theme 'aalto-dark)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End More Color Themes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Theme parks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'theme-park-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Theme parks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#373b41" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#c5c8c6"))
 '(beacon-color "#cc6666")
 '(custom-safe-themes
   (quote
	("595099e6f4a036d71de7e1512656e9375dd72cf60ff69a5f6d14f0171f1de9c1" "ed92c27d2d086496b232617213a4e4a28110bdc0730a9457edf74f81b782c5cf" "5eb4b22e97ddb2db9ecce7d983fa45eb8367447f151c7e1b033af27820f43760" "b8c5adfc0230bd8e8d73450c2cd4044ad7ba1d24458e37b6dec65607fc392980" "4c8372c68b3eab14516b6ab8233de2f9e0ecac01aaa859e547f902d27310c0c3" "8530b2f7b281ea6f263be265dd8c75b502ecd7a30b9a0f28fa9398739e833a35" "1a094b79734450a146b0c43afb6c669045d7a8a5c28bc0210aba28d36f85d86f" "05d009b7979e3887c917ef6796978d1c3bbe617e6aa791db38f05be713da0ba0" "db510eb70cf96e3dbd48f5d24de12b03db30674ea0853f06074d4ccf7403d7d3" "6e03b7f86fcca5ce4e63cda5cd0da592973e30b5c5edf198eddf51db7a12b832" "67b11ee5d10f1b5f7638035d1a38f77bca5797b5f5b21d16a20b5f0452cbeb46" "3fe4861111710e42230627f38ebb8f966391eadefb8b809f4bfb8340a4e85529" "5c83b15581cb7274085ba9e486933062652091b389f4080e94e4e9661eaab1aa" "da8e6e5b286cbcec4a1a99f273a466de34763eefd0e84a41c71543b16cd2efac" "77515a438dc348e9d32310c070bfdddc5605efc83671a159b223e89044e4c4f1" "a513bb141af8ece2400daf32251d7afa7813b3a463072020bb14c82fd3a5fe30" "9bd5ee2b24759fbc97f86c2783d1bf8f883eb1c0dd2cf7bda2b539cd28abf6a9" "0c5204945ca5cdf119390fe7f0b375e8d921e92076b416f6615bbe1bd5d80c88" "39a854967792547c704cbff8ad4f97429f77dfcf7b3b4d2a62679ecd34b608da" "2d5c40e709543f156d3dee750cd9ac580a20a371f1b1e1e3ecbef2b895cf0cd2" "392f19e7788de27faf128a6f56325123c47205f477da227baf6a6a918f73b5dc" "7bd626fcc9fbfb44186cf3f08b8055d5a15e748d5338e47f9391d459586e20db" "be5b03913a1aaa3709d731e1fcfd4f162db6ca512df9196c8d4693538fa50b86" "a455366c5cdacebd8adaa99d50e37430b0170326e7640a688e9d9ad406e2edfd" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "e0d42a58c84161a0744ceab595370cbe290949968ab62273aed6212df0ea94b4" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default)))
 '(fci-rule-color "#373b41")
 '(flycheck-color-mode-line-face-to-color (quote mode-line-buffer-id))
 '(frame-background-mode (quote dark))
 '(global-linum-mode t)
 '(line-number-mode nil)
 '(package-selected-packages
   (quote
	(apache-mode telephone-line on-screen php-mode mu4e-alert mu4e protobuf-mode sublimity minimap smex xkcd 2048-game pdf-tools elfeed yasnippet-snippets flycheck-pos-tip flycheck nov multiple-cursors auto-complete-auctex auctex origami multi-term multi-terms go-mode markdown-mode web-beautify js-format cython-mode projectile magit helm evil color-theme-sanityinc-tomorrow)))
 '(projectile-mode t nil (projectile))
 '(send-mail-function (quote smtpmail-send-it))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
	((20 . "#cc6666")
	 (40 . "#de935f")
	 (60 . "#f0c674")
	 (80 . "#b5bd68")
	 (100 . "#8abeb7")
	 (120 . "#81a2be")
	 (140 . "#b294bb")
	 (160 . "#cc6666")
	 (180 . "#de935f")
	 (200 . "#f0c674")
	 (220 . "#b5bd68")
	 (240 . "#8abeb7")
	 (260 . "#81a2be")
	 (280 . "#b294bb")
	 (300 . "#cc6666")
	 (320 . "#de935f")
	 (340 . "#f0c674")
	 (360 . "#b5bd68"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "PaleGreen2"))))
 '(minimap-active-region-background ((t (:background "dim gray")))))
