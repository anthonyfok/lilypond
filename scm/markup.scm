;;;; This file is part of LilyPond, the GNU music typesetter.
;;;;
;;;; Copyright (C) 2003--2011 Han-Wen Nienhuys <hanwen@xs4all.nl>
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

(defmacro*-public markup (#:rest body)
  "The `markup' macro provides a lilypond-like syntax for building markups.

 - #:COMMAND is used instead of \\COMMAND
 - #:line ( ... ) is used instead of \\line { ... }
 - etc.

Example:
  \\markup { foo
            \\raise #0.2 \\hbracket \\bold bar
            \\override #'(baseline-skip . 4)
            \\bracket \\column { baz bazr bla }
  }
         <==>
  (markup \"foo\"
          #:raise 0.2 #:hbracket #:bold \"bar\"
          #:override '(baseline-skip . 4)
          #:bracket #:column (\"baz\" \"bazr\" \"bla\"))
Use `markup*' in a \\notemode context."

  (car (compile-all-markup-expressions `(#:line ,body))))

(define-markup-command (draw-hline layout props)
  ()
  #:category graphic
  #:properties ((draw-line-markup)
                (line-width)
                (span-factor 1))
  "
@cindex drawing a line across a page

Draws a line across a page, where the property @code{span-factor}
controls what fraction of the page is taken up.
@lilypond[verbatim,quote]
\\markup {
  \\column {
    \\draw-hline
    \\override #'(span-factor . 1/3)
    \\draw-hline
  }
}
@end lilypond"
  (interpret-markup layout
                    props
                    (markup #:draw-line (cons (* line-width
                                                  span-factor)
                                               0))))

;; utility

(define (markup-join markups sep)
  "Return line-markup of MARKUPS, joining them with markup SEP"
  (if (pair? markups)
      (make-line-markup (list-insert-separator markups sep))
      empty-markup))


(define-public interpret-markup ly:text-interface::interpret-markup)

(define-public (interpret-markup-list layout props markup-list)
  (let ((stencils (list)))
    (for-each (lambda (m)
		(set! stencils
		      (if (markup-command-list? m)
			  (append! (reverse! (apply (car m) layout props (cdr m)))
				   stencils)
			  (cons (interpret-markup layout props m) stencils))))
	      markup-list)
    (reverse! stencils)))

(define-public (prepend-alist-chain key val chain)
  (cons (acons key val (car chain)) (cdr chain)))

(define-public (stack-stencil-line space stencils)
  "DOCME"
  (if (and (pair? stencils)
	   (ly:stencil? (car stencils)))

      (if (and (pair? (cdr stencils))
	       (ly:stencil? (cadr stencils)))
          (let* ((tail (stack-stencil-line space (cdr stencils)))
                 (head (car stencils))
                 (xoff (+ space (interval-length (ly:stencil-extent head X)))))
            (ly:stencil-add head
                             (ly:stencil-translate-axis tail xoff X)))
          (car stencils))
      (ly:make-stencil '() '(0 . 0) '(0 . 0))))


;;; convert a full markup object to an approximate pure string representation

(define-public (markup->string m)
  ;; markup commands with one markup argument, formatting ignored
  (define markups-first-argument '(list
    bold-markup box-markup caps-markup dynamic-markup finger-markup
    fontCaps-markup huge-markup italic-markup large-markup larger-markup
    medium-markup normal-size-sub-markup normal-size-super-markup
    normal-text-markup normalsize-markup number-markup roman-markup
    sans-markup simple-markup small-markup smallCaps-markup smaller-markup
    sub-markup super-markup teeny-markup text-markup tiny-markup
    typewriter-markup underline-markup upright-markup bracket-markup
    circle-markup hbracket-markup parenthesize-markup rounded-box-markup

    center-align-markup center-column-markup column-markup dir-column-markup
    fill-line-markup justify-markup justify-string-markup left-align-markup
    left-column-markup line-markup right-align-markup right-column-markup
    vcenter-markup wordwrap-markup wordwrap-string-markup ))

  ;; markup commands with markup as second argument, first argument
  ;; specifies some formatting and is ignored
  (define markups-second-argument '(list
    abs-fontsize-markup fontsize-markup magnify-markup lower-markup
    pad-around-markup pad-markup-markup pad-x-markup raise-markup
    halign-markup hcenter-in-markup rotate-markup translate-markup
    translate-scaled-markup with-url-markup scale-markup ))

  ;; helper functions to handle string cons like string lists
  (define (markup-cons->string-cons c)
    (if (not (pair? c)) (markup->string c)
      (cons (markup->string (car c)) (markup-cons->string-cons (cdr c)))))
  (define (string-cons-join c)
    (if (not (pair? c)) c
        (string-join (list (car c) (string-cons-join (cdr c))) "")))

  (cond
    ((string? m) m)
    ((null? m) "")

    ;; handle \concat (string-join without spaces)
    ((and (pair? m) (equal? (car m) concat-markup))
        (string-cons-join (markup-cons->string-cons (cadr m))) )

    ;; markup functions with the markup as first arg
    ((member (car m) (primitive-eval markups-first-argument))
        (markup->string (cadr m)))

    ;; markup functions with markup as second arg
    ((member (car m) (primitive-eval markups-second-argument))
        (markup->string (cddr m)))

    ;; ignore all other markup functions
    ((markup-function? (car m)) "")

    ;; handle markup lists
    ((list? m)
        (string-join (map markup->string m) " "))

    (else "ERROR, unable to extract string from markup")))
