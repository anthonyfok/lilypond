;;;; This file is part of LilyPond, the GNU music typesetter.
;;;;
;;;; Copyright (C) 2004--2011  Nicolas Sceaux  <nicolas.sceaux@free.fr>
;;;;           Jan Nieuwenhuizen <janneke@gnu.org>
;;;;
;;;; LilyPond is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation, either version 3 of the License, or
;;;; (at your option) any later version.
;;;;
;;;; LilyPond is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;;
;;;; You should have received a copy of the GNU General Public License
;;;; along with LilyPond.  If not, see <http://www.gnu.org/licenses/>.

(define-public (read-lily-expression chr port)
  "Read a lilypond music expression enclosed within @code{#@{} and @code{#@}}
from @var{port} and return the corresponding Scheme music expression.
@samp{$} and @samp{#} introduce immediate and normal Scheme forms."
  (let* ((closures '())
	 (filename (port-filename port))
	 (line (port-line port))
	 (lily-string (call-with-output-string
		       (lambda (out)
			 (let ((copycat 
				(make-soft-port
				 (vector #f #f #f
					 (lambda ()
					   (let ((x (read-char port)))
					     (write-char x out)
					     x)) #f)
				 "r")))
			   (do ((c (read-char port) (read-char port)))
			       ((and (char=? c #\#)
				     (char=? (peek-char port) #\}))
				;; we stop when #} is encountered
				(read-char port))
			     (write-char c out)
			     ;; a #scheme or $scheme expression
			     (if (or (char=? c #\#) (char=? c #\$))
				 (let ((p (ftell out)))
				   (set! closures
					 (cons (cons p (read copycat))
					       closures))))))))))
    `(let* ((clone
	     (ly:parser-clone parser (list ,@(map (lambda (c)
						    `(cons ,(car c)
							   (lambda () ,(cdr c))))
						  (reverse! closures)))))
	    (result (ly:parse-string-expression clone ,lily-string
						,filename
						,line)))
       (if (ly:parser-has-error? clone)
	   (ly:parser-error parser (_ "error in #{ ... #}")))
       result)))

(read-hash-extend #\{ read-lily-expression)
