;;;; framework-tex.scm --
;;;;
;;;;  source file of the GNU LilyPond music typesetter
;;;;
;;;; (c)  2004 Han-Wen Nienhuys <hanwen@cs.uu.nl>

(define-module (scm framework-tex)
  #:export (output-framework-tex	    
	    output-classic-framework-tex
))

(use-modules (ice-9 regex)
	     (ice-9 string-fun)
	     (ice-9 format)
	     (guile)
	     (srfi srfi-13)
	     (lily))

;; FIXME: rename
;; what is bla supposed to do?  It breaks the default output terribly:

;; \def\lilypondpaperbla$\backslash${$\backslash$}{bla$\backslash${$\backslash$}}%
;; \lyitem{089.5557}{-15.3109}{\hbox{\magfontUGQLomTVo{}bla$\backslash${$\backslash$}}}%
;; --jcn
(define-public (sanitize-tex-string s)
   (if (ly:get-option 'safe)
      (regexp-substitute/global #f "\\\\"
				(regexp-substitute/global #f "([{}])" "bla{}" 'pre  "\\" 1 'post )
				'pre "$\\backslash$" 'post)
      
      s))

(define (symbol->tex-key sym)
  (regexp-substitute/global
   #f "_" (sanitize-tex-string (symbol->string sym)) 'pre "X" 'post) )

(define (tex-number-def prefix key number)
  (string-append
   "\\def\\" prefix (symbol->tex-key key) "{" number "}%\n"))

(define-public (tex-font-command font)
  (string-append
   "magfont"
   (string-encode-integer
    (hashq (ly:font-filename font) 1000000))
   "m"
   (string-encode-integer
    (inexact->exact (round (* 1000 (ly:font-magnification font)))))))

(define (font-load-command bookpaper font)
  (let* ((coding-alist (ly:font-encoding-alist font))
	 (font-encoding (assoc-get 'output-name coding-alist))
	 )
    (string-append
     "\\font\\lilypond" (tex-font-command font) "="
     (ly:font-filename font)
     " scaled "
     (ly:number->string (inexact->exact
			 (round (* 1000
				   (ly:font-magnification font)
				   (ly:bookpaper-outputscale bookpaper)))))
     "\n"
     "\\def\\" (tex-font-command font) "{%\n"
     ;; UGH.  Should be handled via alist.
     (if (equal? "Extended-TeX-Font-Encoding---Latin" font-encoding)
	 "  \\fontencoding{T1}\\selectfont"
	 "  ")
     "\\lilypond" (tex-font-command font)
     "}\n"
     )))


(define (define-fonts bookpaper)
  (string-append
   ;; UGH. FIXME.   
   "\\def\\lilypondpaperunit{mm}\n"
   (tex-number-def "lilypondpaper" 'outputscale
		   (number->string (exact->inexact
				    (ly:bookpaper-outputscale bookpaper))))
   (tex-string-def "lilypondpaper" 'papersize
		   (eval 'papersize (ly:output-def-scope bookpaper)))
   (tex-string-def "lilypondpaper" 'inputencoding
		   (eval 'inputencoding (ly:output-def-scope bookpaper)))

   (apply string-append
	  (map (lambda (x) (font-load-command bookpaper x))
	       (ly:bookpaper-fonts bookpaper)))))

(define (header-to-file fn key val)
  (set! key (symbol->string key))
  (if (not (equal? "-" fn))
      (set! fn (string-append fn "." key)))
  (display
   (format (_ "Writing header field `~a' to `~a'...")
	   key
	   (if (equal? "-" fn) "<stdout>" fn))
   (current-error-port))
  (if (equal? fn "-")
      (display val)
      (display val (open-file fn "w")))
  (newline (current-error-port))
  "")

(define (output-scopes  scopes fields basename)
  (define (output-scope scope)
    (apply
     string-append
     (module-map
      (lambda (sym var)
	(let ((val (if (variable-bound? var) (variable-ref var) ""))
	      )
	  
	  (if (and (memq sym fields) (string? val))
	      (header-to-file basename sym val))
	  ""))
      scope)))
  (apply string-append (map output-scope scopes)))

(define (tex-string-def prefix key str)
  (if (equal? "" (sans-surrounding-whitespace (sanitize-tex-string str)))
      (string-append "\\let\\" prefix (symbol->tex-key key) "\\undefined%\n")
      (string-append "\\def\\" prefix (symbol->tex-key key)
		     "{" (sanitize-tex-string str) "}%\n")))

(define (header bookpaper page-count classic?)
  (let ((scale (ly:output-def-lookup bookpaper 'outputscale)))

    (string-append
     "% Generated by LilyPond "
     (lilypond-version) "\n"
     "% at " "time-stamp,FIXME" "\n"
     (if classic?
	 (tex-string-def "lilypond" 'classic "1")
	 "")

     (if (ly:get-option 'safe)
	 "\\nofiles\n"
	 "")

     (tex-string-def
      "lilypondpaper" 'linewidth
      (ly:number->string (* scale (ly:output-def-lookup bookpaper 'linewidth))))

     (tex-string-def
      "lilypondpaper" 'interscoreline
      (ly:number->string
       (* scale (ly:output-def-lookup bookpaper 'interscoreline)))))))

(define (header-end)
  (string-append
   "\\def\\scaletounit{ "
   (number->string (cond
		    ((equal? (ly:unit) "mm") (/ 72.0 25.4))
		    ((equal? (ly:unit) "pt") (/ 72.0 72.27))
		    (else (error "unknown unit" (ly:unit)))))
   " mul }%\n"
   "\\ifx\\lilypondstart\\undefined\n"
   "  \\input lilyponddefs\n"
   "\\fi\n"
   "\\outputscale = \\lilypondpaperoutputscale\\lilypondpaperunit\n"
   "\\lilypondstart\n"
   "\\lilypondspecial\n"
   "\\lilypondpostscript\n"))

(define (dump-page putter page last?)
  (ly:outputter-dump-string
   putter
   (format "\\vbox to ~a\\outputscale{%\n\\leavevmode\n\\lybox{0}{0}{0}{0}{%\n"
	   (interval-length (ly:stencil-extent page Y))
	   ))
  (ly:outputter-dump-stencil putter page)
  (ly:outputter-dump-string
   putter
   (if last?
       "}\\vss\n}\n\\vfill\n"
       "}\\vss\n}\n\\vfill\\lilypondpagebreak\n")))

(define-public (output-framework outputter book scopes fields basename )
  (let* ((bookpaper (ly:paper-book-book-paper book))
	 (pages (ly:paper-book-pages book))
	 (last-page (car (last-pair pages)))
	 )
    (for-each
     (lambda (x)
       (ly:outputter-dump-string outputter x))
     (list
      (header bookpaper (length pages) #f)
      (define-fonts bookpaper)
      (header-end)))
    
    (for-each
     (lambda (page) (dump-page outputter page (eq? last-page page)))
     pages)
    (ly:outputter-dump-string outputter "\\lilypondend\n")))

(define (dump-line putter line last?)
  (ly:outputter-dump-string
   putter
   (string-append "\\leavevmode\n\\lybox{0}{0}{0}{"
		  (ly:number->string (interval-length (ly:paper-system-extent line Y)))
		  "}{"))

  (ly:outputter-dump-stencil putter (ly:paper-system-stencil line))
  (ly:outputter-dump-string
   putter
   (if last?
       "}%\n"
       "}\\interscoreline\n")))

(define-public (output-classic-framework
		outputter book scopes fields basename)
  (let* ((bookpaper (ly:paper-book-book-paper book))
	 (lines (ly:paper-book-systems book))
	 (last-line (car (last-pair lines))))
    (for-each
     (lambda (x)
       (ly:outputter-dump-string outputter x))
     (list
      ;;FIXME
      (header bookpaper (length lines) #f)
      "\\def\\lilypondclassic{1}%\n"
      (output-scopes scopes fields basename)
      (define-fonts bookpaper)
      (header-end)))

    (for-each
     (lambda (line) (dump-line outputter line (eq? line last-line))) lines)
    (ly:outputter-dump-string outputter "\\lilypondend\n")))


(define-public (output-preview-framework
		outputter book scopes fields basename )
  (let* ((bookpaper (ly:paper-book-book-paper book))
	 (lines (ly:paper-book-systems book)))
    (for-each
     (lambda (x)
       (ly:outputter-dump-string outputter x))
     (list
      ;;FIXME
      (header bookpaper (length lines) #f)
      "\\def\\lilypondclassic{1}%\n"
      (output-scopes scopes fields basename)
      (define-fonts bookpaper)
      (header-end)))

    (dump-line outputter (car lines) #t)
    (ly:outputter-dump-string outputter "\\lilypondend\n")))


(define-public (convert-to-pdf book name)
  (let*
      ((defs (ly:paper-book-book-paper book))
       (size (ly:output-def-lookup defs 'papersize)))

    (postscript->pdf (if (string? size) size "a4")
		     (string-append
		      (basename name ".tex")
		      ".ps")
		     )))

(define-public (convert-to-png book name)
  (let*
      ((defs (ly:paper-book-book-paper book))
       (resolution (ly:output-def-lookup defs 'pngresolution)))

    (postscript->png
     (if (number? resolution) resolution 90)
     (string-append (basename name ".tex") ".ps")
     )))

(define-public (convert-to-ps book name)
  (let*
      ((cmd (string-append "dvips -u+ec-mftrace.map -u+lilypond.map -Ppdf "
			   (basename name ".tex"))))

    (display (format #f (_ "Invoking ~S") cmd) (current-error-port))
    (newline (current-error-port))
    (system cmd)))

(define-public (convert-to-dvi book name)
  (let*
      ((cmd (string-append "latex \\\\nonstopmode \\\\input " name)))

    (newline (current-error-port))
    (display (format #f (_ "Invoking ~S") cmd) (current-error-port))
    (newline (current-error-port))

    ;; fixme: set in environment?
    (if (ly:get-option 'safe)
	(set! cmd (string-append "openout_any=p " cmd)))
    
    (system cmd)))

(define-public (convert-to-tex book name)
  #t)

