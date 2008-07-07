%% Do not edit this file; it is auto-generated from input/new
%% This file is in the public domain.
\version "2.11.51"
\header {
  texidoces = "
Si la nota que da fin a un regulador cae sobre la primera parte de
un compás, el regulador se detiene en la línea divisoria
inmediatamente precedente.  Se puede controlar este comportamiento
sobreescribiendo la propiedad @code{to-barline}.

"
  doctitlees = "Establecer el comportamiento de los reguladores en las barras de compás"

  lsrtags = "expressive-marks"
  texidoc = "If the note which ends a hairpin falls on a downbeat,
the hairpin stops at the bar line immediately preceding.  This behavior
can be controlled by overriding the @code{to-barline} property.
"
  doctitle = "Setting hairpin behavior at bar lines"
} % begin verbatim

\relative c'' {
  e4\< e2.
  e1\!
  \override Hairpin #'to-barline = ##f
  e4\< e2.
  e1\!
}
