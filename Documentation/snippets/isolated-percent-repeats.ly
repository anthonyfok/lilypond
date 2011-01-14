%% Do not edit this file; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.13.39"

\header {
  lsrtags = "repeats"

%% Translation of GIT committish: a874fda3641c9e02f61be5c41b215b8304b8ed00
  texidoces = "
También se pueden imprimir símbolos de porcentaje sueltos.

"
  doctitlees = "Símbolos de porcentaje sueltos"


%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
  texidocde = "
Isolierte Prozentwiederholungen können auch ausgegeben werden.  Das wird
erreicht, indem man eine Ganztaktpause notiert und ihre Ausgabeform
ändert:

"
  doctitlede = "Isolierte Prozentwiederholungen"

%% Translation of GIT committish: a5bde6d51a5c88e952d95ae36c61a5efc22ba441
  texidocfr = "
Des symboles de pourcentage isolés peuvent aussi être obtenus, au
moyen d'un silence multi-mesures dont on modifie l'aspect :

"
  doctitlefr = "Répétition en pourcent isolée"


  texidoc = "
Isolated percents can also be printed.

"
  doctitle = "Isolated percent repeats"
} % begin verbatim

makePercent =
#(define-music-function (parser location note) (ly:music?)
   "Make a percent repeat the same length as NOTE."
   (make-music 'PercentEvent
               'length (ly:music-length note)))

\relative c'' {
  \makePercent s1
}

