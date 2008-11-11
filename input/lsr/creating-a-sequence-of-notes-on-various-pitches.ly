%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.62"

\header {
  lsrtags = "pitches"

  texidoces = "
En una música que tenga muchas apariciones de la
misma secuencia de notas a distintas alturas, podría ser de
utilidad la siguiente función musical.  Admite una nota, de la que
sólo se utiliza su altura.  Las funciones de apoyo en Scheme se
han tomado prestadas del documento de \"Consejos y trucos\" de la
versión 2.10 del manual.  Este ejemplo crea las duraciones
rítmicas que se usan a todo lo largo de «Marte», de «Los Planetas»
de Gustav Holst.

"
  doctitlees = "Crear una secuencia de notas a distintas alturas"

  texidoc = "
In music that contains many occurrences of the same sequence of notes
at different pitches, the following music function may prove useful. 
It takes a note, of which only the pitch is used.  The supporting
Scheme functions were borrowed from the \"Tips and tricks\" document in
the manual for version 2.10.   This example creates the rhythm used
throughout Mars, from Gustav Holst's The Planets. 

"
  doctitle = "Creating a sequence of notes on various pitches"
} % begin verbatim

#(define (make-note-req p d)
  (make-music 'NoteEvent
   'duration d
   'pitch p))

#(define (make-note p d)
  (make-music 'EventChord
   'elements (list (make-note-req p d))))

#(define (seq-music-list elts)
  (make-music 'SequentialMusic
   'elements elts))

#(define (make-triplet elt)
  (make-music 'TimeScaledMusic
   'denominator 3
   'numerator 2
   'element elt))


rhythm = #(define-music-function (parser location note) (ly:music?)
          "Make the rhythm in Mars (the Planets) at the given note's pitch"
          (let* ((p (ly:music-property
                      (car (ly:music-property note 'elements))
                      'pitch)))
          (seq-music-list (list
            (make-triplet (seq-music-list (list
              (make-note p (ly:make-duration 3 0 2 3))
              (make-note p (ly:make-duration 3 0 2 3))
              (make-note p (ly:make-duration 3 0 2 3))
            )))
            (make-note p (ly:make-duration 2 0))
            (make-note p (ly:make-duration 2 0))
            (make-note p (ly:make-duration 3 0))
            (make-note p (ly:make-duration 3 0))
            (make-note p (ly:make-duration 2 0))
          ))))

\score {
  \new Staff {
    \time 5/4
    \rhythm c'
    \rhythm c''
    \rhythm g
  }
}
